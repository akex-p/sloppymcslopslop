extends Control

@onready var date_label = $InfoContainer/MarginContainer/VBoxContainer/LabelDate
@onready var time_label = $InfoContainer/MarginContainer/VBoxContainer/LabelTime
# @onready var ask_bob = $BobContainer

# Game day tracker - increment this as game days pass
var game_day = 05
var game_month = 05
var game_year = 2126

# Bob's size
var bob_size = Vector2(0, 0)

func _ready():
	update_time()
	#bob_size = ask_bob.size
	#ask_bob.position.x = 1280 - bob_size.x  # screen width minus bob size

func _process(_delta):
	update_time()
	
	if Input.is_action_just_pressed("grow_bob_delete_later"):
		advance_day()

func update_time():
	var t = Time.get_time_dict_from_system()
	
	# Time format: 14:30 (no seconds)
	time_label.text = "%02d:%02d" % [t.hour, t.minute]
	
	# Date uses game day instead of real date
	date_label.text = "%02d/%02d/%04d" % [game_day, game_month, game_year]
	
	# Keep Dialogic variables in sync
	Dialogic.VAR.date = "%02d/%02d/%04d" % [game_day, game_month, game_year]
	Dialogic.VAR.time = "%02d:%02d" % [t.hour, t.minute]

# Call this function whenever a game day passes
func advance_day():
	game_day += 1
	# bob_size += Vector2(40, 40)
	#ask_bob.size = bob_size
	#ask_bob.position.x = 1280 - bob_size.x  # always stays pinned to right edge
	#ask_bob.position.y = 0
	# TODO: handle month/year rollover when needed
