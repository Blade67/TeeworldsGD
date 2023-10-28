extends Object

const Util = preload("res://lib/map/Util.gd")
const MapItemTypes = preload("res://lib/map/Types.gd").MapItemTypes


class Loader:
    var item_offsets: Array = []
    var data_offsets: Array = []
    var data_sizes: Array = []
    var item_types: Array = []
    var items: Array[Item] = []
        
    func load(path: String) -> TeeworldsMap:
        var file = FileAccess.open(path, FileAccess.READ)
        if file == null:
            push_error("Failed to open file: " + path)
            return null

        var data = file.get_buffer(file.get_length())
        file.close()

        var version_header_buf = data.slice(0, 7)
        var header_buf = data.slice(8, 35)

        var version_header = VersionHeader.new(
            version_header_buf.slice(0, 4).get_string_from_utf8(),
            Util._get_int(version_header_buf.slice(4, 7))
        )

        if not version_header.is_valid():
            push_error("The map header is not valid. Header: %s" % version_header.magic)
            return null

        if not (2 < version_header.version and version_header.version < 5):
            push_error("The map version is not compatible: %d" % version_header.version)
            return null

        var header = Header.new(
            Util._get_int(header_buf.slice(0, 3)),
            Util._get_int(header_buf.slice(4, 7)),
            Util._get_int(header_buf.slice(8, 11)),
            Util._get_int(header_buf.slice(12, 15)),
            Util._get_int(header_buf.slice(16, 19)),
            Util._get_int(header_buf.slice(20, 23)),
            Util._get_int(header_buf.slice(24, 27))
        )
        
        # Header is correct! 
        # push_warning("Header: %s, %s, %s, %s, %s, %s, %s" % [header.size, header.swaplen, header.num_item_types, header.num_items, header.num_data, header.item_size, header.data_size])

        var current_index = 8 + 28

        # Load buffers
        var item_types_buf = data.slice(current_index, current_index + 12 * header.num_item_types - 1)
        current_index += 12 * header.num_item_types

        var item_offsets_buf = data.slice(current_index, current_index + 4 * header.num_items - 1)
        current_index += 4 * header.num_items

        var data_offsets_buf = data.slice(current_index, current_index + 4 * header.num_data - 1)
        current_index += 4 * header.num_data

        var data_sizes_buf = PackedByteArray()
        if version_header.version == 4:
            data_sizes_buf = data.slice(current_index, current_index + 4 * header.num_data - 1)
            current_index += 4 * header.num_data

        var items_buffer = data.slice(current_index, current_index + header.item_size - 1)
        current_index += header.item_size

        var data_buffer = data.slice(current_index, current_index + header.data_size - 1)
        current_index += header.data_size

        # Parse offsets and sizes
        for x in range(header.num_items):
            item_offsets.append(Util._get_int(item_offsets_buf.slice(x * 4, x * 4 + 4)))

        for x in range(header.num_data):
            data_offsets.append(Util._get_int(data_offsets_buf.slice(x * 4, x * 4 + 4)))

        if version_header.version == 4:
            for x in range(header.num_data):
                data_sizes.append(Util._get_int(data_sizes_buf.slice(x * 4, x * 4 + 4)))

        for x in range(header.num_item_types):
            item_types.append(ItemType.new(item_types_buf.slice(x * 12, x * 12 + 12)))

        if item_types.size() != header.num_item_types:
            push_error("Error parsing: Length of item_types is not equal to header.num_item_types")
            return null

        for x in range(header.num_items):
            items.append(Item.new(items_buffer.slice(item_offsets[x], items_buffer.size() - 1)))

        if items.size() != header.num_items:
            push_error("Error parsing: Length of items is not equal to header.num_items")
            return null

        var map_data : Array = []
        for x in range(header.num_data):
            var buffer : PackedByteArray
            if data_offsets.size() < x:
                buffer = data_buffer.slice(data_offsets[x])
            else:
                buffer = data_buffer.slice(data_offsets[x], (data_offsets[x + 1] if x + 1 < data_offsets.size() - 1 else header.data_size))

            if version_header.version == 4:
                map_data.append(buffer.decompress(data_sizes[x], 1))
            else:
                map_data.append(buffer)

        if OS.is_debug_build():
            push_warning("item_offsets: %s" % JSON.stringify(item_offsets))
            push_warning("data_offsets: %s" % JSON.stringify(data_offsets))
            push_warning("data_sizes: %s" % JSON.stringify(data_sizes))
            
            for x in range(map_data.size()):
                if map_data[x].size() != data_sizes[x]:
                    push_error("Data length not equal to data_sizes on index: %d, (%d, %d)" % [x, map_data[x].size(), data_sizes[x]])
                    push_warning("%s:::%s" % [map_data, data_sizes])
                    return null

        # Load Version Item
        var version_item = VersionItem.new(find_item(MapItemTypes.VERSION, 0).item_data)

        # Load stuff
        var map_info = null

        if version_item.version == 1:
            var info_type = get_type(MapItemTypes.INFO)
            for x in range(info_type.start, info_type.start + info_type.num):
                if items[x].id != 0:
                    continue

                map_info = InfoItem.new(items[x].item_data, map_data)

        return TeeworldsMap.new(version_header, header, version_item, map_info)


    func get_type(_type: int):
        for i in item_types:
            if i.type_id == _type:
                return i

    func find_item_index(_type: int, id: int):
        var itemtype = get_type(_type)
        for i in range(itemtype.num):
            if items[itemtype.start + i].id == id:
                return itemtype.start + i

    func find_item(_type: int, id: int):
        var index = find_item_index(_type, id)
        return items[index]
