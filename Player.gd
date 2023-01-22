extends Area2D

signal hit

export var speed = 250 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

var face_up    := false
var face_down  := false
var face_left  := false
var face_right := false

func _ready():
    screen_size = get_viewport_rect().size
    hide()


func _process(delta):
    var velocity = Vector2.ZERO # The player's movement vector.
    if Input.is_action_pressed("move_right") or face_right:
        velocity.x += 1
    if Input.is_action_pressed("move_left") or face_left:
        velocity.x -= 1
    if Input.is_action_pressed("move_down") or face_down:
        velocity.y += 1
    if Input.is_action_pressed("move_up") or face_up:
        velocity.y -= 1

    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        $AnimatedSprite.play()
    else:
        $AnimatedSprite.stop()

    position += velocity * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)

    if velocity.x != 0:
        $AnimatedSprite.animation = "right"
        $AnimatedSprite.flip_v = false
        $AnimatedSprite.flip_h = velocity.x < 0
    elif velocity.y != 0:
        $AnimatedSprite.animation = "up"
        $AnimatedSprite.flip_v = velocity.y > 0


func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false
    # listen to event from mediapipe event
    FaceUtils.safe_connect(FaceClient, "face_event", self, "_on_face_event")


func _on_Player_body_entered(_body):
    # stop listening to event from mediapipe event
    FaceUtils.safe_disconnect(FaceClient, "face_event", self, "_on_face_event")
    hide() # Player disappears after being hit.
    emit_signal("hit")
    # Must be deferred as we can't change physics properties on a physics callback.
    $CollisionShape2D.set_deferred("disabled", true)

func _on_face_event(event: FaceEvent):

    # only processing face with id 0
    if 0 != event.idx: return

    var landmarks = event.landmarks

    # WARN: left ear is on the right side of the image in selfie-mode
    var leftEar  = FaceUtils.get_landmark(landmarks, FaceUtils.LANDMARK_LEFT_EAR)
    var rightEar = FaceUtils.get_landmark(landmarks, FaceUtils.LANDMARK_RIGHT_EAR)
    var noseTip  = FaceUtils.get_landmark(landmarks, FaceUtils.LANDMARK_NOSE_TIP)
    var top      = FaceUtils.get_landmark(landmarks, FaceUtils.LANDMARK_FACE_TOP)
    var bottom   = FaceUtils.get_landmark(landmarks, FaceUtils.LANDMARK_FACE_BOTTOM)

    # ensure nose tip is within boundaries
    if (noseTip[0] < rightEar[0]): noseTip[0] = rightEar[0]
    if (noseTip[0] > leftEar[0]): noseTip[0] = leftEar[0]
    if (noseTip[1] < top[1]): noseTip[1] = top[1]
    if (noseTip[1] > bottom[1]): noseTip[1] = bottom[1]

    face_up = false
    face_right = false
    face_down = false
    face_left = false

    # left / right
    var diff = (noseTip[0] - rightEar[0]) / (leftEar[0] - rightEar[0])
    if 0.4 > diff:
        face_left = true
    elif 0.6 < diff:
        face_right = true

    # top / bottom
    diff = (noseTip[1] - top[1]) / (bottom[1] - top[1])
    if 0.47 > diff:
        face_up = true
    elif 0.6 < diff:
        face_down = true
