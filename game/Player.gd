extends KinematicBody2D


const ACCELERATION = 512
const HEALTHY_MAX_SPEED = 130
const INFECTED_MAX_SPEED = 80
const INFECTION_TIME = 8.0
const FRICTION = 0.2


var velocity = Vector2.ZERO
var infected = 0
var invincible = 0
var life = 3 setget set_life


# Called when the node enters the scene tree for the first time.
func _ready():
	set_life(3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if life < 1:
		return
	
	var max_speed = HEALTHY_MAX_SPEED
	if infected > 0:
		$Sprite.modulate = Color("abe025")
		$CPUParticles2D.show()
		max_speed = INFECTED_MAX_SPEED
		infected = clamp(infected - delta, 0, 10)
		if infected < 0.1:
			for i in range(1, 4):
				var icon = get_node("Life%d" % i)
				icon.modulate = Color("fafdff")
			infected = 0
			set_life(life - 1)
			if life < 1:
				return
	else:
		$Sprite.modulate = Color("fafdff")
		$CPUParticles2D.hide()
	
	if invincible > 0:
		invincible = clamp(invincible - delta, 0, 10)
	
	var input = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	
	if input != Vector2.ZERO:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")
	
	if input.x == 0:
		velocity.x = lerp(velocity.x, 0, FRICTION)
	else:
		velocity.x = clamp(velocity.x + input.x * ACCELERATION * delta, -max_speed, max_speed)
	
	if input.y == 0:
		velocity.y = lerp(velocity.y, 0, FRICTION)
	else:
		velocity.y = clamp(velocity.y + input.y * ACCELERATION * delta, -max_speed, max_speed)
	
	velocity = move_and_slide(velocity)
	pass


func damage():
	if invincible == 0:
		set_life(life - 1)
		invincible = 2.0


func set_infected():
	for i in range(1, 4):
		var icon = get_node("Life%d" % i)
		icon.modulate = Color("abe025")
	infected = INFECTION_TIME


func set_life(value):
	life = value
	for i in range(1, 4):
		var icon = get_node("Life%d" % i)
		icon.region_rect.position.x = 640 if life < i else 672
	if life < 1:
		game_over()


func game_over():
	$AnimationPlayer.play("die")
	$RestartTimer.start()


func _on_RestartTimer_timeout():
	get_tree().reload_current_scene()
