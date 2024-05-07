extends Node
class_name ItemManager

enum ItemCategory { ITEM=0,FOOD=1,WEAPON=2,MELEEWEAPON=3,RANGEDWEAPON=4 }

@export var foodResPath : String = "";
@export var weaponsResPath : String = "";

var foodPrototypes: Array = [];
var weaponPrototypes: Array = [];
var itemsInWorld: Array = [];


func _ready():
	LoadResources(foodResPath.replace('"',''),foodPrototypes);
	print(foodPrototypes);
	#SpawnItem(foodPrototypes[0],Vector2i(16,16));
	var count = 1;
	for i in range(len(foodPrototypes)):
		SpawnItem(foodPrototypes[i],Vector2i(count*16,count*16));
		count = count+1;
	LoadResources(weaponsResPath.replace('"',''),weaponPrototypes);
	print(weaponPrototypes);
	for i in range(len(weaponPrototypes)):
		SpawnItem(weaponPrototypes[i],Vector2i(count*16,count*16));
		count = count+1;
		
	pass

func _process(delta):
	pass

func LoadResources(path:String, arr:Array):
	print(path);
	var dir = DirAccess.open(path);
	if dir:
		dir.open(path);
		dir.list_dir_begin();
		while true:
			var file_name = dir.get_next();
			if (file_name == ""):
				break;
			elif file_name.ends_with(".tscn"):
				arr.append(load(path + "/" + file_name));
				print(file_name);
		dir.list_dir_end();
	else:
		print("error opening dir: " + path);

func SpawnItem(item, mapPosition):

	var newItem = item.instantiate();
	
	# function below will return True if the object contains a script that has the Type/Class Name of Food
	var newItemIsFood = IsItemOfType(newItem,"Food");

	add_child(newItem);
	itemsInWorld.append(newItem);
	newItem.position = MapToWorldPosition(mapPosition.x, mapPosition.y);
	
func FindNearestItem(itemCategory:String, worldPosition: Vector2):
	if (len(itemsInWorld) == 0):
		return false;
	
	var nearestItem = null;
	var nearestDistance = 99999;
	print("Find Nearest Instance of: " + itemCategory)
	
	for item in itemsInWorld:
		if (IsItemOfType(item,itemCategory)):
			var distance = worldPosition.distance_to(item.position);
			
			if (nearestItem == null):
				nearestItem = item;
				nearestDistance = distance;
				continue;
			
			if (distance < nearestDistance):
				nearestItem = item
				nearestDistance = distance;
	return nearestItem;


func MapToWorldPosition(mapPosX:int, mapPosY:int) -> Vector2:
	return Vector2(mapPosX*16+8, mapPosY*16+8);
	
	

# https://stackoverflow.com/a/77951914
static func IsItemOfType(obj : Object, given_class_name : String) -> bool:
	if ClassDB.class_exists(given_class_name):
		# We have a build in class
		return obj.is_class(given_class_name)
	else:
		# We don't have a build in class
		# It must be a script class
		var class_script : Script
		# Assume it is a script path and try to load it
		if ResourceLoader.exists(given_class_name):
			class_script = load(given_class_name) as Script
			
		if class_script == null:
			# Assume it is a class name and try to find it
			for x in ProjectSettings.get_global_class_list():
				
				if str(x["class"]) == given_class_name:
					class_script = load(str(x["path"]))
					break
				
		if class_script == null:
			# Unknown class
			return false
		
		# Get the script of the object and try to match it
		var check_script : Script = obj.get_script()
		while check_script != null:
			if check_script == class_script:
				return true
			
			check_script = check_script.get_base_script()
		
		# Match not found
		return false
