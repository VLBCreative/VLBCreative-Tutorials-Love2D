
Class = require 'class'

WINDOW_HEIGHT = 800
WINDOW_WIDTH = 800

BOX_SIZE = 100
x = WINDOW_WIDTH-BOX_SIZE
y = 0
dy = 0
GRAVITY = 15
PLAYER_MOV = 200
SKIER_MOV = 100

py = WINDOW_HEIGHT/2
px = WINDOW_WIDTH/2

pscore = 0

skierx = 0
skiery = 200
timer = 0

skier_table = {}
skier_fixture = {}

contactBodies = {}

function love.load()

    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = false
    })

    spritesheet = love.graphics.newImage('SkiFree_-_WIN3_-_Sprite_Sheet.png')
    gFrames = {
        ['yeti'] = {
            love.graphics.newQuad(10,52,33,41,spritesheet:getDimensions()),
        love.graphics.newQuad(44,50,29,43,spritesheet:getDimensions()),
        love.graphics.newQuad(74,49,26,44,spritesheet:getDimensions()),
        love.graphics.newQuad(101,54,31,39,spritesheet:getDimensions()),
        love.graphics.newQuad(133,51,33,42,spritesheet:getDimensions()),
        love.graphics.newQuad(167,51,30,42,spritesheet:getDimensions()),
        love.graphics.newQuad(198,51,30,42,spritesheet:getDimensions()),
        love.graphics.newQuad(229,51,24,42,spritesheet:getDimensions()),
        love.graphics.newQuad(254,55,27,38,spritesheet:getDimensions()),
        love.graphics.newQuad(282,55,27,38,spritesheet:getDimensions())},

        ['skier']={love.graphics.newQuad(10,12,23,27,spritesheet:getDimensions()),
        love.graphics.newQuad(34,10,23,29,spritesheet:getDimensions()),
        love.graphics.newQuad(58,7,17,32,spritesheet:getDimensions())}
        
    }

    eatingYeti = Animation{
        frames = {5,6,7,8,9,10},
        interval =0.2
    }

    idleYeti = Animation{
        frames = {1,2},
        interval = 0.2
    }
    runningYeti = Animation{
        frames = {3,4},
        interval = 0.2
    }

    yetiAnim = idleYeti
    yetiState = 1

    world = love.physics.newWorld(0,0)
    world:setCallbacks(beginContact,endContact)

    yetiBody = love.physics.newBody(world,px,py,'dynamic')
    yetiShape = love.physics.newRectangleShape(50,50)
    yetiFixture = love.physics.newFixture(yetiBody,yetiShape)
    yetiFixture:setUserData({'yeti'})

end

function love.keypressed(key)

    if key=='escape' then
        love.event.quit()
    end

    if key == 'space' then
        table.insert(skier_table,{
            ['skierBody'] = love.physics.newBody(world,0,math.random(50, WINDOW_HEIGHT - 50),'dynamic'),
            ['skierShape'] = love.physics.newRectangleShape(25,25),
            ['isNew'] = true
        })

        for i in pairs(skier_table) do
           
            if skier_table[i]['isNew'] == true then
                table.insert(skier_fixture,{
                    ['skierFixture'] = love.physics.newFixture(skier_table[i]['skierBody'],skier_table[i]['skierShape'])
                })
                skier_table[i]['skierBody']:setLinearVelocity(SKIER_MOV,0)
                skier_table[i]['isNew'] = false
                skier_fixture[i]['skierFixture']:setUserData({'skier'})

            end
        end



    end
    

end

