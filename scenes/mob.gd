extends RigidBody2D
#
### Called every frame. 'delta' is the elapsed time since the previous frame.
#@onready var player := $"../Player"
#@export	var speed = 50.0
#
#func _physics_process(delta: float) -> void:
	#if player != null:
		#var direction = position.direction_to(player.position)
		#apply_force(direction * speed, Vector2.ZERO)
		##linear_velocity = direction * speed
		##look_at(player.paosition)  # Rotate to face the player (optional)

# Mob.gd (Attached to each mob RigidBody2D)

@export var speed = 200.0
@export var detection_radius = 300.0

# Use onready for node references
@onready var player := $"../Player"

func _ready():
	# Find the player using a function in a separate "PlayerManager" script
	#player = get_node("/root/Player").get_player() # Replace with the correct path

	if player == null:
		print("Warning: Player not found!")

func _physics_process(delta):
	linear_damp = 1.5 # Adjust this value!
	angular_damp = 1.5 # Adjust this value!
	
	if player == null:
		return  # Player not found, nothing to do

	var distance_to_player = position.distance_to(player.position)

	if distance_to_player <= detection_radius:
		var direction = position.direction_to(player.position)

		# Apply force (or impulse)
		apply_force(direction * speed, Vector2.ZERO) # At center of mass

		# Or for impulse:
		# apply_impulse(direction * speed, Vector2.ZERO) # At center of mass

		look_at(player.position) # Optional: Rotate to face player
	else:
		# Stop moving if player is out of range
		linear_velocity = Vector2.ZERO # Stop immediately
		# Or you might want to apply a small opposing force to slow down
		# when the player is out of range, or set linear_velocity to Vector2.ZERO
		# linear_velocity = linear_velocity * 0.95 # Example of slowing down.
