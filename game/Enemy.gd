extends KinematicBody2D


const MAX_SPEED = 50
const START_FOLLOW_DISTANCE = 70
const LOOSE_FOLLOW_DISTANCE = 150
const INFECTION_TIME = 5.0

var player = null
var following = false
var infected = 0
var die_timer = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().find_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if infected > 0:
		$Sprite.modulate = Color("abe025")
		$CPUParticles2D.show()
		infected -= delta
		if infected < 0.1:
			die()
			return
	
	if die_timer > 0:
		die_timer -= delta
		if die_timer < 0.1:
			queue_free()
		return
	
	for body in get_parent().get_children():
		if body is KinematicBody2D && body.infected > 0 && position.distance_to(body.position) < 32:
			set_infected()
	
	var distance = position.distance_to(player.position)
	if distance < 16:
		player.damage()
	
	if following && distance > LOOSE_FOLLOW_DISTANCE:
		following = false
	elif !following && distance < START_FOLLOW_DISTANCE:
		following = true
		
	var target = player.position if following else position	
	var motion = (target - position).normalized() * MAX_SPEED
	if motion.x != 0 || motion.y != 0:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")
	motion = move_and_slide(motion)


func set_infected():
	if infected == 0:
		infected = INFECTION_TIME


func die():
	$AnimationPlayer.play("die")
	die_timer = 2.0
