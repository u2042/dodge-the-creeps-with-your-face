Read this in other languages: [English](README.md), [Français](Readme_fr.md)

# Dodge the Creeps (with your Face)

This is a fork of the ["Dodge the Creeps"](https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps) project with face recognition.

## Additional features

* Use your face to control the player

## Requirements

* Godot 3.5
* Python 3

The Python script used for face recognition `misc/face-landmarks-detection.py` requires a number of Python modules to run. These modules are:

* mediapipe (0.8.9.1)
* numpy (1.21.6)
* opencv_contrib_python (4.5.5.64)
* websocket (10.3)

You can automatically install them using `pip` and the `requirements.txt` file located into the `misc` folder :

```bash
pip install -r misc/requirements.txt
```

## Usage

To start face recognition using the Python script, just use this command:

```bash
python misc/face-landmarks-detection.py -v
```

Here are the list of options:
```text
Options:
    -h, --help: print this message
    -d, --device <dev>: camera video device id (if /dev/video0, <dev> is 0)
    -x, --flip-x: flip image around x-axis
    -y, --flip-y: flip image around y-axis
    --flip-xy: flip image around both axis
    -v, --verbose: verbose mode (display debug window)
```

The usage instructions for Dodge the Creeps (with your Face) are the same as for the Dodge the Creeps project, refer to the original readme for more details.

## Screenshots

[![Screenshot from the demo](https://img.youtube.com/vi/z8E0HyJvxQ0/0.jpg)](https://youtu.be/z8E0HyJvxQ0)

## Copying

`art/House In a Forest Loop.ogg` Copyright &copy; 2012 [HorrorPen](https://opengameart.org/users/horrorpen), [CC-BY 3.0: Attribution](http://creativecommons.org/licenses/by/3.0/). Source: https://opengameart.org/content/loop-house-in-a-forest

Images are from "Abstract Platformer". Created in 2016 by kenney.nl, [CC0 1.0 Universal](http://creativecommons.org/publicdomain/zero/1.0/). Source: https://www.kenney.nl/assets/abstract-platformer

Font is "Xolonium". Copyright &copy; 2011-2016 Severin Meyer <sev.ch@web.de>, with Reserved Font Name Xolonium, SIL open font license version 1.1. Details are in `fonts/LICENSE.txt`.
