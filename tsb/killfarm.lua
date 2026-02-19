getgenv().FollowConfig = {
    FlySpeed          = 500,
    FlyAltitude       = 300,
    LandOffsetX       = 0,
    LandOffsetY       = 1.6,
    LandOffsetZ       = 3.9,
    LockOnDistance    = 50,
    SafeModeAltitude  = 300,
    SafeModeTrigger   = 0.2,
    SafeModeKey       = Enum.KeyCode.E,
}

local CFG = getgenv().FollowConfig

local function SafeCloneRef(ref)
    if cloneref then return cloneref(ref) end
    return ref
end

local function SafeCloneFunc(fn)
    if clonefunction then return clonefunction(fn) end
    return fn
end

local function ProtectGui(gui)
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = game:GetService("CoreGui")
    elseif protect_gui then
        protect_gui(gui)
        gui.Parent = game:GetService("CoreGui")
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game:GetService("CoreGui")
    end
end

local Players          = SafeCloneRef(game:GetService("Players"))
local RunService       = SafeCloneRef(game:GetService("RunService"))
local TweenService     = SafeCloneRef(game:GetService("TweenService"))
local UserInputService = SafeCloneRef(game:GetService("UserInputService"))
local LocalPlayer      = Players.LocalPlayer

local task_spawn       = SafeCloneFunc(task.spawn)
local ipairs_fn        = SafeCloneFunc(ipairs)
local pcall_fn         = SafeCloneFunc(pcall)

local target               = nil
local followActive         = false
local travelActive         = false
local heartbeatConnection  = nil
local activeTween          = nil

local safeModeEnabled      = true
local safeModeTriggered    = false
local safeAltitudeBase     = nil

-- ============================================================
-- NOCLIP V3
-- ============================================================
local noclipState      = false
local partCache        = {}
local steppedConn      = nil
local descendantConn   = nil

local function PushPhysicsState(character)
    pcall_fn(function()
        local hum = character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:ChangeState(Enum.HumanoidStateType.Physics)
    end)
end

local function RestorePhysicsState(character)
    pcall_fn(function()
        local hum = character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end)
end

local function RebuildPartCache(character)
    partCache = {}
    if not character then return end

    for _, descendant in ipairs_fn(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            table.insert(partCache, descendant)
        end
    end

    if descendantConn then descendantConn:Disconnect() end
    descendantConn = character.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") then
            table.insert(partCache, descendant)
            if noclipState then
                pcall_fn(function() descendant.CanCollide = false end)
            end
        end
    end)
end

local function ApplyNoclipFrame()
    for i = #partCache, 1, -1 do
        local part = partCache[i]
        if part and part.Parent then
            pcall_fn(function()
                if part.CanCollide then
                    part.CanCollide = false
                end
            end)
        else
            table.remove(partCache, i)
        end
    end
end

local function SetNoclip(state)
    noclipState = state
    local character = LocalPlayer.Character
    if not character then return end

    if state then
        PushPhysicsState(character)

        if steppedConn then steppedConn:Disconnect() end
        steppedConn = RunService.Stepped:Connect(SafeCloneFunc(function()
            if not noclipState then return end
            ApplyNoclipFrame()
        end))
    else
        if steppedConn then
            steppedConn:Disconnect()
            steppedConn = nil
        end

        RestorePhysicsState(character)

        for _, part in ipairs_fn(partCache) do
            if part and part.Parent then
                pcall_fn(function() part.CanCollide = true end)
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    RebuildPartCache(character)
    if noclipState then
        PushPhysicsState(character)
    end
end)

if LocalPlayer.Character then
    RebuildPartCache(LocalPlayer.Character)
end
-- ============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Beta"
ScreenGui.ResetOnSpawn = false
ProtectGui(ScreenGui)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 380)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "Farm Kill"
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "Target: [None Selected]"
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Position = UDim2.new(0, 10, 0, 45)
StatusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
StatusLabel.TextSize = 14
StatusLabel.Parent = MainFrame

