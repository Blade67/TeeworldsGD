extends Node

const Loader = preload("res://lib/map/Loader.gd").Loader

func _ready():
    var map = Loader.new()
    map.load("res://Assets/maps/ctf4_old.map")
