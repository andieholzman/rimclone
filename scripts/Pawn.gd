extends CharacterBody2D
@onready var tile_map = $"../TileMap"
@onready var pathfinding = $"../Pathfinding"
@onready var camera_2d = %Camera2D
@onready var item_manager = $"../ItemManager"


const SPEED = 200.0;
var path = [];

func _physics_process(delta):
	# Handle jump.
	var worldSizeOffset = tile_map.rendering_quadrant_size;
	
	
	
	if Input.is_action_just_pressed("click"):
		var pos = position	/ worldSizeOffset;
		var mousePos = get_global_mouse_position() / worldSizeOffset
		var targetPos = Vector2(round(mousePos.x),round(mousePos.y));
		print("Curr: " + str(pos) + "| Goal: " + str(targetPos));
		path = pathfinding.RequestPath(pos,targetPos);
		
	if Input.is_action_just_pressed("ui_accept"):
		var pos = position	/ worldSizeOffset;
		var targetPos = item_manager.FindNearestItem("Food",position).position / worldSizeOffset;
		
		print("Curr: " + str(pos) + "| Goal: " + str(targetPos));
		path = pathfinding.RequestPath(pos,targetPos);

		
	if len(path) > 0:
		var direction = global_position.direction_to(path[0]);
		var difficultyCoefficient = 1 / pathfinding.GetTerrainDifficulty(position / worldSizeOffset)
		velocity = direction * SPEED * difficultyCoefficient;
	
		if (position.distance_to(path[0]) < SPEED*delta):
			path.remove_at(0);
	else:
		velocity=Vector2(0,0);
		
	move_and_slide()
