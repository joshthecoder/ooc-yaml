use yaml
import yaml/[Event, Document]

import io/[File, FileReader]


/**
    A YAML streaming, event-driven parser.
*/
YAMLParser: class {
    parser: _Parser

    init: func ~base {
        parser = _Parser new()
    }

   //TODO: add finializer to delete _Parser so we don't leak

    setInputString: func(text: String) {
        parser setInputString(text, text length())
    }

    setInputFile: func(file: File) {
        setInputString(file read())
    }

    setInputFile: func ~path(path: String) {
        setInputFile(File new(path))
    }

    parseEvent: func ~withEvent(event: Event*) {
        if(!parser parse(event)) {
            //TODO: better errors
            YAMLError new("Error while parsing!") throw()
        }
    }
    parseEvent: func -> Event* {
        event : Event* = gc_malloc(Event instanceSize)
        parseEvent(event)
        return event
    }

    parseAll: func(callbacks: YAMLCallback) {
        while(true) {
            parseEvent(callbacks event&)
            if(callbacks onEvent() == false) break
        }
    }

    parseDocument: func -> Document {
        document := Document new()
        parseAll(document)
        return document
    }

    destroy: func {
        parser delete()
    }
}

YAMLCallback: abstract class {
    event: Event

    onEvent: func -> Bool {
        eventType := event type

        match eventType {
            case EventType STREAM_START => onStreamStart()
            case EventType STREAM_END => onStreamEnd()
            case EventType DOCUMENT_START => onDocumentStart()
            case EventType DOCUMENT_END => onDocumentEnd()
            case EventType ALIAS => onAlias()
            case EventType SCALAR => onScalar()
            case EventType SEQUENCE_START => onSequenceStart()
            case EventType SEQUENCE_END => onSequenceEnd()
            case EventType MAPPING_START => onMappingStart()
            case EventType MAPPING_END => onMappingEnd()
            case => true
        }
    }

    onStreamStart: func -> Bool { true }
    onStreamEnd: func -> Bool { false }
    onDocumentStart: func -> Bool { true }
    onDocumentEnd: func -> Bool { true }
    onAlias: func -> Bool { true }
    onScalar: func -> Bool { true }
    onSequenceStart: func -> Bool { true }
    onSequenceEnd: func -> Bool { true }
    onMappingStart: func -> Bool { true }
    onMappingEnd: func -> Bool { true }
}

YAMLError: class extends Exception {
    init: func { init("YAMLError") }
    init: func ~message (message: String) {
        super(message)
    }
}

ParserStruct: cover from struct yaml_parser_s

_Parser: cover from yaml_parser_t* {
    new: static func -> This {
        instance := gc_malloc(ParserStruct instanceSize) as _Parser
        if(!instance _init()) {
            Exception new("Failed to initialize parser!") throw()
        }
        return instance
    }

    _init: extern(yaml_parser_initialize) func -> Int

    delete: extern(yaml_parser_delete) func

    setInputString: extern(yaml_parser_set_input_string) func(input: CString, size: SizeT)
    setInputFile: extern(yaml_parser_set_input_file) func(file: FILE*)

    parse: extern(yaml_parser_parse) func(event: Event*) -> Int
}
