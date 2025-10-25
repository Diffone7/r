local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- Remotes
local BuyItem = ReplicatedStorage.Remotes.BuyItem
local BuyGear = ReplicatedStorage.Remotes.BuyGear
local EquipBest = ReplicatedStorage.Remotes.EquipBest
local BuyRow = ReplicatedStorage.Remotes.BuyRow
local BuyPlatform = ReplicatedStorage.Remotes.BuyPlatform
local Event = ReplicatedStorage.Remotes.MissionServicesRemotes.RequestStartInvasion
-- Constants
local INTERACT_KEY_STRING = "E"
local LocalPlayer = Players.LocalPlayer
local Plots = Workspace.Plots
local GlobalEnv = (typeof(getgenv) == "function" and getgenv()) or _G
local TWEEN_TIME = 1
local TWEEN_INFO = TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
-- State
local isVisible = true

-- Cache frequently accessed paths
local CachedPaths = {
    PlayerPlot = nil,
    LastPlotUpdate = 0,
    ShopFrames = {},
    LastShopUpdate = 0
}

-- Utility: Get stock count from text
local function GetStockCount(stockText)
    local countStr = string.match(stockText, "x(%d+)")
    return countStr and tonumber(countStr) or 0
end

-- Utility: Cache player plot (update every 5 seconds)
local function GetPlayerPlot(forceUpdate)
    local currentTime = tick()
    if not forceUpdate and CachedPaths.PlayerPlot and (currentTime - CachedPaths.LastPlotUpdate) < 5 then
        return CachedPaths.PlayerPlot
    end
    
    local playerName = LocalPlayer.DisplayName
    if not Plots then return nil end

    for _, plot in ipairs(Plots:GetChildren()) do
        if plot:IsA("Model") or plot:IsA("Folder") then
            local success, textLabel = pcall(function()
                return plot.PlayerSign.BillboardGui.TextLabel
            end)
            
            if success and textLabel and textLabel.Text == playerName then
                CachedPaths.PlayerPlot = plot.Name
                CachedPaths.LastPlotUpdate = currentTime
                return plot.Name
            end
        end
    end
    
    return nil
end
        local playerPlot = GetPlayerPlot()
-- Utility: Get shop frame with caching
local function GetShopFrame(shopType)
    local currentTime = tick()
    if CachedPaths.ShopFrames[shopType] and (currentTime - CachedPaths.LastShopUpdate) < 3 then
        return CachedPaths.ShopFrames[shopType]
    end
    
    local success, frame = pcall(function()
        return LocalPlayer.PlayerGui.Main[shopType].Frame.ScrollingFrame
    end)
    
    if success and frame then
        CachedPaths.ShopFrames[shopType] = frame
        CachedPaths.LastShopUpdate = currentTime
        return frame
    end
    
    return nil
end

