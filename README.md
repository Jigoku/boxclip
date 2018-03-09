**Boxclip** is a 2D platformer engine built using the [love2d](https://love2d.org/) framework. 

Maps can be created with the custom built-in map editor. Simply drop and place entities into the world.

[![2018-03-09-193711_1920x1080_thumb](https://user-images.githubusercontent.com/1535179/37226460-ea4f5b86-23d1-11e8-8aa8-7fa2d6eabe17.png)](https://user-images.githubusercontent.com/1535179/37226506-0e246da8-23d2-11e8-99a3-58c9fd12cbf7.png)

### Features
* game mode
* editor mode
* fully customizable world
* STALKER-X (camera module)
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
Install [love2d](https://love2d.org/) (at least version 0.10.2), and simply type
`love .` in the *src/* directory or you can create a love executable which can be ran directly by using the Makefile:

```
$ make && make all
$ cd build
$ love boxclip-*.love
```
Windows archives are not currently available, but you can create one using the above. Find them in `build/win{32,64}/boxclip-0.2-win{32,64}.zip`

### Note
Please note this is alpha software, there is no stable release yet. Currently the plans are to have a box collision based world with a map editor, and simple path-based enemies. This may change at any time! 


