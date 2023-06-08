class_name TurnDirection

static var UP: TurnDirection = TurnDirection.new(0)
static var UP_LEFT: TurnDirection = TurnDirection.new(1)
static var UP_RIGHT: TurnDirection = TurnDirection.new(2)
static var DOWN: TurnDirection = TurnDirection.new(3)
static var DOWN_LEFT: TurnDirection = TurnDirection.new(4)
static var DOWN_RIGHT: TurnDirection = TurnDirection.new(5)
static var LEFT: TurnDirection = TurnDirection.new(6)
static var RIGHT: TurnDirection = TurnDirection.new(7)

var _v: int

func _init(v: int):
    self._v = v

func value_of() -> int:
    return self._v

var angle: float:
    get:
        return 180 if self == UP else 135 if self == UP_LEFT else 225 if self == UP_RIGHT else 0 if self == DOWN else 45 if self == DOWN_LEFT else 315 if self == DOWN_RIGHT else 90 if self == LEFT else 270 if self == RIGHT else 0

var speed:
    get:
        return Vector2(0, -1) if self == UP else Vector2(-1, -1) if self == UP_LEFT else Vector2(1, -1) if self == UP_RIGHT else Vector2(0, 1) if self == DOWN else Vector2(-1, 1) if self == DOWN_LEFT else Vector2(1, 1) if self == DOWN_RIGHT else Vector2(-1, 0) if self == LEFT else Vector2(1, 0) if self == RIGHT else Vector2.ZERO
