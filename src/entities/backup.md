# Unused

## Automobile entity

```
using Godot;
using System;
using Recoyx.CarKnockOnline;
using Recoyx.CarKnockOnline.Util;

public partial class AutomobileEntity : CharacterBody2D
{
    public PlayerData PlayerData = null;
    public Vector2 RawVelocity = new Vector2(0, 0);
    public Vector2 RawDeacceleration = new Vector2(0, 0);
    public bool IsMainPlayer = false;

    private TurnDirection _direction = TurnDirection.Right;
    private bool _accelerating = false;
    private Node2D _skin = null;
    private CollisionShape2D _collision = null;
    private ConstantRotationTween _rotationTween = new ConstantRotationTween(200);

    private static float ACCELERATION = 512;
    private static float DEACCELERATION = 400;
    private static float DIRECTION_ACCELERATION_RESET = 18_400;
    private static float MAX_VELOCITY = 454_000;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        this._skin = (Node2D) this.GetNode("skin");
        this._skin.RotationDegrees = -90;
        this._collision = (CollisionShape2D) this.GetNode("collision");
        this._collision.RotationDegrees = -90;
    }

    private void _initRotationTween()
    {
        this._stopRotationTween();
        // this._rotationTween = this.GetTree().CreateTween();
        // this._rotationTween.SetTrans(Tween.TransitionType.Linear);
    }

    private bool _rotationTweenIsActive() => this._rotationTween.IsRunning();

    private void _stopRotationTween()
    {
        this._rotationTween.Stop();
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        if (this.IsMainPlayer)
        {
            var pressingUp = Input.IsActionPressed("move_up");
            var pressingDown = Input.IsActionPressed("move_down");
            var pressingLeft = Input.IsActionPressed("move_left");
            var pressingRight = Input.IsActionPressed("move_right");

            if (pressingUp && pressingLeft)
            {
                if (this._direction != TurnDirection.UpLeft)
                {
                    this._direction = TurnDirection.UpLeft;
                    this._initRotationTween();
                    this._rotationTween.Tween(this._collision, 135);
                    // deaccelerate from previous direction
                    var k2 = this.RawVelocity;
                    this.RawVelocity = k2 with {X = k2.X > DIRECTION_ACCELERATION_RESET ? DIRECTION_ACCELERATION_RESET : k2.X, Y = k2.Y > DIRECTION_ACCELERATION_RESET ? DIRECTION_ACCELERATION_RESET : k2.Y};
                }
                var k = this.RawVelocity;
                k = k with {X = k.X - ACCELERATION, Y = k.Y - ACCELERATION};
                this.RawVelocity = k with {X = k.X < -MAX_VELOCITY ? -MAX_VELOCITY : k.X, Y = k.Y < -MAX_VELOCITY ? -MAX_VELOCITY : k.Y};
            }
            else if (pressingUp && pressingRight)
            {
                if (this._direction != TurnDirection.UpRight)
                {
                    this._direction = TurnDirection.UpRight;
                    this._initRotationTween();
                    this._rotationTween.Tween(this._collision, -135);
                    // deaccelerate from previous direction
                    var k2 = this.RawVelocity;
                    this.RawVelocity = k2 with {X = k2.X < -DIRECTION_ACCELERATION_RESET ? -DIRECTION_ACCELERATION_RESET : k2.X, Y = k2.Y > DIRECTION_ACCELERATION_RESET ? DIRECTION_ACCELERATION_RESET : k2.Y};
                }
                var k = this.RawVelocity;
                k = k with {X = k.X + ACCELERATION, Y = k.Y - ACCELERATION};
                this.RawVelocity = k with {X = k.X > MAX_VELOCITY ? MAX_VELOCITY : k.X, Y = k.Y < -MAX_VELOCITY ? -MAX_VELOCITY : k.Y};
            }
            else if (pressingUp)
            {
                if (this._direction != TurnDirection.Up)
                {
                    this._direction = TurnDirection.Up;
                    this._initRotationTween();
                    this._rotationTween.Tween(this._collision, 180);
                    // deaccelerate from previous direction
                    var k2 = this.RawVelocity;
                    this.RawVelocity = k2 with {X = k2.X < -DIRECTION_ACCELERATION_RESET ? -DIRECTION_ACCELERATION_RESET : k2.X > DIRECTION_ACCELERATION_RESET ? DIRECTION_ACCELERATION_RESET : k2.X, Y = k2.Y > DIRECTION_ACCELERATION_RESET ? DIRECTION_ACCELERATION_RESET : k2.Y};
                }
                var k = this.RawVelocity;
                k = k with {Y = k.Y - ACCELERATION};
                this.RawVelocity = k with {Y = k.Y < -MAX_VELOCITY ? -MAX_VELOCITY : k.Y};
            }
            else if (pressingDown && pressingLeft)
            {
                if (this._direction != TurnDirection.DownLeft)
                {
                    this._direction = TurnDirection.DownLeft;
                    this._initRotationTween();
                    this._rotationTween.Tween(this._collision, 45);
                    // deaccelerate from previous direction
                    var k2 = this.RawVelocity;
                    this.RawVelocity = k2 with {X = k2.X > DIRECTION_ACCELERATION_RESET ? DIRECTION_ACCELERATION_RESET : k2.X, Y = k2.Y < -DIRECTION_ACCELERATION_RESET ? -DIRECTION_ACCELERATION_RESET : k2.Y};
                }
                var k = this.RawVelocity;
                k = k with {X = k.X - ACCELERATION, Y = k.Y + ACCELERATION};
                this.RawVelocity = k with {X = k.X < -MAX_VELOCITY ? -MAX_VELOCITY : k.X, Y = k.Y > MAX_VELOCITY ? MAX_VELOCITY : k.Y};
            }
            else if (pressingDown && pressingRight)
            {
                if (this._direction != TurnDirection.DownRight)
                {
                    this._direction = TurnDirection.DownRight;
                    this._initRotationTween();
                    this._rotationTween.Tween(this._collision, -45);
                    // deaccelerate from previous direction
                    var k2 = this.RawVelocity;
                    this.RawVelocity = k2 with {X = k2.X < -DIRECTION_ACCELERATION_RESET ? -DIRECTION_ACCELERATION_RESET : k2.X, Y = k2.Y < -DIRECTION_ACCELERATION_RESET ? -DIRECTION_ACCELERATION_RESET : k2.Y};
                }
                var k = this.RawVelocity;
                k = k with {X = k.X + ACCELERATION, Y = k.Y + ACCELERATION};
                this.RawVelocity = k with {X = k.X > MAX_VELOCITY ? MAX_VELOCITY : k.X, Y = k.Y > MAX_VELOCITY ? MAX_VELOCITY : k.Y};
            }
            else if (pressingDown)
            {
                if (this._direction != TurnDirection.Down)
                {
                    this._direction = TurnDirection.Down;
                    this._initRotationTween();
                    this._rotationTween.Tween(this._collision, 0);
                    // deaccelerate from previous direction
                    var k2 = this.RawVelocity;
                    this.RawVelocity = k2 with {X = k2.X < -DIRECTION_ACCELERATION_RESET ? -DIRECTION_ACCELERATION_RESET : k2.X > DIRECTION_ACCELERATION_RESET ? DIRECTION_ACCELERATION_RESET : k2.X, Y = k2.Y < -DIRECTION_ACCELERATION_RESET ? -DIRECTION_ACCELERATION_RESET : k2.Y};
                }
                var k = this.RawVelocity;
                k = k with {Y = k.Y + ACCELERATION};
                this.RawVelocity = k with {Y = k.Y > MAX_VELOCITY ? MAX_VELOCITY : k.Y};
            }
            else if (pressingLeft)
            {
                if (this._direction != TurnDirection.Left)
                {
                    this._direction = TurnDirection.Left;
                    this._initRotationTween();
                    this._rotationTween.Tween(this._collision, 90);
                    // deaccelerate from previous direction
                    var k2 = this.RawVelocity;
                    this.RawVelocity = k2 with {X = k2.X > DIRECTION_ACCELERATION_RESET ? DIRECTION_ACCELERATION_RESET : k2.X, Y = k2.Y < -DIRECTION_ACCELERATION_RESET ? -DIRECTION_ACCELERATION_RESET : k2.Y > DIRECTION_ACCELERATION_RESET ? DIRECTION_ACCELERATION_RESET : k2.Y};
                }
                var k = this.RawVelocity;
                k = k with {X = k.X - ACCELERATION};
                this.RawVelocity = k with {X = k.X < -MAX_VELOCITY ? -MAX_VELOCITY : k.X};
            }
            else if (pressingRight)
            {
                if (this._direction != TurnDirection.Right)
                {
                    this._direction = TurnDirection.Right;
                    this._initRotationTween();
                    this._rotationTween.Tween(this._collision, -90);
                    // deaccelerate from previous direction
                    var k2 = this.RawVelocity;
                    this.RawVelocity = k2 with {X = k2.X < -DIRECTION_ACCELERATION_RESET ? -DIRECTION_ACCELERATION_RESET : k2.X, Y = k2.Y < -DIRECTION_ACCELERATION_RESET ? -DIRECTION_ACCELERATION_RESET : k2.Y > DIRECTION_ACCELERATION_RESET ? DIRECTION_ACCELERATION_RESET : k2.Y};
                }
                var k = this.RawVelocity;
                k = k with {X = k.X + ACCELERATION};
                this.RawVelocity = k with {X = k.X > MAX_VELOCITY ? MAX_VELOCITY : k.X};
            }
            // do not let car idle in a diagonal
            else if (this._direction == TurnDirection.UpLeft
                ||   this._direction == TurnDirection.DownLeft)
            {
                this._direction = TurnDirection.Left;
                this._initRotationTween();
                this._rotationTween.Tween(this._collision, 90);
            }
            // do not let car idle in a diagonal
            else if (this._direction == TurnDirection.UpRight
                ||   this._direction == TurnDirection.DownRight)
            {
                this._direction = TurnDirection.Right;
                this._initRotationTween();
                this._rotationTween.Tween(this._collision, -90);
            }

            // deacceleration
            if (!pressingLeft && !pressingRight)
            {
                RawDeacceleration = RawDeacceleration with { X = RawDeacceleration.X == 0 ? DEACCELERATION : RawDeacceleration.X };
                var k = this.RawVelocity;
                this.RawVelocity = k with { X = k.X + (k.X > 0 ? -RawDeacceleration.X : RawDeacceleration.X) };
                RawDeacceleration = RawDeacceleration with { X = RawDeacceleration.X - 30 };
                RawDeacceleration = RawDeacceleration with { X = RawDeacceleration.X < 0 ? 0 : RawDeacceleration.X < 10 ? 1 : RawDeacceleration.X };
            }
            else
            {
                RawDeacceleration = RawDeacceleration with { X = 0 };
            }
            if (!pressingUp && !pressingDown)
            {
                RawDeacceleration = RawDeacceleration with { Y = RawDeacceleration.Y == 0 ? DEACCELERATION : RawDeacceleration.Y };
                var k = this.RawVelocity;
                this.RawVelocity = k with { Y = k.Y + (k.Y > 0 ? -RawDeacceleration.Y : RawDeacceleration.Y) };
                RawDeacceleration = RawDeacceleration with { Y = RawDeacceleration.Y - 30 };
                RawDeacceleration = RawDeacceleration with { Y = RawDeacceleration.Y < 0 ? 0 : RawDeacceleration.Y < 10 ? 1 : RawDeacceleration.Y };
            }
            else
            {
                RawDeacceleration = RawDeacceleration with { Y = 0 };
            }
        }
        this.Velocity = this.RawVelocity * ((float) delta);
        this._skin.RotationDegrees = this._collision.RotationDegrees;
        if (this.MoveAndSlide())
        {
            for (int i = 0; i < this.GetSlideCollisionCount(); ++i)
            {
                var collision = this.GetSlideCollision(i);
                if (collision.GetCollider() is StaticBody2D)
                {
                    var angle = Mathf.Round(collision.GetAngle());
                    if (collision.GetPosition().Y <= this.Position.Y && angle == 3)
                    {
                        var k = this.RawVelocity;
                        this.RawVelocity = k with { Y = k.Y < 0 ? 0 : k.Y };
                    }
                    else if (collision.GetPosition().Y >= this.Position.Y && angle == 0)
                    {
                        var k = this.RawVelocity;
                        this.RawVelocity = k with { Y = k.Y > 0 ? 0 : k.Y };
                    }
                    else if (collision.GetPosition().X <= this.Position.X && angle == 2)
                    {
                        var k = this.RawVelocity;
                        this.RawVelocity = k with { X = k.X < 0 ? 0 : k.X };
                    }
                    else if (collision.GetPosition().X >= this.Position.X && angle == 2)
                    {
                        var k = this.RawVelocity;
                        this.RawVelocity = k with { X = k.X > 0 ? 0 : k.X };
                    }
                }
            }
        }
        this._rotationTween.Process(delta);
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

    public TurnDirection(float angle)
    {
        this._angle = angle;
    }

    public float Angle
    {
        get => this._angle;
    }
}
```

