use yaml
import yaml/[Event, Document]


/**
    A YAML streaming, event-driven parser.
*/
YAMLParser: class {
    parser: _Parser

    init: func ~base {
        parser = _Parser new()
    }

    setInputString: func(text: String) {
        parser setInputString(text, text length())
    }

    parseEvent: func ~withEvent(event: Event*) {
        if(!parser parse(event)) {
            //TODO: better errors
            YAMLError new("Error while parsing!") throw()
        }
    }
    parseEvent: func -> Event* {
        event: Event* = gc_malloc(sizeof(Event))
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
}

YAMLCallback: abstract class {
    event: Event

    onEvent: func -> Bool {
        match event type {
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

YAMLError: class extends Exception {}

ParserStruct: cover from struct yaml_parser_s

_Parser: cover from yaml_parser_t* {
    new: static func -> This {
        instance: This = gc_malloc(sizeof(ParserStruct))
        gc_register_finalizer(instance, __destroy__, instance, null, null)
        if(!instance _init()) {
            Exception new("Failed to initialize parser!") throw()
        }
        return instance
    }

    __destroy__: func {
        _delete()
    }

    _init: extern(yaml_parser_initialize) func -> Int
    _delete: extern(yaml_parser_delete) func

    setInputString: extern(yaml_parser_set_input_string) func(input: const UChar*, size: SizeT)

    parse: extern(yaml_parser_parse) func(event: Event*) -> Int
}
