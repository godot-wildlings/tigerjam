"""
if there's a forward vector on the car, compare against wheel friction vector and redirect car.

what happens when forward vector overcomes friction? spin out?

"""

extends Node2D

var wheel_range : Array = [-PI/4, PI/4] # in radians
var wheel_turn_increment : float = 2
var wheel_angle : float = 0.0

var tire_grip : float = 300.0 # magnitude of vector tires can redirect

var grip_vector : Vector2 = Vector2.ZERO

var car : RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	car = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("turn_wheel_clockwise"):
		wheel_angle = clamp(wheel_angle + wheel_turn_increment * delta, wheel_range[0], wheel_range[1])
	elif Input.is_action_pressed("turn_wheel_counterclockwise"):
		wheel_angle = clamp(wheel_angle - wheel_turn_increment * delta, wheel_range[0], wheel_range[1])

	$FrontWheelL.set_rotation(wheel_angle)
	$FrontWheelR.set_rotation(wheel_angle)

	grip_vector = Vector2.RIGHT.rotated(wheel_angle) * tire_grip

func is_turning_wheel() -> bool:
	var turning = false
	if Input.is_action_pressed("turn_wheel_clockwise"):
		turning = true
	if Input.is_action_pressed("turn_wheel_counterclockwise"):
		turning = true
	return turning

func _on_RecenterWheelTimer_timeout():
	if not is_turning_wheel():
		#wheel_angle -= wheel_turn_increment * 0.1 * sign(wheel_angle)
		wheel_angle = lerp(wheel_angle, 0, 0.33)