local SafeModeLabel = Instance.new("TextLabel")
SafeModeLabel.Text = "Safe Mode [" .. CFG.SafeModeKey.Name .. "]: ON"
SafeModeLabel.Size = UDim2.new(1, -20, 0, 25)
SafeModeLabel.Position = UDim2.new(0, 10, 0, 270)
SafeModeLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
SafeModeLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
SafeModeLabel.TextSize = 14
SafeModeLabel.Parent = MainFrame

local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(1, -20, 0, 150)
PlayerListFrame.Position = UDim2.new(0, 10, 0, 80)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.ScrollBarThickness = 6
PlayerListFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = PlayerListFrame
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 2)

local BtnFollow = Instance.new("TextButton")
BtnFollow.Text = "START (Follow)"
BtnFollow.Size = UDim2.new(0.45, 0, 0, 40)
BtnFollow.Position = UDim2.new(0, 10, 1, -50)
BtnFollow.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
BtnFollow.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnFollow.Font = Enum.Font.SourceSansBold
BtnFollow.TextSize = 16
BtnFollow.Parent = MainFrame

local BtnStop = Instance.new("TextButton")
BtnStop.Text = "STOP"
BtnStop.Size = UDim2.new(0.45, 0, 0, 40)
BtnStop.Position = UDim2.new(1, -10 - (250 * 0.45), 1, -50)
BtnStop.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
BtnStop.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnStop.Font = Enum.Font.SourceSansBold
BtnStop.TextSize = 16
BtnStop.Parent = MainFrame

local BtnRefresh = Instance.new("TextButton")
BtnRefresh.Text = "Refresh List"
BtnRefresh.Size = UDim2.new(1, -20, 0, 25)
BtnRefresh.Position = UDim2.new(0, 10, 0, 235)
BtnRefresh.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
BtnRefresh.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnRefresh.TextSize = 14
BtnRefresh.Parent = MainFrame

UserInputService.InputBegan:Connect(SafeCloneFunc(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == CFG.SafeModeKey then
        safeModeEnabled = not safeModeEnabled
        if safeModeEnabled then
            SafeModeLabel.Text = "Safe Mode [" .. CFG.SafeModeKey.Name .. "]: ON"
            SafeModeLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        else
            SafeModeLabel.Text = "Safe Mode [" .. CFG.SafeModeKey.Name .. "]: OFF"
            SafeModeLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end))

