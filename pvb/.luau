
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
-- UI : dawid
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BuyItem = ReplicatedStorage.Remotes.BuyItem 
local BuyGear = ReplicatedStorage.Remotes.BuyGear 
local EquipBest = ReplicatedStorage.Remotes.EquipBest 
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local isVisible = true
local TweenService = game:GetService("TweenService")
local GlobalEnv = (typeof(getgenv) == "function" and getgenv()) or _G

--create window
local Window = Fluent:CreateWindow({
    Title = "Pvb - ",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})
--tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "settings" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
    Tabs.Main:AddButton({ -- discord
        Title = "Discord Server",
        Description = "click to copy",
        Callback = function()
			setclipboard("https://discord.gg/ds7JEaMhkp")
			Fluent:Notify({
				Title = "Discord Server",
				Content = "Copied to clipboard.",
				Duration = 5
			})
        end
    })
    --get stock count from shop
local function GetStockCount(stockText)
    local countStr = string.match(stockText, "x(%d+)")
    if countStr then
        return tonumber(countStr) or 0
    end
    return 0
end
    local Dropdown = Tabs.Main:AddDropdown("seed",{
        Title = "Select seed to buy",
        Values = {"Cactus Seed", "Carnivorous Seed", "Shroombino Seed", "Sunflower Seed", "Tomatrio Seed", "Dragon fruit Seed", "Strawberry Seed", "Eggplant Seed", "Watermelon Seed", "Grape Seed", "Cocotank Seed", "Mr Carrot Seed", "Mango Seed", "Pumpkin Seed"},
        Multi = true,
        Default = {"Cactus Seed"},
    })

    Dropdown:OnChanged(function(Value)
                local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        GlobalEnv.Seed = Value
    end)

    local MultiDropdown = Tabs.Main:AddDropdown("gear",{
        Title = "Gear to buy",
        Values = {"Water Bucket", "Frost Grenade", "Carrot Launcher", "Banana Gun", "Frost Blower"},
        Multi = true,
        Default = {"Water Bucket"},
    })

    MultiDropdown:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
		GlobalEnv.Gear = Value
    end)

Tabs.Main:AddToggle("autobuyseed"	, {
		Title = "Auto buy seed selected",
		Default = false ,
		Callback = function(Value)
			GlobalEnv.Seeds = Value
		end
})

coroutine.wrap(function()
    while true do
        task.wait() 
        if GlobalEnv.Seeds == true and GlobalEnv.Seed then
            local ShopFrames = LocalPlayer.PlayerGui:FindFirstChild("Main")
                        and LocalPlayer.PlayerGui.Main:FindFirstChild("Seeds")
                        and LocalPlayer.PlayerGui.Main.Seeds:FindFirstChild("Frame")
                        and LocalPlayer.PlayerGui.Main.Seeds.Frame:FindFirstChild("ScrollingFrame")
-- check if shop frame exists
            if ShopFrames then
                for itemNames, states in pairs(GlobalEnv.Seed) do -- check all items
                    if states then
                        local itemUIs = ShopFrames:FindFirstChild(itemNames) -- check item selected
                        if itemUIs then
                            local stockTextLabels = itemUIs:FindFirstChild("Stock")
                            if stockTextLabels and stockTextLabels:IsA("TextLabel") then
                                local stockCount = GetStockCount(stockTextLabels.Text)
                            -- buy item if stock available
                                for i = 1, stockCount do
                                    BuyItem:FireServer(itemNames, true)
                                    task.wait(0.05) 
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)()
Tabs.Main:AddToggle("autobuygear"	, {
		Title = "Auto buy gear selected",
		Default = false ,
		Callback = function(Value)
			GlobalEnv.Gears = Value
		end
})

