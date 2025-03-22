
Yeti = Class{__includes = Entity}

function Yeti:init(input)

    self.world = input.world
    self.atlas = input.atlas
    self.x = input.x -- WINDOW_WIDTH/2
    self.y = input.y -- WINDOW_HEIGHT/2
    self.body = love.physics.newBody(self.world,self.x,self.y,'dynamic')
    self.shape = love.physics.newRectangleShape(30,30)
    self.fixture = love.physics.newFixture(self.body,self.shape)
    self.fixture:setUserData({'yeti'})
    self.state = 1
    self.timer = 0
    self.direction  = true

    def = {atlas = self.atlas,texture = 'yeti',x = self.x,y = self.y}
    Entity.init(self,def)

end


function Yeti:eatingFunction()
    if self.state ==2 then
        vecX = 0
        vecY = 0
        Entity.changeAnimation(self,'eatingYeti')
        Timer.after(1.2, function () self.state = 1 end)
    end 
end


function Yeti:update(dt)

    vecX = 0
    vecY = 0

    if self.state == 1 then
        Entity.changeAnimation(self,'idleYeti')
        if love.keyboard.isDown('down') then
            vecY = PLAYER_MOV
            Entity.changeAnimation(self,'runningYeti')
        end
        if love.keyboard.isDown('up') then
            vecY = -PLAYER_MOV
            Entity.changeAnimation(self,'runningYeti')
        end
        if love.keyboard.isDown('left') then
            vecX = -PLAYER_MOV
            Entity.changeAnimation(self,'runningYeti')
            self.direction  = false
        end
        if love.keyboard.isDown('right') then
            vecX = PLAYER_MOV
            Entity.changeAnimation(self,'runningYeti')
            self.direction  = true
        end
    end
        
    self.body:setLinearVelocity(vecX,vecY)

    Entity.update(self,dt)
end

function Yeti:render()

    self.x = self.body:getX()
    self.y = self.body:getY()

    if self.direction then
        self.scalex = TREE_DEFS[self.texture].scalex
    else 
        self.scalex = -TREE_DEFS[self.texture].scalex
    end

    Entity.render(self)

end
