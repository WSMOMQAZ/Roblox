game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "提示";
    Text = "脚本正在加载中";
    Duration = 5; 
})

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "提示";
    Text = "如果长时间加载不出来请更换加速器";
    Duration = 10; 
})


local WindUI = loadstring(game:HttpGet("https://github.com/WSMOMQAZ/Roblox/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Refinery Caves2",
    Icon = "trophy",
    Author = "版本: 1.0",
    Folder = "MySuperHub",

    Size = UDim2.fromOffset(570, 450),
    Transparent = false,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,

    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },

    
})

Window:EditOpenButton({
    Title = "Refinery Caves2",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( 
        Color3.fromHex("FF0F7B"),
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- TAG WHICH SHOWS THE VERSION


local Tab = Window:Tab({
    Title = "人物",
    Icon = "user", 
    Locked = false,
})

Window:Divider()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local chr = player.Character or player.CharacterAdded:Wait()
local hum = chr:WaitForChild("Humanoid")

local tpwalking = false
local speedValue = 10 


player.CharacterAdded:Connect(function(newChar)
    chr = newChar
    hum = chr:WaitForChild("Humanoid")
end)


local Input = Tab:Input({
    Title = "速度控制",
    Desc = "输入速度数字，或输入 off 关闭",
    Value = "",
    InputIcon = "gauge", 
    Type = "Input",     
    Placeholder = "例如: 20 或 off",
    Callback = function(txt) 
        local input = tostring(txt):lower()
        if input == "off" then
            tpwalking = false
            print("已关闭 tpwalk")
        else
            local num = tonumber(input)
            if num then
                if num > 500 then num = 500 end 
                speedValue = num
                tpwalking = true
                print("tpwalk 速度设为: " .. tostring(num))
            else
                print("无效输入: " .. tostring(input))
            end
        end
    end
})


RunService.Heartbeat:Connect(function(delta)
    if tpwalking and hum and hum.Parent and hum.MoveDirection.Magnitude > 0 then
        chr:TranslateBy(hum.MoveDirection * speedValue * delta)
    end
end)

Tab:Divider()

local InfiniteJumpEnabled = false


local Toggle = Tab:Toggle({
    Title = "无限跳跃",
    Desc = "开启后可在空中连续跳跃",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        InfiniteJumpEnabled = state
        if state then
            print("无限跳跃已开启")
        else
            print("无限跳跃已关闭")
        end
    end
})


local function SetupInfiniteJump(character)
    local UserInputService = game:GetService("UserInputService")
    UserInputService.JumpRequest:Connect(function()
        if InfiniteJumpEnabled then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState("Jumping")
            end
        end
    end)
end


local player = game:GetService("Players").LocalPlayer


player.CharacterAdded:Connect(function(character)
    task.wait(1) 
    SetupInfiniteJump(character)
end)


if player.Character then
    SetupInfiniteJump(player.Character)
end

Tab:Divider()

local locations = {
    ["usc"] = Vector3.new(1291.39, 30.13, -697.50),
    ["土地商店"] = Vector3.new(1355.39, 30.08, -748.53),
    ["送快递"] = Vector3.new(1178.06, 30.13, -721.00),
    ["出售中心"] = Vector3.new(934.69, 29.87, -706.00),
    ["海洋出售中心"] = Vector3.new(1624.74, 3.15, -1266.70),
    ["海洋馆"] = Vector3.new(1781.90, 3.03, -1345.13),
    ["家具店"] = Vector3.new(1171.82, 101.37, 534.03),
    ["nova洞口"] = Vector3.new(1919.43, 2.75, -61.68),
    ["葱葱绿郁森林"] = Vector3.new(-456.69, -542.77, 958.58),
    ["巫师"] = Vector3.new(-612.27, -490.69, 1269.72),
    ["国王的大厅"] = Vector3.new(-1849.83, -649.13, 2267.80),
    ["沼河"] = Vector3.new(1231.92, 2.51, 2018.95),
    ["死亡区"] = Vector3.new(1085.95, 210.18, 3549.06),
    ["丛林"] = Vector3.new(520.69, 369.46, 3790.11),
    ["石质摇蓝"] = Vector3.new(286.76, -119.18, 3389.97),
    ["油井"] = Vector3.new(-2345.61, 112.32, 5338.49),
    ["樱花岛"] = Vector3.new(-5731.46, 34.22, 4412.13),
    ["月球宫"] = Vector3.new(-6219.94, 125.93, 4842.74),
    ["饱子洞"] = Vector3.new(-5731.36, -127.63, 4708.23),
    ["逻辑商场"] = Vector3.new(-5146.67, 59.67, -2875.79),
    ["实验室门口"] = Vector3.new(-4508.41, 129.61, -1911.74),
    ["山亚当"] = Vector3.new(-7761.65, 497.54, -4214.17),
    ["云矿"] = Vector3.new(-7209.23, 755.10, -2918.02),
    ["车辆商店"] = Vector3.new(-6878.22, 3.25, -4259.97),
    ["矿工的藏身之处"] = Vector3.new(-7829.37, 169.69, -3199.71)
}

local locationNames = {}
for name,_ in pairs(locations) do
    table.insert(locationNames, name)
end

local Dropdown = Tab:Dropdown({
    Title = "地点传送",
    Values = locationNames,
    Value = "",
    Callback = function(option)
        local pos = locations[option]
        print("选中地点:", option, pos)

        
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end
})



local Tab = Window:Tab({
    Title = "自动传送",
    Icon = "map", 
    Locked = false,
})

Window:Divider()


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer



local savedPosA = nil
local tpEnabledA = false
local checkingA = false

local ToggleA = Tab:Toggle({
    Title = "自动传送①",
    Desc = "每秒检测是否离开保存点①",
    Icon = "map-pin",
    Default = false,
    Callback = function(state)
        tpEnabledA = state
        StarterGui:SetCore("SendNotification", {
            Title = "传送①",
            Text = state and "已开启自动传送①" or "已关闭自动传送①",
            Duration = 2
        })
    end
})

local ButtonA = Tab:Button({
    Title = "保存位置①",
    Desc = "保存当前位置①",
    Callback = function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            savedPosA = hrp.Position
            StarterGui:SetCore("SendNotification", {
                Title = "位置①",
                Text = "保存成功",
                Duration = 2
            })
        end
    end
})

local ResetA = Tab:Button({
    Title = "清除位置①",
    Desc = "清除保存点①",
    Callback = function()
        savedPosA = nil
        StarterGui:SetCore("SendNotification", {
            Title = "位置①",
            Text = "已清除保存点",
            Duration = 2
        })
    end
})

RunService.Heartbeat:Connect(function()
    if tpEnabledA and savedPosA and not checkingA then
        checkingA = true
        task.spawn(function()
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - savedPosA).Magnitude > 3 then
                hrp.CFrame = CFrame.new(savedPosA)
            end
            task.wait(0.01)
            checkingA = false
        end)
    end
end)


local savedPosB = nil
local tpEnabledB = false
local checkingB = false

local ToggleB = Tab:Toggle({
    Title = "自动传送②",
    Desc = "每秒检测是否离开保存点②",
    Icon = "navigation",
    Default = false,
    Callback = function(state)
        tpEnabledB = state
        StarterGui:SetCore("SendNotification", {
            Title = "传送②",
            Text = state and "已开启自动传送②" or "已关闭自动传送②",
            Duration = 2
        })
    end
})

local ButtonB = Tab:Button({
    Title = "保存位置②",
    Desc = "保存当前位置②",
    Callback = function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            savedPosB = hrp.Position
            StarterGui:SetCore("SendNotification", {
                Title = "位置②",
                Text = "保存成功",
                Duration = 2
            })
        end
    end
})

local ResetB = Tab:Button({
    Title = "清除位置②",
    Desc = "清除保存点②",
    Callback = function()
        savedPosB = nil
        StarterGui:SetCore("SendNotification", {
            Title = "位置②",
            Text = "已清除保存点",
            Duration = 2
        })
    end
})

RunService.Heartbeat:Connect(function()
    if tpEnabledB and savedPosB and not checkingB then
        checkingB = true
        task.spawn(function()
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - savedPosB).Magnitude > 3 then
                hrp.CFrame = CFrame.new(savedPosB)
            end
            task.wait(0.01)
            checkingB = false
        end)
    end
end)


local savedPosC = nil
local tpEnabledC = false
local checkingC = false

local ToggleC = Tab:Toggle({
    Title = "自动传送③",
    Desc = "每秒检测是否离开保存点③",
    Icon = "map",
    Default = false,
    Callback = function(state)
        tpEnabledC = state
        StarterGui:SetCore("SendNotification", {
            Title = "传送③",
            Text = state and "已开启自动传送③" or "已关闭自动传送③",
            Duration = 2
        })
    end
})

local ButtonC = Tab:Button({
    Title = "保存位置③",
    Desc = "保存当前位置③",
    Callback = function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            savedPosC = hrp.Position
            StarterGui:SetCore("SendNotification", {
                Title = "位置③",
                Text = "保存成功",
                Duration = 2
            })
        end
    end
})

local ResetC = Tab:Button({
    Title = "清除位置③",
    Desc = "清除保存点③",
    Callback = function()
        savedPosC = nil
        StarterGui:SetCore("SendNotification", {
            Title = "位置③",
            Text = "已清除保存点",
            Duration = 2
        })
    end
})

RunService.Heartbeat:Connect(function()
    if tpEnabledC and savedPosC and not checkingC then
        checkingC = true
        task.spawn(function()
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - savedPosC).Magnitude > 3 then
                hrp.CFrame = CFrame.new(savedPosC)
            end
            task.wait(0.01)
            checkingC = false
        end)
    end
end)