local function RefreshPlayerList()
    for _, child in ipairs_fn(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, player in ipairs_fn(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local entry = Instance.new("TextButton")
            entry.Text = player.Name
            entry.Size = UDim2.new(1, 0, 0, 30)
            entry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            entry.TextColor3 = Color3.fromRGB(220, 220, 220)
            entry.Parent = PlayerListFrame
            entry.MouseButton1Click:Connect(function()
                target = player
                StatusLabel.Text = "Target: " .. player.Name
                for _, btn in ipairs_fn(PlayerListFrame:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    end
                end
                entry.BackgroundColor3 = Color3.fromRGB(0, 120, 210)
            end)
        end
    end
end

RunService.Heartbeat:Connect(SafeCloneFunc(function()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart  = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    local healthCritical = (humanoid.Health <= humanoid.MaxHealth * CFG.SafeModeTrigger) and (humanoid.Health > 0)

    if safeModeEnabled and healthCritical then
        safeModeTriggered = true
        SetNoclip(true)
        StatusLabel.Text = "!!! DANGER: FLYING UP !!!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

        if activeTween then activeTween:Cancel() end

        local escapeCFrame
        if followActive and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = target.Character.HumanoidRootPart
            local safeY = targetRoot.Position.Y + CFG.SafeModeAltitude
            escapeCFrame = CFrame.new(targetRoot.Position.X, safeY, targetRoot.Position.Z) * targetRoot.CFrame.Rotation
            safeAltitudeBase = nil
        else
            if not safeAltitudeBase then safeAltitudeBase = rootPart.Position.Y end
            escapeCFrame = CFrame.new(rootPart.Position.X, safeAltitudeBase + CFG.SafeModeAltitude, rootPart.Position.Z) * rootPart.CFrame.Rotation
        end

        pcall_fn(function()
            character:PivotTo(escapeCFrame)
            rootPart.Velocity    = Vector3.zero
            rootPart.RotVelocity = Vector3.zero
        end)
    else
        if safeModeTriggered then
            safeModeTriggered = false
            safeAltitudeBase  = nil
            StatusLabel.Text = "Safe Mode: Safe / Disabled"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            if not followActive then SetNoclip(false) end
        end
    end
end))

local function ExecuteArcTravel()
    if travelActive then return end
    travelActive = true

    local selfRoot   = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")

    if not selfRoot or not targetRoot then
        travelActive = false
        return
    end

    local function AnimateTween(part, destination)
        if safeModeTriggered or not followActive then return false end

        local dist     = (part.Position - destination.Position).Magnitude
        local duration = math.max(dist / CFG.FlySpeed, 0.05)
        local info     = TweenInfo.new(duration, Enum.EasingStyle.Linear)

        if activeTween then activeTween:Cancel() end
        activeTween = TweenService:Create(part, info, {CFrame = destination})
        activeTween:Play()
        activeTween.Completed:Wait()
        return true
    end

    StatusLabel.Text = "Status: Ascending..."
    local ascendPos   = selfRoot.Position + Vector3.new(0, CFG.FlyAltitude, 0)
    local ascendFrame = CFrame.new(ascendPos) * selfRoot.CFrame.Rotation
    if not AnimateTween(selfRoot, ascendFrame) then travelActive = false return end

    StatusLabel.Text = "Status: Flying to target..."
    targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then travelActive = false return end

    local overheadFrame = CFrame.new(targetRoot.Position.X, ascendPos.Y, targetRoot.Position.Z)
    if not AnimateTween(selfRoot, overheadFrame) then travelActive = false return end

    StatusLabel.Text = "Status: Landing..."
    targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then travelActive = false return end

    local landFrame = targetRoot.CFrame * CFrame.new(CFG.LandOffsetX, CFG.LandOffsetY, CFG.LandOffsetZ)
    if not AnimateTween(selfRoot, landFrame) then travelActive = false return end

    travelActive = false
end

local function StartFollow()
    if not target or not target.Character then
        StatusLabel.Text = "Error: Invalid target!"
        return
    end

    followActive = true
    travelActive = false
    SetNoclip(true)
    StatusLabel.Text = "Status: Starting..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)

    if heartbeatConnection then heartbeatConnection:Disconnect() end

    heartbeatConnection = RunService.Heartbeat:Connect(SafeCloneFunc(function()
        if not followActive or safeModeTriggered then return end

        local selfChar   = LocalPlayer.Character
        local targetChar = target.Character

        if selfChar and targetChar and targetChar:FindFirstChild("HumanoidRootPart") and selfChar:FindFirstChild("HumanoidRootPart") then
            local selfRoot   = selfChar.HumanoidRootPart
            local targetRoot = targetChar.HumanoidRootPart
            local distance   = (selfRoot.Position - targetRoot.Position).Magnitude

            if travelActive then
                pcall_fn(function() selfRoot.Velocity = Vector3.zero end)
                return
            end

            if distance > CFG.LockOnDistance then
                task_spawn(ExecuteArcTravel)
            else
                StatusLabel.Text = "Status: LOCK-ON (Attached)"
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                if activeTween then activeTween:Cancel() end
                local landOffset = CFrame.new(CFG.LandOffsetX, CFG.LandOffsetY, CFG.LandOffsetZ)
                pcall_fn(function()
                    selfChar:PivotTo(targetRoot.CFrame * landOffset)
                    selfRoot.Velocity    = Vector3.zero
                    selfRoot.RotVelocity = Vector3.zero
                end)
            end
        else
            StatusLabel.Text = "Status: Target lost..."
        end
    end))
end

local function StopFollow()
    followActive = false
    travelActive = false
    if heartbeatConnection then heartbeatConnection:Disconnect() end
    if activeTween then activeTween:Cancel() end

    if not safeModeTriggered then
        SetNoclip(false)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall_fn(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end

    StatusLabel.Text = "Status: STOPPED"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
end

BtnFollow.MouseButton1Click:Connect(StartFollow)
BtnStop.MouseButton1Click:Connect(StopFollow)
BtnRefresh.MouseButton1Click:Connect(RefreshPlayerList)

RefreshPlayerList()
Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(RefreshPlayerList)
