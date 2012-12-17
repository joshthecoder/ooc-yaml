
use yaml
import yaml/Emitter

main: func {
    emitter := YAMLEmitter new()
    emitter setOutputFile("output.yml")

    emitter open()

    emitter streamStart()
    emitter documentStart()

    emitter scalar("baboo")

    emitter documentEnd()
    emitter streamEnd()

    emitter close()

    emitter delete()
}

