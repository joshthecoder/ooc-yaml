use yaml


Event: cover from struct yaml_event_s {
    type: extern Int
    data: extern EventData
}

EventPointer: cover from Event* {

    initStreamStart: extern(yaml_stream_start_event_initialize) func (YAMLEncoding)
    initStreamEnd: extern(yaml_stream_end_event_initialize) func ()
    initDocumentStart: extern(yaml_document_start_event_initialize) func (VersionDirective*,
        TagDirective*, TagDirective*, Bool)
    initDocumentEnd: extern(yaml_document_end_event_initialize) func (Bool)
    initScalar: extern(yaml_scalar_event_initialize) func (CString, CString, CString, SizeT, Bool, Bool, YAMLScalarStyle)

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
    encoding: extern YAMLEncoding
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
    anchor, tag, value: extern CString
    length: extern SizeT
    plainImplicit: extern(plain_implicit) Int
    quotedImplicit: extern(quoted_implicit) Int
    style: extern Int
}

SequenceStartEvent: cover {
    anchor, tag: extern CString
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

YAMLEncoding: enum /* from yaml_encoding_t */ {
    any: extern(YAML_ANY_ENCODING)
    utf8: extern(YAML_UTF8_ENCODING)
    utf16le: extern(YAML_UTF16LE_ENCODING)
    utf16be: extern(YAML_UTF16BE_ENCODING)
}

YAMLScalarStyle: enum /* from yaml_scalar_style_t */ {
    any: extern(YAML_ANY_SCALAR_STYLE)
    plain: extern(YAML_PLAIN_SCALAR_STYLE)
    singleQuoted: extern(YAML_SINGLE_QUOTED_SCALAR_STYLE)
    doubleQuoted: extern(YAML_DOUBLE_QUOTED_SCALAR_STYLE)
    literal: extern(YAML_LITERAL_SCALAR_STYLE)
    folded: extern(YAML_FOLDED_SCALAR_STYLE)
}

YAMLError: enum /* from yaml_error_type_e */ {
    /** No error is produced. */
    no: extern(YAML_NO_ERROR)

    /** Cannot allocate or reallocate a block of memory. */
    memory: extern(YAML_MEMORY_ERROR)

    /** Cannot read or decode the input stream. */
    reader: extern(YAML_READER_ERROR)

    /** Cannot scan the input stream. */
    scanner: extern(YAML_SCANNER_ERROR)

    /** Cannot parse the input stream. */
    parser: extern(YAML_PARSER_ERROR)

    /** Cannot compose a YAML document. */
    composer: extern(YAML_COMPOSER_ERROR)

    /** Cannot write to the output stream. */
    writer: extern(YAML_WRITER_ERROR)

    /** Cannot emit a YAML stream. */
    emitter: extern(YAML_EMITTER_ERROR)

    toString: func -> String {
        match this {
            case no => "No error is produced"
            case memory => "Cannot allocate or reallocate a block of memory"
            case reader => "Cannot read or decode the input stream"
            case scanner => "Cannot scan the input stream"
            case parser => "Cannot parse the input stream"
            case composer => "Cannot compose a YAML document"
            case writer => "Cannot write to the output stream"
            case emitter => "Cannot emit a YAML stream"
        }
    }
}