coroutine.wrap(function()
    while true do
        task.wait(2) 
        if GlobalEnv.Gears == true and GlobalEnv.Gear then
            local GearsFrame = LocalPlayer.PlayerGui:FindFirstChild("Main")
                        and LocalPlayer.PlayerGui.Main:FindFirstChild("Gears")
                        and LocalPlayer.PlayerGui.Main.Gears:FindFirstChild("Frame")
                        and LocalPlayer.PlayerGui.Main.Gears.Frame:FindFirstChild("ScrollingFrame")
            
            if GearsFrame then
                for itemName, state in pairs(GlobalEnv.Gear) do
                    if state then
                        local itemUI = GearsFrame:FindFirstChild(itemName)
                        if itemUI then
                            local stockTextLabel = itemUI:FindFirstChild("Stock")

                            if stockTextLabel and stockTextLabel:IsA("TextLabel") then

                                local stockCount = GetStockCount(stockTextLabel.Text)
                                
                                for i = 1, stockCount do
                                    BuyGear:FireServer(itemName, true)
                                    task.wait(0.2) 
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)()
Tabs.Main:AddToggle(	"autoequipt"	, {
		Title = "Auto equip best brainrot",
		Default = false ,
		Callback = function(Value)
			GlobalEnv.equipt = Value
		end
})
    
    local Slider = Tabs.Main:AddSlider("time",{
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

    Slider:OnChanged(function(Value)
        GlobalEnv.time = Value
    end)

coroutine.wrap(function()
    while true do
        wait(0.1)
        if GlobalEnv.equipt == true then
            EquipBest:Fire()
            wait(GlobalEnv.time or 60)
        end
    end
end)()

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("github.com")
SaveManager:SetFolder("github.com/Diffone7")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
        local VirtualUser = cloneref(game:GetService("VirtualUser"))
        Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end) -- anti afk
    local GuiService = game:GetService("GuiService")
    GuiService.ErrorMessageChanged:Connect(function()
        local TeleportService = game:GetService("TeleportService")
        local placeId = game.PlaceId
        TeleportService:Teleport(placeId, LocalPlayer)
    end) -- auto rejoin on kick
    -- toggle button
local function a(b,c,d,e)local f=TweenService:Create(b,c,d)f:Play()if e then local g;g=f.Completed:Connect(function(h)if h==Enum.PlaybackState.Completed then e()g:Disconnect()end end)end;return f end;local i=game:GetService("CoreGui")local j=Instance.new("ScreenGui")local k=Instance.new("TextButton")local l=Instance.new("UICorner")j.Parent=i;j.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;k.Parent=j;k.BackgroundColor3=Color3.fromRGB(50,50,50)k.BorderColor3=Color3.fromRGB(0,0,0)k.BorderSizePixel=0;k.Position=UDim2.new(0.136,0,0.216,0)k.Size=UDim2.new(0,45,0,45)k.Font=Enum.Font.FredokaOne;k.Text="ON"k.TextColor3=Color3.fromRGB(192,192,192)k.TextSize=18.000;k.Draggable=true;l.Parent=k;l.CornerRadius=UDim.new(0,8)local m=nil;local n=nil;k.MouseEnter:Connect(function()if m then m:Cancel()end;m=a(k,TweenInfo.new(0.11,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out),{BackgroundColor3=Color3.fromRGB(65,65,65),Size=UDim2.new(0,47,0,47)})end)k.MouseLeave:Connect(function()if m then m:Cancel()end;m=a(k,TweenInfo.new(0.11,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out),{BackgroundColor3=Color3.fromRGB(50,50,50),Size=UDim2.new(0,45,0,45)})end)k.MouseButton1Down:Connect(function()if n then n:Cancel()end;n=a(k,TweenInfo.new(0.07,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,43,0,43)})end)k.MouseButton1Up:Connect(function()if n then n:Cancel()end;n=a(k,TweenInfo.new(0.09,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,47,0,47)})end)k.MouseButton1Click:Connect(function()isVisible=not isVisible;k.Text=isVisible and"ON"or"OFF"k.TextColor3=isVisible and Color3.fromRGB(120,255,120)or Color3.fromRGB(255,120,120)Window:Minimize()end)
