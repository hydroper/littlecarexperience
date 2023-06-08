extends Node2D

var game_data: GameData = GameData.new()
var main_player: AutomobileEntity = null

@onready
var world: Node2D = $world

@onready
var world_entities: Node2D = $world/entities

@onready
var world_entity_labels: Node2D = $world/entity_labels

func _ready() -> void:
    self.main_player = preload("res://src/entities/AutomobileEntity.tscn").instantiate()
    self.main_player.position = Vector2(600, 430)
    self.main_player.is_main_player = true
    self.world_entities.add_child(self.main_player)
    self.world_entity_labels.add_child(self.main_player.player_label)

func _process(_delta: float) -> void:
    pass
