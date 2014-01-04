
// ours
use yaml
import yaml/[Document, Parser]

extend DocumentNode {

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

operator [] (node: DocumentNode, key: String) -> DocumentNode {
    map := node asMap()
    map map get(key)
}

operator [] (node: DocumentNode, index: Int) -> DocumentNode {
    list := node asList()
    list nodes get(index)
}

