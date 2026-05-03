extends Interactable

@onready var audio_player_music: AudioStreamPlayer3D = $AudioPlayerMusic
@onready var audio_player_clock: AudioStreamPlayer3D = $AudioPlayerClock

func _ready():
	super()
	prompt_text = "Start Radio"
	GameManager.register(GameManager.Step.RADIO, self)

func interact() -> void:
	audio_player_music.play()
	cleared.emit()
	Dialogic.paused = false
	GameManager.advance_step()
	
