
Skier = Class{__includes = Entity}

function Skier:init(input)

    self.world = input.world
    self.atlas = input.atlas
    self.x = 0
    self.y = math.random(100,WINDOW_HEIGHT-100)
    self.body = love.physics.newBody(self.world,self.x,self.y,'dynamic')
    self.shape = love.physics.newRectangleShape(25,25)
    self.fixture = love.physics.newFixture(self.body,self.shape)
    self.fixture:setUserData({'skier'})
    self.state = 1
    self.timer = 0

    def = {atlas = self.atlas,texture = 'skier',x = self.x,y = self.y}
    Entity.init(self,def)

end


function Skier:update(dt)
    self.body:setLinearVelocity(SKIER_MOV,0)
    Entity.update(self,dt)
end

function Skier:render()

    self.x = self.body:getX()
    self.y = self.body:getY()

    Entity.render(self)
end
