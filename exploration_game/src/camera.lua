-- camera creation and configuration

-- create camera
camera = gamera.new(0, 0, world_width, world_height)

-- just in case, set the zoom scale to default to 1 and the angle to 0
camera:setScale(1)
camera:setAngle(0)

-- variables for cam scaling

local cam_scale = 1 -- default
local cam_scale_increase = 0.25 -- how much to increase the scale by each time the camera is zoomed in/out

local cam_min_scale = 0.5 -- minimum scale
local cam_max_scale = 2 -- maximum scale

local goto_cam_scale = 1 -- default scale

local cam_scale_change_multiplier = 4 -- how much to multiply the change in scale by when the camera is zoomed in/out

-- set default camera position
camera_position = {
    x = 0,
    y = 0,
}

-- apply default camera position
camera:setPosition(camera_position.x, camera_position.y)

-- camera position to follow (default is 0, 0)
camera_follow_position = {
    x = 0,
    y = 0,
}

-- the amount that the camera speed is multiplied by
camera_speed_multiplier = 4

function update_camera(dt)
    -- update camera position and move towards the follow/goto position
    camera_position.x = camera_position.x + (camera_follow_position.x - camera_position.x)*dt*camera_speed_multiplier
    camera_position.y = camera_position.y + (camera_follow_position.y - camera_position.y)*dt*camera_speed_multiplier

    -- set camera position
    camera:setPosition(camera_position.x, camera_position.y)

    -- move camera scale towards goto camera scale
    cam_scale = cam_scale + (goto_cam_scale - cam_scale)*dt*cam_scale_change_multiplier

    -- update camera scale
    camera:setScale(cam_scale)
end

-- changes the camera scale, increment is a string that can either be increase or decrease, also checks if the scale is within the min/max scale
function change_camera_scale(increment)
    -- if the increment is increase
    if increment == "increase" then
        -- if the scale is less than the max scale
        if goto_cam_scale < cam_max_scale then
            -- increase the scale
            goto_cam_scale = goto_cam_scale + cam_scale_increase
        end
    -- if the increment is decrease
    elseif increment == "decrease" then
        -- if the scale is more than the min scale
        if goto_cam_scale > cam_min_scale then
            -- decrease the scale
            goto_cam_scale = goto_cam_scale - cam_scale_increase
        end
    end
end

-- thanks again github copilot lol

-- camera debugging
function debug_camera()
    love.graphics.setColor(0.5, 0, 0.5, 1) -- set color to purple

    love.graphics.print("Camera scale: "..cam_scale, 10, 52)
end