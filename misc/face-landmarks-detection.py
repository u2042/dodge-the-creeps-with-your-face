#!/usr/bin/python3

import asyncio
import base64
import cv2
import json
import mediapipe as mp
import numpy as np
import signal
import sys, getopt
import websockets

HELP_MSG = """
face-landmarks-detection

Options:
    -h, --help: print this message
    -d, --device <dev>: camera video device id (if /dev/video0, <dev> is 0)
    -x, --flip-x: flip image around x-axis
    -y, --flip-y: flip image around y-axis
    --flip-xy: flip image around both axis
    -v, --verbose: verbose mode (display debug window)
"""

DEBUG_WINDOW_TITLE = "MEDIAPIPE_DEBUG"


# script options
camera_id  = 0
flip_x     = False
flip_y     = True  # default mode: selfie mode

debug         = False
debug_visible = False

# (debug) face mesh drawing settings
mp_face_mesh      = mp.solutions.face_mesh
mp_drawing        = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
drawing_spec      = mp_drawing.DrawingSpec(thickness=1, circle_radius=1)

CONNECTIONS = set()

async def register(websocket):
    """ Process new websocket connection.

    Arguments:
    websocket -- the new websocket connection

    NOTE: this function is asynchronous
    """

    global debug

    CONNECTIONS.add(websocket)

    # loop until exception is thrown
    while True:
        try:
            message = await websocket.recv()
            debug = "DEBUG" == message
        except:
            break

    CONNECTIONS.remove(websocket)

async def capture():
    """ Capture video stream from the webcam and sends face mesh landmarks
        to connected websockets

    NOTE: this function is asynchronous
    """

    global debug_visible

    cap = cv2.VideoCapture(camera_id)

    # configure the mediapipe facemesh pipeline
    with mp_face_mesh.FaceMesh(
            max_num_faces=2,
            refine_landmarks=True,
            min_detection_confidence=0.6,
            min_tracking_confidence=0.6) as face_mesh:

        # capture video stream from webcam
        while cap.isOpened():

            success, image = cap.read()

            if not success:
                # camera is not ready yet
                print("Ignoring empty camera frame.")
                continue

            height, width, depth = image.shape

            # Flip image if necessary (for instance, if camera is upside-down)
            # 0 means flipping around the x-axis
            # 0 < means flipping around y-axis (selfie mode)
            # 0 > means flipping around both axes
            if flip_x and flip_y:
                image = cv2.flip(image, -1)
            elif flip_x:
                image = cv2.flip(image, 0)
            elif flip_y:
                image = cv2.flip(image, 1)

            # NOTE: image read using VideoCapture will have channels stored in
            # BGR order
            # Convert the BGR image to RGB before processing.
            imageRGB = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

            # To improve performance, mark the image as not writeable to
            # pass by reference
            imageRGB.flags.writeable = False

            # Call mediapipe pipeline to get face mesh landmarks
            results = face_mesh.process(imageRGB)

            if results.multi_face_landmarks:

                # count detected faces
                faces_count = len(results.multi_face_landmarks)

                idx = 0
                for face_landmarks in results.multi_face_landmarks:

                    # prepare landmarks for export
                    landmarks = list([lm.x, lm.y, lm.z] for lm in face_landmarks.landmark)

                    # serialize image data
                    ret, buf = cv2.imencode(".jpg", image, [int(cv2.IMWRITE_JPEG_QUALITY), 90])
                    imageb64 = base64.b64encode(buf).decode()

                    # build the message to send to connected websockets
                    message = json.dumps({
                        "idx"      : (faces_count - 1) - idx,
                        "landmarks": landmarks,
                        "image"    : imageb64,
                        "width"    : width,
                        "height"   : height
                    }).encode("utf-8")
                    websockets.broadcast(CONNECTIONS, message)

                    if debug_visible:

                        # draw face meshes
                        mp_drawing.draw_landmarks(
                                image=image,
                                landmark_list=face_landmarks,
                                connections=mp_face_mesh.FACEMESH_TESSELATION,
                                landmark_drawing_spec=None,
                                connection_drawing_spec=mp_drawing_styles
                                .get_default_face_mesh_tesselation_style())

                    idx += 1

            if debug:

                # display debug window
                cv2.imshow(DEBUG_WINDOW_TITLE, image)
                debug_visible = True
                if cv2.waitKey(5) & 0xFF == 27: break

            elif debug_visible:

                # hide debug window
                cv2.destroyWindow(DEBUG_WINDOW_TITLE);
                debug_visible = False

            if stopWebSocketServer:
                print("Turning off")
                break

            await asyncio.sleep(0)

    cap.release()

# websocket server settings (must match godot's mediapipe-client settings)
SERVER_HOST = "localhost"
SERVER_PORT = 0xFACE

stopWebSocketServer = False

def signal_handler(sig, frame):
    """ intercepts SIGINT (Ctrl+C) and stops the server properly
    """
    global stopWebSocketServer

    stopWebSocketServer = True

async def startWebSocketServer():
    """ starts WebSocket server and begin video capture
    """

    # handle SIGINT
    signal.signal(signal.SIGINT, signal_handler)

    async with websockets.serve(register, SERVER_HOST, SERVER_PORT):
        await capture()

if __name__ == "__main__":

    # parse command-line options
    try:
        argv = sys.argv[1:]
        opts, args = getopt.getopt(argv, "hvxyd:", ["help", "device=","flip-x", "flip-y", "flip-xy", "verbose"])
    except getopt.GetoptError:
        print(HELP_MSG, file=sys.stderr)
        sys.exit(1)

    # process command-line options
    for opt, arg in opts:
        if opt in ("-h", "--help"):  # print help message
            print(HELP_MSG)
            sys.exit()
        elif opt in ("-d", "--device"): # set camera id
            try:
                camera_id = int(arg)
            except ValueError:
                print(f"Invalid device id '{arg}'", file=sys.stderr)
                sys.exit(1)
        elif opt in ("-x", "--flip-x"): # flip x-axis
            flip_x = True
            flip_y = False
        elif opt in ("-y", "--flip-y"): # flip y-axis
            flip_x = False
            flip_y = True
        elif opt == "--flip-xy": # flip both axis
            flip_x = True
            flip_y = True
        elif opt in ("-v", "--verbose"): # display debug window
            debug = True

    # run async task
    asyncio.run(startWebSocketServer())
