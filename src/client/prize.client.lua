-- Mystery Machine | apresentação dos prêmios em 3D (somente cliente).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("MysteryMachineRemotes")
local update = remotes:WaitForChild("Update")
local Models = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("PrizeModels"))
local screen = Instance.new("ScreenGui")
screen.Name = "MysteryPrizePresentation"
screen.ResetOnSpawn = false
screen.DisplayOrder = 20
screen.Parent = player:WaitForChild("PlayerGui")
local shade = Instance.new("Frame")
shade.Size = UDim2.fromScale(1,1)
shade.BackgroundColor3 = Color3.fromRGB(9,14,27)
shade.BackgroundTransparency = 0.23
shade.Visible = false
shade.Parent = screen
local box = Instance.new("Frame")
box.AnchorPoint = Vector2.new(0.5,0.5)
box.Position = UDim2.fromScale(0.5,0.5)
box.Size = UDim2.fromScale(0.86,0.72)
box.BackgroundColor3 = Color3.fromRGB(25,34,57)
box.Parent = shade
local constraint = Instance.new("UISizeConstraint")
constraint.MaxSize = Vector2.new(480,540)
constraint.MinSize = Vector2.new(250,270)
constraint.Parent = box
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,18)
corner.Parent = box
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-24,0,62)
title.Position = UDim2.fromOffset(12,10)
title.BackgroundTransparency = 1
title.Text = "CÁPSULA MISTERIOSA"
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.new(1,1,1)
title.Parent = box
local viewport = Instance.new("ViewportFrame")
viewport.Position = UDim2.new(0.07,0,0.18,0)
viewport.Size = UDim2.new(0.86,0,0.52,0)
viewport.BackgroundColor3 = Color3.fromRGB(17,25,43)
viewport.Ambient = Color3.fromRGB(160,170,195)
viewport.LightColor = Color3.new(1,1,1)
viewport.LightDirection = Vector3.new(-1,-2,-2)
viewport.Parent = box
Instance.new("UICorner",viewport).CornerRadius = UDim.new(0,12)
local camera = Instance.new("Camera")
camera.Parent = viewport
viewport.CurrentCamera = camera
local world = Instance.new("WorldModel")
world.Parent = viewport
local footer = Instance.new("TextLabel")
footer.Position = UDim2.new(0.05,0,0.73,0)
footer.Size = UDim2.new(0.9,0,0.1,0)
footer.BackgroundTransparency = 1
footer.TextScaled = true
footer.Font = Enum.Font.GothamBold
footer.TextColor3 = Color3.new(1,1,1)
footer.Parent = box
local close = Instance.new("TextButton")
close.Position = UDim2.new(0.15,0,0.86,0)
close.Size = UDim2.new(0.7,0,0.105,0)
close.BackgroundColor3 = Color3.fromRGB(71,186,152)
close.Text = "GUARDAR NO INVENTÁRIO"
close.TextColor3 = Color3.new(1,1,1)
close.TextScaled = true
close.Font = Enum.Font.GothamBold
close.Parent = box
Instance.new("UICorner",close).CornerRadius = UDim.new(0,10)
local activeModel = nil
local spinConnection = nil
local token = 0
local pending = {}
local showPrize
local function dismiss()
    token += 1
    if spinConnection then spinConnection:Disconnect() spinConnection = nil end
    shade.Visible = false
    if activeModel then activeModel:Destroy() activeModel = nil end
    if #pending > 0 then
        local nextPrize = table.remove(pending,1)
        task.defer(function() showPrize(nextPrize) end)
    end
end
close.MouseButton1Click:Connect(dismiss)
showPrize = function(prize)
    token += 1
    local current = token
    if spinConnection then spinConnection:Disconnect() spinConnection = nil end
    if activeModel then activeModel:Destroy() end
    activeModel = Models.create(prize.id,prize.rarity)
    activeModel.Parent = world
    shade.Visible = true
    local accent = Models.palette[prize.rarity] or Color3.new(1,1,1)
    title.Text = "VOCÊ GANHOU!"
    title.TextColor3 = accent
    footer.Text = prize.name.."  |  "..prize.rarity.."  |  "..tostring(prize.value).." Coins"
    footer.TextColor3 = accent
    local _, size = activeModel:GetBoundingBox()
    local distance = math.max(size.X,size.Y,size.Z)*1.9 + 2
    camera.CFrame = CFrame.lookAt(Vector3.new(distance*0.4,distance*0.3,distance), Vector3.new(0,0,0))
    activeModel:PivotTo(CFrame.new())
    local elapsed = 0
    spinConnection = RunService.RenderStepped:Connect(function(dt)
        if token ~= current then return end
        elapsed += dt
        activeModel:PivotTo(CFrame.new()*CFrame.Angles(0,elapsed*0.85,0))
    end)
end
update.OnClientEvent:Connect(function(kind, data, prize)
    if kind=="State" and typeof(prize)=="table" and typeof(prize.id)=="string" then
        if shade.Visible then table.insert(pending,prize) else showPrize(prize) end
    end
end)
