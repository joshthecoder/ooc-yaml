
use yaml
import yaml/[Parser, Document, Utils]

main: func {
    parser := YAMLParser new()
    parser setInputFile("bottle.yml")
    doc := parser parseDocument()
    root := doc getRootNode()

    root each(|k, v|
        "Got key #{k}" println()
    )

    root["platforms"] each(|node|
        node each(|k, v|
            "Got subkey #{k}" println()
        )
    )
}

