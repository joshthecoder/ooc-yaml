
use yaml
import yaml/Parser

import mycallbacks

main: func {
    parser := YAMLParser new()
    parser setInputFile("log.yml")
    parser parseAll(MyCallbacks new())
}

