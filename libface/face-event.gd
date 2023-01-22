extends Reference
class_name FaceEvent

var idx = -1
var landmarks = []
var image = null
var image_width = 0
var image_height = 0

static func check_json_defaults(json:Dictionary):
    return json.has_all(["idx", "landmarks"])

func load_from_json(json:Dictionary):

    idx       = json["idx"]
    landmarks = json["landmarks"]

    if json.has("image"):
        image        = json["image"]
        image_width  = json["width"]
        image_height = json["height"]
