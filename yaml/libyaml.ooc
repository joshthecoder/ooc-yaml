use yaml

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

    parse: extern(yaml_parser_parse) func(event: _Event*) -> Int
}

_Event: cover from struct yaml_event_s {
    type: extern Int
    data: extern EventData

    isEnd: func -> Bool { type == EventType STREAM_END }
}

EventType: cover {
    EMPTY: extern(YAML_NO_EVENT) static Int
    STREAM_START: extern(YAML_STREAM_START_EVENT) static Int
    STREAM_END: extern(YAML_STREAM_END_EVENT) static Int
    DOCUMENT_START: extern(YAML_DOCUMENT_START_EVENT) static Int
    DOCUMENT_END: extern(YAML_DOCUMENT_END_EVENT) static Int
    ALIAS: extern(YAML_ALIAS_EVENT) static Int
    SCALAR: extern(YAML_ALIAS_EVENT) static Int
    SEQUENCE_START: extern(YAML_SEQUENCE_START_EVENT) static Int
    SEQUENCE_END: extern(YAML_SEQUENCE_START_EVENT) static Int
    MAPPING_START: extern(YAML_MAPPING_START_EVENT) static Int
    MAPPING_END: extern(YAML_MAPPING_END_EVENT) static Int
}

EventData: cover {
    startStream: extern(start_stream) StreamStartData
    documentStart: extern(document_start) DocumentStartData
    documentEnd: extern(document_end) DocumentEndData
    alias: extern AliasData
    scalar: extern ScalarData
    sequenceStart: extern(sequence_start) SequenceStartData
    mappingStart: extern(mapping_start) MappingStartData
}

StreamStartData: cover {
    encoding: extern Int
}

DocumentStartData: cover {
    versionDirective: extern(version_directive) VersionDirective*
    tagDirectives: extern(tag_directives) TagDirectives
    implicit: extern Int
}

DocumentEndData: cover {
    implicit: extern Int
}

AliasData: cover {
    anchor: extern UChar*
}

ScalarData: cover {
    anchor, tag, value: extern UChar*
    length: extern SizeT
    plainImplicit: extern(plain_implicit) Int
    quotedImplicit: extern(quoted_implicit) Int
    style: extern Int
}

SequenceStartData: cover {
    anchor, tag: extern UChar*
    implicit: extern Int
    style: extern Int
}

MappingStartData: cover {
    anchor, tag: extern UChar*
    implicit: extern Int
    style: extern Int
}

VersionDirective: cover from yaml_version_directive_t {
    major: extern Int
    minor: extern Int
}

TagDirective: cover from yaml_tag_directive_t {
    handle: extern UChar*
    prefix: extern UChar*
}

TagDirectives: cover {
    start: extern TagDirective*
    end: extern TagDirective*
}

Mark: cover from yaml_mark_t {
    index, line, column: extern SizeT
}
