-- list of rock
local rocks = {}

-- spawns a rock in the given location
function create_rock(xpos, ypos)
    -- minimum and maximum sizes
    local min_size = 12.8 -- one tenth of a rock spawner side
    local max_size = 19.2 -- 1.5x min_size

    table.insert(rocks, {
        position = {x = xpos, y = ypos},

        -- randomize size
        size = math.random(min_size, max_size),

        -- for now, draw a circle with the size of the rock
        draw = function(self)
            local alpha = 0 -- default

            -- set alpha based on how close the rock is to the player

            -- alpha = 1/absolute_distance_from_player_center (keeping both x and y in mind, as well as player field of view variable)
            alpha = (1/(math.abs(player.position.x+player.width/2 - self.position.x) + math.abs(player.position.y+player.height/2 - self.position.y)))*player.fov

            -- this forms a sort of like diamond shape around the player

            -- if alpha is less than 15% just set it to 0
            if alpha <= 0.15 then
                alpha = 0
            end

            -- if alpha is 0
            if alpha == 0 then
                -- draw small squares instead of a circle, centered on their spot, all equal size (min_size) for rocks that are too far away from the player
                -- this just provides a small outline of the map when they zoom out
                -- queued at 0 Z axis level
                deep.queue(0, function()
                    love.graphics.setColor(0.05, 0.05, 0.05, 1) -- reset color to white

                    love.graphics.rectangle("fill", self.position.x-min_size/2, self.position.y-min_size/2, min_size, min_size)
                end)
            else
                -- otherwise draw the circle at Z axis layer 2
                deep.queue(2, function()
                    -- set every red to alpha value, so the farther away the rock is, the more grayed out and "transparent" it is
                    love.graphics.setColor(alpha, 0, 0, 1)

                    -- draw a circle with it's generated size at the rock's location
                    love.graphics.circle("fill", self.position.x, self.position.y, self.size)
                end)
            end
        end,
    })
end

-- draw all of the created rocks
function draw_rocks()
    -- iterate thru all of the rocks in the rocks list
    for _, rock in ipairs(rocks) do
        rock:draw() -- draw the individual rock
    end
end