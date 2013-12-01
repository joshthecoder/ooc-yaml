use yaml
import yaml/[Parser, Event, Emitter]

import structs/[Stack, LinkedList, HashMap]


Document: class extends YAMLCallback {
    stack: Stack<DocumentNode>
    current: DocumentNode

    init: func ~doc {
        current = EmptyNode new()
        stack = Stack<DocumentNode> new()
    }

    getRootNode: func -> DocumentNode { current }

    insert: func(node: DocumentNode) {
        nodeType := current class

        match nodeType {
            case SequenceNode => (current as SequenceNode) add(node)
            case MappingNode => (current as MappingNode) addPairValue(node)
            case EmptyNode => current = node
            case => YAMLError new("Current node does not support inserts") throw()
        }
    }

    onScalar: func -> Bool {
        value: String = (event data scalar value as CString) toString()
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
        if(stack size) {
            YAMLError new("Premature ending of document!") throw()
        }
        return false
    }

    emit: func (emitter: YAMLEmitter) {
        emitter documentStart()
        getRootNode() emit(emitter)
        emitter documentEnd()
    }
}

DocumentNode: abstract class {
    toString: abstract func -> String

    emit: abstract func (emitter: YAMLEmitter)
}

EmptyNode: class extends DocumentNode {
    toString: func -> String { "<empty>" }

    init: func

    emit: func (emitter: YAMLEmitter) {
        // nothing there
    }
}

ScalarNode: class extends DocumentNode {
    value: String

    init: func ~scalar (=value) {}

    toString: func -> String { value }

    emit: func (emitter: YAMLEmitter) {
        emitter scalar(value)
    }
}

SequenceNode: class extends DocumentNode {
    nodes: LinkedList<DocumentNode>

    init: func ~sequence {
        nodes = LinkedList<DocumentNode> new()
    }

    toString: func -> String { "Sequence" }

    toList: func -> LinkedList<DocumentNode> { nodes }

    add: func(node: DocumentNode) {
        nodes add(node)
    }

    emit: func (emitter: YAMLEmitter) {
        emitter sequenceStart()
        for (n in nodes) {
            n emit(emitter)
        }
        emitter sequenceEnd()
    }
}

MappingNode: class extends DocumentNode {
    map: HashMap<String, DocumentNode>
    key: String

    init: func ~mapping {
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

    put: func (key: String, value: DocumentNode) {
        map put(key, value)
    }

    emit: func (emitter: YAMLEmitter) {
        emitter mappingStart()
        map each(|k, v|
            emitter scalar(k)
            v emit(emitter)
        )
        emitter mappingEnd()
    }
}

/* bindings for YAMLDocument */

YAMLDocumentStruct: cover from struct yaml_document_s

YAMLDocument: cover from yaml_document_t* {

    new: static func (vd: VersionDirective*, start: TagDirective*, end: TagDirective*, startImplicit: Bool, endImplicit: Bool) -> This {
        doc := gc_malloc(YAMLDocumentStruct instanceSize) as This
        if (!yaml_document_initialize(doc, vd, start, end, startImplicit, endImplicit)) {
            Exception new("Could not initialize document") throw()
        }
        doc
    }

    delete: extern(yaml_document_delete) func

    addScalar: extern(yaml_document_add_scalar) func (CString, CString, Int, YAMLScalarStyle) -> Int
    addSequence: extern(yaml_document_add_sequence) func (CString, YAMLSequenceStyle) -> Int
    addMapping: extern(yaml_document_add_mapping) func (CString, YAMLMappingStyle)

    appendSequenceItem: extern(yaml_document_append_sequence_item) func (Int, Int)
    appendMappingPair: extern(yaml_document_append_mapping_pair) func (Int, Int, Int)

    getRootNode: extern(yaml_document_get_root_node) func -> YAMLNode*

}

yaml_document_initialize: extern func (YAMLDocument, VersionDirective*, TagDirective*,
    TagDirective*, Bool, Bool) -> Int

YAMLNode: cover from yaml_node_t {

    type: YAMLNodeType

}

YAMLNodeType: enum /* from yaml_node_type_t */ {
    empty: extern(YAML_NO_NODE)
    scalar: extern(YAML_SCALAR_NODE)
    sequence: extern(YAML_SEQUENCE_NODE)
    mapping: extern(YAML_MAPPING_NODE)
}

