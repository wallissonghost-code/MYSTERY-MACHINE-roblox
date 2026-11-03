-- Mystery Machine | servidor v0.1
-- Ações econômicas sempre validadas no servidor.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local Items = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Items"))
local store = DataStoreService:GetDataStore("MysteryMachineProfile_v1")
local COST, STARTING_COINS, MAX_ITEMS = 25, 250, 150
local profiles = {}
local busy = {}
local lastOpen = {}
local lastSell = {}
local FREE_COINS, REWARD_COOLDOWN = 50, 180
local remotes = Instance.new("Folder")
remotes.Name = "MysteryMachineRemotes"
remotes.Parent = ReplicatedStorage
local action = Instance.new("RemoteEvent")
action.Name = "Action"
action.Parent = remotes
local update = Instance.new("RemoteEvent")
update.Name = "Update"
update.Parent = remotes

local function snapshot(profile)
    local inventory = {}
    for id, quantity in pairs(profile.inventory) do
        if Items.byId[id] and quantity > 0 then inventory[id] = quantity end
    end
    return {coins=profile.coins, inventory=inventory, discovered=profile.discovered, lastClaim=profile.lastClaim or 0}
end

local function broadcast(player, prize)
    local profile = profiles[player]
    if profile then update:FireClient(player, "State", snapshot(profile), prize) end
end
local function message(player, text)
    update:FireClient(player, "Message", text)
end
local function save(player)
    local profile = profiles[player]
    if not profile or profile.readOnly then return false end
    profile.saveRequested = true
    if profile.saving then
        while profile.saving do task.wait(0.1) end
        if not profile.saveRequested then return true end
    end
    profile.saving = true
    local success = true
    repeat
        profile.saveRequested = false
        local payload = snapshot(profile)
        local ok, err = pcall(function()
            store:UpdateAsync("player_"..player.UserId, function()
                return payload
            end)
        end)
        if not ok then
            warn("Mystery Machine: save failed", player.UserId, err)
            success = false
            break
        end
    until not profile.saveRequested
    profile.saving = false
    return success
end

local function countItems(profile)
    local total = 0
    for _, amount in pairs(profile.inventory) do total += amount end
    return total
end

local function useMachine(player)
    local profile = profiles[player]
    if not profile or profile.readOnly or busy[player] then return end
    if os.clock() - (lastOpen[player] or -100) < 1.2 then return end
    lastOpen[player] = os.clock()
    if profile.coins < COST then message(player, "Moedas insuficientes. Venda itens no inventário!") return end
    if countItems(profile) >= MAX_ITEMS then message(player, "Inventário cheio! Venda alguns objetos.") return end
    busy[player] = true
    local prize = Items.roll()
    profile.coins -= COST
    profile.inventory[prize.id] = (profile.inventory[prize.id] or 0) + 1
    profile.discovered[prize.id] = true
    broadcast(player, {id=prize.id, name=prize.name, rarity=prize.rarity, value=prize.value})
    busy[player] = nil
    task.spawn(save, player)
end

local function claimCoins(player)
    local profile = profiles[player]
    if not profile or profile.readOnly or busy[player] then return end
    local now = os.time()
    if now - (profile.lastClaim or 0) < REWARD_COOLDOWN then
        message(player, "Recompensa ainda não disponível.")
        return
    end
    profile.lastClaim = now
    profile.coins += FREE_COINS
    broadcast(player)
    message(player, "+50 Coins grátis!")
    task.spawn(save, player)
end

local function sell(player, id)
    if typeof(id) ~= "string" or not Items.byId[id] then return end
    local profile = profiles[player]
    if not profile or profile.readOnly or busy[player] then return end
    if os.clock() - (lastSell[player] or -100) < 0.35 then return end
    if (profile.inventory[id] or 0) < 1 then return end
    lastSell[player] = os.clock()
    busy[player] = true
    profile.inventory[id] -= 1
    if profile.inventory[id] == 0 then profile.inventory[id] = nil end
    profile.coins += Items.byId[id].value
    broadcast(player)
    busy[player] = nil
    task.spawn(save, player)
end

local function part(parent, name, size, position, color, material)
    local p = Instance.new("Part")
    p.Name = name
    p.Anchored = true
    p.Size = size
    p.Position = position
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Parent = parent
    return p
end

