use yaml
import yaml/Parser

main: func {
    parser := YamlParser new()
    parser loadFromString("[1,2,3]")

    i := parser parse()
    while(i hasNext()) {
        e := i next()
        "got event!" println()
    }
}