### Do not let car idle on a diagonal

This was simplified in the current code. The following considers the direction with the maximum speed.

```
// do not let car idle in a diagonal
else if (this._direction == TurnDirection.UpLeft)
{
    if (this.RawVelocity.X < this.RawVelocity.Y)
    {
        this._direction = TurnDirection.Left;
        this._initRotationTween();
        this._rotationTween.Tween(this._collision, 90);
    }
    else
    {
        this._direction = TurnDirection.Up;
        this._initRotationTween();
        this._rotationTween.Tween(this._collision, 180);
    }
}
// do not let car idle in a diagonal
else if (this._direction == TurnDirection.UpRight)
{
    if (this.RawVelocity.X > -this.RawVelocity.Y)
    {
        this._direction = TurnDirection.Right;
        this._initRotationTween();
        this._rotationTween.Tween(this._collision, -90);
    }
    else
    {
        this._direction = TurnDirection.Up;
        this._initRotationTween();
        this._rotationTween.Tween(this._collision, 180);
    }
}
// do not let car idle in a diagonal
else if (this._direction == TurnDirection.DownLeft)
{
    if (this.RawVelocity.X < -this.RawVelocity.Y)
    {
        this._direction = TurnDirection.Left;
        this._initRotationTween();
        this._rotationTween.Tween(this._collision, 90);
    }
    else
    {
        this._direction = TurnDirection.Down;
        this._initRotationTween();
        this._rotationTween.Tween(this._collision, 0);
    }
}
// do not let car idle in a diagonal
else if (this._direction == TurnDirection.DownRight)
{
    if (this.RawVelocity.X > this.RawVelocity.Y)
    {
        this._direction = TurnDirection.Right;
        this._initRotationTween();
        this._rotationTween.Tween(this._collision, -90);
    }
    else
    {
        this._direction = TurnDirection.Down;
        this._initRotationTween();
        this._rotationTween.Tween(this._collision, 0);
    }
}
```