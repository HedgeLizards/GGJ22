extends Sprite

export(NodePath) var opposite_path
onready var opposite = get_node(opposite_path)

export(NodePath) var music_path
onready var music = get_node(music_path)
onready var music_length = music.stream.get_length()

func _process(delta):
	var progress = 0.85
	
	if get_parent().visible:
		progress -= 0.7 * music.get_playback_position() / music_length
	else:
		opposite.set_process(true)
		
		set_process(false)
	
	position.x = 1024.5 / 0.75 + cos(progress * PI) * 1250
	position.y = 1350 - sin(progress * PI) * 1250
