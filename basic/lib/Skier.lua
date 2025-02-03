
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

    self.sensorShape = love.physics.newCircleShape(100)
    self.sensorFixture = love.physics.newFixture(self.body,self.sensorShape)
    self.sensorFixture:setSensor(true)
    self.sensorFixture:setUserData({'skier_sensor'})

    def = {atlas = self.atlas,texture = 'skier',x = self.x,y = self.y}
    Entity.init(self,def)

    self.detectedBodies = {}
end


function Skier:update(dt)
    self.body:setLinearVelocity(SKIER_MOV,0)
    Entity.update(self,dt)
end

function Skier:render()

    self.x = self.body:getX()
    self.y = self.body:getY()

    if self.state == 4 then
        love.graphics.setColor(1,0,0)
        for i,bodies in pairs(self.detectedBodies) do
            love.graphics.line(self.x,self.y, bodies:getX(), bodies:getY())
        end
        love.graphics.reset()
    end

    Entity.render(self)
end
