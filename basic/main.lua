
require 'lib/dependencies'


function love.load()

    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = false
    })

    world = love.physics.newWorld(0,0)
    world:setCallbacks(beginContact,endContact)

    input = {world = world, atlas = spritesheet}

    yeti_character = Yeti(input)
    yeti_character:createAnimation('idleYeti')
    yeti_character:createAnimation('runningYeti')
    yeti_character:createAnimation('eatingYeti')
    yeti_character:changeAnimation('idleYeti')

    for i = 1,6,1 do
        table.insert(treeTable,Tree(input))
        treeTable[i]:createAnimation('idleTree')
        treeTable[i]:createAnimation('burningTree')
        treeTable[i]:changeAnimation('idleTree')
    end

end

function love.keypressed(key)

    if key=='escape' then
        love.event.quit()
    end

    if key == 'space' then
        skier_character = Skier(input)
        skier_character:createAnimation('skiingSkier')
        skier_character:changeAnimation('skiingSkier')
        table.insert(skier_table, skier_character)
    end
    

end

function love.update(dt)

    Timer.update(dt)
    yeti_character:update(dt)
    world:update(dt)

    for i,tree in pairs(treeTable) do
        tree:update(dt)
    end
    for i,skier in pairs(skier_table) do
        skier:update(dt)
    end


    if y<= 0 then
        dy = GRAVITY
    elseif y>= WINDOW_HEIGHT-BOX_SIZE then
        dy = -GRAVITY
    end

    y = y+dy

   

    if py >= y and py <= y+BOX_SIZE then
        if px >= x and px <= x+BOX_SIZE then
            px = 10
            py = 10
        end
    end

  

    for i,skier in  pairs(skier_table) do
        if skier.state == 2 then
            if love.keyboard.isDown('return') then
                while yeti_character.state == 1 do
                    table.remove(skier_table,i)
                    skier.body:destroy()
                    pscore = pscore + 1
                    yeti_character.state = 2
                    yeti_character:eatingFunction()
                end
            end
        end
    end


    for i,tree in pairs(treeTable) do
        if tree.state == 2 then
            if love.keyboard.isDown('return') then
                tree:removal()
            end
        elseif tree.state ==3 then
            table.remove(treeTable, i)
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
    love.graphics.reset( )

    for i,skier in pairs(skier_table) do
        skier:render()
    end

    for i,tree in pairs(treeTable) do
        tree:render()
    end

    yeti_character:render()

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



function beginContact(a,b,coll)

    local types = {}
    types[a:getUserData()[1]] = true
    types[b:getUserData()[1]] = true
    
    if types['yeti'] and types['skier'] then
        local skierFixture = a:getUserData()[1] == 'skier' and a or b
        for i,skier in pairs(skier_table) do
            if skier.body == skierFixture:getBody() then
                skier.state = 2
            end
        end
    end

    if types['yeti'] and types['tree'] then
        local treeFixture = a:getUserData()[1] == 'tree' and a or b
        for i,tree in pairs(treeTable) do
            if tree.body == treeFixture:getBody() then
                tree.state = 2
            end
        end
    end

end

function endContact(a,b,coll)

    local types = {}
    types[a:getUserData()[1]] = true
    types[b:getUserData()[1]] = true
    
    if types['yeti'] and types['skier'] then
        local skierFixture = a:getUserData()[1] == 'skier' and a or b
        for i,skier in pairs(skier_table) do
            if skier.body == skierFixture:getBody() then
                skier.state = 1
            end
        end
    end

    if types['yeti'] and types['tree'] then
        local treeFixture = a:getUserData()[1] == 'tree' and a or b
        for i,tree in pairs(treeTable) do
            if tree.body == treeFixture:getBody() then
                tree.state = 1
            end
        end
    end


end