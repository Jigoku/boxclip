**Boxclip** is a 2D platformer engine, with an emphasis on interactive map editing. Built using the [LÖVE2D](https://love2d.org/) framework.

Maps can be created with the custom built-in map editor. Simply drop and place entities into the world.

[![1](screenshots/1.jpg)](screenshots/1.jpg)

### Features
* game mode
* editor mode
* fully customizable world
* [STALKER-X](https://github.com/SSYGEN/STALKER-X) (camera module)
* simple AABB collisions
* gravity / velocity
* moving platforms
* player powerups
* destroyable crate pickups
* springs / bumpers
* traps / enemies
* unlimited map size restrictions
* map states

Visit the [Wiki](https://github.com/Jigoku/boxclip/wiki) for help with game controls and editor tips.

### Using the editor
(click the image to play) 
[![youtube](https://user-images.githubusercontent.com/1535179/37005890-ac2257a2-20cd-11e8-9cbe-47d57f738b1f.png)](https://www.youtube.com/watch?v=WS5fl4KJfOY)

### Get the development branch
```
$ git clone git@github.com:Jigoku/boxclip.git
```

### Run the game/engine
Install [love2d](https://love2d.org/) (at least version 11.1), and simply type
`love .` in the *src/* directory or you can create a love executable which can be ran directly by using the Makefile:

```
$ make && make all
```
Windows archives are not currently available, but you can create them using the above. Find them in `dist/win{32,64}/boxclip-0.2-win{32,64}.zip`

### Note
Please note this is alpha software, there is no stable release yet. Currently the plans are to have a box collision based world with a map editor, and simple path-based enemies. This may change at any time! 

[![2](screenshots/2.jpg)](screenshots/2.jpg)

[![3](screenshots/3.jpg)](screenshots/3.jpg)


