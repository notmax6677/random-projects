-- import libraries

gamera = require "lib.gamera" -- camera system

bump = require "lib.bump" -- collision detection

deep = require "lib.deep" -- adds Z axis

require "lib.require" -- require all files in a folder

-- import debugging features [ self made ;) ]
require "debugger"

-- import collision setup
require "collision"

-- import game related functions (before main source files because this might be a dependency for some of them)
require "game"

-- import all source files in the ./src directory
require.tree("src")

-- randomize rng seed
math.randomseed(os.time())

-- main game functions

-- load game
function love.load()
    -- set default filter so that images are not smoothed
    love.graphics.setDefaultFilter("nearest", "nearest")

    generate_world()

    player:init()
end

-- update game
function love.update(dt)
    player:update(dt)

    update_camera(dt)

    ui:update(dt)
end

-- draw game
function love.draw()
    -- clear the screen
    love.graphics.clear(0, 0, 0)

    -- draw stuff relative to the camera
    camera:draw(camera_draw)

    -- draw ui
    ui:draw()

    -- draw debug features NOT relative to camera
    draw_debug()
end