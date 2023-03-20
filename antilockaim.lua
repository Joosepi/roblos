-- // Services
local Players = game:GetService("Players")

-- // Vars
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local SilentAimEnabled = false
local FOV = 27
local AccommodationFactor = 0.1474432
local TargetPart = "HumanoidRootPart","Head"
local MovementThreshold = 100 -- increase or decrease this value to adjust sensitivity

-- // Silent Aim Module
local SilentAim = loadstring(game:HttpGet("https://pastebin.com/raw/2f0mGbMP"))()
SilentAim.TeamCheck = false

-- // Metatable vars
local mt = getrawmetatable(game)
local backupindex = mt.__index
setreadonly(mt, false)

-- // Check if player is down
SilentAim.checkSilentAim = function()
    local checkA = (SilentAimEnabled == true and SilentAim.Selected ~= LocalPlayer)
    local playerCharacter = SilentAim.Selected.Character
    local daHood = (playerCharacter.BodyEffects["K.O"].Value == false or playerCharacter:FindFirstChild("GRABBING_CONSTRAINT") ~= nil)

    return (checkA and daHood)
end

-- // Hook
mt.__index = newcclosure(function(t, k)
    if (t:IsA("Mouse") and (k == "Hit")) then
        local CPlayer = SilentAim.Selected
        if (SilentAim.checkSilentAim()) then
            local playerCharacter = CPlayer.Character
            if (playerCharacter:FindFirstChild(TargetPart)) then
                local targetPartPosition = playerCharacter[TargetPart].CFrame.p
                local direction = (targetPartPosition - Mouse.Hit.p).Unit
                local angle = math.acos(direction:Dot(Mouse.UnitRay.Direction))

                if angle <= math.rad(FOV) then
                    local distance = (targetPartPosition - LocalPlayer.Character[TargetPart].Position).Magnitude
                    if (distance > MovementThreshold) then
                        SilentAimEnabled = false
                    else
                        SilentAimEnabled = true
                        if (playerCharacter:FindFirstChild("HumanoidRootPart")) then
                            return {p=(playerCharacter.HumanoidRootPart.CFrame.p+(playerCharacter.HumanoidRootPart.Velocity*AccommodationFactor))}
                        end
                    end
                end
            end
        end
    end
    return backupindex(t, k)
end)

-- // Revert
setreadonly(mt, true)

-- // Keybind
Mouse.KeyDown:Connect(function(key)
    if key == "t" then
        SilentAimEnabled = not SilentAimEnabled
    end
end)