local Tab = Window:Tab({
    Title = "esp",
    Icon = "view", 
    Locked = false,
})

Window:Divider()

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local oresFolder = workspace:WaitForChild("WorldSpawn"):WaitForChild("Ores")


local DropdownValues = {}


local esp_cache = {}


local OresDropdown = Tab:Dropdown({
    Title = "矿物选择（ESP 多选）",
    Values = DropdownValues,
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        print("当前已选择矿物: " .. HttpService:JSONEncode(option))
    end
})


local function unique(list)
    local set = {}
    local result = {}
    for _, v in ipairs(list) do
        if not set[v] then
            set[v] = true
            table.insert(result, v)
        end
    end
    return result
end



local function createESP(part, name)
    if esp_cache[part] then return end

    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.Parent = part

    esp_cache[part] = highlight
end

local function removeESP(part)
    if esp_cache[part] then
        esp_cache[part]:Destroy()
        esp_cache[part] = nil
    end
end



local function UpdateESP()
    local selected = OresDropdown.Value 

    for _, ore in ipairs(oresFolder:GetChildren()) do
        if table.find(selected, ore.Name) then
            createESP(ore, ore.Name)
        else
            removeESP(ore)
        end
    end
end

RunService.RenderStepped:Connect(UpdateESP)



local function UpdateDropdown()
    local newList = {}

    for _, obj in ipairs(oresFolder:GetChildren()) do
        table.insert(newList, obj.Name)
    end

    newList = unique(newList)


    if HttpService:JSONEncode(newList) ~= HttpService:JSONEncode(DropdownValues) then
        DropdownValues = newList
        OresDropdown:Refresh(newList)
        print("Dropdown 已更新: " .. HttpService:JSONEncode(newList))
    end
