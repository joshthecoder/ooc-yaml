use yaml
import yaml/[Event, Document]

import io/[File, FileReader]


/**
    A YAML emitter.
*/
YAMLEmitter: class {
    emitter: _Emitter
    event: EventPointer
    _file: FILE*

    init: func ~base {
        event = gc_malloc(Event instanceSize)

        emitter = _Emitter new()

        emitter setEncoding(YAMLEncoding utf8)
        emitter setCanonical(false)
    }

    setOutputFile: func(file: File) {
        _file = fopen(file getPath(), "wb")
        emitter setOutputFile(_file)
    }

    setOutputFile: func ~path(path: String) {
        setOutputFile(File new(path))
    }

    emit: func {
        error := emitter emit(event)
        if (error != YAMLError no) {
            Exception new("Error while emitting: %s" format(error toString())) throw()
        }
        flush()
    }

    streamStart: func {
        event initStreamStart(YAMLEncoding utf8)
        emit()
    }

    streamEnd: func {
        event initStreamEnd()
        emit()
    }

    documentStart: func {
        // emit YAML 1.2 by default
        vd: VersionDirective
        vd major = 1
        vd minor = 2

        event initDocumentStart(vd&, null, null, true)
        emit()
    }

    documentEnd: func {
        event initDocumentEnd(true)
        emit()
    }

    scalar: func (value: String) {
        event initScalar(null, null, value toCString(), value size, true, false, YAMLScalarStyle plain)
        emit()
    }

    open: func {
        emitter open()
    }

    close: func {
        emitter close()
    }

    flush: func {
        emitter flush()
    }

    delete: func {
        if (_file) {
            fclose(_file)
            _file = null
        }
        emitter delete()
    }

}

EmitterStruct: cover from struct yaml_parser_s

_Emitter: cover from yaml_emitter_t* {
    new: static func -> This {
        instance := gc_malloc(EmitterStruct instanceSize) as _Emitter
        if (!instance _init()) {
            Exception new("Failed to initialize YAML emitter!") throw()
        }
        return instance
    }

    _init: extern(yaml_emitter_initialize) func -> Int

    delete: extern(yaml_emitter_delete) func
    flush: extern(yaml_emitter_flush) func
    close: extern(yaml_emitter_close) func
    open: extern(yaml_emitter_open) func

    setEncoding: extern(yaml_emitter_set_encoding) func (YAMLEncoding)
    setCanonical: extern(yaml_emitter_set_canonical) func (Bool)

    setOutputFile: extern(yaml_emitter_set_output_file) func (file: FILE*)

    emit: extern(yaml_emitter_emit) func (e: Event*) -> YAMLError
}

