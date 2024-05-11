# LoveToastify: toasts for Löve2D
Made and tested in Löve2D v11.5

LoveToastify is a modified and updated version of Lucy van Sandwijk's [Lövely Toasts](https://github.com/Loucee/Lovely-Toasts) library for Love2D. I've modified it to use the Slicy library as well as the SimpleLuaClasses snippet from the Lua User wiki. It now allows you to specify the font, change the background image of the toast, and the font color all within the show function. 

## Usage
Step 1: Place the "lovetoastify.lua" library somewhere in your source folder (e.g. "/lib/soupy.lua"), along with slicy.lua and class.lua<br/><br/>
Step 2: Add a variable to require the library in your main.lua file:
```lua
require ("lovetoastify")
local loveToastify = LoveToastify()
```
Step 3: Call LoveToastify's draw and update functions
```lua
function love.update(dt)
  loveToastify:update(dt)
end

function love.draw()
  loveToastify:draw()
end
```
Step 4: Show a toast message!
```lua
loveToastify:show("This is a Lövely toast :)")
```

For best looking toasts, set `t.window.msaa` in your conf.lua to 16

## Customization
Other than the toast message you can also pass a duration and position
```lua
loveToastify:show("Lövely toast :)", 2, "top")
```
This will create a toast messsage at the top of the screen that appears for 2 seconds. Other options for the position are "middle", to put the toast in the center of the screen, "bottom", the default value, or a number for the Y position.

Or you can also pass in duration, position, font, color, and an image
```lua
loveToastify:show("Lövely toast :)", 2, "top", comicSans_font, { 1, 1, 1, 1 }, newPaneImage)
```

Doing so allows you to style the background image, the font and font color of the toast. This will create a toast similar to the previous one, but with the font set to Comic Sans, the color set to white and a new image supplied. The image is a 9Patch image. Allowing for textbox styled window graphics to be used if configured properly. 

### Other options
- **loveToastify:setTapToDismiss(true|false)** (set to false by default)<br/>Allows user to tap or click on the toast message to dismiss it
- **loveToastify:setQueueEnabled(true|false)** (set to false by default)<br/>When set to true the toasts don't replace, but enter a queue so you can queue multiple toasts in a row

In order for `loveToastify:tapToDismiss` to work you only need to implement Love's mousereleased for mouse and/or touchreleased for touch screens such a mobile devices.
```lua
function love.mousereleased(x, y, button)
 	loveToastify:onMouseReleased(x, y, button)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
	loveToastify:onTouchReleased(id, x, y, dx, dy, pressure)
end
```

# Thanks!
To you for reading and/or using LoveToastify, to [Lucy van Sandwijk](https://github.com/Loucee) for making [Lövely Toasts](https://github.com/Loucee/Lovely-Toasts), to [wqferr](https://github.com/wqferr) for creating [Slicy](https://github.com/wqferr/slicy), to the [Lua-User Wiki](http://lua-users.org/wiki/) for it's wonderful community and the [class snippet](http://lua-users.org/wiki/SimpleLuaClasses), and finally to [Buch](https://opengameart.org/users/buch) for [making the panel used in the code](https://opengameart.org/content/sci-fi-user-interface-elements).

## License
MIT
