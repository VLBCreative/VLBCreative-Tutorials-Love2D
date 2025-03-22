Menu = Class{}

function Menu:init()

    self.x = 10
    self.y = 10
    self.width = 600 
    self.height = 50

end

function Menu:render()

    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
    love.graphics.reset()

    for i=0,(self.width/60)-1,1 do
        x_panel = self.x + i * self.width/10

        if mousex >= x_panel + 5 and mousex <= x_panel+55 then
            if mousey >= self.y+ 5 and mousey <= 40 then 

                love.graphics.setColor(0,1,1,0.5)
                love.graphics.rectangle('fill',x_panel+5,self.y+5,50,40)
                love.graphics.reset()
            else
                love.graphics.setColor(1,1,1)
                love.graphics.rectangle('fill',x_panel+5,self.y+5,50,40)
                love.graphics.reset()
        
            end
        else

            love.graphics.setColor(1,1,1)
            love.graphics.rectangle('fill',x_panel+5,self.y+5,50,40)
            love.graphics.reset()
        end
    end

    for i,panel in pairs(panel_items) do
        love.graphics.draw(spritesheet,gFrames[panel['image']][1],panel['x'],panel['y'])
    end

end