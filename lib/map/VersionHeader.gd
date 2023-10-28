class_name VersionHeader extends Object

var magic: String
var version: int

func _init(_magic: String, _version: int):
    self.magic = _magic
    self.version = _version

func _to_string() -> String:
    push_warning("VersionHeader version: %s" % str(self.version))
    return str(self.version)

func is_valid() -> bool:
    return self.magic == "DATA" or self.magic == "ATAD"