-- Create window
local Window = Fluent:CreateWindow({
    Title = "Silver",
    SubTitle = "by jrhrbr",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "settings" }),
    Event = Window:AddTab({ Title = "Event", Icon = "settings" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Discord button
Tabs.Main:AddButton({
    Title = "Discord Server",
    Description = "click to copy",
    Callback = function()
        setclipboard("https://discord.gg/DFG4QZHkfK")
        Fluent:Notify({
            Title = "Discord Server",
            Content = "Copied to clipboard.",
            Duration = 5
        })
    end
})
Tabs.Event:AddButton({
    Title = "FPS boost",
    Description = "Not recommended",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Diffone7/r/refs/heads/main/GraphicsTuner/main/dotrblx"))()
end
})
local function delt(objectType)
    local myPlot = GetPlayerPlot()
    if not myPlot then 
        warn("⚠️ Cannot find your plot!")
        return 0 
    end
    
    local count = 0
    local validPlots = {"1", "2", "3", "4", "5", "6"}
    
    for _, plotNumber in ipairs(validPlots) do
        if plotNumber ~= myPlot then
            local plot = Plots:FindFirstChild(plotNumber)
            if plot then
                local folder = plot:FindFirstChild(objectType)
                if folder then
                    pcall(function()
                        for _, obj in ipairs(folder:GetChildren()) do
                            pcall(function() 
                                obj:Destroy() 
                                count = count + 1 
                            end)
                        end
                    end)
                end
            end
        end
    end
    
    return count
end
Tabs.Event:AddButton({
    Title = "Delete others' brainrot (recommended)",
    Description = "Similar to FPS boost but only for brainrot",
    Callback = function()
        delt("Brainrots")
    end
})
Tabs.Event:AddButton({
    Title = "Delete others' plant (recommended)",
    Description = "Similar to FPS boost but only for plants",
    Callback = function()
        delt("Plants")
    end
})
-- Seed dropdown
local SeedDropdown = Tabs.Main:AddDropdown("seed", {
    Title = "Select seed to buy",
    Values = {
        "King Limone Seed", "Mr Carrot Seed", "Carnivorous Plant Seed",
        "Shroombino Seed", "Tomatrio Seed", "Mango Seed", "Cactus Seed",
        "Sunflower Seed", "Dragon fruit Seed", "Strawberry Seed",
        "Eggplant Seed", "Watermelon Seed", "Grape Seed",
        "Cocotank Seed", "Pumpkin Seed"
    },
    Multi = true,
    Default = {"King Limone Seed", "Mr Carrot Seed", "Carnivorous Plant Seed", "Shroombino Seed", "Tomatrio Seed", "Mango Seed"},
})

SeedDropdown:OnChanged(function(Value)
    GlobalEnv.Seed = Value
end)

-- Gear dropdown
local GearDropdown = Tabs.Main:AddDropdown("gear", {
    Title = "Gear to buy",
    Values = {"Water Bucket", "Frost Grenade", "Carrot Launcher", "Banana Gun", "Frost Blower"},
    Multi = true,
    Default = {"Water Bucket", "Frost Grenade", "Frost Blower"},
})

GearDropdown:OnChanged(function(Value)
    GlobalEnv.Gear = Value
end)

-- Auto buy seed toggle (FIXED DUPLICATE ID)
Tabs.Main:AddToggle("autobuyseed_toggle", {
    Title = "Auto buy seed selected",
    Default = true,
    Callback = function(Value)
        GlobalEnv.Seeds = Value
    end
})

-- Auto buy seed loop (OPTIMIZED)
task.spawn(function()
    while task.wait(2) do 
        if not GlobalEnv.Seeds or not GlobalEnv.Seed then continue end
        
        local shopFrame = GetShopFrame("Seeds")
        if not shopFrame then continue end
        
        -- Batch buy items to reduce remote calls
        local itemsToBuy = {}
        
        for itemName, isSelected in pairs(GlobalEnv.Seed) do
            if isSelected then
                local itemUI = shopFrame:FindFirstChild(itemName)
                if itemUI then
                    local stockLabel = itemUI:FindFirstChild("Stock")
                    if stockLabel and stockLabel:IsA("TextLabel") then
                        local stockCount = GetStockCount(stockLabel.Text)
                        if stockCount > 0 then
                            table.insert(itemsToBuy, {name = itemName, count = stockCount})
                        end
                    end
                end
            end
        end
        
        -- Buy items with proper delays
        for _, item in ipairs(itemsToBuy) do
            for i = 1, item.count do
                BuyItem:FireServer(item.name, true)
                task.wait(0.15) 
            end
        end
    end
end)

-- Auto buy gear toggle
Tabs.Main:AddToggle("autobuygear_toggle", {
    Title = "Auto buy gear selected",
    Default = true,
    Callback = function(Value)
        GlobalEnv.Gears = Value
    end
})

-- Auto buy gear loop (OPTIMIZED)
task.spawn(function()
    while task.wait(3) do -- Consistent timing
        if not GlobalEnv.Gears or not GlobalEnv.Gear then continue end
        
        local gearFrame = GetShopFrame("Gears")
        if not gearFrame then continue end
        
        for itemName, isSelected in pairs(GlobalEnv.Gear) do
            if isSelected then
                local itemUI = gearFrame:FindFirstChild(itemName)
                if itemUI then
                    local stockLabel = itemUI:FindFirstChild("Stock")
                    if stockLabel and stockLabel:IsA("TextLabel") then
                        local stockCount = GetStockCount(stockLabel.Text)
                        for i = 1, stockCount do
                            BuyGear:FireServer(itemName, true)
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
    end
end)

-- Auto equip best toggle
Tabs.Main:AddToggle("autoequipt", {
    Title = "Auto equip best brainrot",
    Default = false,
    Callback = function(Value)
        GlobalEnv.equipt = Value
    end
})

-- Time slider
local TimeSlider = Tabs.Main:AddSlider("time", {
    Title = "Time (s)",
    Description = "Second to wait before equip best brainrot again.",
    Default = 60,
    Min = 10,
    Max = 600,
    Rounding = 1,
    Callback = function(Value)
        GlobalEnv.time = Value
    end
})

-- Auto equip loop (OPTIMIZED)
task.spawn(function()
    while task.wait(1) do
        if GlobalEnv.equipt then
            EquipBest:Fire()
            task.wait(GlobalEnv.time or 60)
        end
    end
end)

-- Find platform price plant (OPTIMIZED)
local function FindPlatformPricePlant(plotNumber)
    if not plotNumber then return nil end
    
    local plot = Plots:FindFirstChild(plotNumber)
    if not plot then return nil end
    
    local plantsFolder = plot:FindFirstChild("Plants")
    if not plantsFolder then return nil end

    for _, plant in ipairs(plantsFolder:GetChildren()) do
        local plantNumber = tonumber(plant.Name)
        if plantNumber and plantNumber > 1 and math.floor(plantNumber) == plantNumber then
            if plant:FindFirstChild("PlatformPrice") then
                return plant.Name
            end
        end
    end
    
    return nil
end

-- Auto buy rows toggle
Tabs.Main:AddToggle("autobuyrows", {
    Title = "Auto buy rows",
    Default = false,
    Callback = function(Value)
        GlobalEnv.abc = Value
    end
})

-- Auto buy rows loop (OPTIMIZED)
task.spawn(function()
    while task.wait(5) do
        if not GlobalEnv.abc then continue end
        
        local success, rows = pcall(function()
            return Workspace.Plots[playerPlot].Rows
        end)
        
        if not success or not rows then continue end
        
        -- Buy all rows in one pass
        for i = 2, 7 do
            local rowName = tostring(i)
            local row = rows:FindFirstChild(rowName)
            if row and not row:FindFirstChild("Lawn Mower") then
                BuyRow:FireServer(i)
                task.wait(0.1)
            end
        end
    end
end)

-- Auto buy platforms toggle
Tabs.Main:AddToggle("autobuyplatforms", {
    Title = "Auto buy platforms",
    Default = false,
    Callback = function(Value)
        GlobalEnv.plat = Value
    end
})

-- Auto buy platforms loop (OPTIMIZED with caching)
task.spawn(function()
    while task.wait(2) do
        if not GlobalEnv.plat then continue end
        
        local plantNumber = FindPlatformPricePlant(playerPlot)
        if plantNumber then
            BuyPlatform:FireServer(plantNumber)
            task.wait(0.1)
        end
    end
end)

-- Equip tool function (OPTIMIZED)
local function EquipTool(toolNameFragment)
    local character = LocalPlayer.Character
    local lowerFragment = string.lower(toolNameFragment)
    local matchingTools = {}
    
    -- Combine backpack and character search
    local function searchTools(parent)
        for _, tool in ipairs(parent:GetChildren()) do
            if tool:IsA("Tool") and string.find(string.lower(tool.Name), lowerFragment, 1, true) then
                table.insert(matchingTools, tool)
            end
        end
    end
    
    if LocalPlayer.Backpack then
        searchTools(LocalPlayer.Backpack)
    end
    searchTools(character)
    
    if #matchingTools == 0 then return end
    

    local vInputManager = game:GetService("VirtualInputManager")
    local toolToEquip = matchingTools[math.random(1, #matchingTools)]
    
    toolToEquip.Parent = character
    task.wait(0.1)
    toolToEquip:Activate()
    task.wait(0.1)
    
    vInputManager:SendKeyEvent(true, INTERACT_KEY_STRING, false, game)
    task.wait(0.35)
    vInputManager:SendKeyEvent(false, INTERACT_KEY_STRING, false, game)
    

end

-- Check for tool (OPTIMIZED)
local function CheckForTool(toolNameFragment)
    if not LocalPlayer.Backpack then return false end
    
    local lowerFragment = string.lower(toolNameFragment)
    
    local function hasMatchingTool(parent)
        for _, tool in ipairs(parent:GetChildren()) do
            if tool:IsA("Tool") and string.find(string.lower(tool.Name), lowerFragment, 1, true) then
                return true
            end
        end
        return false
    end
    
    return hasMatchingTool(LocalPlayer.Backpack) or 
           (LocalPlayer.Character and hasMatchingTool(LocalPlayer.Character))
end

-- Auto daily quest toggle
Tabs.Event:AddToggle("autodailyquest", {
    Title = "Auto daily quest",
    Default = false,
    Callback = function(Value)
        GlobalEnv.autodailyquest = Value
    end
})

-- Platform positions (cached)
local PLATFORM_POSITIONS = {
    [-1] = CFrame.new(-221.470734, 14.4373589, 963.78894, 0.0145302061, -3.20977449e-08, 0.99989444, 1.6955525e-08, 1, 3.18547393e-08, -0.99989444, 1.64908798e-08, 0.0145302061),
    [-2] = CFrame.new(-222.26709, 14.437356, 973.853394, -0.0029228921, -4.35246292e-08, 0.999995708, 2.78393379e-08, 1, 4.36061853e-08, -0.999995708, 2.79666743e-08, -0.0029228921),
    [-3] = CFrame.new(-221.931732, 14.437356, 983.577087, 0.0145260086, 9.83009851e-09, 0.9998945, -3.94364275e-09, 1, -9.77384396e-09, -0.9998945, -3.80125176e-09, 0.0145260086),
    [-4] = CFrame.new(-221.90036, 14.437356, 993.992615, -0.36594069, 3.05171817e-08, 0.930638194, 3.58376937e-08, 1, -1.86997635e-08, -0.930638194, 2.65089213e-08, -0.36594069)
}

-- Auto daily quest loop (OPTIMIZED)
task.spawn(function()
    while task.wait(1) do
        if not GlobalEnv.autodailyquest then continue end
        
        local success, eventPlatforms = pcall(function()
            return Workspace.Plots[playerPlot].EventPlatforms
        end)
        
        if not success or not eventPlatforms then continue end
        
        for i = -1, -4, -1 do
            local platform = eventPlatforms:FindFirstChild(tostring(i))
            if not platform then continue end
            
            local platformUI = platform:FindFirstChild("PlatformEventUI")
            if not platformUI then continue end
            
            local titleLabel = platformUI:FindFirstChild("Title")
            if not titleLabel or titleLabel.Text == "" then continue end
            
            -- Check if incomplete
            local success2, rootPart = pcall(function()
                return platform.VisualFolder[titleLabel.Text].RootPart
            end)
            
            if success2 and rootPart and rootPart.Color == Color3.fromRGB(0, 0, 0) then
                if CheckForTool(titleLabel.Text) then
                    local character = LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                            local root = character:FindFirstChild("HumanoidRootPart")
        local originalCFrame = root.CFrame
                        character.HumanoidRootPart.CFrame = PLATFORM_POSITIONS[i]
                        task.wait(0.2)
                        EquipTool(titleLabel.Text)
                        task.wait(0.5)
        root.CFrame = originalCFrame
        task.wait()
                    end
                end
            end
        end
    end
end)

Tabs.Event:AddToggle("autostart_toggle", {
    Title = "Auto start brainrot invasion",
    Default = false,
    Callback = function(Value)
        GlobalEnv.startinv = Value
    end
})

local AttackTimer = {
    Cache = nil,
    LastUpdate = 0,
    ColorHistory = {}, 
    MaxHistory = 5, 
    LastFireTime = 0,
    FireCooldown = 15 
}

function AttackTimer:GetLabel()
    local now = tick()
    
    if self.Cache and self.Cache.Parent and (now - self.LastUpdate) < 3 then
        local success = pcall(function()
            return self.Cache.Text
        end)
        if success then return self.Cache end
        self.Cache = nil
    end
    
    if (now - self.LastUpdate) < 1 then
        return nil
    end
    
    self.LastUpdate = now
    
    local success, label = pcall(function()
        return LocalPlayer.PlayerGui.Main.Right.ImminentAttackTimer.Main.Time
    end)
    
    if success and label then
        self.Cache = label
        return label
    end
    
    return nil
end

function AttackTimer:IsColorChanging()
    if #self.ColorHistory < 3 then
        return false 
    end
    
    for _, color in ipairs(self.ColorHistory) do
        if color.R < 0.95 then
            return false 
        end
    end
    
    local firstColor = self.ColorHistory[1]
    
    for i = 2, #self.ColorHistory do
        local color = self.ColorHistory[i]

        local gDiff = math.abs(color.G - firstColor.G)
        local bDiff = math.abs(color.B - firstColor.B)
        
        if gDiff > 0.01 or bDiff > 0.01 then
            return true
        end
    end
    
    return false
end

function AttackTimer:AddColorToHistory(color)
    table.insert(self.ColorHistory, 1, color)

    if #self.ColorHistory > self.MaxHistory then
        table.remove(self.ColorHistory)
    end
end

task.spawn(function()
    while task.wait(0.2) do 
        if not GlobalEnv.startinv then continue end
        
        local label = AttackTimer:GetLabel()
        
        if label then
            local text = label.Text
            local color = label.TextColor3

            if text ~= "READY!" then
                if #AttackTimer.ColorHistory > 0 then
                    AttackTimer.ColorHistory = {}
                end
                continue
            end

            AttackTimer:AddColorToHistory(color)

            local now = tick()
            if (now - AttackTimer.LastFireTime) < AttackTimer.FireCooldown then
                continue 
            end

            if AttackTimer:IsColorChanging() then
                Event:FireServer()
                AttackTimer.LastFireTime = now
                AttackTimer.ColorHistory = {} 
            end
        else
            if #AttackTimer.ColorHistory > 0 then
                AttackTimer.ColorHistory = {}
            end
        end
    end
end)

local function Cleanup()
    AttackTimer.Cache = nil
    AttackTimer.ColorHistory = {}
end

Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        Cleanup()
    end
end)



--start
Tabs.Event:AddToggle(	"autoclaim"	, {
		Title = "Auto claim exp bottle",
		Default = false ,
		Callback = function(Value)
			GlobalEnv.autoclaim = Value
		end
})

local function AutoInteract()
    local character = LocalPlayer.Character
    local camera = Workspace.CurrentCamera
    
    if not character or not camera then
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    --local originalCFrame = root.CFrame
    root.CFrame = CFrame.new(-180.408737, 15.0893822, 1024.20129, -0.99984771, 5.86564077e-08, 0.0174525231, 5.82762105e-08, 1, -2.22933494e-08, -0.0174525231, -2.12728875e-08, -0.99984771)
    task.wait(0.1)
    local targetCameraCFrame = CFrame.new(root.Position) * CFrame.new(-180.408737, 15.0893822, 1024.20129, -0.99984771, 5.86564077e-08, 0.0174525231, 5.82762105e-08, 1, -2.22933494e-08, -0.0174525231, -2.12728875e-08, -0.99984771).Rotation
    camera.CameraType = Enum.CameraType.Scriptable
    local tween = TweenService:Create(camera, TWEEN_INFO, {CFrame = targetCameraCFrame})
    tween:Play()
    task.wait(TWEEN_TIME)
    camera.CameraType = Enum.CameraType.Custom
    local vInputManager = game:GetService("VirtualInputManager")
    vInputManager:SendKeyEvent(true, INTERACT_KEY_STRING, false, game)
    task.wait(0.1)
    vInputManager:SendKeyEvent(false, INTERACT_KEY_STRING, false, game)
    task.wait(0.1)
    --root.CFrame = originalCFrame
end
--end

task.spawn(function()
    while task.wait(3.5) do
        if Workspace.ScriptedMap.PlantExtractor.PlantExtractor.UI.GUI.Timer.Text == "Ready!" and GlobalEnv.autoclaim == true then
            AutoInteract()
        end
    end
end)



-- Save manager setup
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("Fluent")
SaveManager:SetFolder("Fluent/Fluent")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()

-- Anti-AFK
local VirtualUser = cloneref(game:GetService("VirtualUser"))
Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Auto rejoin on kick
local GuiService = game:GetService("GuiService")
GuiService.ErrorMessageChanged:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

-- Toggle button (CLEANED UP)
local function createTween(obj, info, props, callback)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    if callback then
        tween.Completed:Once(function(state)
            if state == Enum.PlaybackState.Completed then
                callback()
            end
        end)
    end
    return tween
end

local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.136, 0, 0.216, 0)
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Font = Enum.Font.FredokaOne
ToggleButton.Text = "ON"
ToggleButton.TextColor3 = Color3.fromRGB(192, 192, 192)
ToggleButton.TextSize = 18
ToggleButton.Draggable = true

UICorner.Parent = ToggleButton
UICorner.CornerRadius = UDim.new(0, 8)

local currentTween = nil

ToggleButton.MouseEnter:Connect(function()
    if currentTween then currentTween:Cancel() end
    currentTween = createTween(
        ToggleButton,
        TweenInfo.new(0.11, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(65, 65, 65), Size = UDim2.new(0, 47, 0, 47)}
    )
end)

ToggleButton.MouseLeave:Connect(function()
    if currentTween then currentTween:Cancel() end
    currentTween = createTween(
        ToggleButton,
        TweenInfo.new(0.11, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(50, 50, 50), Size = UDim2.new(0, 45, 0, 45)}
    )
end)

ToggleButton.MouseButton1Down:Connect(function()
    if currentTween then currentTween:Cancel() end
    currentTween = createTween(
        ToggleButton,
        TweenInfo.new(0.07, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 43, 0, 43)}
    )
end)

ToggleButton.MouseButton1Up:Connect(function()
    if currentTween then currentTween:Cancel() end
    currentTween = createTween(
        ToggleButton,
        TweenInfo.new(0.09, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 47, 0, 47)}
    )
end)

ToggleButton.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    ToggleButton.Text = isVisible and "ON" or "OFF"
    ToggleButton.TextColor3 = isVisible and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
    Window:Minimize()
end)
