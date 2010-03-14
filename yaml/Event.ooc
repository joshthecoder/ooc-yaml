use yaml
import yaml/Common

Event: cover from struct yaml_event_s {
    type: extern Int
    data: extern EventData
}

EventType: cover {
    STREAM_END: extern(YAML_STREAM_END_EVENT) static Int
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

TagDirectives: cover {
    start: extern TagDirective*
    end: extern TagDirective*
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
