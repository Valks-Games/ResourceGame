extends Node

# Normalized converts vector to a length unit vector of 1 unit.
static func calc_target_velocity(mover, target, speed):
	return (target - mover).normalized() * speed