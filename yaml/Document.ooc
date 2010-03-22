use yaml
import yaml/Parser

import structs/[Stack, LinkedList, HashMap]


Document: class extends YAMLCallback {
    stack: Stack<DocumentNode>
    current: DocumentNode

    init: func {
        current = EmptyNode new()
        stack = Stack<DocumentNode> new()
    }

    getRootNode: func -> DocumentNode { current }

    insert: func(node: DocumentNode) {
        match current class {
            case SequenceNode => (current as SequenceNode) add(node)
            case MappingNode => (current as MappingNode) addPairValue(node)
            case EmptyNode => current = node
            case => YAMLError new("Current node does not support inserts") throw()
        }
    }

    onScalar: func -> Bool {
        value: String = event data scalar value as Char*
        insert(ScalarNode new(value clone()))
        return true
    }

    onSequenceStart: func -> Bool {
        stack push(current)
        current = SequenceNode new()
        return true
    }
    onSequenceEnd: func -> Bool {
        seq := current
        current = stack pop()
        insert(seq)
        return true
    }

    onMappingStart: func -> Bool {
        stack push(current)
        current = MappingNode new()
        return true
    }
    onMappingEnd: func -> Bool {
        map := current
        current = stack pop()
        insert(map)
        return true
    }

    onDocumentEnd: func -> Bool {
        if(stack size()) {
            YAMLError new("Premature ending of document!") throw()
        }
        return false
    }
}

DocumentNode: abstract class {
    toString: abstract func -> String
}

EmptyNode: class extends DocumentNode {
    toString: func -> String { "Empty" }
}

ScalarNode: class extends DocumentNode {
    value: String

    init: func(=value) {}

    toString: func -> String { value }
}

SequenceNode: class extends DocumentNode {
    nodes: LinkedList<DocumentNode>

    init: func {
        nodes = LinkedList<DocumentNode> new()
    }

    toString: func -> String { "Sequence" }

    toList: func -> LinkedList<DocumentNode> { nodes }

    add: func(node: DocumentNode) {
        nodes add(node)
    }
}

MappingNode: class extends DocumentNode {
    map: HashMap<String, DocumentNode>
    key: String

    init: func {
        map = HashMap<String, DocumentNode> new()
    }

    toString: func -> String { "Mapping" }

    toHashMap: func -> HashMap<String, DocumentNode> { map }

    addPairValue: func(value: DocumentNode) {
        if(!key) {
            if(value class == ScalarNode) {
                key = (value as ScalarNode) value
            }
            else {
                YAMLError new("Invalid mapping key type!") throw()
            }
        }
        else {
            map add(key, value)
            key = null
        }
    }
}
