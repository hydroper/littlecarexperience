class_name CarDirection

static var _id_to_obj: Dictionary = {}

static var UP: CarDirection = CarDirection.new(0, 180, Vector2(0, -1))
static var UP_LEFT: CarDirection = CarDirection.new(1, 135, Vector2(-1, -1))
static var UP_RIGHT: CarDirection = CarDirection.new(2, 225, Vector2(1, -1))
static var DOWN: CarDirection = CarDirection.new(3, 0, Vector2(0, 1))
static var DOWN_LEFT: CarDirection = CarDirection.new(4, 45, Vector2(-1, 1))
static var DOWN_RIGHT: CarDirection = CarDirection.new(5, 315, Vector2(1, 1))
static var LEFT: CarDirection = CarDirection.new(6, 90, Vector2(-1, 0))
static var RIGHT: CarDirection = CarDirection.new(7, 270, Vector2(1, 0))

var id: int
var vector: Vector2
var angle: float

func _init(id: int, angle: float, vector: Vector2):
    self.id = id
    self.vector = vector
    self.angle = angle
    _id_to_obj[id] = self

static func from_id(id: int) -> CarDirection:
    return _id_to_obj.get(id)

static func from_arrows(left: bool, right: bool, up: bool, down: bool) -> CarDirection:
    if up:
        return UP_LEFT if left else UP_RIGHT if right else UP
    elif down:
        return DOWN_LEFT if left else DOWN_RIGHT if right else DOWN
    else:
        return LEFT if left else RIGHT if right else null

static var _UP_DIRECTIONS: Array = [UP, UP_LEFT, UP_RIGHT]
static var _DOWN_DIRECTIONS: Array = [DOWN, DOWN_LEFT, DOWN_RIGHT]
static var _LEFT_DIRECTIONS: Array = [LEFT, UP_LEFT, DOWN_LEFT]
static var _RIGHT_DIRECTIONS: Array = [RIGHT, UP_RIGHT, DOWN_RIGHT]

var is_up: bool:
    get:
        return self in _UP_DIRECTIONS

var is_down: bool:
    get:
        return self in _DOWN_DIRECTIONS

var is_left: bool:
    get:
        return self in _LEFT_DIRECTIONS

var is_right: bool:
    get:
        return self in _RIGHT_DIRECTIONS