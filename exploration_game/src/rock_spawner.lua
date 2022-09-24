-- rock spawners
local rock_spawners = {}

-- a 128x128 square tile, visibility can be toggled with a boolean called debug
function create_rock_spawner(xpos, ypos)
    table.insert(rock_spawners, {
        position = {
            x = xpos,
            y = ypos,
        },

        draw = function(self)
            love.graphics.setColor(0.5, 0, 0.5, 1) -- set color to purple

            love.graphics.rectangle("line", self.position.x, self.position.y, 128, 128) -- draw rectangle showing 
        end,
    })
end

-- generate the rocks based on the positions of rock spawners
function generate_rocks()
    -- place a rock on each side of a rock spawner where it isn't touching an adjacent rock spawner
    for _, rock_spawner1 in ipairs(rock_spawners) do
        -- create variables for each side of the spawner
        local right = false
        local left = false
        local down = false
        local up = false

        -- check if the rock spawner is touching an adjacent rock spawner
        for _, rock_spawner2 in ipairs(rock_spawners) do
            -- if the rock spawner is touching the right side of the other rock spawner
            if rock_spawner1.position.x + 128 == rock_spawner2.position.x and rock_spawner1.position.y == rock_spawner2.position.y then
                right = true
            -- if the rock spawner is touching the left side of the other rock spawner
            elseif rock_spawner1.position.x - 128 == rock_spawner2.position.x and rock_spawner1.position.y == rock_spawner2.position.y then
                left = true
            -- if the rock spawner is touching the down side of the other rock spawner
            elseif rock_spawner1.position.y + 128 == rock_spawner2.position.y and rock_spawner1.position.x == rock_spawner2.position.x then
                down = true
            -- if the rock spawner is touching the up side of the other rock spawner
            elseif rock_spawner1.position.y - 128 == rock_spawner2.position.y and rock_spawner1.position.x == rock_spawner2.position.x then
                up = true
            end
        end

        -- thanks github copilot for these blocks of code LMAO

        -- if the rock spawner is not touching an adjacent rock spawner on the right
        if not right then
            for i=0, 10 do
                create_rock(rock_spawner1.position.x + 128, rock_spawner1.position.y + i*12.8) -- 12.8 is one tenth of 128, which is the length of one side of a rock spawner
            end

            -- add a wall to the bump.lua world
            world:add(
                {name="rock_spawner"..#rock_spawners},
                rock_spawner1.position.x+128, rock_spawner1.position.y,
                128, 128
            )
        end

        -- if the rock spawner is not touching an adjacent rock spawner on the left
        if not left then
            for i=0, 10 do
                create_rock(rock_spawner1.position.x, rock_spawner1.position.y + i*12.8)
            end

            -- add a wall to the bump.lua world
            world:add(
                {name="rock_spawner"..#rock_spawners},
                rock_spawner1.position.x-128, rock_spawner1.position.y,
                128, 128
            )
        end

        -- if the rock spawner is not touching an adjacent rock spawner below it
        if not down then
            for i=0, 10 do
                create_rock(rock_spawner1.position.x + i*12.8, rock_spawner1.position.y + 128)
            end

            -- add a wall to the bump.lua world
            world:add(
                {name="rock_spawner"..#rock_spawners},
                rock_spawner1.position.x, rock_spawner1.position.y+128,
                128, 128
            )
        end

        -- if the rock spawner is not touching an adjacent rock spawner above it
        if not up then
            for i=0, 10 do
                create_rock(rock_spawner1.position.x + i*12.8, rock_spawner1.position.y)
            end

            -- add a wall to the bump.lua world
            world:add(
                {name="rock_spawner"..#rock_spawners},
                rock_spawner1.position.x, rock_spawner1.position.y-128,
                128, 128
            )
        end
    end
end

-- draw all of the rock spawners
function draw_rock_spawners()
    -- iterate through the rock spawners
    for _, rock_spawner in ipairs(rock_spawners) do
        -- call the draw function for each individual rock spawner
        rock_spawner:draw()
    end
end