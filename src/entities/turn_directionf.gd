class_name TurnDirectionf

static func angle(dir: TurnDirection) -> float:
    180 if dir == TurnDirection.UP else
    135 if dir == TurnDirection.UP_LEFT else
    225 if dir == TurnDirection.UP_RIGHT else
    0 if dir == TurnDirection.DOWN else
    45 if dir == TurnDirection.DOWN_LEFT else
    315 if dir == TurnDirection.DOWN_RIGHT else
    90 if dir == TurnDirection.X else
    270 if dir == TurnDirection.X else 0

static func speed_of(dir: TurnDirection, entity: AutomobileEntity) -> Vector2:
    return Vector2(0, -entity.move_speed) if this == TurnDirection.UP else
        Vector2(-entity.move_speed, -entity.move_speed) if this == TurnDirection.UP_LEFT else
        Vector2(entity.move_speed, -entity.move_speed) if this == TurnDirection.UP_RIGHT else
        Vector2(0, entity.move_speed) if this == TurnDirection.DOWN else
        Vector2(-entity.move_speed, entity.move_speed) if this == TurnDirection.DOWN_LEFT else
        Vector2(entity.move_speed, entity.move_speed) if this == TurnDirection.DOWN_RIGHT else
        Vector2(-entity.move_speed, 0) if this == TurnDirection.LEFT else
        Vector2(entity.move_speed, 0) if this == TurnDirection.RIGHT else Vector2.ZERO
