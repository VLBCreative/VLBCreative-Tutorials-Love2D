
require 'lib/dependencies'


function love.load()

    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = false
    })

    world = love.physics.newWorld(0,0)
    world:setCallbacks(beginContact,endContact)

    input = {world = world, atlas = spritesheet}

    input.x = WINDOW_WIDTH/2
    input.y = WINDOW_HEIGHT/2
    yeti_character = Yeti(input)
    yeti_character:createAnimation('idleYeti')
    yeti_character:createAnimation('runningYeti')
    yeti_character:createAnimation('eatingYeti')
    yeti_character:changeAnimation('idleYeti')
    table.insert(yetiTable, yeti_character)

    for i = 1,6,1 do
        input.x = math.random(100,WINDOW_WIDTH-100)
        input.y = math.random(100,WINDOW_HEIGHT-100)
        table.insert(treeTable,Tree(input))
        treeTable[i]:createAnimation('idleTree')
        treeTable[i]:createAnimation('burningTree')
        treeTable[i]:changeAnimation('idleTree')
    end

    menu = Menu()

end


function love.mousepressed(x,y,button,istouch)
    if button == 1 then
        mousex = x
        mousey = y
    end
end


function love.keypressed(key)

    if key=='escape' then
        love.event.quit()
    end

    if key == 'space' then
        input.x = 0
        input.y = math.random(100,WINDOW_HEIGHT-100)
        skier_character = Skier(input)
        skier_character:createAnimation('skiingSkier')
        skier_character:changeAnimation('skiingSkier')
        table.insert(skier_table, skier_character)
    end

    if key == 'p' and pause_status then
        pause_status = false
    elseif key =='p' and not pause_status then
        pause_status = true
    end
    
    if pause_status and key == 't' and mousex <= 65 and mousex >= 15 and mousey <= 40 and mousey >= 15 then
        input.x = mouse.x
        input.y = mouse.y
        new_tree = Tree(input)
        new_tree:createAnimation('idleTree')
        new_tree:createAnimation('burningTree')
        new_tree:changeAnimation('idleTree')
        table.insert(treeTable,new_tree)

    elseif  pause_status and key == 't' and mousex <= 130 and mousex >= 75 and mousey <= 40 and mousey >= 15 then
        input.x = mouse.x
        input.y = mouse.y
        new_sign = Sign(input)
        new_sign:createAnimation('idleSign')
        new_sign:changeAnimation('idleSign')
        table.insert(signTable,new_sign)

    
    elseif  pause_status and key == 't' and mousex <= 195 and mousex >= 140 and mousey <= 40 and mousey >= 15 then
        input.x = mouse.x
        input.y = mouse.y
        new_skier = Skier(input)
        new_skier:createAnimation('skiingSkier')
        new_skier:changeAnimation('skiingSkier')
        table.insert(skier_table, new_skier)

    elseif  pause_status and key == 't' and mousex <= 260 and mousex >= 205 and mousey <= 40 and mousey >= 15 and #yetiTable<2 then
        input.x = mouse.x
        input.y = mouse.y
        new_yeti = Yeti(input)
        new_yeti:createAnimation('idleYeti')
        new_yeti:createAnimation('runningYeti')
        new_yeti:createAnimation('eatingYeti')
        new_yeti:changeAnimation('idleYeti')
        table.insert(yetiTable, new_yeti)

    end

end

function love.update(dt)

    if not pause_status then
        Timer.update(dt)

        world:update(dt)


        for i,yeti in pairs(yetiTable) do
            yeti:update(dt)
        end
        for i,tree in pairs(treeTable) do
            tree:update(dt)
        end
        for i,sign in pairs(signTable) do
            sign:update(dt)
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

    

        for i,skierFlag in pairs(skierDestroy) do
            if love.keyboard.isDown('return') then
                while yeti_character.state == 1 do
                    skierFlag.body:destroy()
                    for j, skier in pairs(skier_table) do
                        if skier.body:isDestroyed() then
                            table.remove(skier_table,j)
                        end
                        pscore = pscore + 1
                        yeti_character.state = 2
                        yeti_character:eatingFunction()
                    end
                    skierDestroy = {}
                end
            end
        end

        for i,skier in pairs(skier_table) do
            if not skier.body:isDestroyed() then
                if skier.state == 4 then
                    for j,bodies in pairs(skier.detectedBodies) do
                        if math.abs(bodies:getY() - skier.y) < 12.5 + 30 then
                            if bodies:getY() - skier.y < 0 then
                                mov = SKIER_MOV
                            else
                                mov = -SKIER_MOV
                            end
                            skier.body:setLinearVelocity(SKIER_MOV,mov)
                        end
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

    else
        mouse.x,mouse.y = love.mouse.getPosition()
    
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

    if pause_status then
        menu:render()
    end


    for i,skier in pairs(skier_table) do
        skier:render()
    end

    for i,tree in pairs(treeTable) do
        tree:render()
    end

    for i,sign in pairs(signTable) do
        sign:render()
    end

    for i,yeti in pairs(yetiTable) do
        yeti:render()
    end


    -- love.graphics.setColor(0,0,0)
    -- for _, body in pairs(world:getBodies()) do
    --     for _, fixture in pairs(body:getFixtures()) do
    --         local shape = fixture:getShape()
    
    --         if shape:typeOf("CircleShape") then
    --             local cx, cy = body:getWorldPoints(shape:getPoint())
    --             love.graphics.circle("line", cx, cy, shape:getRadius())
    --         elseif shape:typeOf("PolygonShape") then
    --             love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
    --         else
    --             love.graphics.line(body:getWorldPoints(shape:getPoints()))
    --         end
    --     end
    -- end
    -- love.graphics.reset( )

end



function beginContact(a,b,coll)

    local types = {}
    types[a:getUserData()[1]] = true
    types[b:getUserData()[1]] = true
    
    if types['yeti'] and types['skier'] then
        local skierFixture = a:getUserData()[1] == 'skier' and a or b
        for i,skier in pairs(skier_table) do
            if skier.body == skierFixture:getBody() then
                table.insert(skierDestroy, skier)
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

    if (types['yeti'] or types['tree']) and types['skier_sensor'] then
        local skierFixture = a:getUserData()[1] == 'skier_sensor' and a or b
        local otherFixture = a:getUserData()[1] ~= 'skier_sensor' and a or b
        for i,skier in pairs(skier_table) do
            if skier.body == skierFixture:getBody() then
                skier.state = 4
                table.insert(skier.detectedBodies, otherFixture:getBody())
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
                table.remove(skierDestroy,1)
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

    if (types['yeti'] or types['tree']) and types['skier_sensor'] then
        local skierFixture = a:getUserData()[1] == 'skier_sensor' and a or b
        local otherFixture = a:getUserData()[1] ~= 'skier_sensor' and a or b
        for i,skier in pairs(skier_table) do
            if skier.body == skierFixture:getBody() then
                for j, bodies in pairs(skier.detectedBodies) do 
                    if otherFixture:getBody() == bodies then
                        table.remove(skier.detectedBodies, j)
                    end
                end
            end
        end
    end



end