function love.update(dt)

    yetiAnim:update(dt)
    world:update(dt)

    py = yetiBody:getY()
    px = yetiBody:getX()


    if y<= 0 then
        dy = GRAVITY
    elseif y>= WINDOW_HEIGHT-BOX_SIZE then
        dy = -GRAVITY
    end

    y = y+dy

    vecX = 0
    vecY = 0
    yetiAnim = idleYeti

    if yetiState == 1 then
        if love.keyboard.isDown('down') then
            vecY = PLAYER_MOV
            yetiAnim = runningYeti
        end
        if love.keyboard.isDown('up') then
            vecY = -PLAYER_MOV
            yetiAnim = runningYeti
        end
        if love.keyboard.isDown('left') then
            vecX = -PLAYER_MOV
            yetiAnim = runningYeti
            left_direction  = true
        end
        if love.keyboard.isDown('right') then
            vecX = PLAYER_MOV
            yetiAnim = runningYeti
            left_direction = false
        end
    else
        vecX = 0
        vecY = 0
        yetiAnim = eatingYeti

        timer = timer +dt
        if timer >= 1.2 then
            yetiState = 1
            timer = 0
        end

    end
        
    yetiBody:setLinearVelocity(vecX,vecY)

    if py >= y and py <= y+BOX_SIZE then
        if px >= x and px <= x+BOX_SIZE then
            px = 10
            py = 10
        end
    end

    destroySkiers = {}
    if #contactBodies > 0 then
        if love.keyboard.isDown('return') then
            table.insert(destroySkiers,contactBodies[1])
        end
    end

    for k, body in pairs(destroySkiers) do
        if not body:isDestroyed() then
            body:destroy()
        end
    end

    for i = #skier_table, 1, -1 do
        if skier_table[i].skierBody:isDestroyed() then
            table.remove(skier_table,i)
            table.remove(skier_fixture, i)
            pscore = pscore + 1
            yetiState = 2
        end
    end


end

function love.draw()

    love.graphics.setColor(255,255,255)
    love.graphics.rectangle('fill',0,0,WINDOW_WIDTH,WINDOW_HEIGHT)
    
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill',x,y,BOX_SIZE,BOX_SIZE)
    
    love.graphics.line(WINDOW_WIDTH/2,0,WINDOW_WIDTH/2,WINDOW_HEIGHT)
    love.graphics.printf('Score: ' ..tostring(pscore),0,0,WINDOW_WIDTH)
    love.graphics.printf('2pt Area',WINDOW_WIDTH/4 -10,WINDOW_HEIGHT/2,WINDOW_WIDTH)
    love.graphics.printf('1pt Area',WINDOW_WIDTH*3/4 -10,WINDOW_HEIGHT/2,WINDOW_WIDTH)

    -- love.graphics.rectangle('line',px,py,50,50)
    -- love.graphics.rectangle('line',skierx,skiery,50,50)
    love.graphics.reset()

    offsetx_yeti = select(3,gFrames['yeti'][1]:getViewport())/2
    offsety_yeti = select(4,gFrames['yeti'][1]:getViewport())/2

    -- love.graphics.draw(spritesheet,gFrames['skier'][1],skierx,skiery,0,2,2)


    for i in pairs(skier_table) do
        love.graphics.draw(spritesheet,gFrames['skier'][1],skier_table[i]['skierBody']:getX(),skier_table[i]['skierBody']:getY(),0,2,2)
    end

    love.graphics.draw(spritesheet,gFrames['yeti'][yetiAnim:getFrame()],yetiBody:getX(),yetiBody:getY(),0,left_direction == true and -2 or 2,2,offsetx_yeti,offsety_yeti)
    -- love.graphics.draw()


    love.graphics.setColor(0,0,0)
    for _, body in pairs(world:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()
    
            if shape:typeOf("CircleShape") then
                local cx, cy = body:getWorldPoints(shape:getPoint())
                love.graphics.circle("line", cx, cy, shape:getRadius())
            elseif shape:typeOf("PolygonShape") then
                love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
            else
                love.graphics.line(body:getWorldPoints(shape:getPoints()))
            end
        end
    end
    love.graphics.reset( )

end


Animation = Class{}

function Animation:init(def)

    self.frames = def.frames
    self.interval = def.interval
    self.timer = 0
    self.currentFrame = 1

end

function Animation:update(dt)

    if #self.frames > 1 then
        self.timer = self.timer +dt
        if self.timer > self.interval then
            self.timer = self.timer % self.interval
            self.currentFrame = math.max(1, (self.currentFrame+1) % (#self.frames+1))
        end
    end
end

function Animation:getFrame()
    return self.frames[self.currentFrame]
end

function beginContact(a,b,coll)

    local types = {}
    types[a:getUserData()[1]] = true
    types[b:getUserData()[1]] = true
    
    if types['yeti'] and types['skier'] then

        local skierFixture = a:getUserData()[1] == 'skier' and a or b

        table.insert(contactBodies, skierFixture:getBody())


    end

end

function endContact(a,b,coll)

    local types = {}
    types[a:getUserData()[1]] = true
    types[b:getUserData()[1]] = true
    
    if types['yeti'] and types['skier'] then

        local skierFixture = a:getUserData()[1] == 'skier' and a or b

        if #contactBodies > 0 then
            table.remove(contactBodies,1)
        end


    end


end