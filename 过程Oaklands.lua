-- // wsomoQaz 制作 - 含10秒过场动画 + 动态GUI出现 //
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local player = game:GetService("Players").LocalPlayer

-- 远程Key存放链接
local keyURL = "https://raw.githubusercontent.com/WSMOMQAZ/Roblox/main/keys.json"

-- // 主容器 //
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeyAuthUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-------------------------------------------------------
-- 🎬 第一阶段：过场动画
-------------------------------------------------------
local Transition = Instance.new("Frame", ScreenGui)
Transition.Size = UDim2.new(1, 0, 1, 0)
Transition.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Transition.BackgroundTransparency = 0

-- Logo文字
local Logo = Instance.new("TextLabel", Transition)
Logo.Size = UDim2.new(1, 0, 1, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "Es hub"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextSize = 60
Logo.Font = Enum.Font.SourceSansBold
Logo.TextTransparency = 1

-- 渐入 Logo
TweenService:Create(Logo, TweenInfo.new(2, Enum.EasingStyle.Sine), {TextTransparency = 0}):Play()
wait(2)

-- 闪光效果
local Flash = Instance.new("Frame", Transition)
Flash.Size = UDim2.new(1, 0, 1, 0)
Flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Flash.BackgroundTransparency = 1
TweenService:Create(Flash, TweenInfo.new(0.5), {BackgroundTransparency = 0.3}):Play()
wait(0.3)
TweenService:Create(Flash, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()

-- 等待剩余过场
wait(6.5)

-- 整体淡出过场
TweenService:Create(Transition, TweenInfo.new(2), {BackgroundTransparency = 1}):Play()
TweenService:Create(Logo, TweenInfo.new(1.5), {TextTransparency = 1}):Play()
wait(2)
Transition:Destroy()

-------------------------------------------------------
-- 🧩 第二阶段：Key 验证GUI
-------------------------------------------------------

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 0, 0, 0)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)
local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(100, 100, 255)

-- 标题
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔑 Key 验证系统"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left

-- 关闭按钮
local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -40, 0, 0)
Close.BackgroundTransparency = 1
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.Font = Enum.Font.SourceSansBold
Close.TextSize = 24

-- 输入框
local Input = Instance.new("TextBox", Frame)
Input.PlaceholderText = "请输入密钥..."
Input.Size = UDim2.new(1, -40, 0, 35)
Input.Position = UDim2.new(0, 20, 0, 60)
Input.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Input.TextColor3 = Color3.new(1,1,1)
Input.Text = ""
Input.Font = Enum.Font.SourceSans
Input.TextSize = 20
Input.ClearTextOnFocus = false
Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

-- 验证按钮
local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(1, -40, 0, 35)
Button.Position = UDim2.new(0, 20, 0, 110)
Button.Text = "验证 Key"
Button.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
Button.TextColor3 = Color3.new(1,1,1)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 20
Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

-- 状态文字
local Status = Instance.new("TextLabel", Frame)
Status.Size = UDim2.new(1, 0, 0, 25)
Status.Position = UDim2.new(0, 0, 1, -25)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.new(1,1,1)
Status.Text = "等待输入 Key..."
Status.Font = Enum.Font.SourceSans
Status.TextSize = 18

-- 关闭动画
Close.MouseButton1Click:Connect(function()
        local tw = TweenService:Create(Frame, TweenInfo.new(0.4), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
        tw:Play()
        wait(0.4)
        ScreenGui:Destroy()
end)

-------------------------------------------------------
-- ✨ GUI 动态出现动画
-------------------------------------------------------
Frame.BackgroundTransparency = 1
Frame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(Frame, TweenInfo.new(1.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 320, 0, 190),
        BackgroundTransparency = 0
}):Play()

-------------------------------------------------------
-- ✅ 验证逻辑
-------------------------------------------------------
Button.MouseButton1Click:Connect(function()
        local userKey = Input.Text
        if userKey == "" then
                Status.Text = "请先输入密钥"
                return
        end

        Status.Text = "正在验证，请稍候..."
        local success, result = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(keyURL))
        end)
        if not success then
                Status.Text = "服务器无响应"
                return
        end

        local keyData = result[userKey]
        if keyData then
                local today = os.date("%Y-%m-%d")
                if today <= keyData.expire then
                        Status.Text = "验证成功！欢迎 " .. keyData.user
                        wait(1)
                        TweenService:Create(Frame, TweenInfo.new(0.6), {BackgroundTransparency = 1, Size = UDim2.new(0,0,0,0)}):Play()
                        wait(0.6)
                        ScreenGui:Destroy()
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/WSMOMQAZ/Roblox/main/%E6%A9%A1%E6%A0%91%E5%9C%B0.lua"))()
                else
                        Status.Text = "密钥已过期"
                end
        else
                Status.Text = "无效的密钥"
        end
end)