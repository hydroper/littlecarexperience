class_name TurnDirection

static var _from: Dictionary = {}
static var UP: TurnDirection = TurnDirection.new(0, 180, Vector2(0, -1))
static var UP_LEFT: TurnDirection = TurnDirection.new(1, 135, Vector2(-1, -1))
static var UP_RIGHT: TurnDirection = TurnDirection.new(2, 225, Vector2(1, -1))
static var DOWN: TurnDirection = TurnDirection.new(3, 0, Vector2(0, 1))
static var DOWN_LEFT: TurnDirection = TurnDirection.new(4, 45, Vector2(-1, 1))
static var DOWN_RIGHT: TurnDirection = TurnDirection.new(5, 315, Vector2(1, 1))
static var LEFT: TurnDirection = TurnDirection.new(6, 90, Vector2(-1, 0))
static var RIGHT: TurnDirection = TurnDirection.new(7, 270, Vector2(1, 0))

var _v: int
var _speed: Vector2
var _angle: float

func _init(v: int, angle: float, speed: Vector2):
    self._v = v
    self._speed = speed
    self._angle = angle
    TurnDirection._from[v] = self

static func from(value: int) -> TurnDirection:
    return TurnDirection._from.get(value)

func value_of() -> int:
    return self._v

var angle: float:
    get:
        return self._angle

var speed:
    get:
        return self._speed
