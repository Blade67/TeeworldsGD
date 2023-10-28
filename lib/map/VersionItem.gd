class_name VersionItem extends Node

const Util = preload("res://lib/map/Util.gd")

var version: int

func _init(buffer: PackedByteArray) -> void:
    self.version = Util._get_int(buffer)
