class_name ItemType extends Node

const Util = preload("res://lib/map/Util.gd")

var type_id: int
var start: int
var num: int

func _init(buffer: PackedByteArray) -> void:
    self.type_id = Util._get_int(buffer)
    self.start = Util._get_int(buffer.slice(4, buffer.size() - 1))
    self.num = Util._get_int(buffer.slice(8, buffer.size() - 1))
