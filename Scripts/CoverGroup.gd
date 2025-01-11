extends Node
@export var length : int
@export var cover : PackedScene
var group : Array[Cover]
@export var textures : Array[Texture]
func _ready() -> void:
	for i in length:
		var coverUnit = cover.instantiate()
		coverUnit.position.x += i*16
		coverUnit.index = i
		add_child(coverUnit)
		group.append(coverUnit)
		coverUnit.breakage.connect(_on_cover_breakage)
	if group.size() == 1:
		group[0].changeSprite(textures[3])
	else:
		group[0].changeSprite(textures[0])
		group[group.size() - 1].changeSprite(textures[2])
		for i in range(1,group.size()-1):
			group[i].changeSprite(textures[1])

func _process(delta: float) -> void:
	pass

func _on_cover_breakage(index):
	if index - 1 >= 0 && group[index - 1] != null:
		if index - 2 >= 0 && group[index - 2] != null:
			group[index - 1].changeSprite(textures[2])
		else:
			group[index - 1].changeSprite(textures[3])
	if index + 1 < group.size() && group[index + 1] != null:
		if index + 2 < group.size() && group[index + 2] != null:
			group[index + 1].changeSprite(textures[0])
		else:
			group[index + 1].changeSprite(textures[3])
	
