extends TextureRect
class_name FaceViewer

onready var desired_size := rect_size
onready var face_texture := ImageTexture.new()
onready var face_image   := Image.new()

func _ready():
    # listen to event from mediapipe event
    FaceUtils.safe_connect(FaceClient, "face_event", self, "_on_face_event")

func _on_face_event(event: FaceEvent):

    # only processing face with id 0
    if 0 != event.idx: return

    var array = Marshalls.base64_to_raw(event.image)
    if OK == face_image.load_jpg_from_buffer(array):
        face_texture.create_from_image(face_image, Image.FORMAT_RGB8)

        texture = face_texture
