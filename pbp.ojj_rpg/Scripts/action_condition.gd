class_name ActionCondition
extends Node

var condition_name : String
var duration : int
var strength : float

func _init(new_name : String, new_duration : int, new_strength):
	condition_name = new_name
	duration = new_duration
	strength = new_strength

func passTurn():
	duration -= 1

func getName():
	return condition_name

func getDuration():
	return duration

func getStrength():
	return strength
