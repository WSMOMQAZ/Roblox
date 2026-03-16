local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

while task.wait(0.01) do

    local x = math.random(-2000,2000)
    local z = math.random(-2000,2000)

    hrp.CFrame = CFrame.new(x,120,z)

end