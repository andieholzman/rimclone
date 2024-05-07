@tool

extends Node2D
@onready var tile_map = $"../TileMap"

var astar_grid = AStarGrid2D.new();
@export var start : Vector2i
@export var end : Vector2i
@export var calculate : bool

var path = [];

func _ready():
	InitPathfinding();
	pass

func _process(delta):
	if (calculate):
		calculate = false;
		InitPathfinding();
		RequestPath(start,end);
	
func _draw():

	if (len(path) > 0):
		for i in range(len(path)-1):
			draw_line(path[i],path[i+1],Color.PURPLE);

func RequestPath(start: Vector2i, end : Vector2i):
	path = astar_grid.get_point_path(start,end);
	for i in range(len(path)):
		path[i]+= Vector2(tile_map.rendering_quadrant_size/2,tile_map.rendering_quadrant_size/2);
	queue_redraw();
	return path;

func InitPathfinding():
	astar_grid.region = Rect2i(0,0,tile_map.mapWidth, tile_map.mapHeight);
	astar_grid.cell_size = Vector2i(16,16);
	astar_grid.update();

	for x in range(tile_map.mapWidth):
		for y in range(tile_map.mapHeight):
			var diff = GetTerrainDifficulty(Vector2i(x,y));
			if (diff == -1):
				astar_grid.set_point_solid(Vector2i(x,y,));
			else:
				astar_grid.set_point_weight_scale(Vector2i(x,y,),diff);
			#astar_grid.set_point_weight_scale(Vector2i(x,y,),diff);



func GetTerrainDifficulty(coords : Vector2i):
	var terrainLayer = 0
	var objectLayer = 1
	var cellDifficulty = 1;
	var terrain_source_id = tile_map.get_cell_source_id(terrainLayer,coords,false);
	var terrain_source : TileSetAtlasSource = tile_map.tile_set.get_source(terrain_source_id);
	var terrain_atlas_coords = tile_map.get_cell_atlas_coords(terrainLayer,coords,false);
	var terrain_tile_data = terrain_source.get_tile_data(terrain_atlas_coords,0);
	cellDifficulty = terrain_tile_data.get_custom_data("walk_difficulty");
	
	var object_source_id = tile_map.get_cell_source_id(objectLayer,coords,false);
	if (object_source_id != -1):	
		var object_source : TileSetAtlasSource = tile_map.tile_set.get_source(object_source_id);
		var object_atlas_coords = tile_map.get_cell_atlas_coords(objectLayer,coords,false);
		var object_tile_data = terrain_source.get_tile_data(object_atlas_coords,0);
		var object_difficulty = object_tile_data.get_custom_data("walk_difficulty");
		if (object_difficulty != 0):
			cellDifficulty+=object_difficulty;
	
	
	return cellDifficulty;
