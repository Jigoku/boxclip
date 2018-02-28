**Boxclip** is a 2D platformer engine built using the [love2d](https://love2d.org/) framework. 

Maps can be created with the custom built-in map editor. Simply drop and place entities into the world.

![gif-editor](https://media.giphy.com/media/xUNd9OREaN1DHuxkcg/giphy.gif)

### Features
* game mode
* editor mode
* fully customizable world
* simple AABB collisions
* gravity / velocity
* moving platforms
* player powerups
* destroyable crate pickups
* springs / bumpers
* traps / enemies
* unlimited map size restrictions

Visit the [Wiki](https://github.com/Jigoku/boxclip/wiki) for help with game controls and editor tips.


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


### Using the editor (outdated): 
[![screenshot_20160911_060027](https://cloud.githubusercontent.com/assets/1535179/18415293/1279053e-77e5-11e6-9b08-e05ef0c43237.png)](https://www.youtube.com/watch?v=NiMqQbY2wIY)

