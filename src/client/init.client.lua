-- Mystery Machine | HUD v0.1; não modifica dados econômicos localmente.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Items = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Items"))
local remotes = ReplicatedStorage:WaitForChild("MysteryMachineRemotes")
local action = remotes:WaitForChild("Action")
local update = remotes:WaitForChild("Update")
local gui = Instance.new("ScreenGui")
gui.Name = "MysteryMachineHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = player:WaitForChild("PlayerGui")
local state = {coins=0, inventory={}, discovered={}}
local colors = {Comum=Color3.fromRGB(167,180,196), Incomum=Color3.fromRGB(93,223,147), Raro=Color3.fromRGB(82,157,250), ["Épico"]=Color3.fromRGB(176,102,251), ["Lendário"]=Color3.fromRGB(255,191,65), Secreto=Color3.fromRGB(255,83,110)}
local function make(class, parent, props)
    local obj=Instance.new(class)
    for k,v in pairs(props or {}) do obj[k]=v end
    obj.Parent=parent
    return obj
end
local function rounded(obj, r)
    make("UICorner",obj,{CornerRadius=UDim.new(0,r)})
end
local function label(parent,text,size,pos,font,color)
    return make("TextLabel",parent,{BackgroundTransparency=1,Text=text,TextColor3=color or Color3.new(1,1,1),TextSize=size,Font=font or Enum.Font.GothamBold,Position=pos or UDim2.new(),Size=UDim2.fromScale(1,1),TextXAlignment=Enum.TextXAlignment.Center})
end
local top=make("Frame",gui,{Size=UDim2.fromOffset(290,65),Position=UDim2.new(0.5,-145,0,15),BackgroundColor3=Color3.fromRGB(25,35,61)})
rounded(top,16)
local balance=label(top,"Coins: ...",24,nil,Enum.Font.GothamBlack)
local inventoryButton=make("TextButton",gui,{Text="INVENTÁRIO",Font=Enum.Font.GothamBold,TextSize=16,TextColor3=Color3.new(1,1,1),BackgroundColor3=Color3.fromRGB(69,105,210),Size=UDim2.fromOffset(164,50),Position=UDim2.new(0,16,1,-70)})
rounded(inventoryButton,13)
local openButton=make("TextButton",gui,{Text="ABRIR CÁPSULA · 25",Font=Enum.Font.GothamBlack,TextSize=16,TextColor3=Color3.fromRGB(19,30,52),BackgroundColor3=Color3.fromRGB(255,207,70),Size=UDim2.fromOffset(210,50),Position=UDim2.new(1,-226,1,-70)})
rounded(openButton,13)
local note=make("TextLabel",gui,{Visible=false,Size=UDim2.fromOffset(350,60),Position=UDim2.new(0.5,-175,0.2,0),BackgroundColor3=Color3.fromRGB(21,29,48),TextWrapped=true,TextSize=18,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold})
rounded(note,12)
local panel=make("Frame",gui,{Visible=false,Size=UDim2.new(0.86,0,0.66,0),Position=UDim2.new(0.07,0,0.17,0),BackgroundColor3=Color3.fromRGB(21,29,48)})
make("UISizeConstraint",panel,{MaxSize=Vector2.new(600,630),MinSize=Vector2.new(280,240)})
rounded(panel,18)
local title=label(panel,"MINHA COLEÇÃO",23,UDim2.fromOffset(10,8),Enum.Font.GothamBlack)
title.Size=UDim2.new(1,-80,0,44)
local close=make("TextButton",panel,{Text="X",TextSize=21,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,BackgroundColor3=Color3.fromRGB(169,69,94),Size=UDim2.fromOffset(45,40),Position=UDim2.new(1,-54,0,8)})
rounded(close,10)
local summary=label(panel,"0/20 descobertos",14,UDim2.fromOffset(18,53),Enum.Font.Gotham)
summary.Size=UDim2.new(1,-36,0,22)
local scroll=make("ScrollingFrame",panel,{Position=UDim2.fromOffset(14,84),Size=UDim2.new(1,-28,1,-98),BackgroundTransparency=1,ScrollBarThickness=6,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new()})
make("UIPadding",scroll,{PaddingBottom=UDim.new(0,8)})
local layout=make("UIListLayout",scroll,{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder})
local noticeVersion=0
local function toast(text)
    noticeVersion += 1
    local version=noticeVersion
    note.Text=text
    note.Visible=true
    task.delay(3.5,function()
        if version==noticeVersion then note.Visible=false end
    end)
end
local function render()
    balance.Text="🪙 "..tostring(state.coins).." COINS"
    local discovered=0
    for _, v in pairs(state.discovered) do if v then discovered+=1 end end
    summary.Text=discovered.."/"..#Items.all.." objetos descobertos"
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for i,item in ipairs(Items.all) do
        local qty=state.inventory[item.id] or 0
        local found=state.discovered[item.id]==true
        local card=make("Frame",scroll,{LayoutOrder=i,Size=UDim2.new(1,-7,0,66),BackgroundColor3=Color3.fromRGB(35,47,75)})
        rounded(card,10)
        local strip=make("Frame",card,{Size=UDim2.fromOffset(5,52),Position=UDim2.fromOffset(7,7),BackgroundColor3=colors[item.rarity] or Color3.new(1,1,1)})
        rounded(strip,3)
        local name=label(card,found and item.name or "??? • Não descoberto",16,UDim2.fromOffset(20,7))
        name.Size=UDim2.new(1,-147,0,25)
        name.TextXAlignment=Enum.TextXAlignment.Left
        local detail=label(card,item.rarity.." • "..item.value.." coins • x"..qty,12,UDim2.fromOffset(20,34),Enum.Font.Gotham,colors[item.rarity])
        detail.Size=UDim2.new(1,-145,0,20)
        detail.TextXAlignment=Enum.TextXAlignment.Left
        local sell=make("TextButton",card,{Text="VENDER",Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.new(1,1,1),BackgroundColor3=qty>0 and Color3.fromRGB(52,151,113) or Color3.fromRGB(65,73,87),Size=UDim2.fromOffset(92,36),Position=UDim2.new(1,-101,0,16),Active=qty>0,AutoButtonColor=qty>0})
        rounded(sell,8)
        sell.MouseButton1Click:Connect(function()
            if qty>0 then action:FireServer("Sell",item.id) end
        end)
    end
end
inventoryButton.MouseButton1Click:Connect(function()
    panel.Visible=not panel.Visible
    if panel.Visible then render() end
end)
close.MouseButton1Click:Connect(function() panel.Visible=false end)
openButton.MouseButton1Click:Connect(function() action:FireServer("Open") end)
update.OnClientEvent:Connect(function(kind,data,prize)
    if kind=="State" and typeof(data)=="table" then
        state=data
        render()
        if prize then toast("🎁 "..prize.name.."! ["..prize.rarity.."]  +"..prize.value.." valor") end
    elseif kind=="Message" then
        toast(tostring(data))
    end
end)
action:FireServer("GetState")
