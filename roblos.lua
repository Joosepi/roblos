local hotkey = "t" -- toggle key
local mouse = game.Players.LocalPlayer:GetMouse()

mouse.KeyDown:Connect(function(key)
    if key == hotkey then
        getgenv().ValiantAimHacks.SilentAimEnabled = not getgenv().ValiantAimHacks.SilentAimEnabled
    end
end)

-- Services
local Players = game:GetService("Players")

-- Variables
local LocalPlayer = Players.LocalPlayer
local accommodationFactor = 0.12235

-- Silent Aim Module
local SilentAim = loadstring(game:HttpGet("https://pastebin.com/raw/2f0mGbMP"))()
SilentAim.TeamCheck = false

-- Hook function
local hookFunction = function(t, k)
    if t:IsA("Mouse") and k == "Hit" then
        local selectedPlayer = SilentAim.Selected
        if SilentAim.SilentAimEnabled and selectedPlayer ~= LocalPlayer and not selectedPlayer.Character.BodyEffects["K.O"].Value 
            and not selectedPlayer.Character:FindFirstChild("GRABBING_CONSTRAINT") then
            local parts = {...}
            for i, partName in ipairs(parts) do
                local part = selectedPlayer.Character:FindFirstChild(partName)
                if part then
                    local velocity = partName == "Humanoid" and part.RootPart.Velocity or part.Velocity
                    return {p = part.CFrame.p + velocity * accommodationFactor}
                end
            end
        end
    end
    return mt.__index(t, k)
end

-- Metatable vars
local mt = getrawmetatable(game)
local backupIndex = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(hookFunction)
setreadonly(mt, true)

-- Set the FOV
getgenv().ValiantAimHacks.FOV = 24


-- Hook
local hookFunction = function(t, k)
    if t:IsA("Mouse") and k == "Hit" then
        local selectedPlayer = SilentAim.Selected
        if SilentAim.SilentAimEnabled and selectedPlayer ~= LocalPlayer and not selectedPlayer.Character.BodyEffects["K.O"].Value 
            and not selectedPlayer.Character:FindFirstChild("GRABBING_CONSTRAINT") then
            local parts = {"UpperTorso", "HumanoidRootPart"}
            for i, partName in ipairs(parts) do
                local part = selectedPlayer.Character:FindFirstChild(partName)
                if part then
                    local velocity = partName == "Humanoid" and part.RootPart.Velocity or part.Velocity
                    return {p = part.CFrame.p + velocity * accommodationFactor}
                end
            end
        end
    end
    return mt.__index(t, k)
end
