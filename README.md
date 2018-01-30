Boxclip is a work in progress 2D platform engine using the love2d framework with it's own custom built-in map editor.

Create levels by simply dragging and dropping platforms, and placing entities into the world.

![gif1](https://media.giphy.com/media/xUNd9OREaN1DHuxkcg/giphy.gif) ![gif2](https://media.giphy.com/media/3o6nUStjw9kog981Us/giphy.gif)

Visit the [Wiki](https://github.com/Jigoku/boxclip/wiki) for help with game controls and editor features


### Obtain development branch
```
$ git clone git@github.com:Jigoku/boxclip.git
```

### Running the game/engine
Install [love2d](https://love2d.org/) (at least version 0.10.2), and simply type
`love .` in the *src/* directory or you can create a love executable which can be ran directly by using the Makefile:

```
$ make && make all
$ cd build
$ love boxclip-*.love
```

Please note this is alpha software, there is no stable release yet. Currently the plans are to have a box collision based world with a map editor, and simple path-based enemies. This may change at any time.


### Using the editor: 
[![screenshot_20160911_060027](https://cloud.githubusercontent.com/assets/1535179/18415293/1279053e-77e5-11e6-9b08-e05ef0c43237.png)](https://www.youtube.com/watch?v=NiMqQbY2wIY)

