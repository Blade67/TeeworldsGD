class_name Header extends Object

var size: int
var swaplen: int
var num_item_types: int
var num_items: int
var num_data: int
var item_size: int
var data_size: int


func _init(_size: int, _swaplen: int, _num_item_types: int, _num_items: int, _num_data: int, _item_size: int, _data_size: int) -> void:
    self.data_size = _data_size
    self.num_items = _num_items
    self.item_size = _item_size
    self.num_data = _num_data
    self.num_item_types = _num_item_types
    self.size = _size
    self.swaplen = _swaplen
