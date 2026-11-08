-- Rivals Ragebot | Xeno
-- TP + head lock + aggressive 0.02s fire
-- Toggle: Z

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local enabled = true
local toggleKey = Enum.KeyCode.Z
local behindOffset = 2.6
local heightOffset = 0.4
local fireInterval = 0.02

local lastFire = 0
local side = 1
local reloading = false

local function isAlive(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function getClosest()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end

    local myRoot = myChar.HumanoidRootPart
    local closest, closestDist = nil, math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and isAlive(plr.Character) then
            if plr.Team == LocalPlayer.Team and LocalPlayer.Team ~= nil then
                continue
            end

            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            local head = plr.Character:FindFirstChild("Head")
            if root and head then
                local dist = (root.Position - myRoot.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

local function isReloading()
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return false end

    for _, v in ipairs(tool:GetDescendants()) do
        local n = v.Name:lower()
        if v:IsA("BoolValue") and (n:find("reload") or n:find("reloading")) then
            if v.Value == true then return true end
        end
        if (v:IsA("NumberValue") or v:IsA("IntValue")) and n:find("ammo") then
            if v.Value <= 0 then return true end
        end
    end

    local ok, val = pcall(function()
        return tool:GetAttribute("Reloading") or tool:GetAttribute("IsReloading")
    end)
    if ok and val == true then return true end

    return false
end

local function fireOnce()
    -- no yield, pure input spam
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

RunService.Heartbeat:Connect(function()
    if not enabled then return end

    local target = getClosest()
    if not target or not target.Character then return end

    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end

    local enemyRoot = target.Character:FindFirstChild("HumanoidRootPart")
    local enemyHead = target.Character:FindFirstChild("Head")
    if not enemyRoot or not enemyHead then return end

    -- reload side flip
    local currentlyReloading = isReloading()
    if currentlyReloading and not reloading then
        side = -side
        reloading = true
    elseif not currentlyReloading then
        reloading = false
    end

    -- TP
    local offsetZ = behindOffset * side
    myChar.HumanoidRootPart.CFrame = enemyRoot.CFrame * CFrame.new(0, heightOffset, offsetZ)

    -- head lock
    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, enemyHead.Position)

    -- strict 0.02s fire
    local now = tick()
    if now - lastFire >= fireInterval then
        lastFire = now
        fireOnce()
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == toggleKey then
        enabled = not enabled
        print("[Ragebot]", enabled and "ON" or "OFF")
    end
end)

print("[Ragebot] loaded | Z toggle | 0.02s fire | side flip on reload")
