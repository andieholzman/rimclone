extends Item
class_name Weapon

enum WeaponType {MELEE = 0, RANGED = 1, MAGIC = 2}
enum WeaponQuality {RUBBISH = 0, SIMPLE = 1, GOOD = 2, FANCY = 3}

@export var damage = 1.0
@export var weaponType : WeaponType
@export var weaponQuality : WeaponQuality 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
