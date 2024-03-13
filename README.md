# FabAI - Cubzh Module for creating neural networks

## FabAI (constructor) Methods

- `fabai:createNetwork() -> network`: Create a new network.
- `fabai:importNetwork(export) -> network`: Import a exported network.

## Network Methods

### * - Optional

- `network:addLayer(neurons, biases*)`: Add a layer. Note: First (input) layers can't have biases.
- `network:compile()`: Compile (Create a weights) a network. After compiling you can't add layers
- `network:decompile()`: Decompile a network. This will erase all your weights without any recovery.
- `network:ask(input) -> table`: Ask a network. Input size must be first (input) layer size.
- `network:export() -> export`: Export network. Returns a table without functions that can be encoded to JSON
