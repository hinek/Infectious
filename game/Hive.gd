extends Area2D


func _ready():
	pass # Replace with function body.


func _on_Hive_body_entered(body):
	body.set_infected()
