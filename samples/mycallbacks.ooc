
use yaml
import yaml/[Parser, Document, Event]

MyCallbacks: class extends YAMLCallback {
    init: func

    onStreamStart: func -> Bool {
        "Stream start..." println()
        true
    }

    onStreamEnd: func -> Bool {
        "Stream end..." println()
        false
    }

    onDocumentStart: func -> Bool {
        "Document start..." println()
        true
    }
    onDocumentEnd: func -> Bool {
        "End of document." println()
        true
    }

    onScalar: func -> Bool {
        "Scalar: %s" format(event data scalar value) println()
        "(with anchor = %s, tag = %s, style = %d, plainImplicit %d, quotedImplicit %d, length: %d)" printfln(
            event data scalar anchor,
            event data scalar tag,
            event data scalar style,
            event data scalar plainImplicit,
            event data scalar quotedImplicit,
            event data scalar length
        )
        true
    }

    onMappingStart: func -> Bool {
        "Mapping start..." println()
        true
    }
    onMappingEnd: func -> Bool {
        "End of mapping." println()
        true
    }
}
