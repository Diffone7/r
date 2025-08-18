local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ntmc0987se/r/refs/heads/main/a"))()

-- Check if the library was loaded successfully
if not redzlib then
    warn("redzlib library failed to load! Please check the URL in HttpGet.")
    return
end

-- Create the main window
local Window = redzlib:MakeWindow({
  Title = "redz Hub : Blox Fruits",
  SubTitle = "by redz9999",
  SaveFolder = "redz_lib_v5_save.json" -- Use a valid filename for saving
})

-- Create Tabs
local Tab1 = Window:MakeTab({Title = "UI Settings", Icon = "palette"})
local Tab2 = Window:MakeTab({Title = "Main Functions", Icon = "swords"})
local Tab3 = Window:MakeTab({Title = "Misc", Icon = "info"})

-- Tab 1: Theme changing buttons
Tab1:AddButton({Title = "Dark Theme", function()
  redzlib:SetTheme("Dark")
end})

Tab1:AddButton({Title = "Dark+ Theme", function()
  redzlib:SetTheme("Dark +") 
end})

Tab1:AddButton({Title = "Purple Theme", function()
  redzlib:SetTheme("Purple")
end})

-- Select Tab 2 by default when the UI opens
Window:SelectTab(Tab2)

-- Add components to Tab 2
local Section = Tab2:AddSection({Title = "Main Section"})
local Paragraph = Tab2:AddParagraph({Title = "Notification", Text = "This is a paragraph.\nSecond line."})

local Number = 0
local ButtonCounter = Tab2:AddButton({Title = "Counter Button", Description = "Press to increase the number and show a dialog.", function()
  Number = Number + 1
  Section:Set("Button presses: " .. tostring(Number))
  
  Window:Dialog({
    Title = "Dialog",
    Text = "You just pressed the counter button!",
    Options = {
      {"Confirm", function() print("Confirmed!") end},
      {"Cancel", function() print("Cancelled.") end}
    }
  })
end})

-- Button to hide/show the Toggles
local InvisibleButton = Tab2:AddButton({
  Name = "Hide/Show Toggles",
  Description = "Makes the Toggles below invisible or visible."
})

local Toggle1 = Tab2:AddToggle({
  Name = "Toggle 1",
  Description = "This is a <font color='rgb(88, 101, 242)'>Toggle</font> example",
  Default = false
})

local Toggle2 = Tab2:AddToggle({
  Name = "Toggle 2",
  Default = true
})

local togglesAreVisible = true
InvisibleButton:Callback(function()
    togglesAreVisible = not togglesAreVisible
    Toggle1:Visible(togglesAreVisible)
    Toggle2:Visible(togglesAreVisible)
end)

-- Callback to make the two toggles mutually exclusive
Toggle1:Callback(function(Value)
  if Value then Toggle2:Set(false) end
end)

Toggle2:Callback(function(Value)
  if Value then Toggle1:Set(false) end
end)

-- Add a Slider
Tab2:AddSlider({
  Name = "Slider",
  Min = 1,
  Max = 10,
  Increase = 1,
  Default = 5,
  Callback = function(Value)
    print("Slider value:", Value)
  end
})

-- Add a Dropdown with the fixed multi-select feature
local Dropdown = Tab2:AddDropdown({
  Name = "Player List",
  Description = "Select one or more <font color='rgb(88, 101, 242)'>players</font>",
  Options = {"Player1", "Player2", "Player3", "Player4"},
  Default = {"Player2", "Player4"}, -- Default can be a table
  Flag = "player_dropdown",
  MultSelected = true, -- ENABLE MULTI-SELECT FEATURE
  Callback = function(selectedPlayers)
    -- When MultSelected is true, the callback returns a table
    if type(selectedPlayers) == "table" then
        print("Selected players: " .. table.concat(selectedPlayers, ", "))
    else
        -- This case won't happen if MultSelected is true, but it's here for safety
        print("Selected (single mode):", selectedPlayers)
    end
  end
})
