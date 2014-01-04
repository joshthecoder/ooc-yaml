
[![Build Status](https://secure.travis-ci.org/nddrylliog/ooc-yaml.png?branch=master)](https://travis-ci.org/nddrylliog/ooc-yaml)

## ooc-yaml

An ooc binding for the libyaml parser and emitter.

### Example parsing

First, use the yaml package and import everything you need:

```ooc
use yaml
import yaml/[Parser, Document, Utils]
```

Then, create a parser and set it up with your input:

```ooc
parser := YAMLParser new(File new("bottle.yml"))
doc := parser parseDocument()
```

Get the root node:

```ooc
root := doc getRootNode()
```

And then iterate through it to find your values. Example for a map:

```ooc
root each(|k, v|
    "Got key #{k}" println()
)
```

For a list:

```ooc
root each(|node|
    "Got node #{node _}" println()
)
```

Note that `_` is a shortcut to convert a scalar node to a string.

See the `samples/` directory for custom callbacks, multiple documents, etc.

### Authors

  * Joshua Roesslein (aka @joshthecoder)
  * Amos Wenger (aka @nddrylliog)

### License

ooc-yaml is distributed under the MIT license. See the `LICENSE` file for more
details.

### Links

  * The YAML format: <http://yaml.org>
  * libyaml: <http://pyyaml.org/wiki/LibYAML>

