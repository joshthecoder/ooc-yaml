use yaml
import yaml/[Parser, Event]

main: func {
    parser := EventParser new()
    parser loadFromString("[1,2,3]")

    e := parser parse()
}
