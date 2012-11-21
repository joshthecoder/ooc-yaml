
use yaml
import yaml/[Parser, Document]

MyCallbacks: class extends YAMLCallback {
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
