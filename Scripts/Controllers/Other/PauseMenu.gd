extends Control

# SIGNALS

@warning_ignore("unused_signal")
signal AnimateIn
@warning_ignore("unused_signal")
signal AnimateOut
signal PageLoaded

# ONREADY

@onready var BG = $BG
@onready var Book = $Book
@onready var Content = $Book/Content

# FUNC

# This function will play a sound and tween the buttons size
func mouseOverButton(button):
	if not get_tree().paused: return
	var anim = button.create_tween()
	SOUNDS.playSound("ui_tick01")
	anim.tween_property(button, "scale", Vector2(1.1,1.1), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

# This function will tween the buttons size
func mouseLeaveButton(button):
	var anim = button.create_tween()
	anim.tween_property(button, "scale", Vector2(1,1), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

# This function sets all of the buttons into the correct positions, an error with godot caused me to have to do this
func initAllButtonPos():
	
	for child in Content.get_children():
		Content.remove_child(child)
	
	$Book/Profile/Label.position.x = 0
	$Book/Collection/Label.position.x = 0
	$Book/Controls/Label.position.x = 0
	$Book/Settings/Label.position.x = 0

# This function runs whenever the Profile page is opened, and updates all of the contents within
func page_Profile():
	$Pages/ProfilePage/collectables.text = "collectables: " + str(INVENTORY.Inventory.size()) + " / " + str(INVENTORY.ItemInformation.size())
	$Pages/ProfilePage/died.text = "died: " + str(DATA.Data["Died"])
	$Pages/ProfilePage/puzzles.text = "puzzles completed: " + str(DATA.Data["CurrentPuzzle"])

# This function runs whenever the Collection page is opened, and updates all of the contents within
func page_Collection():
	
	await PageLoaded
	
	for item in INVENTORY.ItemInformation:
		var newTemp = $Pages/CollectionPage/Templates/ItemTemplate.duplicate()
		$Book/Content/ContentPage/ScrollContainer/BoxContainer.add_child(newTemp)
		newTemp.name = item
		newTemp.get_child(0).texture = load(INVENTORY.ItemInformation[item]["Image"])
		newTemp.get_child(1).text = "???"
		newTemp.get_child(2).text = INVENTORY.ItemInformation[item]["Rarity"]
		newTemp.color = INVENTORY.RarityColors[INVENTORY.ItemInformation[item]["Rarity"]]
		
		for itemInInv in INVENTORY.Inventory:
			if item == itemInInv[0]:
				newTemp.get_child(1).text = item
				newTemp.self_modulate = Color.from_string("#ffffff8b", Color())
				break

func page_Settings():
	
	await PageLoaded
	
	var musicslider : HSlider = $Book/Content/ContentPage/Sticky1/HSlider
	var sfxslider : HSlider = $Book/Content/ContentPage/Sticky2/HSlider2
	
	musicslider.value = SOUNDS.MusicVol
	sfxslider.value = SOUNDS.SFXVol
	
	sfxslider.drag_ended.connect(func(v):
		if sfxslider.value != -10:
			SOUNDS.SFXVol = sfxslider.value
		else:
			SOUNDS.SFXVol = -1000
	)
	
	musicslider.drag_ended.connect(func(v):
		if musicslider.value != -10:
			SOUNDS.MusicVol = musicslider.value
		else:
			SOUNDS.MusicVol = -1000
	)

# This function is essentially the hub for all of the pages & buttons to connect / display their contents
func pageController(page):
	var newPage
	match page:
		"Profile":
			newPage = $Pages/ProfilePage
			page_Profile()
		"Collection":
			newPage = $Pages/CollectionPage
			page_Collection()
		"Controls":
			newPage = $Pages/CreditsPage
		"Settings":
			newPage = $Pages/SettingsPage
			page_Settings()
		"Resume":
			pass # keep pass
		_: print("Page: | " + page + " |\nnot found")
	
	if not newPage: return
	
	var p = newPage.duplicate()
	p.position = Vector2(0,20)
	p.modulate = Color(1,1,1,0)
	p.name = "ContentPage"
	
	var nt = p.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_parallel(true)
	nt.tween_property(p, "position", Vector2(0,0), 0.3)
	nt.tween_property(p, "modulate", Color(1,1,1,1), 0.3)
	
	Content.add_child(p)
	emit_signal("PageLoaded")

# This function will run when a button is clicked, and do different actions depending on which button clicked
func clickButton(button):
	initAllButtonPos()
	
	if not get_tree().paused: return
	
	SOUNDS.playSound("ui_click01")
	
	match button.name:
		"Profile":
			$Book/Profile/Label.create_tween().tween_property($Book/Profile/Label, "position", Vector2(25,0), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			pageController("Profile")
		"Collection":
			$Book/Collection/Label.create_tween().tween_property($Book/Collection/Label, "position", Vector2(25,0), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			pageController("Collection")
		"Controls":
			$Book/Controls/Label.create_tween().tween_property($Book/Controls/Label, "position", Vector2(25,0), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			pageController("Controls")
		"Settings":
			$Book/Settings/Label.create_tween().tween_property($Book/Settings/Label, "position", Vector2(25,0), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			pageController("Settings")
		"Resume":
			get_parent().get_parent().emit_signal("unpauseGame")
			emit_signal("AnimateOut")
		"Quit":
			get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		_: print("Button | " + button.name + " | \nnot found")

# This function initializes the pause menu, making it easily animateable
func init():
	BG.modulate = Color.from_string("ffffff00", Color())
	Book.position = Vector2(0,540)
	Book.modulate = Color.from_string("ffffff00", Color())
	visible = true

# CONNECTORS

# This function makes sure the pause menu is always able to run
func _init():
	process_mode = PROCESS_MODE_ALWAYS

# This function runs when the signal 'AnimateIn' is emitted, animating the pause menu in
func _on_animate_in() -> void:
	get_tree().paused = true
	
	SOUNDS.playSound("ui_swoop")
	SOUNDS.pauseMusic()
	
	init()
	
	var animateTween = self.create_tween().set_parallel(true)
	
	animateTween.tween_property(BG, "modulate", Color.from_string("ffffff23", Color()), 1)
	animateTween.tween_property(Book, "modulate", Color.from_string("ffffff", Color()), 0.2)
	animateTween.tween_property(Book, "position", Vector2(0,0), 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# This function runs on the 'AnimateOut' signal, and animates the pause menu out
func _on_animate_out() -> void:
	var animateTween = self.create_tween().set_parallel(true)
	
	SOUNDS.resumeMusic()
	
	animateTween.tween_property(BG, "modulate", Color.from_string("ffffff00", Color()), 1)
	animateTween.tween_property(Book, "modulate", Color.from_string("ffffff00", Color()), 0.2)
	animateTween.tween_property(Book, "position", Vector2(0,540), 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	get_tree().paused = false

# --- # <- Seperators to make the multitude of connections a little easier to read

# Regarding all the functions below, they all connect mouse events to certain buttons

func _on_profile_mouse_entered() -> void:
	mouseOverButton($Book/Profile)

func _on_collection_mouse_entered() -> void:
	mouseOverButton($Book/Collection)

func _on_tasks_mouse_entered() -> void:
	mouseOverButton($Book/Controls)

func _on_settings_mouse_entered() -> void:
	mouseOverButton($Book/Settings)

func _on_resume_mouse_entered() -> void:
	mouseOverButton($Book/Resume)

func _on_quit_mouse_entered() -> void:
	mouseOverButton($Book/Quit)

# --- #

func _on_profile_pressed() -> void:
	clickButton($Book/Profile)

func _on_collection_pressed() -> void:
	clickButton($Book/Collection)

func _on_tasks_pressed() -> void:
	clickButton($Book/Controls)

func _on_settings_pressed() -> void:
	clickButton($Book/Settings)

func _on_resume_pressed() -> void:
	clickButton($Book/Resume)

func _on_quit_pressed() -> void:
	clickButton($Book/Quit)

# --- #

func _on_profile_mouse_exited() -> void:
	mouseLeaveButton($Book/Profile)

func _on_collection_mouse_exited() -> void:
	mouseLeaveButton($Book/Collection)

func _on_tasks_mouse_exited() -> void:
	mouseLeaveButton($Book/Controls)

func _on_settings_mouse_exited() -> void:
	mouseLeaveButton($Book/Settings)

func _on_resume_mouse_exited() -> void:
	mouseLeaveButton($Book/Resume)

func _on_quit_mouse_exited() -> void:
	mouseLeaveButton($Book/Quit)
