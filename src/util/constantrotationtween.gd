class_name ConstantRotationTween

var increment_degrees: float

var _tween_node: Node2D = null
var _running: bool = false
var _increment_scale: float = 1
var _target_degrees: float = 0
var _current_rotation: float = 0

func _init(increment_degrees: float):
    self.increment_degrees = increment_degrees
