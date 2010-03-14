use yaml
import yaml/Event

// LibYAML Parser covers & externs
include yaml
yaml_parser: cover from yaml_parser_t
yaml_parser_initialize: extern func(...) -> Int
yaml_parser_delete: extern func(...)
yaml_parser_set_input_string: extern func(...)
yaml_parser_parse: extern func(...) -> Int


/**
    A YAML parser
*/
YamlParser: class {
    parser: yaml_parser

    init: func {
        if(!yaml_parser_initialize(parser&)) {
            Exception new("Failed to initialize parser") throw()
        }
    }

    __destroy__: func {
        yaml_parser_delete(parser&)
    }

    loadFromString: func ~withLength(text: String, length: SizeT) {
        yaml_parser_set_input_string(parser&, text, length)
    }
    loadFromString: func(text: String) {
        loadFromString(text, text length())
    }

    //TODO: maybe also expose the scanning tokens method

    /**
        Parse the input stream and produce events.

        :return: An iterator used for processing the produced events.
    */
    parse: func -> EventIterator { EventIterator new(parser) }

    /**
        Parse the input stream and produce documents.

        :return: An iterator used for processing the produced documents.
    */
    load: func -> DocumentIterator { null }
}

EventIterator: class extends Iterator<Event> {
    parser: yaml_parser
    event: Event

    init: func(=parser) {}

    _fetch: func {
        if(!yaml_parser_parse(parser&, event&)) {
            Exception new("Error while parsing!") throw()
        }
    }

    hasNext: func -> Bool {
        if(!event) _fetch()

        return event type != EventType STREAM_END
    }

    next: func -> T {
        current := event
        _fetch()
        return current
    }

    hasPrev: func -> Bool { false }
    prev: func -> T { null }

    remove: func -> Bool { false }
}
