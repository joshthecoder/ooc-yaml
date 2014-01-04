
// sdk
import io/File

// ours
use yaml
import yaml/[Document, Parser, Emitter]

extend Document {

    write: func ~file (file: File) {
        emitter := YAMLEmitter new()
        emitter setOutputFile(file)
        emitter streamStart()
        emit(emitter)
        emitter streamEnd()
        emitter delete()
    }

}

extend DocumentNode {

    write: func ~file (file: File) {
        emitter := YAMLEmitter new()
        emitter setOutputFile(file)
        emitter streamStart()
        emitter documentStart()
        emit(emitter)
        emitter documentEnd()
        emitter streamEnd()
        emitter delete()
    }

    asMap: func -> MappingNode {
        if (!this) {
            raise("called asMap on null node!")
        }
        match this {
            case map: MappingNode =>
                map
            case =>
                raise("Invalid node type, expected Mapping, got: #{class name}")
                null
        }
    }

    asList: func -> SequenceNode {
        if (!this) {
            raise("called asList on null node!")
        }
        match this {
            case seq: SequenceNode =>
                seq
            case =>
                raise("Invalid node type, expected Sequence, got: #{class name}")
                null
        }
    }

    asScalar: func -> String {
        if (!this) {
            raise("called asScalar on null node!")
        }
        match this {
            case scalar: ScalarNode =>
                scalar value
            case =>
                raise("Invalid node type, expected Scalar, got: #{class name}")
                null
        }
    }

    _: String { get {
        asScalar()
    } }

    each: func ~map (f: Func (String, DocumentNode)) {
        asMap() each(|k, v| f(k, v))
    }

    each: func ~list (f: Func (DocumentNode)) {
        asList() each(|x| f(x))
    }

}

extend MappingNode {

    each: func (f: Func (String, DocumentNode)) {
        map each(|k, v| f(k, v))
    }

}

extend SequenceNode {

    each: func (f: Func (DocumentNode)) {
        nodes each(|x| f(x))
    }

}

// map get
operator [] (node: DocumentNode, key: String) -> DocumentNode {
    node asMap() map get(key)
}

// map put
operator []= (node: DocumentNode, key: String, value: DocumentNode) {
    node asMap() map put(key, value)
}

// map put scalar
operator []= (node: DocumentNode, key: String, value: String) {
    node[key] = ScalarNode new(value)
}

// list get
operator [] (node: DocumentNode, index: Int) -> DocumentNode {
    node asList() nodes get(index)
}

// list set
operator []= (node: DocumentNode, index: Int, value: DocumentNode) {
    node asList() nodes set(index, value)
}

// list set scalar
operator []= (node: DocumentNode, index: Int, value: String) {
    node[index] = ScalarNode new(value)
}

// list append
operator << (node: DocumentNode, value: DocumentNode) {
    node asList() nodes add(value)
}

// list append scalar
operator << (node: DocumentNode, value: String) {
    node << ScalarNode new(value)
}

