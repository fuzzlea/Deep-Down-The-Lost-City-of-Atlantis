extends Control

@warning_ignore("unused_signal")
signal AnimateIn
@warning_ignore("unused_signal")
signal AnimateOut

@onready var BG = $BG
@onready var Book = $Book
@onready var Content = $Book/Content

func mouseOverButton(button):
	var anim = button.create_tween()
	anim.tween_property(button, "scale", Vector2(1.1,1.1), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func mouseLeaveButton(button):
	var anim = button.create_tween()
	anim.tween_property(button, "scale", Vector2(1,1), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func initAllButtonPos():
	
	for child in Content.get_children():
		Content.remove_child(child)
	
	$Book/Profile/Label.position.x = 0
	$Book/Collection/Label.position.x = 0
	$Book/Tasks/Label.position.x = 0
	$Book/Settings/Label.position.x = 0

func pageController(page):
	var newPage
	match page:
		"Profile":
			newPage = $Pages/ProfilePage
		"Collection":
			pass
		"Tasks":
			pass
		"Resume":
			pass
		_: print("Page: | " + page + " |\nnot found")
	
	if not newPage: return
	
	var p = newPage.duplicate()
	Content.add_child(p)

func clickButton(button):
	initAllButtonPos()
	
	match button.name:
		"Profile":
			$Book/Profile/Label.create_tween().tween_property($Book/Profile/Label, "position", Vector2(25,0), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			pageController("Profile")
		"Collection":
			$Book/Collection/Label.create_tween().tween_property($Book/Collection/Label, "position", Vector2(25,0), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			pageController("Collection")
		"Tasks":
			$Book/Tasks/Label.create_tween().tween_property($Book/Tasks/Label, "position", Vector2(25,0), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			pageController("Tasks")
		"Settings":
			$Book/Settings/Label.create_tween().tween_property($Book/Settings/Label, "position", Vector2(25,0), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			pageController("Settings")
		"Resume":
			get_parent().get_parent().emit_signal("unpauseGame")
			emit_signal("AnimateOut")
		_: print("Button | " + button.name + " | \nnot found")

func init():
	BG.modulate = Color.from_string("ffffff00", Color())
	Book.position = Vector2(0,540)
	Book.modulate = Color.from_string("ffffff00", Color())
	visible = true

func _on_animate_in() -> void:
	get_tree().paused = true
	
	init()
	
	var animateTween = self.create_tween().set_parallel(true)
	
	animateTween.tween_property(BG, "modulate", Color.from_string("ffffff23", Color()), 1)
	animateTween.tween_property(Book, "modulate", Color.from_string("ffffff", Color()), 0.2)
	animateTween.tween_property(Book, "position", Vector2(0,0), 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_animate_out() -> void:
	var animateTween = self.create_tween().set_parallel(true)
	
	animateTween.tween_property(BG, "modulate", Color.from_string("ffffff00", Color()), 1)
	animateTween.tween_property(Book, "modulate", Color.from_string("ffffff00", Color()), 0.2)
	animateTween.tween_property(Book, "position", Vector2(0,540), 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	get_tree().paused = false

func _on_profile_mouse_entered() -> void:
	mouseOverButton($Book/Profile)

func _on_collection_mouse_entered() -> void:
	mouseOverButton($Book/Collection)

func _on_tasks_mouse_entered() -> void:
	mouseOverButton($Book/Tasks)

func _on_settings_mouse_entered() -> void:
	mouseOverButton($Book/Settings)

func _on_resume_mouse_entered() -> void:
	mouseOverButton($Book/Resume)


func _on_profile_pressed() -> void:
	clickButton($Book/Profile)

func _on_collection_pressed() -> void:
	clickButton($Book/Collection)

func _on_tasks_pressed() -> void:
	clickButton($Book/Tasks)

func _on_settings_pressed() -> void:
	clickButton($Book/Settings)

func _on_resume_pressed() -> void:
	clickButton($Book/Resume)

func _on_profile_mouse_exited() -> void:
	mouseLeaveButton($Book/Profile)

func _on_collection_mouse_exited() -> void:
	mouseLeaveButton($Book/Collection)

func _on_tasks_mouse_exited() -> void:
	mouseLeaveButton($Book/Tasks)

func _on_settings_mouse_exited() -> void:
	mouseLeaveButton($Book/Settings)

func _on_resume_mouse_exited() -> void:
	mouseLeaveButton($Book/Resume)
