extends Camera2D

var zoomTarget : Vector2
@export var zoomSpeed : float = 10
@export var panSpeed : float = 1000

var dragStartMousePos = Vector2.ZERO;
var dragStartCameraPos = Vector2.ZERO;
var isDragging: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	zoomTarget = zoom;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	Zoom(delta)
	SimplePan(delta)
	ClickAndDrag(delta)
	pass
	
func Zoom(delta):
	if (Input.is_action_just_pressed("camera_zoom_in")):
		zoomTarget *= 1.1
	if (Input.is_action_just_pressed("camera_zoom_out")):
		zoomTarget *= 0.9
	zoom = zoom.slerp(zoomTarget,zoomSpeed*delta);

	
func SimplePan(delta):
	var moveAmount = Vector2.ZERO;
	if (Input.is_action_pressed("camera_move_right")):
		moveAmount.x +=1;
	if (Input.is_action_pressed("camera_move_left")):
		moveAmount.x -=1;
	if (Input.is_action_pressed("camera_move_up")):
		moveAmount.y -=1;
	if (Input.is_action_pressed("camera_move_down")):
		moveAmount.y +=1;
		
	moveAmount = moveAmount.normalized();
	position += moveAmount*delta*panSpeed * (1/zoom.x);
	#position = position.slerp(moveAmount,panSpeed*delta*(1/zoom.x));


func ClickAndDrag(delta):
	if (!isDragging and Input.is_action_just_pressed("camera_pan")):
		dragStartMousePos = get_viewport().get_mouse_position();
		dragStartCameraPos = position;
		
		isDragging = true;
	
	if (isDragging and Input.is_action_just_released("camera_pan")):
		isDragging = false;
	
	if (isDragging):
		var moveVector = get_viewport().get_mouse_position() - dragStartMousePos;
		position = dragStartCameraPos - moveVector * (1/zoom.x);
