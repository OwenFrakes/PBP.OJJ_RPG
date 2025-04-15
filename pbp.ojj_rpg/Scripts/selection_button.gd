class_name SelectionButton
extends Button

signal send_reference(reference)
var reference

func _init(new_ref) -> void:
	reference = new_ref
	pressed.connect(sendSignal)

func setReference(new_ref) -> void:
	reference = new_ref

func sendSignal():
	emit_signal("send_reference", reference)
