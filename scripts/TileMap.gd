@tool
extends TileMap

@export var generateTerrain : bool
@export var clearTerrain : bool

@export var mapWidth : int
@export var mapHeight : int
@export var terrainSeed : int
@export var deepwaterThreshold : float
@export var waterThreshold : float
@export var grassThreshold : float
@export var grass2Threshold : float
@export var dirtThreshold : float
@export var rockThreshold : float

#this doesn't work when running in editor with @tool. need to directly refernce the node below
@onready var seed_label = %"Seed Label"

# Called when the node enters the scene tree for the first time.
func _ready():
	GenerateTerrain();
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (generateTerrain):
		generateTerrain = false
		GenerateTerrain();
		
	if (clearTerrain):
		clearTerrain = false
		clear();
		
func GenerateTerrain():
	print("generating terrain...")
	var rng = RandomNumberGenerator.new();
	var noise = FastNoiseLite.new();
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR;
	
	if (terrainSeed == 0):
		noise.seed = rng.randi();
	else:
		noise.seed = terrainSeed;
	#print(terrainSeed);
	#print(noise.seed);
	
	(%"Seed Label").text = "Seed: " + str(noise.seed);
	for x in range(mapWidth):
		for y in range(mapHeight):
			#print(noise.get_noise_2d(x,y));
			if (noise.get_noise_2d(x,y) > deepwaterThreshold):
				set_cell(0,Vector2i(x,y),0,Vector2i(2,1));
			elif (noise.get_noise_2d(x,y) > waterThreshold):
				set_cell(0,Vector2i(x,y),0,Vector2i(1,1));
			elif (noise.get_noise_2d(x,y) > grassThreshold):
				set_cell(0,Vector2i(x,y),0,Vector2i(0,0));
				#draw grassland tree
				#if (rng.randi_range(0,15) == 1):
					#set_cell(1,Vector2i(x,y),0,Vector2i(0,2));
			elif (noise.get_noise_2d(x,y) > grass2Threshold):
				set_cell(0,Vector2i(x,y),0,Vector2i(1,0));
				#draw forest tree
				#if (rng.randi_range(0,20) == 1):
					#set_cell(1,Vector2i(x,y),0,Vector2i(1,2));
			elif (noise.get_noise_2d(x,y) > dirtThreshold):
				set_cell(0,Vector2i(x,y),0,Vector2i(2,0));
			elif (noise.get_noise_2d(x,y) > rockThreshold):
				set_cell(0,Vector2i(x,y),0,Vector2i(3,0));
			else:
				set_cell(0,Vector2i(x,y),0,Vector2i(0,1));
