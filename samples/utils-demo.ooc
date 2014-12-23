
use yaml
import yaml/[Parser, Document, Utils]

import io/File

main: func {
    parser := YAMLParser new(File new("bottle.yml"))
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

