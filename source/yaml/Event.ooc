use yaml


Event: cover from struct yaml_event_s {
    type: extern Int
    data: extern EventData
}

EventType: cover {
    EMPTY: extern(YAML_NO_EVENT) static Int
    STREAM_START: extern(YAML_STREAM_START_EVENT) static Int
    STREAM_END: extern(YAML_STREAM_END_EVENT) static Int
    DOCUMENT_START: extern(YAML_DOCUMENT_START_EVENT) static Int
    DOCUMENT_END: extern(YAML_DOCUMENT_END_EVENT) static Int
    ALIAS: extern(YAML_ALIAS_EVENT) static Int
    SCALAR: extern(YAML_SCALAR_EVENT) static Int
    SEQUENCE_START: extern(YAML_SEQUENCE_START_EVENT) static Int
    SEQUENCE_END: extern(YAML_SEQUENCE_END_EVENT) static Int
    MAPPING_START: extern(YAML_MAPPING_START_EVENT) static Int
    MAPPING_END: extern(YAML_MAPPING_END_EVENT) static Int
}

EventData: cover {
    startStream: extern(start_stream) StreamStartEvent
    documentStart: extern(document_start) DocumentStartEvent
    documentEnd: extern(document_end) DocumentEndEvent
    alias: extern AliasEvent
    scalar: extern ScalarEvent
    sequenceStart: extern(sequence_start) SequenceStartEvent
    mappingStart: extern(mapping_start) MappingStartEvent
}

StreamStartEvent: cover {
    encoding: extern Int
}

DocumentStartEvent: cover {
    versionDirective: extern(version_directive) VersionDirective*
    tagDirectives: extern(tag_directives) TagDirectives
    implicit: extern Int
}

DocumentEndEvent: cover {
    implicit: extern Int
}

AliasEvent: cover {
    anchor: extern UChar*
}

ScalarEvent: cover {
    anchor, tag, value: extern UChar*
    length: extern SizeT
    plainImplicit: extern(plain_implicit) Int
    quotedImplicit: extern(quoted_implicit) Int
    style: extern Int
}

SequenceStartEvent: cover {
    anchor, tag: extern UChar*
    implicit: extern Int
    style: extern Int
}

MappingStartEvent: cover {
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
