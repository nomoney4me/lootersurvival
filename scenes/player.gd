extends CharacterBody2D
@export var speed = 300

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	if velocity.x == 0 && velocity.y == 0:
		$AnimatedSprite2D.animation = "default"
	if velocity.x != 0: # right		
		$AnimatedSprite2D.animation = "walk-right"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		if velocity.y < 0:
			$AnimatedSprite2D.animation = "walk-up"
		else:
			$AnimatedSprite2D.animation = "walk-down"
	move_and_slide()
	look_at(get_global_mouse_position())

function fire():
	var bullet_instance = bullet.instance()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)
