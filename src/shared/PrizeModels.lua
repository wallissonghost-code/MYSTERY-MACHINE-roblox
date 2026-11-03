-- Modelos estilizados originais, gerados com peças do Roblox.
-- Sem assets externos nem IDs fictícios. Compatível com ViewportFrame.
local Models = {}
local palette = {
    Comum = Color3.fromRGB(162,180,196),
    Incomum = Color3.fromRGB(75,222,141),
    Raro = Color3.fromRGB(75,156,245),
    ["Épico"] = Color3.fromRGB(177,96,246),
    ["Lendário"] = Color3.fromRGB(248,191,67),
    Secreto = Color3.fromRGB(255,77,106)
}
Models.palette = palette
local function piece(parent, size, position, color, shape, material)
    local p = Instance.new("Part")
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.Size = size
    p.CFrame = CFrame.new(position)
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    if shape then p.Shape = shape end
    p.Parent = parent
    return p
end
local function sphere(parent, x,y,z, sx,sy,sz, color, material)
    return piece(parent,Vector3.new(sx,sy,sz),Vector3.new(x,y,z),color,Enum.PartType.Ball,material)
end
local function block(parent,x,y,z,sx,sy,sz,color,material)
    return piece(parent,Vector3.new(sx,sy,sz),Vector3.new(x,y,z),color,nil,material)
