using Godot;
using System;
using Recoyx.CarKnockOnline;
using Recoyx.CarKnockOnline.Util;

public partial class AutomobileEntity : RigidBody2D
{
    public PlayerData PlayerData = null;
    public bool IsMainPlayer = false;

    private Node2D _skin = null;
    private Camera2D _camera = null;
    private CollisionShape2D _collision = null;
    private ConstantRotationTween _rotation_tween = new ConstantRotationTween(200);

    private TurnDirection _turn_dir = TurnDirection.RIGHT;
    private bool _moving = false;
    private bool _pressing_up = false;
    private bool _pressing_down = false;
    private bool _pressing_left = false;
    private bool _pressing_right = false;
    private float _moveSpeed = 700;
    private float _max_speed = 1_000;

    private static float PIF = (float) Math.PI;
    private static float DECEL = 14;

    public float move_speed
    {
        get => self._moveSpeed;
    }

    public Vector2 RawSpeed
    {
        get => self._moving ? self._turn_dir.SpeedOf(this) : Vector2.Zero;
    }

    public override void _Ready()
    {
        self._skin = (Node2D) self.GetNode("skin");
        self._camera = (Camera2D) self.GetNode("Camera2D");
        self._camera.Enabled = self.IsMainPlayer;
        // self._camera.Enabled = false;
        self._collision = (CollisionShape2D) self.GetNode("collision");
        self._turn_dir = TurnDirection.RIGHT;
        self.rotation_degrees = self._turn_dir.Angle;
    }

    public override void _IntegrateForces(PhysicsDirectBodyState2D state)
    {
        Vector2 k;
        self.rotation_degrees = self._rotation_tween.is_running() ? self._rotation_tween.current_rotation : self._turn_dir.Angle;

        if (self._turn_dir == TurnDirection.LEFT || self._turn_dir == TurnDirection.RIGHT)
        {
            self.linear_velocity = (self._turn_dir == TurnDirection.LEFT ? self.linear_velocity.X > 2 : self.linear_velocity.X < -2) ? self.linear_velocity with {X = self.linear_velocity.X - self.linear_velocity.X / 8} : self.linear_velocity;
            self.linear_velocity = self.linear_velocity with {Y = self.linear_velocity.Y - self.linear_velocity.Y / 12};
        }
        else if (self._turn_dir == TurnDirection.UP || self._turn_dir == TurnDirection.DOWN)
        {
            self.linear_velocity = (self._turn_dir == TurnDirection.UP ? self.linear_velocity.Y > 2 : self.linear_velocity.Y < -2) ? self.linear_velocity with {Y = self.linear_velocity.Y - self.linear_velocity.Y / 8} : self.linear_velocity;
            self.linear_velocity = self.linear_velocity with {X = self.linear_velocity.X - self.linear_velocity.X / 12};
        }

        self.linear_velocity = (!self._pressing_left && !self._pressing_right) ? self.linear_velocity with {X = self.linear_velocity.X - self.linear_velocity.X / DECEL} : self.linear_velocity;
        self.linear_velocity = (!self._pressing_up && !self._pressing_down) ? self.linear_velocity with {Y = self.linear_velocity.Y - self.linear_velocity.Y / DECEL} : self.linear_velocity;

        // maximum speed
        k = self.linear_velocity;
        self.linear_velocity = k with {
            x = k.x < -self._max_speed ? -self._max_speed : k.x > self._max_speed ? self._max_speed : k.x,
            y = k.y < -self._max_speed ? -self._max_speed : k.y > self._max_speed ? self._max_speed : k.y,
        };
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        self._camera.Enabled = self.IsMainPlayer;
        // self._camera.Enabled = false;
        if (self.IsMainPlayer)
        {
            self._pressing_up = Input.is_action_pressed("move_up")
            self._pressing_down = Input.is_action_pressed("move_down")
            self._pressing_left = Input.is_action_pressed("move_left")
            self._pressing_right = Input.is_action_pressed("move_right")

            var k = self._turn_dir;
            self._turn_dir =
                (self._pressing_up && self._pressing_left) ? TurnDirection.UP_LEFT :
                (self._pressing_up && self._pressing_right) ? TurnDirection.UP_RIGHT :
                self._pressing_up ? TurnDirection.UP :
                (self._pressing_down && self._pressing_left) ? TurnDirection.DOWN_LEFT :
                (self._pressing_down && self._pressing_right) ? TurnDirection.DOWN_RIGHT :
                self._pressing_down ? TurnDirection.DOWN :
                self._pressing_left ? TurnDirection.LEFT :
                self._pressing_right ? TurnDirection.RIGHT : self._turn_dir;
            if (k != self._turn_dir)
            {
                self._rotation_tween.Tween(this, self._turn_dir.Angle);
            }
            self._moving = self._pressing_up || self._pressing_down || self._pressing_left || self._pressing_right;
            if (!self._moving)
            {
                if (self._turn_dir == TurnDirection.UP_LEFT || self._turn_dir == TurnDirection.DOWN_LEFT)
                {
                    self._turn_dir = TurnDirection.LEFT;
                    self._rotation_tween.Tween(this, self._turn_dir.Angle);
                }
                else if (self._turn_dir == TurnDirection.UP_RIGHT || self._turn_dir == TurnDirection.DOWN_RIGHT)
                {
                    self._turn_dir = TurnDirection.RIGHT;
                    self._rotation_tween.Tween(this, self._turn_dir.Angle);
                }
            }
        }
        else
        {
            self._pressing_up = false
            self._pressing_down = false
            self._pressing_left = false
            self._pressing_right = false
        }

        self.rotation_degrees = self._rotation_tween.current_rotation if self._rotation_tween.is_running() else TurnDirectionf.angle(self._turn_dir)
        self.move_forward(delta)
        self.rotation_degrees = self._rotation_tween.current_rotation if self._rotation_tween.is_running() else TurnDirectionf.angle(self._turn_dir)
        self._rotation_tween.process(delta)
    }

