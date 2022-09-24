-- basic global game variables
window_width = love.graphics.getWidth()

window_height = love.graphics.getHeight()

world_width = 6400
world_height = 6400

-- global love keypressed function
function love.keypressed(key)
    if key == "space" then
        player:jump()
    elseif key == "up" then
        change_camera_scale("increase")
    elseif key == "down" then
        change_camera_scale("decrease")
    end
end

-- all objects that are drawn relative to the camera should be put here
function camera_draw()
    -- draw player at layer 1
    deep.queue(1, function()
        player:draw()
    end)

    -- draw rocks and walls, the layers are sorted out within the function
    draw_rocks()

    -- draw objects loaded into deep
    deep.execute()
    --[[
        layers:
            0: wall squares
            1: player
            2: rocks
        
        to quickly change layers or smth and cant find the code for it just search thru all files with something like
        `deep.queue(x...`
        x being the current layer u wanna find 

        remember to change the assigned documented layer here so you dont get confused af
    --]]

    -- draw debug features that ARE relative to the camera
    draw_debug_camera()
end