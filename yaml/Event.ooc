use yaml
import yaml/libyaml


Event: class {
    event: _Event

    type: func -> Int { event type }
}

StreamStartEvent: class extends Event {}

StreamEndEvent: class extends Event {}

DocumentStartEvent: class extends Event {}

DocumentEndEvent: class extends Event {}

AliasEvent: class extends Event {}

ScalarEvent: class extends Event {}

SequenceStartEvent: class extends Event {}

SequenceEndEvent: class extends Event {}

MappingStartEvent: class extends Event {}

MappingEndEvent: class extends Event {}
