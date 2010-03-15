use yaml
import yaml/Event

// LibYAML Parser covers & externs
include yaml
YamlParser: cover from yaml_parser_t
yaml_parser_initialize: extern func(...) -> Int
yaml_parser_delete: extern func(...)
yaml_parser_set_input_string: extern func(...)
yaml_parser_parse: extern func(...) -> Int


BaseParser: abstract class <T> {
    parser: YamlParser

    init: func {
        if(!yaml_parser_initialize(parser&)) {
            Exception new("Failed to initialize parser") throw()
        }
    }

    __destroy__: func {
        yaml_parser_delete(parser&)
    }

    loadFromString: func ~withLength(text: String, length: SizeT) {
        yaml_parser_set_input_string(parser&, text as const UChar*, length)
    }
    loadFromString: func(text: String) {
        loadFromString(text, text length())
    }

    parse: abstract func -> T
}

EventParser: class <T> extends BaseParser<Event> {
    event: Event

    parse: func -> T {
        if(!yaml_parser_parse(parser&, event&)) {
            Exception new("Error while parsing!") throw()
        }

        return event
    }
}
