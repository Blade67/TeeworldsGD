extends Node


func _ready():
    var map = TeeworldsMapLoader.new()
    map.load("res://Assets/maps/ctf4_old.map")

    var images: Array = map.get_images()
    print(images.size())
    var posOffset: int = 0
    for image in images:
        printt(image.version, image.width, image.height, image.name)
        
        #var i = TeeworldsImage.new(image)
        var sprite: Image = image.rendered()
        
        var img = Sprite2D.new()
        img.centered = false
        img.texture = ImageTexture.create_from_image(sprite)
        img.position = Vector2(posOffset, 648 / 2.0)
        posOffset += image.width
        add_child(img)
    #printt(images.size(), images[0].size(), sqrt(images[0].size() / 4))
