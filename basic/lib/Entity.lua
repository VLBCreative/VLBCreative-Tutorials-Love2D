
Entity = Class{}

function Entity:init(input)

    self.atlas = input.atlas
    self.x = input.x
    self.y = input.y
    self.texture = input.texture

    self.animations = {}
    self.currentAnimation = ""
    self.entity_animations = TREE_DEFS[self.texture].anims
    self.angle = TREE_DEFS[self.texture].r
    self.scalex = TREE_DEFS[self.texture].scalex
    self.scaley = TREE_DEFS[self.texture].scaley
    self.offsetx = select(3,gFrames[self.texture][1]:getViewport())/2
    self.offsety = select(4,gFrames[self.texture][1]:getViewport())/2

end

function Entity:createAnimation(animation_name)
    self.animations[animation_name] = Animation{frames = self.entity_animations[animation_name].frames,
                                                interval = self.entity_animations[animation_name].interval,}
end

function Entity:changeAnimation(animation_name)
    if animation_name ~= self.currentAnimation then
        self.currentAnimation = animation_name
    end
end


function Entity:update(dt)
    self.animations[self.currentAnimation]:update(dt)
end

function Entity:render()

    love.graphics.draw(self.atlas, gFrames[self.texture][self.animations[self.currentAnimation]:getFrame()],
    self.x,self.y
    ,self.angle,self.scalex,self.scaley,self.offsetx,self.offsety)

end
