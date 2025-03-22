
Sign = Class{__includes = Entity}

function Sign:init(input)

    self.world = input.world
    self.atlas = input.atlas
    self.x = input.x --math.random(100,WINDOW_WIDTH-100)
    self.y = input.y --math.random(100,WINDOW_HEIGHT-100)
    self.body = love.physics.newBody(self.world,self.x,self.y,'static')
    self.shape = love.physics.newRectangleShape(25,50)
    self.fixture = love.physics.newFixture(self.body,self.shape)
    self.fixture:setUserData({'sign'})
    self.state = 1
    self.timer = 0

    def = {atlas = self.atlas,texture = 'sign',x = self.x,y = self.y}
    Entity.init(self,def)

end


function Sign:update(dt)
    Entity.update(self,dt)
end

function Sign:render()
    Entity.render(self)
end