end
function Models.create(id, rarity)
    local model=Instance.new("Model")
    model.Name=id
    local c=palette[rarity] or palette.Comum
    local dark=Color3.fromRGB(29,40,58)
    local light=Color3.fromRGB(234,243,252)
    local gold=Color3.fromRGB(255,207,89)
    local glow=Enum.Material.Neon
    if id=="cup" then
        block(model,0,0,0,1.35,1.7,1.2,c)
        block(model,0,0.84,0,1.45,0.18,1.3,light)
        block(model,0,-0.9,0,1.1,0.18,1,dark)
        block(model,0.85,0.12,0,0.35,0.72,0.22,c)
    elseif id=="ball" then
        sphere(model,0,0,0,2,2,2,c,glow)
        block(model,0,0,0.95,0.25,1.3,0.13,light)
        block(model,0,0.05,0.96,1.25,0.2,0.1,light)
    elseif id=="toycar" then
        block(model,0,0,0,2.4,0.6,1.2,c)
        block(model,0,0.55,-0.15,1.15,0.55,1.1,dark)
        for _,x in ipairs({-0.75,0.75}) do for _,z in ipairs({-0.66,0.66}) do
            sphere(model,x,-0.38,z,0.6,0.6,0.26,dark)
        end end
        block(model,0.1,0.6,-0.76,0.7,0.3,0.1,light)
    elseif id=="plush" then
        sphere(model,0,0.65,0,1.25,1.2,1.1,c)
        sphere(model,0,-0.55,0,1.55,1.5,1.15,c)
        for _,x in ipairs({-0.63,0.63}) do
            sphere(model,x,1.15,0,0.55,0.55,0.5,c)
            sphere(model,x*0.57,0.72,-0.55,0.14,0.14,0.14,dark)
            sphere(model,x*1.35,-1.1,0,0.55,0.55,0.6,c)
        end
        sphere(model,0,0.28,-0.61,0.35,0.25,0.17,light)
    elseif id=="headphones" then
        local arc=block(model,0,0.85,0,1.75,0.22,0.35,c)
        for _,x in ipairs({-0.9,0.9}) do
            block(model,x,0.17,0,0.3,1.25,0.5,c)
            block(model,x,-0.3,-0.08,0.45,0.8,0.7,dark)
        end
    elseif id=="watch" then
        block(model,0,0,0,0.9,2.55,0.38,dark)
        block(model,0,0,-0.23,1.45,1.4,0.3,c,glow)
        block(model,0,0,-0.41,0.9,0.85,0.12,dark)
        block(model,0.1,0,-0.48,0.13,0.52,0.08,light)
    elseif id=="controller" then
        block(model,0,0,0,2.5,0.9,0.75,c)
        for _,x in ipairs({-0.8,0.8}) do
            sphere(model,x,-0.45,0.1,0.8,0.95,0.7,c)
            sphere(model,x,0,-0.43,0.38,0.3,0.16,dark)
        end
        for _,v in ipairs({{0.55,-0.1},{1,0.2}}) do sphere(model,v[1],v[2],-0.45,0.14,0.14,0.11,gold) end
    elseif id=="phone" then
        block(model,0,0,0,1.4,2.45,0.22,dark)
        block(model,0,0,-0.14,1.22,2.11,0.1,c,glow)
        sphere(model,0,-1.13,-0.21,0.09,0.09,0.06,light)
    elseif id=="drone" then
        block(model,0,0,0,1.3,0.4,1,dark)
        for _,x in ipairs({-1.1,1.1}) do for _,z in ipairs({-0.8,0.8}) do
            block(model,x/2,0,z/2,1.0,0.15,0.18,c)
            sphere(model,x,0,z,0.45,0.15,0.45,c,glow)
        end end
        sphere(model,0,-0.25,-0.45,0.38,0.35,0.38,light)
    elseif id=="console" then
        block(model,0,0,0,2.8,1.55,0.33,dark)
        block(model,0,0,-0.21,1.55,1.25,0.08,c,glow)
        for _,x in ipairs({-1.12,1.12}) do
            sphere(model,x,0,-0.22,0.4,0.4,0.15,light)
        end
    elseif id=="robot" then
        block(model,0,0.65,0,1.45,1.15,1.0,c)
        block(model,0,-0.55,0,1.6,1.3,0.95,dark)
        for _,x in ipairs({-0.4,0.4}) do
            sphere(model,x,0.75,-0.53,0.28,0.24,0.13,light,glow)
            block(model,x,-1.35,0,0.35,0.55,0.5,c)
        end
        block(model,0,1.45,0,0.13,0.47,0.13,light)
        sphere(model,0,1.75,0,0.2,0.2,0.2,gold,glow)
    elseif id=="skate" then
        block(model,0,-0.6,0,2.9,0.2,0.76,c)
        for _,x in ipairs({-1,1}) do
            sphere(model,x,-0.93,-0.5,0.46,0.46,0.25,dark)
            sphere(model,x,-0.93,0.5,0.46,0.46,0.25,dark)
        end
        block(model,1.05,0.3,0,0.13,1.8,0.13,dark)
        block(model,0.7,1.13,0,0.9,0.14,0.14,c)
    elseif id=="rocket" then
        block(model,0,0,0,0.85,2.2,0.85,light)
        sphere(model,0,1.07,0,0.85,0.75,0.85,c)
        for _,x in ipairs({-0.55,0.55}) do
            block(model,x,-0.8,0,0.45,0.85,0.3,c)
        end
        sphere(model,0,0.1,-0.48,0.35,0.35,0.12,dark)
        block(model,0,-1.25,0,0.38,0.7,0.38,gold,glow)
    elseif id=="diamond" then
        local gem=block(model,0,0,0,1.7,1.7,1.7,c,Enum.Material.Glass)
        gem.CFrame=CFrame.Angles(math.rad(45),math.rad(35),math.rad(20))
        block(model,0,-1.2,0,1.9,0.25,1.9,dark)
    elseif id=="crown" then
        block(model,0,-0.52,0,2.4,0.65,1.4,gold,Enum.Material.Metal)
        for _,x in ipairs({-0.9,0,0.9}) do
            block(model,x,0.18,0,0.35,0.85,0.35,gold,Enum.Material.Metal)
            sphere(model,x,0.69,0,0.24,0.24,0.24,c,glow)
        end
    elseif id=="dragon" then
        sphere(model,0,0,0,1.55,1.2,1.1,c)
        sphere(model,0.7,0.65,0,0.9,0.85,0.8,c)
        for _,x in ipairs({-0.6,0.3}) do
            local wing=block(model,x,0.75,0.7,0.25,1.45,1.2,light,Enum.Material.Glass)
            wing.CFrame=CFrame.new(wing.Position)*CFrame.Angles(0,0,math.rad(22))
        end
        sphere(model,0.85,0.72,-0.4,0.13,0.13,0.13,dark)
    elseif id=="cube" then
        local cube=block(model,0,0,0,1.7,1.7,1.7,dark,Enum.Material.Metal)
        cube.CFrame=CFrame.Angles(0.2,0.6,0.3)
        for _,x in ipairs({-0.9,0.9}) do
            sphere(model,x,0,0,0.3,0.3,0.3,c,glow)
        end
    elseif id=="relic" then
        block(model,0,-0.85,0,1.8,0.4,1.8,dark)
        block(model,0,0,0,0.45,1.65,0.45,gold,Enum.Material.Metal)
        sphere(model,0,1.08,0,1.25,1.25,1.25,c,glow)
    elseif id=="star" then
        sphere(model,0,0,0,1.45,1.45,1.45,c,glow)
        for _,axis in ipairs({"x","y","z"}) do
            local bar=block(model,0,0,0,axis=="x" and 3.5 or 0.21,axis=="y" and 3.5 or 0.21,axis=="z" and 3.5 or 0.21,light,glow)
        end
    elseif id=="artifact" then
        block(model,0,0,0,1.2,2.1,1.2,dark,Enum.Material.Metal)
        for _,x in ipairs({-0.58,0.58}) do
            block(model,x,0,0,0.18,1.8,1.3,c,glow)
        end
        sphere(model,0,1.35,0,0.7,0.7,0.7,c,glow)
    else
        sphere(model,0,0,0,1.5,1.5,1.5,c)
    end
    return model
end
return Models
