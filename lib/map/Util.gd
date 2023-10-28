extends Object

static func _get_int(buf: PackedByteArray, endian: String = "little", signed: bool = true, num_bytes: int = 4) -> int:
    num_bytes = min(num_bytes, buf.size())  # Ensure num_bytes is not greater than the length of buf
    var result: int = 0
    if endian == "little":
        for i in range(num_bytes):
            result |= int(buf[i]) << (8 * i)
    else:
        for i in range(num_bytes):
            result |= int(buf[i]) << (8 * (num_bytes - 1 - i))
    if signed and (buf[num_bytes - 1] & 0x80):
        return result - (1 << (8 * num_bytes))
    return result
