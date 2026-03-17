for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if string.find(v.Name:lower(), "coru") then
        v:Destroy()
    end
end