use godot::prelude::*;

mod data;

struct MyExtension;

#[gdextension]
unsafe impl ExtensionLibrary for MyExtension {}