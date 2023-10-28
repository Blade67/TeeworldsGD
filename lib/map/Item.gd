class_name Item extends Object

const Util = preload("res://lib/map/Util.gd")

var size: int
var item_data: PackedByteArray
var type_id: int
var id: int

func _init(buffer: PackedByteArray) -> void:
    var itemtype: int = Util._get_int(buffer)
    self.size = Util._get_int(buffer.slice(4, buffer.size() - 1))
    self.item_data = buffer.slice(8, 8 + self.size)
    # type_id might not be accurate, TODO: make uuid
    # datafile.cppL445
    self.type_id = (itemtype >> 16) & 0xffff
    self.id = itemtype & 0xffff

func _get_size() -> int:
    """
    Used internally to know the next index.

    :return: The index of the next object in the buffer
    """
    return 4 + 4 + self.size
