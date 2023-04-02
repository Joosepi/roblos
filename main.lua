local hotkey = "t" -- toggle key
local mouse = game.Players.LocalPlayer:GetMouse()

mouse.KeyDown:Connect(function(key)
    if key == hotkey then
        if getgenv().ValiantAimHacks.SilentAimEnabled == true then
            getgenv().ValiantAimHacks.SilentAimEnabled = false
        else
            getgenv().ValiantAimHacks.SilentAimEnabled = true
        end
    end
end)

-- // Services
local Players = game:GetService("Players")

-- // Vars
local LocalPlayer = Players.LocalPlayer
local accommodationFactor = 0.1474432
local targetPart = {"HumanoidRootPart", "Head"}

-- // Silent Aim Module
local SilentAim = loadstring(game:HttpGet("https://pastebin.com/raw/2f0mGbMP"))()
SilentAim.TeamCheck = false

-- // Metatable vars
local mt = getrawmetatable(game)
local backupindex = mt.__index
setreadonly(mt, false)

-- // Check if player is down
SilentAim.checkSilentAim = function()
    local checkA = (SilentAim.SilentAimEnabled == true and SilentAim.Selected ~= LocalPlayer)
    local playerCharacter = SilentAim.Selected.Character
    local daHood = (playerCharacter.BodyEffects["K.O"].Value == false or playerCharacter:FindFirstChild("GRABBING_CONSTRAINT") ~= nil)

    return (checkA and daHood)
end

-- // Hook
mt.__index = newcclosure(function(t, k)
    if (t:IsA("Mouse") and (k == "Hit")) then
        print(t, k)
        local CPlayer = SilentAim.Selected
        if (SilentAim.checkSilentAim()) then
            for i, partName in ipairs(targetPart) do
                if (CPlayer.Character:FindFirstChild(partName)) then
                    return {p=(CPlayer.Character[partName].CFrame.p+(CPlayer.Character[partName].Velocity*accommodationFactor))}
                end
            end
        end
    end
    return backupindex(t, k)
end)

-- // Revert
setreadonly(mt, true)
getgenv().ValiantAimHacks.FOV = 24