local function buildWorld()
    local old = workspace:FindFirstChild("MysteryMachineWorld")
    if old then old:Destroy() end
    local folder = Instance.new("Folder")
    folder.Name = "MysteryMachineWorld"
    folder.Parent = workspace
    part(folder, "Plataforma", Vector3.new(82, 1, 82), Vector3.new(0, -0.5, 0), Color3.fromRGB(31, 43, 66))
    local spawn = Instance.new("SpawnLocation")
    spawn.Name = "MysterySpawn"
    spawn.Size = Vector3.new(8, 1, 8)
    spawn.Position = Vector3.new(0, 0.5, 20)
    spawn.Anchored = true
    spawn.Neutral = true
    spawn.Color = Color3.fromRGB(75, 179, 255)
    spawn.Parent = folder
    local machine = Instance.new("Model")
    machine.Name = "MaquinaSurpresa"
    machine.Parent = folder
    part(machine, "Corpo", Vector3.new(10, 12, 5), Vector3.new(0, 6, -8), Color3.fromRGB(60, 84, 195), Enum.Material.Metal)
    local visor = part(machine, "Visor", Vector3.new(8, 6, 0.3), Vector3.new(0, 8, -5.35), Color3.fromRGB(108, 225, 246), Enum.Material.Glass)
    visor.Transparency = 0.32
    part(machine, "Painel inferior", Vector3.new(8, 2, 0.5), Vector3.new(0, 3, -5.2), Color3.fromRGB(18, 28, 57), Enum.Material.Metal)
    local button = part(machine, "Botão", Vector3.new(2.8, 1.2, 0.8), Vector3.new(0, 3.1, -4.5), Color3.fromRGB(255, 206, 68), Enum.Material.Neon)
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Abrir por 25 Coins"
    prompt.ObjectText = "Máquina Surpresa"
    prompt.KeyboardKeyCode = Enum.KeyCode.E
    prompt.HoldDuration = 0.25
    prompt.MaxActivationDistance = 13
    prompt.RequiresLineOfSight = false
    prompt.Parent = button
    prompt.Triggered:Connect(useMachine)
    for i = -2, 2 do
        local capsule = part(machine, "Cápsula"..i, Vector3.new(1,1,1), Vector3.new(i * 1.5, 8, -4.9), Color3.fromHSV((i+2)/5, 0.65, 1), Enum.Material.Neon)
        capsule.Shape = Enum.PartType.Ball
    end
    local sign = Instance.new("BillboardGui")
    sign.Name = "Letreiro"
    sign.Size = UDim2.fromOffset(340, 70)
    sign.StudsOffset = Vector3.new(0, 8, 0)
    sign.AlwaysOnTop = true
    sign.Parent = machine.Corpo
    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBlack
    label.TextScaled = true
    label.TextColor3 = Color3.new(1,1,1)
    label.TextStrokeTransparency = 0.3
    label.Text = "MYSTERY MACHINE"
    label.Parent = sign
end

Players.PlayerAdded:Connect(function(player)
    local ok, data = pcall(function() return store:GetAsync("player_"..player.UserId) end)
    local profile = {coins=STARTING_COINS, inventory={}, discovered={}, lastClaim=0, readOnly=not ok}
    if ok and typeof(data) == "table" then
        if typeof(data.coins) == "number" then profile.coins = math.max(0, math.floor(data.coins)) end
        if typeof(data.inventory) == "table" then
            for id, qty in pairs(data.inventory) do
                if Items.byId[id] and typeof(qty) == "number" and qty >= 1 then
                    profile.inventory[id] = math.min(MAX_ITEMS, math.floor(qty))
                end
            end
        end
        if typeof(data.lastClaim) == "number" then profile.lastClaim = math.floor(data.lastClaim) end
        if typeof(data.discovered) == "table" then
            for id, found in pairs(data.discovered) do
                if Items.byId[id] and found == true then profile.discovered[id] = true end
            end
        end
    end
    profiles[player] = profile
    broadcast(player)
    if not ok then message(player, "Dados indisponíveis: operações bloqueadas para proteger seu progresso.") end
end)

action.OnServerEvent:Connect(function(player, verb, id)
    if verb == "GetState" then broadcast(player)
    elseif verb == "Open" then
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root and (root.Position - Vector3.new(0,3,-8)).Magnitude <= 18 then useMachine(player) end
    elseif verb == "Sell" then sell(player, id)
    elseif verb == "ClaimFree" then claimCoins(player) end
end)
Players.PlayerRemoving:Connect(function(player)
    save(player)
    profiles[player] = nil
    busy[player] = nil
    lastOpen[player] = nil
    lastSell[player] = nil
end)
game:BindToClose(function()
    for _, player in ipairs(Players:GetPlayers()) do save(player) end
end)
task.spawn(function()
    while true do
        task.wait(90)
        for _, player in ipairs(Players:GetPlayers()) do task.spawn(save, player) end
    end
end)
buildWorld()
