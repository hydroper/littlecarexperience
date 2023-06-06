namespace Recoyx.CarKnockOnline.Util;

using Godot;

public class ConstantRotationTween
{
    public float IncrementDegrees;

    private Node2D _tweenNode = null;
    private bool _running = false;
    private float _incrementScale = 1;
    private float _targetDegrees = 0;
    private float _currentRotation = 0;

    public ConstantRotationTween(float incrementDegrees)
    {
        this.IncrementDegrees = incrementDegrees;
    }

    public bool IsRunning() => this._running;

    public float CurrentRotation
    {
        get => this._currentRotation;
    }

    public void Tween(Node2D tweenNode, float targetDegrees)
    {
        if (this.IsRunning())
        {
            this._tweenNode.RotationDegrees = this._currentRotation;
            this.Stop();
        }
        this._tweenNode = tweenNode;
        this._currentRotation = this._tweenNode.RotationDegrees;

        // keep target rotation between 0-360
        float a = targetDegrees;
        a = a < 0 ? 360 - (-a % 360) : a;
        this._targetDegrees = Mathf.Round(a) % 360;

        this._running = true;
    }

    public void Stop()
    {
        this._running = false;
        this._tweenNode = null;
    }

    public void Process(double delta)
    {
        if (!this._running)
        {
            return;
        }
        this._lockTweenNodeRotation();
        if (this._currentRotation == this._targetDegrees)
        {
            this._running = false;
            this._tweenNode.RotationDegrees = this._currentRotation;
            return;
        }
        (bool goClockwise, float routeDelta) = this._updateRoute();
        this._currentRotation += this.IncrementDegrees * this._incrementScale * ((float) delta);
        if (routeDelta <= 1.8)
        {
            this._tweenNode.RotationDegrees = this._targetDegrees;
            this._running = false;
        }
        else
        {
            this._tweenNode.RotationDegrees = this._currentRotation;
        }
    }

    private (bool goClockwise, float routeDelta) _updateRoute()
    {
        float a = this._targetDegrees;
        float b = this._currentRotation;
        float ab = a - b, ba = b - a;
        ab = ab < 0 ? ab + 360 : ab;
        ba = ba < 0 ? ba + 360 : ba;
        bool goClockwise = ab < ba;
        this._incrementScale = goClockwise ? 1 : -1;
        return (goClockwise, Mathf.Round(goClockwise ? ab : ba));
    }

    /// <summary>Keep node rotation between 0-360.</summary>
    private void _lockTweenNodeRotation()
    {
        float a = this._currentRotation;
        a = a < 0 ? 360 - (-a % 360) : a;
        this._currentRotation = a % 360;
    }
}