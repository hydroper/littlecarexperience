class_name ConstantRotationTween

var increment_degrees: float

var _tween_node: Node2D = null
var _running: bool = false
var _increment_scale: float = 1
var _target_degrees: float = 0
var _current_rotation: float = 0

var _route_result_go_clockwise: bool = false
var _route_result_delta: float = 0

var current_rotation: float:
    get:
        return self.current_rotation

func _init(increment_degrees: float):
    self.increment_degrees = increment_degrees

func is_running() -> bool:
    return self._running

func tween(tween_node: Node2D, target_degrees: float):
    if self.is_running():
        self._tween_node.rotation_degrees = self._current_rotation
        self.stop()
    self._tween_node = tween_node
    self._current_rotation = self._tween_node.rotation_degrees

    # keep target rotation between 0-360
    float a = target_degrees
    a = 360 - (-a % 360) if a < 0 else a
    self._target_degrees = Mathf.round(a) % 360

    self._running = true

func stop():
    self._running = false
    self._tween_node = null

func process(delta: float):
    if not self._running:
        return
    self._lock_tween_node_rotation()
    if self._current_rotation == self._target_degrees:
        self._running = false
        self._tween_node.rotation_degrees = self._current_rotation
        return
    self._update_route()
    var go_clockwise = self._route_result_go_clockwise
    var route_delta = self._route_result_delta
    self._current_rotation += self.increment_degrees * self._increment_scale * delta
    if self._route_delta <= 1.8:
        self._tween_node.rotation_degrees = self._target_degrees
        self._running = false
    else:
        self._tween_node.rotation_degrees = self._current_rotation

func _update_route():
    var a = self._target_degrees
    var b = self._current_rotation
    var ab = a - b
    var ba = b - a
    ab = ab + 360 if ab < 0 else ab
    ba = ba + 360 if ba < 0 else ba
    var go_clockwise = ab < ba
    self._increment_scale = 1 if go_clockwise else -1
    self._route_result_go_clockwise = go_clockwise
    self._route_result_delta = Mathf.round(ab if go_clockwise else ba)

# keep node rotation between 0-360.
func _lock_tween_node_rotation():
    var a = self._current_rotation
    a = 360 - (-a % 360) if a < 0 else a
    self._current_rotation = a % 360
