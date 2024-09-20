extends Node2D

@onready var fusedirections = $"fuse directions"
@onready var moneydirections = $moneydirections
@onready var healthdirections = $"health directions"
@onready var timedirections = $"time directions"
@onready var explodirectons = $"explo directions"
@onready var continuebutton = $continuebutton

var tutorialnumb = 0
func _ready():
	continuebutton.hide()
	explotorial()


func explotorial():
	explodirectons.show()
	fusedirections.hide()
	healthdirections.hide()
	timedirections.hide()
	moneydirections.hide()


func moneytorial():
	explodirectons.hide()
	fusedirections.hide()
	healthdirections.hide()
	timedirections.hide()
	moneydirections.show()
func fusetorial():
	explodirectons.hide()
	fusedirections.show()
	healthdirections.hide()
	timedirections.hide()
	moneydirections.hide()

func timetorial():
	explodirectons.hide()
	fusedirections.hide()
	healthdirections.hide()
	timedirections.show()
	moneydirections.hide()
func healthtorial():
	explodirectons.hide()
	fusedirections.hide()
	healthdirections.show()
	timedirections.hide()
	moneydirections.hide()

func _on_nextbutton_pressed():
	tutorialnumb += 1
	if tutorialnumb > 4:
		tutorialnumb = 4
	settutorial()


func _on_backbutton_pressed():
	tutorialnumb -= 1
	if tutorialnumb < 0:
		tutorialnumb = 0
	settutorial()

func settutorial():
	if tutorialnumb == 0:
		explotorial()
	elif tutorialnumb == 1:
		fusetorial()
	elif tutorialnumb == 2:
		timetorial()
	elif tutorialnumb == 3:
		healthtorial()
	elif tutorialnumb == 4:
		moneytorial()
		continuebutton.show()


func _on_skipbutton_pressed():
	get_tree().change_scene_to_file("res://sandbox.tscn")


func _on_continuebutton_pressed():
	get_tree().change_scene_to_file("res://sandbox.tscn")
