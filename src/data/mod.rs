use godot::prelude::*;
use num_bigint::BigUint;

pub struct PlayerData {
    pub id: BigUint,
    pub username: String,
}