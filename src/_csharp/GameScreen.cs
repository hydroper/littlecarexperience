using Godot;
using System;
using System.Collections.Generic;
using Recoyx.CarKnockOnline;

public partial class GameScreen : Node2D
{
    private GameData GameData = new GameData();
    private AutomobileEntity MainPlayerEntity = null;
    private Node2D World = null;
    private Node2D WorldEntities = null;

    public GameScreen()
    {
        self.MainPlayerEntity = (AutomobileEntity) GD.Load<PackedScene>("res://src/entities/AutomobileEntity.tscn").Instantiate();
    }

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        // World
        self.World = (Node2D) self.GetNode("world");

        // WorldEntities
        self.WorldEntities = (Node2D) self.GetNode("world/entities");

        // MainPlayerEntity
        self.MainPlayerEntity.Position = new Vector2(600, 430);
        self.MainPlayerEntity.IsMainPlayer = true;
        self.WorldEntities.AddChild(self.MainPlayerEntity);
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }
}
