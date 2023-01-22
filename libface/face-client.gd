extends Node

# defining face_event signal
signal face_event

const CONNECTION_ATTEMP_DELAY_S = 1

# websocket server settings (must match python script websocket server settings)
const SERVER_HOST = "localhost"
const SERVER_PORT = 0xFACE

var debug_mode = false

# Our WebSocketClient instance
var _client := WebSocketClient.new()
var _connecting := false
var _peer:WebSocketPeer = null

var _last_connection_attempt = -1

func _ready():
    # Connect base signals to get notified of connection open, close, and errors.
    FaceUtils.safe_connect(_client, "connection_established", self, "_on_connection_established")
    FaceUtils.safe_connect(_client, "connection_closed", self, "_on_connection_closed")
    FaceUtils.safe_connect(_client, "connection_error", self, "_on_connection_error")
    _start_connection()

func _process(delta):
    _last_connection_attempt += delta

    if not _peer and not _connecting:
        if CONNECTION_ATTEMP_DELAY_S < _last_connection_attempt:
            _start_connection()
        return

    _client.poll()

    if not _peer: return

    # show / hide debug window when pressing ui_enter
    if Input.is_action_just_pressed("ui_accept"):
        debug_mode = not debug_mode
        _peer.put_packet(("DEBUG" if debug_mode else "NO_DEBUG").to_utf8())

    # process pending packets
    while 0 < _peer.get_available_packet_count():
        var pkt = _peer.get_packet()

        # parse message content as json object
        var parse_result = JSON.parse(pkt.get_string_from_utf8())
        if OK != parse_result.error:
            printerr("FaceClient - cannot parse JSON from packet", parse_result.error_string)
            return
        var json = parse_result.result

        # check json object has default properties
        if FaceEvent.check_json_defaults(json):
            # notify new mpevent
            var event = FaceEvent.new()
            event.load_from_json(parse_result.result)
            emit_signal("face_event", event)

func _start_connection():
    if _connecting: return

    print("FaceClient - connecting client websocket...")

    _connecting = true
    _last_connection_attempt = 0

    var websocket_url = "ws://%s:%d" % [SERVER_HOST, SERVER_PORT]
    var err = _client.connect_to_url(websocket_url)
    if OK != err:
        printerr("FaceClient - cannot connect client to websocket server %s: %s" % [websocket_url, err])
        _connecting = false


func _on_connection_established(proto = ""):
    _connecting = false

    print("FaceClient - connection established with protocol %s" % proto)
    _peer = _client.get_peer(1)
    _peer.set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)

func _on_connection_closed(was_clean_close = false):
    _connecting = false

    print("FaceClient - connection closed %s" % ("clean" if was_clean_close else "not clean"))
    _peer = null

func _on_connection_error():
    _connecting = false

    printerr("FaceClient - connection error")
    _peer = null