end

task.spawn(function()
    while task.wait(1) do
        UpdateDropdown()
    end
end)

Tab:Divider()

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local treesFolder = workspace:WaitForChild("WorldSpawn"):WaitForChild("Trees")


local DropdownValues = {}

local esp_cache = {}


local TreesDropdown = Tab:Dropdown({
    Title = "树木选择（ESP 多选）",
    Values = DropdownValues,
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        print("当前已选择树木: " .. HttpService:JSONEncode(option))
    end
})


local function unique(list)
    local set = {}
    local result = {}
    for _, v in ipairs(list) do
        if not set[v] then
            set[v] = true
            table.insert(result, v)
        end
    end
    return result
end



local function createESP(part)
    if esp_cache[part] then return end

    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
    highlight.Parent = part

    esp_cache[part] = highlight
end

local function removeESP(part)
    if esp_cache[part] then
        esp_cache[part]:Destroy()
        esp_cache[part] = nil
    end
end


local function UpdateESP()
    local selected = TreesDropdown.Value 

    for _, tree in ipairs(treesFolder:GetChildren()) do
        if table.find(selected, tree.Name) then
            createESP(tree)
        else
            removeESP(tree)
        end
    end
end

RunService.RenderStepped:Connect(UpdateESP)


local function UpdateDropdown()
    local newList = {}

    for _, obj in ipairs(treesFolder:GetChildren()) do
        table.insert(newList, obj.Name)
    end

    newList = unique(newList)

    if HttpService:JSONEncode(newList) ~= HttpService:JSONEncode(DropdownValues) then
        DropdownValues = newList
        TreesDropdown:Refresh(newList)

        print("Trees 下拉菜单已更新: " .. HttpService:JSONEncode(newList))
    end
