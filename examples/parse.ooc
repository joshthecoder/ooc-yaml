use yaml
import yaml/[Parser, Event]

MyParser: class extends YAMLParser {
    init: func {
        super()
        setInputString("---\n[1,2,3]\n...")
    }

    onStreamStart: func(event: StreamStartEvent) -> Bool {
        "Stream starting" println()
        return true
    }
    onStreamEnd: func(event: StreamEndEvent) -> Bool {
        "Stream ending" println()
        return true
    }
    onScalar: func(event: ScalarEvent) -> Bool {
        "Scalar!" println()
        return true
    }
    onSequenceStart: func(event: SequenceStartEvent) -> Bool {
        "Sequence!" println()
        return true
    }
}

main: func {
    parser := MyParser new()
    parser parseAll()
}
