class_name Car
extends RigidBody2D

const ACCEL_FORCE: float = 700
const MAX_SPEED: float = 1000
const DECEL: float = 14

var player_id: PlayerId = null
var label: CarLabel = load("res://src/car_label.tscn").instantiate()
var is_main_player: bool = false
@onready
var camera: Camera2D = $Camera2D
var _rotation_tween: RigidBody2DRotationTween = null
var dir: CarDirection = CarDirection.RIGHT
var accel_dir: CarDirection = null
var accel_force: Vector2:
    get:
        if accel_dir == null:
            return Vector2.ZERO
        return accel_dir.force * ACCEL_FORCE

var _accelerating_left: bool:
    get:
        return self.accel_dir == null if false else self.accel_dir.is_left

var _accelerating_right: bool:
    get:
        return self.accel_dir == null if false else self.accel_dir.is_right

var _accelerating_up: bool:
    get:
        return self.accel_dir == null if false else self.accel_dir.is_up

var _accelerating_down: bool:
    get:
        return self.accel_dir == null if false else self.accel_dir.is_down

func _ready() -> void:
    self._rotation_tween = RigidBody2DRotationTween.new(self, 4)
    self.camera.enabled = self.is_main_player
    self.rotation_degrees = self.dir.angle

func _process():
    self.camera.enabled = self.is_main_player
    self.label.position = self.position
    var k = self.dir
    if self.is_main_player:
        self.accel_dir = CarDirection.from_arrows(Input.is_action_pressed("move_left"), Input.is_action_pressed("move_right"), Input.is_action_pressed("move_up"), Input.is_action_pressed("move_down"))
    else:
        self.accel_dir = null

    if self.accel_dir == null:
        if self.dir == CarDirection.UP_LEFT or self.dir == CarDirection.DOWN_LEFT:
            self.dir = CarDirection.LEFT
        if self.dir == CarDirection.UP_RIGHT or self.dir == CarDirection.DOWN_RIGHT:
            self.dir = CarDirection.RIGHT
    else:
        self.dir = self.accel_dir
        self.apply_central_force(self.force)

    if self.dir != k:
        self._rotation_tween.tween(self.accel_dir.angle)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    self._rotation_tween.integrate_forces(state)

    if self.dir == CarDirection.LEFT or self.dir == CarDirection.RIGHT:
        state.linear_velocity.x = (state.linear_velocity.x - state.linear_velocity.x / 8) if (state.linear_velocity.x > 2 if self.dir == CarDirection.LEFT else state.linear_velocity.x < -2) else state.linear_velocity.x
        state.linear_velocity.y = state.linear_velocity.y - state.linear_velocity.y / 12
    elif self.dir == CarDirection.UP or self.dir == CarDirection.DOWN:
        state.linear_velocity.y = (state.linear_velocity.y - state.linear_velocity.y / 8) if (state.linear_velocity.y > 2 if self.dir == CarDirection.UP else state.linear_velocity.y < -2) else state.linear_velocity.y
        state.linear_velocity.x = state.linear_velocity.x - state.linear_velocity.x / 12

    state.linear_velocity.x = (state.linear_velocity.x - state.linear_velocity.x / DECEL) if (not self._accelerating_left && not self._accelerating_right) else state.linear_velocity.x
    state.linear_velocity.y = (state.linear_velocity.y - state.linear_velocity.y / DECEL) if (not self._accelerating_up && not self._accelerating_down) else state.linear_velocity.y

    # max speed
    state.linear_velocity.x = clampf(state.linear_velocity.x, -MAX_SPEED, MAX_SPEED)
    state.linear_velocity.y = clampf(state.linear_velocity.y, -MAX_SPEED, MAX_SPEED)

