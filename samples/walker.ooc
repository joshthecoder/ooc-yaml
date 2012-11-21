
use yaml
import yaml/[Parser, Document]

main: func {
    parser := YAMLParser new()
    parser setInputFile("bottle.yml")

    doc := Document new()
    parser parseAll(doc)

    walker := Walker new()
    walker walk(doc getRootNode())
}

Walker: class {

  indentation := 0

  walk: func (node: DocumentNode) {
    match (node) {
      case seq: ScalarNode => walkScalar(seq)
      case seq: SequenceNode => walkSequence(seq)
      case map: MappingNode => walkMapping(map)
      case emp: EmptyNode => "noop"
      case => put("<?>")
    }
  }

  walkSequence: func (node: SequenceNode) {
    put("["); indent(1)
    node toList() each(|elem|
      walk(elem)
    )
    indent(-1); put("]")
  }

  walkMapping: func (node: MappingNode) {
    put("{"); indent(1)
    node toHashMap() each(|k, v|
      putnoln("%s: " format(k))
      walk(v)
    )
    indent(-1); put("}")
  }

  walkScalar: func (node: ScalarNode) {
    put(node value)
  }

  indent: func (diff: Int) {
    indentation += diff
  }

  putIndent: func {
    for (i in 0..indentation) {
      "  " print()
    }
  }

  put: func (msg: String) {
    putIndent()
    msg println()
  }

  putnoln: func (msg: String) {
    putIndent()
    msg print()
  }

}

