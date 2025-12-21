-- VIP ESP Script - Simple Version
local Config = {
    EnableESP = true,
    ShowTeam = true,
    ShowName = true,
    ShowDistance = true,
    ShowHealth = true,
    ShowBox = true,
    ShowTracer = true,
    ShowHeadDot = true,
    EnemyColor = Color3.fromRGB(255, 0, 0),
    AllyColor = Color3.fromRGB(0, 255, 0),
    MaxDistance = 200,
    ESPOpacity = 0.8
}

local ESP = {Objects = {}, Enabled = Config.EnableESP}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Fungsi untuk membuat UI sederhana
local function CreateSimpleUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VIP_ESP_UI"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.fromRGB(0, 120, 255)
    MainFrame.Parent = ScreenGui
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(0, 60, 120)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "VIP ESP CONFIG"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Header
    
    -- Container untuk toggles
    local ToggleContainer = Instance.new("ScrollingFrame")
    ToggleContainer.Size = UDim2.new(1, -20, 1, -100)
    ToggleContainer.Position = UDim2.new(0, 10, 0, 50)
    ToggleContainer.BackgroundTransparency = 1
    ToggleContainer.ScrollBarThickness = 5
    ToggleContainer.Parent = MainFrame
    
    local ToggleList = Instance.new("UIListLayout")
    ToggleList.Padding = UDim.new(0, 5)
    ToggleList.Parent = ToggleContainer
    
    -- Fungsi untuk membuat toggle
    local function CreateToggle(name, configKey, defaultValue)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        ToggleFrame.BorderSizePixel = 1
        ToggleFrame.BorderColor3 = Color3.fromRGB(60, 60, 70)
        ToggleFrame.Parent = ToggleContainer
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        ToggleLabel.TextSize = 14
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 50, 0, 25)
        ToggleButton.Position = UDim2.new(0.85, -25, 0.5, -12.5)
        ToggleButton.Text = Config[configKey] and "ON" or "OFF"
        ToggleButton.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.Parent = ToggleFrame
        
        ToggleButton.MouseButton1Click:Connect(function()
            Config[configKey] = not Config[configKey]
            ToggleButton.Text = Config[configKey] and "ON" or "OFF"
            ToggleButton.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
            
            if configKey == "EnableESP" then
                ESP.Enabled = Config.EnableESP
            end
        end)
    end
    
    -- Buat semua toggles
    local Toggles = {
        {"Enable ESP", "EnableESP"},
        {"Show Team", "ShowTeam"},
        {"Show Name", "ShowName"},
        {"Show Distance", "ShowDistance"},
        {"Show Health", "ShowHealth"},
        {"Show Box", "ShowBox"},
        {"Show Tracer", "ShowTracer"},
        {"Show Head Dot", "ShowHeadDot"}
    }
    
    for _, toggle in ipairs(Toggles) do
        CreateToggle(toggle[1], toggle[2])
    end
    
    -- Tombol Close
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0.8, 0, 0, 35)
    CloseButton.Position = UDim2.new(0.1, 0, 0.9, -35)
    CloseButton.Text = "CLOSE UI"
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = MainFrame
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    return ScreenGui
end

-- Fungsi ESP (sama seperti versi lengkap)
local function CreateESPBox(player)
    -- Implementasi ESP seperti di versi lengkap
    -- ...
end

local function UpdateESP()
    -- Implementasi update ESP seperti di versi lengkap
    -- ...
end

-- Hotkeys
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        Config.EnableESP = not Config.EnableESP
        ESP.Enabled = Config.EnableESP
    end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        CreateSimpleUI()
    end
    
    if input.KeyCode == Enum.KeyCode.End then
        -- Cleanup
        for player, objects in pairs(ESP.Objects) do
            for _, obj in pairs(objects) do
                if obj then obj:Destroy() end
            end
        end
        ESP.Objects = {}
        ESP.Enabled = false
        print("VIP ESP Unloaded")
    end
end)

-- Loop update
RunService.RenderStepped:Connect(UpdateESP)

print("VIP ESP Script Loaded!")
print("Hotkeys: F1 (Toggle ESP), Insert (Open UI), End (Unload)")
