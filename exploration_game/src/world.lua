-- world will use drunkard walk cellular algorithm in order to procedurally generate a map

--[[
    The algorithm is as follows:

        1) Pick a random point on a filled grid and mark it empty.
        2) Choose a random cardinal direction (N, E, S, W).
        3) Move in that direction, and mark it empty unless it already was.
        4) Repeat steps 2-3, until you have emptied as many grids as desired.

    guide for this algorithm here:
        http://pcg.wikidot.com/pcg-algorithm:drunkard-walk

    extra rules:
        - in step 3 when moving in a direction, move a random amount of "steps" between 2 and 20, each step being 128 pixels
--]]

local drunkard_start_position = {
    x = 0,
    y = 0,
}

-- runs the drunkard walk algorithm
local function run_drunkard_walk()
    -- amount of times the drunkard walk algorithm will run
    local iteration_amount = math.random(500, 750)

    -- spawn the walker by picking a random position in the world
    local position = {
        x = math.random(0, world_width),
        y = math.random(0, world_height),
    }

    -- set the drunkard_start_position to the position we just picked so it can be used for debugging
    drunkard_start_position = position

    -- snap the position to a grid of 128 pixels
    position.x = position.x - position.x % 128
    position.y = position.y - position.y % 128

    -- now run the actual algorithm loop the amount of times that was generate_world
    for i = 0, iteration_amount do
        -- pick a random direction
        local direction = math.random(1, 4)

        -- NOTE: when checking for bounds, i've moved them 128 pixels in from each side so if the camera hits the edge, theres a bit of padding to make it look a bit nicer

        -- move in that direction
        if direction == 1 then
            -- if new position is within world bounds
            if position.y - 128 > 128 then
                position.y = position.y - 128 -- up
            end
        elseif direction == 2 then
            -- if new position is within world bounds
            if position.x + 128 < world_width-128 then
                position.x = position.x + 128 -- right
            end
        elseif direction == 3 then
            -- if new position is within world bounds
            if position.y + 128 < world_height-128 then
                position.y = position.y + 128 -- down
            end
        elseif direction == 4 then
            -- if new position is within world bounds
            if position.x - 128 > 128 then
                position.x = position.x - 128 -- left
            end
        end

        -- place a rock spawner at the given location
        create_rock_spawner(position.x, position.y)
    end
end


-- generates the world
function generate_world()
    -- list of rock positions that will be filled
    local rock_positions = {}

    -- create rocks according to the rock positions
    for _, rock_position in ipairs(rock_positions) do
        create_rock(rock_position.x, rock_position.y)
    end

    -- run the drunkard walk algorithm 
    run_drunkard_walk()

    -- now finally generate the rocks
    generate_rocks()

    -- set player position to drunkard walker starting position
    player.position = {
        x = drunkard_start_position.x,
        y = drunkard_start_position.y,
    }
end

function debug_world()
    love.graphics.setColor(0.5, 0, 0.5, 1) -- set color to purple

    -- print the start position of the drunkard walk algorithm
    love.graphics.print("Drunkard Start Position: " .. drunkard_start_position.x .. ", " .. drunkard_start_position.y, 10, 32)
end