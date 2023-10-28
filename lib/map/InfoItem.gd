class_name InfoItem extends Node

const Util = preload("res://lib/map/Util.gd")

func _init(buffer: PackedByteArray, data: Array) -> void:
    self.version = Util._get_int(buffer)
    var idx_author: int = Util._get_int(buffer.slice(4, buffer.size() - 1))
    self.author = data[idx_author].get_string_from_utf8().slice(0, -1) if idx_author > -1 else ""
    var idx_map_version: int = Util._get_int(buffer.slice(4 * 2, buffer.size() - 1))
    self.map_version = data[idx_map_version].get_string_from_utf8().slice(0, -1) if idx_map_version > -1 else ""
    var idx_credits: int = Util._get_int(buffer.slice(4 * 3, buffer.size() - 1))
    self.credits = data[idx_credits].get_string_from_utf8().slice(0, -1) if idx_credits > -1 else ""
    var idx_license: int = Util._get_int(buffer.slice(4 * 4, buffer.size() - 1))
    self.license = data[idx_license].get_string_from_utf8().slice(0, -1) if idx_license > -1 else ""
    self.settings = []
    
    var idx_settings: int = Util._get_int(buffer.slice(4 * 5, buffer.size() - 1))
    
    if idx_settings > -1:
        var settings_data: PackedByteArray = data[idx_settings]
        for i in range(0, settings_data.size() - 1):
            if settings_data[i] == 0:
                self.settings.append(settings_data.slice(i + 1, settings_data.size() - 1).get_string_from_utf8())
                settings_data = settings_data.slice(0, i)