    private float currentRotation
    {
        get => self.rotation_degrees;
        set
        {
            self.rotation_degrees = value;
        }
    }

    private void move_forward(double delta)
    {
        self.ApplyCentralForce(self.RawSpeed);
    }
}

public sealed class TurnDirection
{
    public static TurnDirection Up = new TurnDirection(180);
    public static TurnDirection UpLeft = new TurnDirection(135);
    public static TurnDirection UpRight = new TurnDirection(225);
    public static TurnDirection Down = new TurnDirection(0);
    public static TurnDirection DownLeft = new TurnDirection(45);
    public static TurnDirection DownRight = new TurnDirection(315);
    public static TurnDirection Left = new TurnDirection(90);
    public static TurnDirection Right = new TurnDirection(270);

    private float _angle;

    private TurnDirection(float angle)
    {
        self._angle = angle;
    }

    public float Angle
    {
        get => self._angle;
    }

    public Vector2 SpeedOf(AutomobileEntity entity) =>
        this == TurnDirection.Up ? Vector2(0, -entity.move_speed) :
        this == TurnDirection.UpLeft ? Vector2(-entity.move_speed, -entity.move_speed) :
        this == TurnDirection.UpRight ? Vector2(entity.move_speed, -entity.move_speed) :
        this == TurnDirection.Down ? Vector2(0, entity.move_speed) :
        this == TurnDirection.DownLeft ? Vector2(-entity.move_speed, entity.move_speed) :
        this == TurnDirection.DownRight ? Vector2(entity.move_speed, entity.move_speed) :
        this == TurnDirection.Left ? Vector2(-entity.move_speed, 0) :
        this == TurnDirection.Right ? Vector2(entity.move_speed, 0) : Vector2.Zero
}