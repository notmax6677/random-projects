-- player object
player = {
    -- position
    position = {x = 0, y = 0},

    -- horizontal movement
    speed = 0,
    max_speed = 200,
    speed_acceleration = 20,
    speed_slow_down = 5,

    -- vertical movement

    gravity = 0,
    max_gravity = 400,
    gravity_increase = 15,

    jump_force = -400,

    -- body variables

    width = 32,
    height = 32,

    rect = {name="player"}, -- bump.lua body

    -- lighting
    fov = 100, -- field of view

    -- drawing

    -- rubber effect
    rubber_effect_strength = 1.25, -- strength of the rubber bouncy effect when the player is moving
    rubber_effect_strength_applied = 0, -- actual rubber bounce effect strength that will be applied with delta-time in mind

    -- player initiation function
    init = function(self)
        -- add body to collision world
        world:add(self.rect, self.position.x, self.position.y, self.width, self.height)
    end,

    -- player update function
    update = function(self, dt)
        -- horizontal movement

        -- if pressing "d" and not pressing "a"
        if love.keyboard.isDown("d") and not love.keyboard.isDown("a") then
            -- if speed is less than max speed to the right
            if self.speed < self.max_speed then
                -- increase speed
                self.speed = self.speed + self.speed_acceleration
            end
        -- else if pressing "a" and not pressing "d"
        elseif love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
            -- if speed is less than max speed to the left
            if self.speed > -self.max_speed then
                -- increase speed
                self.speed = self.speed - self.speed_acceleration
            end
        -- otherwise balance the speed out back to 0
        else
            -- if speed is less than 0
            if self.speed < 0 then
                self.speed = self.speed + self.speed_slow_down -- add speed to balance out
            -- if speed is more than 0
            elseif self.speed > 0 then
                self.speed = self.speed - self.speed_slow_down -- decrease speed to balance out
            end
        end


        -- vertical movement

        -- if gravity is less than max gravity
        if self.gravity < self.max_gravity then
            -- increase gravity
            self.gravity = self.gravity + self.gravity_increase
        end

        -- attempt to move to new position and resolve collisions with walls using bump
        local actualX, actualY, cols, len = world:move(
            self.rect,
            self.position.x + self.speed*dt,
            self.position.y + self.gravity*dt
        )

        -- set position to resolved position
        self.position.x = actualX
        self.position.y = actualY

        -- post collision resolution logic

        -- if amount of collisions is more than 0
        if len > 0 then
            -- iterate through collisions
            for i = 1, len do
                -- get individual collision
                local collision = cols[i]

                -- get object from collision
                local object = collision.otherRect

                -- if object is below player (meaning that player is standing on it)
                -- and gravity is more than (or equals to) 0 (meaning that the player landed on it from above)
                if object.y >= self.position.y + self.height and self.gravity >= 0 then
                    self.gravity = 0 -- set gravity to 0, so that when player just walks off the ledge, it's a smooth fall motion
                end

                -- if object is on top of player and gravity is less than 0 (meaning that player is moving up)
                if object.y <= self.position.y and self.gravity < 0
                    and object.x ~= self.position.x + self.width -- and object x isn't the same as the player x + width (meaning that object left is not touching player right)
                    and object.x + object.w ~= self.position.x then -- and object x + width isn't the same as the player x (meaning that object right is not touching player left)
                    -- set gravity to 0 so when the player bounces off the ceiling they wont stick for a small period of time while gravity is still negative
                    self.gravity = 0
                end
                -- the last two if statements here are to prevent the player from bouncing down when they didnt touch the ceiling, but just touches a wall thats on their side
                -- e.g: a tunnel going upwards and you touch the side wall, so you dont just rebound down when you jump yk
            end 
        end

        -- set camera position to player position
        camera_follow_position = {
            x = self.position.x + self.width/2, -- add half of width and height so the camera looks directly into the center of the player
            y = self.position.y + self.height/2,
        }

        -- set applied rubber strength with current delta-time
        self.rubber_effect_strength_applied = self.rubber_effect_strength * dt
    end,

    -- player draw function
    draw = function(self)
        love.graphics.setColor(1, 1, 1, 1) -- set color back to default white with full opacity

        --love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)

        --self.animation:draw(self.spritesheet, self.position.x, self.position.y)

        -- draw an ellipse at player's coordinates
        love.graphics.ellipse(
            "fill", -- draw mode
            self.position.x + self.width/2, -- center in on player x with width
            self.position.y + self.height/2, -- center in on player y with height
            self.width/2 + math.abs(self.speed)*self.rubber_effect_strength_applied, -- width
            self.height/2 + math.abs(self.gravity)*self.rubber_effect_strength_applied -- height
        )
    end,

    -- debugging functionality
    debug = function(self)
        love.graphics.setColor(0.5, 0, 0.5, 1) -- set color to purple

        love.graphics.print("PLAYER_POS: "..self.position.x..", "..self.position.y, 10, 10)
    end,

    -- other mini functions

    -- jump function
    jump = function(self)
        self.gravity = self.jump_force -- set gravity to jump force
    end,
}