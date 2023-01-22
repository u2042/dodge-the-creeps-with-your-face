extends Object
class_name FaceUtils

# @see https://github.com/tensorflow/tfjs-models/blob/838611c02f51159afdd77469ce67f0e26b7bbb23/face-landmarks-detection/src/mediapipe-facemesh/keypoints.ts

const LANDMARKS_SILHOUETTE = [
    10,  338, 297, 332, 284, 251, 389, 356, 454, 323, 361, 288,
    397, 365, 379, 378, 400, 377, 152, 148, 176, 149, 150, 136,
    172, 58,  132, 93,  234, 127, 162, 21,  54,  103, 67,  109
]

# from top to bottom
const LANDMARKS_LIPS_UPPER_OUTER = [61, 185, 40, 39, 37, 0, 267, 269, 270, 409, 291]
const LANDMARKS_LIPS_UPPER_INNER = [78, 191, 80, 81, 82, 13, 312, 311, 310, 415, 308]
const LANDMARKS_LIPS_LOWER_INNER = [78, 95, 88, 178, 87, 14, 317, 402, 318, 324, 308]
const LANDMARKS_LIPS_LOWER_OUTER = [146, 91, 181, 84, 17, 314, 405, 321, 375, 291]
const LANDMARK_LIPS_INNER_TOP   = 13
const LANDMARK_LIPS_INNER_BOTTOM = 14

# from top to bottom
const LANDMARKS_RIGHT_EYE_UPPER_2 = [113, 225, 224, 223, 222, 221, 189]
const LANDMARKS_RIGHT_EYE_UPPER_1 = [247, 30, 29, 27, 28, 56, 190]
const LANDMARKS_RIGHT_EYE_UPPER_0 = [246, 161, 160, 159, 158, 157, 173]
const LANDMARKS_RIGHT_EYE_LOWER_0 = [33, 7, 163, 144, 145, 153, 154, 155, 133]
const LANDMARKS_RIGHT_EYE_LOWER_1 = [130, 25, 110, 24, 23, 22, 26, 112, 243]
const LANDMARKS_RIGHT_EYE_LOWER_2 = [226, 31, 228, 229, 230, 231, 232, 233, 244]
const LANDMARKS_RIGHT_EYE_LOWER_3 = [143, 111, 117, 118, 119, 120, 121, 128, 245]
const LANDMARKS_RIGHT_EYE_LTRB    = [33, 159, 133, 145]
const LANDMARKS_RIGHT_EYE_DIAMOND = [33, 160, 158, 133, 153, 144]

const LANDMARKS_RIGHT_EYEBROW_UPPER = [156, 70, 63, 105, 66, 107, 55, 193]
const LANDMARKS_RIGHT_EYEBROW_LOWER = [35, 124, 46, 53, 52, 65]

const LANDMARKS_RIGHT_EYE_IRIS = [473, 474, 475, 476, 477]

# from top to bottom
const LANDMARKS_LEFT_EYE_UPPER_2 = [342, 445, 444, 443, 442, 441, 413]
const LANDMARKS_LEFT_EYE_UPPER_1 = [467, 260, 259, 257, 258, 286, 414]
const LANDMARKS_LEFT_EYE_UPPER_0 = [466, 388, 387, 386, 385, 384, 398]
const LANDMARKS_LEFT_EYE_LOWER_0 = [263, 249, 390, 373, 374, 380, 381, 382, 362]
const LANDMARKS_LEFT_EYE_LOWER_1 = [359, 255, 339, 254, 253, 252, 256, 341, 463]
const LANDMARKS_LEFT_EYE_LOWER_2 = [446, 261, 448, 449, 450, 451, 452, 453, 464]
const LANDMARKS_LEFT_EYE_LOWER_3 = [372, 340, 346, 347, 348, 349, 350, 357, 465]
const LANDMARKS_LEFT_EYE_LTRB    = [263, 386, 362, 374]
const LANDMARKS_LEFT_EYE_DIAMOND = [362, 385, 387, 263, 373, 380]

const LANDMARKS_LEFT_EYEBROW_UPPER = [383, 300, 293, 334, 296, 336, 285, 417]
const LANDMARKS_LEFT_EYEBROW_LOWER = [265, 353, 276, 283, 282, 295]

const LANDMARKS_LEFT_EYE_IRIS = [468, 469, 470, 471, 472]

const LANDMARK_MIDWAY_BETWEEN_EYES = 168

const LANDMARK_FACE_TOP = 10
const LANDMARK_FACE_BOTTOM = 152
const LANDMARK_NOSE_TIP = 1
const LANDMARK_NOSE_BOTTOM = 2
const LANDMARK_NOSE_RIGHT_CORNER = 98
const LANDMARK_NOSE_LEFT_CORNER = 327

const LANDMARK_LEFT_EAR = 454
const LANDMARK_RIGHT_EAR = 234

static func get_mean(coords):
    var mean = Vector3.ZERO
    for coord in coords:
        mean += coords
    if 0 < len(coords):
        mean /= len(coords)
    return mean

static func get_landmarks_mean(landmarks, idxs):
    var mean = Vector3.ZERO
    for idx in idxs:
        mean += get_landmark(landmarks, idx)
    return mean / len(idxs)

static func get_landmark(landmarks, idx):
    var landmark = landmarks[idx]
    return Vector3(landmark[0], landmark[1], landmark[2])

static func landmarks_euclydian_distance_squared(landmarks, p1_idx, p2_idx):
    var p1 = get_landmark(landmarks, p1_idx)
    var p2 = get_landmark(landmarks, p2_idx)
    return p1.distance_squared_to(p2)


static func safe_connect(source: Object, signal_name: String, target: Object, method: String, binds: Array = [], flags: int = 0):
    var err = source.connect(signal_name, target, method, binds, flags)
    if OK != err:
        printerr("Cannot connect %s to signal %s: %s" % [target.name, signal_name, err])

static func safe_disconnect(source: Object, signal_name: String, target: Object, method: String):
    source.disconnect(signal_name, target, method)
