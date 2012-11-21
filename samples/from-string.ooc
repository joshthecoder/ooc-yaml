
use yaml
import yaml/Parser

import mycallbacks

main: func {
    parser := YAMLParser new()
    parser setInputString("---\ntest: hi\n...")
    parser parseAll(MyCallbacks new())
}

