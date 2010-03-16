use yaml
import yaml/[libyaml, Event]


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

    getNextEvent: func -> Event {
        event := Event new()
        parser parse(event event&)
        return event
    }

    parseOne: func {
        onEvent(getNextEvent())
    }

    parseAll: func {
        event: Event

        while(true) {
            event = getNextEvent()
            if(onEvent(event) == false || event type() == EventType STREAM_END) break
        }
    }

    onEvent: func(event: Event) -> Bool {
        match event type() {
            case EventType STREAM_START => onStreamStart(event as StreamStartEvent)
            case EventType STREAM_END => onStreamEnd(event as StreamEndEvent)
            case EventType DOCUMENT_START => onDocumentStart(event as DocumentStartEvent)
            case EventType DOCUMENT_END => onDocumentEnd(event as DocumentEndEvent)
            case EventType ALIAS => onAlias(event as AliasEvent)
            case EventType SCALAR => onScalar(event as ScalarEvent)
            case EventType SEQUENCE_START => onSequenceStart(event as SequenceStartEvent)
            case EventType SEQUENCE_END => onSequenceEnd(event as SequenceEndEvent)
            case EventType MAPPING_START => onMappingStart(event as MappingStartEvent)
            case EventType MAPPING_END => onMappingEnd(event as MappingEndEvent)
            case => true
        }
    }

    onStreamStart: func(event: StreamStartEvent) -> Bool { true }
    onStreamEnd: func(event: StreamEndEvent) -> Bool { true }
    onDocumentStart: func(event: DocumentStartEvent) -> Bool { true }
    onDocumentEnd: func(event: DocumentEndEvent) -> Bool { true }
    onAlias: func(event: AliasEvent) -> Bool { true }
    onScalar: func(event: ScalarEvent) -> Bool { true }
    onSequenceStart: func(event: SequenceStartEvent) -> Bool { true }
    onSequenceEnd: func(event: SequenceEndEvent) -> Bool { true }
    onMappingStart: func(event: MappingStartEvent) -> Bool { true }
    onMappingEnd: func(event: MappingEndEvent) -> Bool { true }
}

YAMLError: class extends Exception {}
