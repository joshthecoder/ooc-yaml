
use yaml
import yaml/[Emitter, Document]

main: func {
    doc := Document new()

    map := MappingNode new()
    map map put("bi", ScalarNode new("baa"))

    seq := SequenceNode new()
    seq nodes add(ScalarNode new("1"))
    seq nodes add(ScalarNode new("2"))
    seq nodes add(ScalarNode new("3"))
    map map put("array", seq)

    doc current = map

    /* Actually emit */

    emitter := YAMLEmitter new()
    emitter setOutputFile("output.yml")

    emitter streamStart()
    doc emit(emitter)
    emitter streamEnd()

    emitter flush()
    emitter delete()
}

