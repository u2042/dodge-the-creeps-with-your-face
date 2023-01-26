Lire dans une autre langue: [English](README.md), [Français](Readme_fr.md)

# Dodge the Creeps (with your Face)

Ceci est un fork du projet ["Dodge the Creeps"](https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps) avec reconnaissance faciale.

## Fonctionnalités supplémentaires

* Possibilité de contrôler le personnage avec son visage

## Pré-requis

* Godot 3.5
* Python 3

Le script Python `misc/face-landmarks-detection.py` chargé de la reconnaissance faciale nécessite un certain nombre de modules Python pour fonctionner. Ces modules sont :

* mediapipe (0.8.9.1)
* numpy (1.21.6)
* opencv_contrib_python (4.5.5.64)
* websocket (10.3)

Vous pouvez les installer automatiquement en utilisant `pip` et le fichier `misc/requirements.txt` :

```bash
pip install -r misc/requirements.txt
```

## Utilisation

Pour démarrer la reconnaissance faciale avec le script Python, saisir cette commande :

```bash
python misc/face-landmarks-detection.py -v
```

Voici la liste des options :
```text
Options:
    -h, --help: print this message
    -d, --device <dev>: camera video device id (if /dev/video0, <dev> is 0)
    -x, --flip-x: flip image around x-axis
    -y, --flip-y: flip image around y-axis
    --flip-xy: flip image around both axis
    -v, --verbose: verbose mode (display debug window)
```

Les instructions d'utilisation de Dodge the Creeps (with your Face) sont les mêmes que pour le projet Dodge the Creeps project, veuillez consulter le README du projet d'origine pour plus d'informations.

## Captures d'écran

[![Captures d'écran de la vidéo de demo](https://img.youtube.com/vi/z8E0HyJvxQ0/0.jpg)](https://youtu.be/z8E0HyJvxQ0)

## Reproduction

`art/House In a Forest Loop.ogg` Copyright &copy; 2012 [HorrorPen](https://opengameart.org/users/horrorpen), [CC-BY 3.0: Attribution](http://creativecommons.org/licenses/by/3.0/). Source: https://opengameart.org/content/loop-house-in-a-forest

Les images sont tirées de "Abstract Platformer". Crée en 2016 par kenney.nl, [CC0 1.0 Universal](http://creativecommons.org/publicdomain/zero/1.0/). Source: https://www.kenney.nl/assets/abstract-platformer

La police de caractères est "Xolonium". Copyright &copy; 2011-2016 Severin Meyer <sev.ch@web.de>, avec Reserved Font Name Xolonium, SIL open font license version 1.1. Plus de détails dans `fonts/LICENSE.txt`.
