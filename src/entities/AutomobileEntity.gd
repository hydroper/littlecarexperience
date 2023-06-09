class_name AutomobileEntity
extends RigidBody2D

var player_data: PlayerData = null
var player_label: Node2D = preload("res://src/entities/EntityLabel.tscn").instantiate()

var is_main_player: bool = false

@onready
var _camera: Camera2D = $Camera2D

var _rotation_tween: ConstantPhysicsRotationTween = null

var _turn_dir: TurnDirection = TurnDirection.RIGHT

var _moving: bool = false
var _pressing_up: bool = false
var _pressing_down: bool = false
var _pressing_left: bool = false
var _pressing_right: bool = false
var _move_speed: float = 700
var _max_speed: float = 1000

const DECEL: float = 14

var move_speed: float:
    get:
        return self._move_speed

var raw_speed: Vector2:
    get:
        return (self._turn_dir.speed * self._move_speed) if self._moving else Vector2.ZERO

var current_rotation: float:
    get:
        return self.rotation_degrees

func _ready() -> void:
    self._rotation_tween = ConstantPhysicsRotationTween.new(self, 4)
    self._camera.enabled = self.is_main_player
    self.rotation_degrees = self._turn_dir.angle

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    self._rotation_tween.integrate_forces(state)

    if self._turn_dir == TurnDirection.LEFT or self._turn_dir == TurnDirection.RIGHT:
        state.linear_velocity.x = (state.linear_velocity.x - state.linear_velocity.x / 8) if (state.linear_velocity.x > 2 if self._turn_dir == TurnDirection.LEFT else state.linear_velocity.x < -2) else state.linear_velocity.x
        state.linear_velocity.y = state.linear_velocity.y - state.linear_velocity.y / 12
    elif self._turn_dir == TurnDirection.UP or self._turn_dir == TurnDirection.DOWN:
        state.linear_velocity.y = (state.linear_velocity.y - state.linear_velocity.y / 8) if (state.linear_velocity.y > 2 if self._turn_dir == TurnDirection.UP else state.linear_velocity.y < -2) else state.linear_velocity.y
        state.linear_velocity.x = state.linear_velocity.x - state.linear_velocity.x / 12

    state.linear_velocity.x = (state.linear_velocity.x - state.linear_velocity.x / DECEL) if (not self._pressing_left && not self._pressing_right) else state.linear_velocity.x
    state.linear_velocity.y = (state.linear_velocity.y - state.linear_velocity.y / DECEL) if (not self._pressing_up && not self._pressing_down) else state.linear_velocity.y

    # max speed
    state.linear_velocity.x = clampf(state.linear_velocity.x, -self._max_speed, self._max_speed)
    state.linear_velocity.y = clampf(state.linear_velocity.y, -self._max_speed, self._max_speed)

func _process(delta: float) -> void:
    self._camera.enabled = self.is_main_player
    self.player_label.position = self.position

    var k = self._turn_dir

    if self.is_main_player:
        self._pressing_up = Input.is_action_pressed("move_up")
        self._pressing_down = Input.is_action_pressed("move_down")
        self._pressing_left = Input.is_action_pressed("move_left")
        self._pressing_right = Input.is_action_pressed("move_right")
        self._turn_dir = TurnDirection.UP_LEFT if (self._pressing_up and self._pressing_left) else TurnDirection.UP_RIGHT if (self._pressing_up and self._pressing_right) else TurnDirection.UP if self._pressing_up else TurnDirection.DOWN_LEFT if (self._pressing_down and self._pressing_left) else TurnDirection.DOWN_RIGHT if (self._pressing_down and self._pressing_right) else TurnDirection.DOWN if self._pressing_down else TurnDirection.LEFT if self._pressing_left else TurnDirection.RIGHT if self._pressing_right else self._turn_dir
    else:
        self._pressing_up = false
        self._pressing_down = false
        self._pressing_left = false
        self._pressing_right = false

    if k != self._turn_dir:
        self._rotation_tween.tween(self._turn_dir.angle)

    self._moving = self._pressing_up or self._pressing_down or self._pressing_left or self._pressing_right

    if not self._moving:
        if self._turn_dir == TurnDirection.UP_LEFT or self._turn_dir == TurnDirection.DOWN_LEFT:
            self._turn_dir = TurnDirection.LEFT
            self._rotation_tween.tween(self._turn_dir.angle)
        elif self._turn_dir == TurnDirection.UP_RIGHT or self._turn_dir == TurnDirection.DOWN_RIGHT:
            self._turn_dir = TurnDirection.RIGHT
            self._rotation_tween.tween(self._turn_dir.angle)

    self.move_forward(delta)

func move_forward(_delta: float) -> void:
    # self.apply_force(self.raw_speed)
    self.apply_central_force(self.raw_speed)
