class_name Angle

# Places rotation angle into the range 0-360.
static func zero_to_360(angle: float) -> float:
    return 360 - fmod(-angle, 360.0) if angle < 0 else fmod(angle, 360.0)