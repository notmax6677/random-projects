-- boolean to turn debugging on and off
local debug = false

-- draw debug objects that are relative to the camera
function draw_debug_camera()
    -- if debug is true
    if debug == true then
        draw_rock_spawners()
    end
end

-- draw debug objects that are NOT relative to the camera
function draw_debug()
    -- if debug is true
    if debug == true then
        player:debug()
        debug_world()
        debug_camera()
    end
end