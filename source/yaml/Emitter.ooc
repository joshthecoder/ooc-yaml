use yaml
import yaml/[Event, Document]

import io/[File, FileReader]


/**
 *  A YAML emitter.
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

    setOutputFile: func (file: File) {
        _file = fopen(file getPath(), "wb")
        emitter setOutputFile(_file)
    }

    setOutputFile: func ~path (path: String) {
        setOutputFile(File new(path))
    }

    setOutputString: func (buffer: CString, bufferSize: Int, writtenSize: Int*) {
        emitter setOutputString(buffer, bufferSize, writtenSize)
    }

    checkError: func (statusCode: Int) {
        if (!statusCode) {
            error := (emitter as EmitterStruct*)@ problem
            Exception new("Error while emitting: %s" format(error)) throw()
        }
    }

    emit: func {
        checkError(emitter emit(event))
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
        // emit YAML 1.1 by default
        vd: VersionDirective
        vd major = 1
        vd minor = 1

        event initDocumentStart(vd&, null, null, true)
        emit()
    }

    documentEnd: func {
        event initDocumentEnd(true)
        emit()
    }

    sequenceStart: func {
        event initSequenceStart(null, null, true, YAMLSequenceStyle block)
        emit()
    }

    sequenceEnd: func {
        event initSequenceEnd()
        emit()
    }

    mappingStart: func {
        event initMappingStart(null, null, true, YAMLMappingStyle block)
        emit()
    }

    mappingEnd: func {
        event initMappingEnd()
        emit()
    }

    scalar: func (value: String) {
        event initScalar(null, null, value toCString(), value size, true, false, YAMLScalarStyle plain)
        emit()
    }

    open: func {
        checkError(emitter open())
    }

    close: func {
        checkError(emitter close())
    }

    flush: func {
        checkError(emitter flush())
    }

    delete: func {
        if (_file) {
            fclose(_file)
            _file = null
        }
        emitter delete()
    }

}

EmitterStruct: cover from struct yaml_emitter_s {
    error: YAMLError
    problem: extern CString
}

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
    flush: extern(yaml_emitter_flush) func -> Int
    close: extern(yaml_emitter_close) func -> Int
    open: extern(yaml_emitter_open) func -> Int
    dump: extern(yaml_emitter_dump) func (YAMLDocument) -> Int

    setEncoding: extern(yaml_emitter_set_encoding) func (YAMLEncoding)
    setCanonical: extern(yaml_emitter_set_canonical) func (Bool)

    setOutputFile: extern(yaml_emitter_set_output_file) func (file: FILE*)
    setOutputString: extern(yaml_emitter_set_output_string) func (CString, Int, Int*)

    emit: extern(yaml_emitter_emit) func (e: Event*) -> Int
}

