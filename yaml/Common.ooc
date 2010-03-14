use yaml

YamlChar: extern UChar

VersionDirective: cover from yaml_version_directive_t {
    major: extern Int
    minor: extern Int
}

TagDirective: cover from yaml_tag_directive_t {
    handle: extern YamlChar*
    prefix: extern YamlChar*
}

Mark: cover from yaml_mark_t {
    index, line, column: extern SizeT
}
