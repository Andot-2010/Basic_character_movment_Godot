extends CharacterBody2D
#var used to be able to play animations
@onready var animated_sprite = $AnimatedSprite2D
#movment speeds
@export var speed = 200
@export var run_speed_damping = 5
@export var jump_velocity = -500
#physics
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_direction = "Right" 

func _ready():
	animated_sprite.play("Idle_" + current_direction)
	pass
func _physics_process(delta):
	#Movement
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("Andrew_Jump") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_just_released("Andrew_Jump") and velocity.y < 0:
		velocity.y *= 0.5
		
	var direction_input = Input.get_axis("Andrew_Move_Left", "Andrew_Move_Right")
	
	if direction_input:
		velocity.x = lerpf(velocity.x, speed * direction_input, run_speed_damping * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
	#Animation
	if direction_input > 0:
		current_direction = "Right"
		if is_on_floor():
			animated_sprite.play("Move_Right")
		else:
			if velocity.y < 0:
				animated_sprite.play("Fall_Right")
				animated_sprite.stop()
			else:
				animated_sprite.play("Fall_Right") 
				animated_sprite.stop()
	elif direction_input < 0:
		current_direction = "Left"
		if is_on_floor():
			animated_sprite.play("Move_Left")
		else:
			if velocity.y < 0:
				animated_sprite.play("Fall_Left")
				animated_sprite.stop()
			else:
				animated_sprite.play("Fall_Left") 
				animated_sprite.stop()
	else:
		if is_on_floor():
			animated_sprite.play("Idle_" + current_direction)
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("Fall_" + current_direction)
			animated_sprite.stop()
	else:
		if velocity.x == 0:
			animated_sprite.play("Idle_" + current_direction)

	move_and_slide()
