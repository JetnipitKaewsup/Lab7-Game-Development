extends Node3D

@export_group("Properties")
@export var target: Node

@export_group("Zoom")
@export var zoom_minimum = 16
@export var zoom_maximum = 4
@export var zoom_speed = 10

@export_group("Rotation")
@export var rotation_speed = 1
var movement_velocity: Vector3 = Vector3.ZERO
var camera_rotation:Vector3
var zoom = 10

@onready var camera = $Camera
var rotating = false
var sensitivity = 0.005
func _ready():
	camera_rotation = rotation_degrees
	#camera_rotation = rotation_degrees # Initial rotation
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #set mouse to center
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		rotating = event.pressed
		if rotating:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta):
	
	# Set position and rotation to targets
	
	self.position = self.position.lerp(target.position, delta * 4)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)
	
	handle_input(delta)
	
# Handle input

func handle_input(delta):
	
	if rotating:
		var mouse_motion = Input.get_last_mouse_velocity()
		camera_rotation.y -= mouse_motion.x * sensitivity
		camera_rotation.x -= mouse_motion.y * sensitivity
		camera_rotation.x = clamp(camera_rotation.x, -80, 80)
		rotation_degrees = camera_rotation
	
	
	
	# Zooming
	
	zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
	zoom = clamp(zoom, zoom_maximum, zoom_minimum)
