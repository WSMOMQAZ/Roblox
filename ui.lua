-- ☆ UI 锁定悬浮窗 ☆

local playerGui = client:WaitForChild("PlayerGui")

-- UI锁定遮罩
local uiLock = Instance.new("ScreenGui")
uiLock.Name = "UILock"
uiLock.ResetOnSpawn = false

local lockFrame = Instance.new("Frame")
lockFrame.Size = UDim2.new(1, 0, 1, 0)
lockFrame.BackgroundColor3 = Color3.new(0, 0, 0)
lockFrame.BackgroundTransparency = 0.5
lockFrame.BorderSizePixel = 0
lockFrame.ZIndex = 1000
lockFrame.Visible = false
lockFrame.Parent = uiLock
uiLock.Parent = playerGui

-- 悬浮窗
local floatGui = Instance.new("ScreenGui")
floatGui.Name = "FloatLockUI"
floatGui.ResetOnSpawn = false
floatGui.Parent = playerGui

local dragFrame = Instance.new("Frame")
dragFrame.Size = UDim2.new(0, 150, 0, 50)
dragFrame.Position = UDim2.new(0.5, -75, 0, 100)
dragFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dragFrame.Active = true
dragFrame.Draggable = true -- 允许拖动
dragFrame.ZIndex = 2000
dragFrame.Parent = floatGui

local lockButton = Instance.new("TextButton")
lockButton.Size = UDim2.new(0.6, 0, 0.6, 0)
lockButton.Position = UDim2.new(0.2, 0, 0.2, 0)
lockButton.Text = "锁定UI"
lockButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
lockButton.TextColor3 = Color3.new(1,1,1)
lockButton.Parent = dragFrame

local locked = false

lockButton.MouseButton1Click:Connect(function()
    locked = not locked
    lockFrame.Visible = locked
    lockButton.Text = locked and "解锁UI" or "锁定UI"
end)