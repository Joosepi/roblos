local hotkey = "t" -- toggle key
local mouse = game.Players.LocalPlayer:GetMouse()

-- // Services
local Players = game:GetService("Players")

-- // Vars
local LocalPlayer = Players.LocalPlayer
local SilentAimEnabled = true
local TargetPart = "Head", "HumanoidRootPart",
local AccommodationFactor = 0.14333
local FOV = 30

-- // Silent Aim Module
local SilentAim = loadstring(game:HttpGet("https://pastebin.com/raw/2f0mGbMP"))()
SilentAim.TeamCheck = false

-- // Check if player is down
local function checkSilentAim()
    local checkA = SilentAimEnabled and SilentAim.Selected ~= LocalPlayer
    local playerCharacter = SilentAim.Selected.Character
    local daHood = (playerCharacter.BodyEffects["K.O"].Value == false or playerCharacter:FindFirstChild("GRABBING_CONSTRAINT") ~= nil)
    return checkA and daHood
end

-- // Hook
local mt = getrawmetatable(game)
local backupIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if t:IsA("Mouse") and k == "Hit" then
        local CPlayer = SilentAim.Selected
        if checkSilentAim() and CPlayer.Character and CPlayer.Character:FindFirstChild(TargetPart) then
            local TargetCFrame = CPlayer.Character[TargetPart].CFrame
            local TargetVelocity = CPlayer.Character[TargetPart].Velocity
            local AimPosition = TargetCFrame.p + TargetVelocity * AccommodationFactor
            local CurrentPosition = LocalPlayer.Character.Head.Position
            local Distance = (AimPosition - CurrentPosition).magnitude

            if Distance <= FOV then
                return {p = AimPosition}
            end
        end
    end
    return backupIndex(t, k)
end)

-- // Revert
setreadonly(mt, true)

-- // Toggle Silent Aim
mouse.KeyDown:Connect(function(key)
    if key == hotkey then
        SilentAimEnabled = not SilentAimEnabled
    end
end)