end

task.spawn(function()
    while task.wait(1) do
        UpdateDropdown()
    end
end)

local Tab = Window:Tab({
    Title = "工具",
    Icon = "bird", 
    Locked = false,
})


local AttackToggle = Tab:Toggle({
    Title = "攻击开关",           
    Desc = "镐子 斧头 鱼竿",  
    Icon = "sword",                
    Type = "Checkbox",             
    Default = false,               
    Callback = function(state)
        _G.AutoAttack = state   
    end
})

local AlphaSlider = Tab:Slider({
    Title = "攻击伤害",            
    Step = 1,                        
    Value = {
        Min = 1,                     
        Max = 100,                   
        Default = 100,               
    },
    Callback = function(value)
        
        _G.AttackAlpha = value / 100
    end
})


_G.AutoAttack = false
_G.AttackAlpha = 1.0

spawn(function()  
    while true do
        if _G.AutoAttack then
            local args = {
                {
                    Alpha = _G.AttackAlpha,   
                    ResponseTime = 0.01
                }
            }
            
            game:GetService("ReplicatedStorage")
                :WaitForChild("Events")
                :WaitForChild("Tools")
                :WaitForChild("Attack")
                :FireServer(unpack(args))
        end
        wait(0.01)  
    end
end)

Tab:Divider()


local Button = Tab:Button({
    Title = "鱼竿",
    Desc = "抛竿按钮",
    Locked = false,
    Callback = function()
    local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Charge = game:GetService("ReplicatedStorage")
    :WaitForChild("Events")
    :WaitForChild("Tools")
    :WaitForChild("Charge")

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local args = {
    {
        HitPosition = hrp.CFrame
    }
}

Charge:FireServer(unpack(args))
        print("clicked")
    end
})

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local userGui = playerGui:WaitForChild("UserGui")
local catchFrame = userGui:WaitForChild("CatchFrame")
local fishObject = catchFrame:WaitForChild("Fish")

local autoFishing = false
local active = false

local holdingA = false
local holdingD = false
local rotationConnection

local function pressKey(key)
	if key == Enum.KeyCode.A and not holdingA then
		holdingA = true
		VirtualInputManager:SendKeyEvent(true, key, false, game)
	elseif key == Enum.KeyCode.D and not holdingD then
		holdingD = true
		VirtualInputManager:SendKeyEvent(true, key, false, game)
	end
end

local function releaseKey(key)
	if key == Enum.KeyCode.A and holdingA then
		holdingA = false
		VirtualInputManager:SendKeyEvent(false, key, false, game)
	elseif key == Enum.KeyCode.D and holdingD then
		holdingD = false
		VirtualInputManager:SendKeyEvent(false, key, false, game)
	end
end

local function stopAll()
	releaseKey(Enum.KeyCode.A)
	releaseKey(Enum.KeyCode.D)
end

local function updateFishing()
	if not autoFishing or not active then
		stopAll()
		return
	end

	local rot = fishObject.AbsoluteRotation

	if rot == 0 then
		releaseKey(Enum.KeyCode.D)
		pressKey(Enum.KeyCode.A)
	elseif rot == 180 then
		releaseKey(Enum.KeyCode.A)
		pressKey(Enum.KeyCode.D)
	else
		stopAll()
	end
end

local function onRotationChanged()
	updateFishing()
end

catchFrame:GetPropertyChangedSignal("Visible"):Connect(function()
	if catchFrame.Visible then
		active = true

		if not rotationConnection then
			rotationConnection =
				fishObject:GetPropertyChangedSignal("AbsoluteRotation"):Connect(onRotationChanged)
		end

		updateFishing()
	else
		active = false
		stopAll()
	end
end)

local Toggle = Tab:Toggle({
	Title = "自动钓鱼",
	Desc = "开启后请关闭速度",
	Icon = "fish",
	Type = "Checkbox",
	Default = false,
	Callback = function(state)
		autoFishing = state

		if state then
			updateFishing()
		else
			stopAll()
		end
	end
})