class_name RotationTween

var increment_degrees: float

var _tween_node: Node2D = null
var _running: bool = false
var _increment_scale: float = 1
var _final_degrees: float = 0
var _current_rotation: float = 0

var _route_result_go_clockwise: bool = false
var _route_result_delta: float = 0

var current_rotation: float:
    get:
        return self._current_rotation

# delta ~= 0.02
const COMMON_DELTA_SCALE = 50

func _init(increment_degrees: float):
    self.increment_degrees = increment_degrees * COMMON_DELTA_SCALE

func is_running() -> bool:
    return self._running

func tween(tween_node: Node2D, final_degrees: float):
    if self.is_running():
        self._tween_node.rotation_degrees = self._current_rotation
        self.stop()
    self._tween_node = tween_node
    self._current_rotation = self._tween_node.rotation_degrees
    self._final_degrees = fmod(roundf(Angle.zero_to_360(final_degrees)), 360.0)
    self._running = true

func stop() -> void:
    self._running = false
    self._tween_node = null

func process(delta: float) -> void:
    if not self._running:
        return
    self._lock_tween_node_rotation()
    if self._current_rotation == self._final_degrees:
        self._running = false
        self._tween_node.rotation_degrees = self._current_rotation
        return
    self._update_route()
    var route_delta = self._route_result_delta
    self._current_rotation += self._increment_scale if route_delta <= 2.7 else self.increment_degrees * self._increment_scale * delta
    self._tween_node.rotation_degrees = self._current_rotation

func _update_route() -> void:
    var a = self._final_degrees
    var b = self._current_rotation
    var ab = a - b
    var ba = b - a
    ab = ab + 360 if ab < 0 else ab
    ba = ba + 360 if ba < 0 else ba
    var go_clockwise = ab < ba
    self._increment_scale = 1 if go_clockwise else -1
    self._route_result_go_clockwise = go_clockwise
    self._route_result_delta = roundf(ab if go_clockwise else ba)

# keep node rotation between 0-360.
func _lock_tween_node_rotation() -> void:
    self._current_rotation = fmod(Angle.zero_to_360(self._current_rotation), 360)
