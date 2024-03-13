# CloneManager - SubModule for managing multiple neural networks

## CloneManager Methods

### * - Optional

- `cloneManager:createClones() -> clones`: Create new networks.
- `cloneManager:importNetwork(exports) -> clones`: Import a exported networks.
- `cloneManager:addLayer(clones, neurons, biases*)`: Add a layer. Note: First (input) layers can't have biases.
- `cloneManager:compile(clones)`: Compile (Create a weights) networks. After compiling you can't add layers
- `cloneManager:decompile(clones)`: Decompile networks. This will erase all your weights without any recovery.
- `cloneManager:ask(clones, input) -> table`: Ask networks. Input size must be first (input) layer size.
- `cloneManager:export(clones) -> exports`: Export networks. Returns a table of exports without functions that can be encoded to JSON
