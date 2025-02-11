extends Node
#extends Node2D  # The "World" node or a dedicated spawner node

@export var enemy_scene : PackedScene  # The enemy scene to instantiate
@export var min_spawn_interval = 1.0
@export var max_spawn_interval = 3.0
var spawn_area

func _ready():

	#var viewport = get_viewport()
	#var viewport_rect = viewport.get_visible_rect()
	# Assuming you have a reference to your Camera2D node
	var camera = $Player/Camera2D

	# Assuming you have a reference to your Camera2D node
	#var camera = $Camera2D

	# Get the viewport's visible rectangle
	var viewport_rect = get_viewport().get_visible_rect()

	# Calculate the camera's visible rectangle in world coordinates
	var camera_rect = Rect2(
		camera.position - viewport_rect.size / (2 * camera.zoom),
		viewport_rect.size / camera.zoom
	)

	#Example: Setting spawn area
	spawn_area = Rect2(0, 0, camera_rect.size.x, camera_rect.size.y)
	randomize()  # Initialize random number generator
	$SpawnTimer.wait_time = randf_range(min_spawn_interval, max_spawn_interval)
	$SpawnTimer.start()

func _on_spawn_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	# 1. Generate random position within the world bounds
	var random_x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
	var random_y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	var random_position = Vector2(random_x, random_y)
	print_debug(random_position)

	# 2. Instantiate the enemy
	var enemy_instance = enemy_scene.instantiate()

	# 3. Add the enemy to the world
	add_child(enemy_instance)  # Or get_node("/root/World").add_child(enemy_instance) if this script is on a separate spawner.

	# 4. Set the enemy's position
	enemy_instance.position = random_position

	# 5. (Optional) Set the enemy's rotation (randomly)
	enemy_instance.rotation = randf() * 360

	# 6. Reset the timer for the next spawn
	$SpawnTimer.wait_time = randf_range(min_spawn_interval, max_spawn_interval)
	$SpawnTimer.start()

	# 7. (Optional) If you use Navigation2D, use this instead of direct position setting:
	# onready var navigation = get_node("/root/World/Navigation2D") # Replace with the actual path!
	# if navigation != null:
	#     var nav_safe_position = navigation.get_closest_point(random_position)
	#     enemy_instance.position = nav_safe_position
	# else:
	#     print("Navigation2D node not found!")
