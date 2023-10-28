class_name TeeworldsMap extends Node

const Util = preload("res://lib/map/Util.gd")

var version_header: VersionHeader
var header: Header
var version_item: VersionItem
var info_item: InfoItem


func _init(_version_header: VersionHeader, _header: Header, _version_item: VersionItem, _info_item: InfoItem) -> void:
    self.version_header = _version_header
    self.header = _header
    self.version = _version_item.version
    self.map_info = _info_item

