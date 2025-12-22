-- Find The Brainrot UI Script
-- By DeepSeek Assistant
-- Support Universal: Windows & Android

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Key System
local WYKEY = "WYKEY_k9X63kbHegHSS6ovuU9F"
local isKeyActivated = false

-- Tools Variables
local noclip = false
local noclipConnection
local infJumpEnabled = false
local tpToolEnabled = false
local tpTool

-- Cari workspace Brainrots
local function findBrainrots()
    local brainrots = {}
    
    -- Cari di workspace utama
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("brainrot") then
            table.insert(brainrots, obj)
        end
    end
    
    -- Cari di folder khusus jika ada
    if workspace:FindFirstChild("Brainrots") then
        for _, obj in pairs(workspace.Brainrots:GetDescendants()) do
            if obj:IsA("BasePart") then
                table.insert(brainrots, obj)
            end
        end
    end
    
    print("Found " .. #brainrots .. " brainrots")
    return brainrots
end

-- Fungsi teleport ke brainrot
local function teleportToBrainrot(part)
    if part and part:IsA("BasePart") then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 5, 0)
        end
    end
end

-- Teleport ke semua brainrot secara berurutan
local function teleportToAllBrainrots()
    local brainrots = findBrainrots()
    if #brainrots == 0 then
        warn("No brainrots found!")
        return
    end
    
    for i, brainrot in ipairs(brainrots) do
        teleportToBrainrot(brainrot)
        wait(1) -- Tunggu 1 detik antara teleport
    end
end

-- ============================================
-- TOOLS FUNCTIONS
-- ============================================

-- Infinite Jump Function
local function toggleInfiniteJump()
    infJumpEnabled = not infJumpEnabled
    
    if infJumpEnabled then
        print("Infinite Jump: ON")
        local conn
        conn = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
        return conn
    else
        print("Infinite Jump: OFF")
        return nil
    end
end

-- Noclip Function
local function toggleNoclip()
    noclip = not noclip
    
    if noclip then
        print("Noclip: ON")
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        print("Noclip: OFF")
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        -- Reset collision
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- TpTool Function (Similar to Infinite Yield)
local function toggleTpTool()
    tpToolEnabled = not tpToolEnabled
    
    if tpToolEnabled then
        print("TpTool: ON")
        
        -- Create TpTool
        tpTool = Instance.new("Tool")
        tpTool.Name = "TpTool"
        tpTool.RequiresHandle = false
        tpTool.CanBeDropped = false
        
        -- Tool icon
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(4, 0, 4, 0)
        billboard.Adornee = tpTool
        billboard.Parent = tpTool
        
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(1, 0, 1, 0)
        icon.Image = "rbxassetid://13337298324"
        icon.BackgroundTransparency = 1
        icon.Parent = billboard
        
        -- Tool functionality
        tpTool.Activated:Connect(function()
            local target = Mouse.Target
            local hit = Mouse.Hit
            
            if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(hit.p) + Vector3.new(0, 3, 0)
            end
        end)
        
        tpTool.Equipped:Connect(function()
            print("TpTool equipped - Click to teleport")
        end)
        
        tpTool.Parent = LocalPlayer.Backpack
        
        -- Equip the tool
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:EquipTool(tpTool)
            end
        end
    else
        print("TpTool: OFF")
        if tpTool then
            tpTool:Destroy()
            tpTool = nil
        end
    end
end

-- Key Activation Function
local function activateKey(inputKey)
    if inputKey == WYKEY then
        isKeyActivated = true
        print("✅ Key activated successfully!")
        return true
    else
        print("❌ Invalid key!")
        return false
    end
end

-- ============================================
-- UI CREATION
-- ============================================

-- Buat ScreenGui utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotFinderUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Buat frame utama window
local mainFrame = Instance.new("Frame")
mainFrame.Name = "BrainrotWindow"
mainFrame.Size = UDim2.new(0, 400, 0, 450) -- Increased size for new tab
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- Corner rounding
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Shadow effect
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = -1
shadow.Parent = mainFrame

-- ============================================
-- HEADER WITH TITLE AND MINIMIZE BUTTON
-- ============================================

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header

-- Title dengan font code
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Find The Brainrot"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.Code
title.TextXAlignment = Enum.TextXAlignment.Left

-- Tambahkan icon brainrot kecil di samping title
local titleIcon = Instance.new("ImageLabel")
titleIcon.Name = "TitleIcon"
titleIcon.Size = UDim2.new(0, 24, 0, 24)
titleIcon.Position = UDim2.new(0, 10, 0.5, -12)
titleIcon.BackgroundTransparency = 1
titleIcon.Image = "rbxassetid://13337298324"
titleIcon.ImageColor3 = Color3.fromRGB(100, 200, 255)

-- Minimize button
local minimizeButton = Instance.new("ImageButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -40, 0.5, -15)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
minimizeButton.AutoButtonColor = false

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

local minimizeIcon = Instance.new("ImageLabel")
minimizeIcon.Name = "MinimizeIcon"
minimizeIcon.Size = UDim2.new(0, 16, 0, 16)
minimizeIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
minimizeIcon.BackgroundTransparency = 1
minimizeIcon.Image = "rbxassetid://13337301954"
minimizeIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)

-- Close button
local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -80, 0.5, -15)
closeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
closeButton.AutoButtonColor = false

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

local closeIcon = Instance.new("ImageLabel")
closeIcon.Name = "CloseIcon"
closeIcon.Size = UDim2.new(0, 16, 0, 16)
closeIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
closeIcon.BackgroundTransparency = 1
closeIcon.Image = "rbxassetid://13337301954"
closeIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)

-- ============================================
-- TAB SYSTEM (NOW WITH TOOLS TAB)
-- ============================================

local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, -20, 0, 30)
tabContainer.Position = UDim2.new(0, 10, 0, 50)
tabContainer.BackgroundTransparency = 1

-- Tab 1: Teleport
local teleportTab = Instance.new("TextButton")
teleportTab.Name = "TeleportTab"
teleportTab.Size = UDim2.new(0, 90, 1, 0) -- Smaller for 3 tabs
teleportTab.Position = UDim2.new(0, 0, 0, 0)
teleportTab.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
teleportTab.Text = "Teleport"
teleportTab.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportTab.TextSize = 14
teleportTab.Font = Enum.Font.Code
teleportTab.AutoButtonColor = false

local teleportTabCorner = Instance.new("UICorner")
teleportTabCorner.CornerRadius = UDim.new(0, 6)
teleportTabCorner.Parent = teleportTab

-- Tab 2: Tools
local toolsTab = Instance.new("TextButton")
toolsTab.Name = "ToolsTab"
toolsTab.Size = UDim2.new(0, 90, 1, 0)
toolsTab.Position = UDim2.new(0, 95, 0, 0)
toolsTab.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
toolsTab.Text = "Tools"
toolsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
toolsTab.TextSize = 14
toolsTab.Font = Enum.Font.Code
toolsTab.AutoButtonColor = false

local toolsTabCorner = Instance.new("UICorner")
toolsTabCorner.CornerRadius = UDim.new(0, 6)
toolsTabCorner.Parent = toolsTab

-- Tab 3: Settings
local settingsTab = Instance.new("TextButton")
settingsTab.Name = "SettingsTab"
settingsTab.Size = UDim2.new(0, 90, 1, 0)
settingsTab.Position = UDim2.new(0, 190, 0, 0)
settingsTab.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
settingsTab.Text = "Settings"
settingsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsTab.TextSize = 14
settingsTab.Font = Enum.Font.Code
settingsTab.AutoButtonColor = false

local settingsTabCorner = Instance.new("UICorner")
settingsTabCorner.CornerRadius = UDim.new(0, 6)
settingsTabCorner.Parent = settingsTab

-- ============================================
-- CONTENT AREA
-- ============================================

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -100)
contentFrame.Position = UDim2.new(0, 10, 0, 90)
contentFrame.BackgroundTransparency = 1

-- Teleport content
local teleportContent = Instance.new("ScrollingFrame")
teleportContent.Name = "TeleportContent"
teleportContent.Size = UDim2.new(1, 0, 1, 0)
teleportContent.BackgroundTransparency = 1
teleportContent.ScrollBarThickness = 4
teleportContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
teleportContent.Visible = true

local teleportListLayout = Instance.new("UIListLayout")
teleportListLayout.Padding = UDim.new(0, 5)
teleportListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Tools content
local toolsContent = Instance.new("ScrollingFrame")
toolsContent.Name = "ToolsContent"
toolsContent.Size = UDim2.new(1, 0, 1, 0)
toolsContent.BackgroundTransparency = 1
toolsContent.ScrollBarThickness = 4
toolsContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
toolsContent.Visible = false

local toolsListLayout = Instance.new("UIListLayout")
toolsListLayout.Padding = UDim.new(0, 5)
toolsListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Settings content
local settingsContent = Instance.new("Frame")
settingsContent.Name = "SettingsContent"
settingsContent.Size = UDim2.new(1, 0, 1, 0)
settingsContent.BackgroundTransparency = 1
settingsContent.Visible = false

-- ============================================
-- KEY ACTIVATION UI
-- ============================================

local keyFrame = Instance.new("Frame")
keyFrame.Name = "KeyFrame"
keyFrame.Size = UDim2.new(1, -40, 0, 120)
keyFrame.Position = UDim2.new(0, 20, 0, 10)
keyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
keyFrame.BorderSizePixel = 0

local keyFrameCorner = Instance.new("UICorner")
keyFrameCorner.CornerRadius = UDim.new(0, 8)
keyFrameCorner.Parent = keyFrame

local keyTitle = Instance.new("TextLabel")
keyTitle.Name = "KeyTitle"
keyTitle.Size = UDim2.new(1, 0, 0, 30)
keyTitle.Position = UDim2.new(0, 0, 0, 0)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "🔑 Activation Key Required"
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.TextSize = 16
keyTitle.Font = Enum.Font.Code
keyTitle.TextXAlignment = Enum.TextXAlignment.Center

local keyInputBox = Instance.new("TextBox")
keyInputBox.Name = "KeyInputBox"
keyInputBox.Size = UDim2.new(1, -20, 0, 35)
keyInputBox.Position = UDim2.new(0, 10, 0, 40)
keyInputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
keyInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInputBox.Text = ""
keyInputBox.PlaceholderText = "Enter your key here..."
keyInputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
keyInputBox.TextSize = 14
keyInputBox.Font = Enum.Font.Code
keyInputBox.ClearTextOnFocus = false

local keyInputCorner = Instance.new("UICorner")
keyInputCorner.CornerRadius = UDim.new(0, 6)
keyInputCorner.Parent = keyInputBox

local activateButton = Instance.new("TextButton")
activateButton.Name = "ActivateButton"
activateButton.Size = UDim2.new(1, -20, 0, 35)
activateButton.Position = UDim2.new(0, 10, 0, 85)
activateButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
activateButton.Text = "Activate"
activateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
activateButton.TextSize = 14
activateButton.Font = Enum.Font.Code
activateButton.AutoButtonColor = false

local activateCorner = Instance.new("UICorner")
activateCorner.CornerRadius = UDim.new(0, 6)
activateCorner.Parent = activateButton

-- ============================================
-- TELEPORT BUTTONS
-- ============================================

-- Button untuk teleport ke semua brainrot
local teleportAllButton = Instance.new("TextButton")
teleportAllButton.Name = "TeleportAllButton"
teleportAllButton.Size = UDim2.new(1, 0, 0, 50)
teleportAllButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
teleportAllButton.Text = "Teleport to All Brainrots"
teleportAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportAllButton.TextSize = 16
teleportAllButton.Font = Enum.Font.Code
teleportAllButton.AutoButtonColor = false

local teleportAllCorner = Instance.new("UICorner")
teleportAllCorner.CornerRadius = UDim.new(0, 8)
teleportAllCorner.Parent = teleportAllButton

local teleportAllIcon = Instance.new("ImageLabel")
teleportAllIcon.Name = "TeleportAllIcon"
teleportAllIcon.Size = UDim2.new(0, 24, 0, 24)
teleportAllIcon.Position = UDim2.new(0, 10, 0.5, -12)
teleportAllIcon.BackgroundTransparency = 1
teleportAllIcon.Image = "rbxassetid://13337298324"
teleportAllIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)

-- Button untuk refresh brainrot list
local refreshButton = Instance.new("TextButton")
refreshButton.Name = "RefreshButton"
refreshButton.Size = UDim2.new(1, 0, 0, 50)
refreshButton.Position = UDim2.new(0, 0, 0, 60)
refreshButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
refreshButton.Text = "Refresh Brainrot List"
refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshButton.TextSize = 16
refreshButton.Font = Enum.Font.Code
refreshButton.AutoButtonColor = false

local refreshCorner = Instance.new("UICorner")
refreshCorner.CornerRadius = UDim.new(0, 8)
refreshCorner.Parent = refreshButton

-- Area untuk daftar brainrot individu
local brainrotList = Instance.new("Frame")
brainrotList.Name = "BrainrotList"
brainrotList.Size = UDim2.new(1, 0, 0, 200)
brainrotList.Position = UDim2.new(0, 0, 0, 120)
brainrotList.BackgroundTransparency = 1

local brainrotListLayout = Instance.new("UIListLayout")
brainrotListLayout.Padding = UDim.new(0, 5)
brainrotListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================
-- TOOLS CONTROLS
-- ============================================

-- Infinite Jump Toggle
local infJumpToggle = Instance.new("TextButton")
infJumpToggle.Name = "InfJumpToggle"
infJumpToggle.Size = UDim2.new(1, 0, 0, 50)
infJumpToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
infJumpToggle.Text = "Infinite Jump: OFF"
infJumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
infJumpToggle.TextSize = 16
infJumpToggle.Font = Enum.Font.Code
infJumpToggle.AutoButtonColor = false

local infJumpCorner = Instance.new("UICorner")
infJumpCorner.CornerRadius = UDim.new(0, 8)
infJumpCorner.Parent = infJumpToggle

local infJumpIcon = Instance.new("ImageLabel")
infJumpIcon.Name = "InfJumpIcon"
infJumpIcon.Size = UDim2.new(0, 24, 0, 24)
infJumpIcon.Position = UDim2.new(0, 10, 0.5, -12)
infJumpIcon.BackgroundTransparency = 1
infJumpIcon.Image = "rbxassetid://13337301956" -- Jump icon
infJumpIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)

-- Noclip Toggle
local noclipToggle = Instance.new("TextButton")
noclipToggle.Name = "NoclipToggle"
noclipToggle.Size = UDim2.new(1, 0, 0, 50)
noclipToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
noclipToggle.Text = "Noclip: OFF"
noclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipToggle.TextSize = 16
noclipToggle.Font = Enum.Font.Code
noclipToggle.AutoButtonColor = false

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 8)
noclipCorner.Parent = noclipToggle

local noclipIcon = Instance.new("ImageLabel")
noclipIcon.Name = "NoclipIcon"
noclipIcon.Size = UDim2.new(0, 24, 0, 24)
noclipIcon.Position = UDim2.new(0, 10, 0.5, -12)
noclipIcon.BackgroundTransparency = 1
noclipIcon.Image = "rbxassetid://13337301957" -- Ghost/NoClip icon
noclipIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)

-- TpTool Toggle
local tpToolToggle = Instance.new("TextButton")
tpToolToggle.Name = "TpToolToggle"
tpToolToggle.Size = UDim2.new(1, 0, 0, 50)
tpToolToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
tpToolToggle.Text = "TpTool: OFF"
tpToolToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
tpToolToggle.TextSize = 16
tpToolToggle.Font = Enum.Font.Code
tpToolToggle.AutoButtonColor = false

local tpToolCorner = Instance.new("UICorner")
tpToolCorner.CornerRadius = UDim.new(0, 8)
tpToolCorner.Parent = tpToolToggle

local tpToolIcon = Instance.new("ImageLabel")
tpToolIcon.Name = "TpToolIcon"
tpToolIcon.Size = UDim2.new(0, 24, 0, 24)
tpToolIcon.Position = UDim2.new(0, 10, 0.5, -12)
tpToolIcon.BackgroundTransparency = 1
tpToolIcon.Image = "rbxassetid://13337298324" -- Teleport icon
tpToolIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)

-- Tools Instructions
local toolsInstructions = Instance.new("TextLabel")
toolsInstructions.Name = "ToolsInstructions"
toolsInstructions.Size = UDim2.new(1, 0, 0, 80)
toolsInstructions.BackgroundTransparency = 1
toolsInstructions.Text = "📋 Instructions:\n• Inf Jump: Press space to jump infinitely\n• Noclip: Walk through walls\n• TpTool: Click where you want to teleport"
toolsInstructions.TextColor3 = Color3.fromRGB(200, 200, 200)
toolsInstructions.TextSize = 12
toolsInstructions.Font = Enum.Font.Code
toolsInstructions.TextXAlignment = Enum.TextXAlignment.Left
toolsInstructions.TextYAlignment = Enum.TextYAlignment.Top
toolsInstructions.TextWrapped = true

-- ============================================
-- SETTINGS CONTROLS
-- ============================================

local uiScaleLabel = Instance.new("TextLabel")
uiScaleLabel.Name = "UIScaleLabel"
uiScaleLabel.Size = UDim2.new(1, 0, 0, 30)
uiScaleLabel.BackgroundTransparency = 1
uiScaleLabel.Text = "UI Scale: 100%"
uiScaleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
uiScaleLabel.TextSize = 14
uiScaleLabel.Font = Enum.Font.Code
uiScaleLabel.TextXAlignment = Enum.TextXAlignment.Left

local uiScaleSlider = Instance.new("Frame")
uiScaleSlider.Name = "UIScaleSlider"
uiScaleSlider.Size = UDim2.new(1, 0, 0, 20)
uiScaleSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)

local uiScaleSliderCorner = Instance.new("UICorner")
uiScaleSliderCorner.CornerRadius = UDim.new(0, 10)
uiScaleSliderCorner.Parent = uiScaleSlider

local uiScaleFill = Instance.new("Frame")
uiScaleFill.Name = "UIScaleFill"
uiScaleFill.Size = UDim2.new(0.5, 0, 1, 0)
uiScaleFill.BackgroundColor3 = Color3.fromRGB(70, 120, 200)

local uiScaleFillCorner = Instance.new("UICorner")
uiScaleFillCorner.CornerRadius = UDim.new(0, 10)
uiScaleFillCorner.Parent = uiScaleFill

local uiScaleButton = Instance.new("TextButton")
uiScaleButton.Name = "UIScaleButton"
uiScaleButton.Size = UDim2.new(0, 20, 0, 20)
uiScaleButton.Position = UDim2.new(0.5, -10, 0, 0)
uiScaleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiScaleButton.Text = ""
uiScaleButton.AutoButtonColor = false

local uiScaleButtonCorner = Instance.new("UICorner")
uiScaleButtonCorner.CornerRadius = UDim.new(1, 0)
uiScaleButtonCorner.Parent = uiScaleButton

-- Platform detection label
local platformLabel = Instance.new("TextLabel")
platformLabel.Name = "PlatformLabel"
platformLabel.Size = UDim2.new(1, 0, 0, 30)
platformLabel.Position = UDim2.new(0, 0, 0, 50)
platformLabel.BackgroundTransparency = 1
platformLabel.Text = "Platform: Detecting..."
platformLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
platformLabel.TextSize = 14
platformLabel.Font = Enum.Font.Code
platformLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Key Status
local keyStatusLabel = Instance.new("TextLabel")
keyStatusLabel.Name = "KeyStatusLabel"
keyStatusLabel.Size = UDim2.new(1, 0, 0, 30)
keyStatusLabel.Position = UDim2.new(0, 0, 0, 100)
keyStatusLabel.BackgroundTransparency = 1
keyStatusLabel.Text = "🔑 Key Status: NOT ACTIVATED"
keyStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
keyStatusLabel.TextSize = 14
keyStatusLabel.Font = Enum.Font.Code
keyStatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================
-- PARENTING HIERARCHY
-- ============================================

-- Parent semua elemen
closeIcon.Parent = closeButton
minimizeIcon.Parent = minimizeButton
titleIcon.Parent = header
title.Parent = header
minimizeButton.Parent = header
closeButton.Parent = header
header.Parent = mainFrame

-- Key UI
keyTitle.Parent = keyFrame
keyInputBox.Parent = keyFrame
activateButton.Parent = keyFrame
keyFrame.Parent = mainFrame

-- Settings UI
uiScaleButton.Parent = uiScaleSlider
uiScaleFill.Parent = uiScaleSlider
uiScaleSlider.Parent = settingsContent
uiScaleLabel.Parent = settingsContent
platformLabel.Parent = settingsContent
keyStatusLabel.Parent = settingsContent
settingsContent.Parent = contentFrame

-- Tools UI
tpToolIcon.Parent = tpToolToggle
noclipIcon.Parent = noclipToggle
infJumpIcon.Parent = infJumpToggle
infJumpToggle.Parent = toolsContent
noclipToggle.Parent = toolsContent
tpToolToggle.Parent = toolsContent
toolsInstructions.Parent = toolsContent
toolsListLayout.Parent = toolsContent
toolsContent.Parent = contentFrame

-- Teleport UI
teleportAllIcon.Parent = teleportAllButton
teleportAllButton.Parent = teleportContent
refreshButton.Parent = teleportContent
brainrotList.Parent = teleportContent
brainrotListLayout.Parent = brainrotList
teleportListLayout.Parent = teleportContent
teleportContent.Parent = contentFrame

-- Tabs
teleportTab.Parent = tabContainer
toolsTab.Parent = tabContainer
settingsTab.Parent = tabContainer
tabContainer.Parent = mainFrame

contentFrame.Parent = mainFrame
mainFrame.Parent = screenGui
screenGui.Parent = game.CoreGui

-- ============================================
-- UI LOGIC AND FUNCTIONALITY
-- ============================================

-- Variabel untuk state UI
local isMinimized = false
local originalSize = mainFrame.Size
local minimizedSize = UDim2.new(0, 200, 0, 40)
local activeTab = "teleport"
local isDragging = false
local dragStart, frameStart

-- Connection untuk tools
local infJumpConnection

-- Fungsi untuk show/hide tools berdasarkan key activation
local function updateToolsVisibility()
    if isKeyActivated then
        toolsTab.Visible = true
        keyFrame.Visible = false
        keyStatusLabel.Text = "🔑 Key Status: ACTIVATED"
        keyStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        toolsTab.Visible = false
        keyFrame.Visible = true
        
        -- Jika di tab tools, pindah ke teleport
        if activeTab == "tools" then
            switchTab("teleport")
        end
    end
end

-- Fungsi untuk minimize/maximize
local function toggleMinimize()
    if isMinimized then
        mainFrame:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        tabContainer.Visible = true
        contentFrame.Visible = true
        minimizeIcon.Image = "rbxassetid://13337301954"
    else
        mainFrame:TweenSize(minimizedSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        tabContainer.Visible = false
        contentFrame.Visible = false
        minimizeIcon.Image = "rbxassetid://13337301955"
    end
    isMinimized = not isMinimized
end

-- Fungsi untuk mengganti tab
local function switchTab(tabName)
    if tabName == "teleport" then
        teleportContent.Visible = true
        toolsContent.Visible = false
        settingsContent.Visible = false
        teleportTab.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
        toolsTab.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        settingsTab.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        activeTab = "teleport"
    elseif tabName == "tools" then
        if isKeyActivated then
            teleportContent.Visible = false
            toolsContent.Visible = true
            settingsContent.Visible = false
            teleportTab.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            toolsTab.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
            settingsTab.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            activeTab = "tools"
        else
            print("Please activate key first!")
        end
    elseif tabName == "settings" then
        teleportContent.Visible = false
        toolsContent.Visible = false
        settingsContent.Visible = true
        teleportTab.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        toolsTab.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        settingsTab.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
        activeTab = "settings"
    end
end

-- Fungsi untuk membuat tombol brainrot individual
local function createBrainrotButton(brainrot, index)
    local button = Instance.new("TextButton")
    button.Name = "BrainrotButton_" .. index
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    button.Text = "Brainrot #" .. index .. " - " .. brainrot.Name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.Code
    button.AutoButtonColor = false
    button.TextTruncate = Enum.TextTruncate.AtEnd
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        teleportToBrainrot(brainrot)
    end)
    
    return button
end

-- Fungsi untuk memperbarui daftar brainrot
local function updateBrainrotList()
    for _, child in pairs(brainrotList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local brainrots = findBrainrots()
    for i, brainrot in ipairs(brainrots) do
        local button = createBrainrotButton(brainrot, i)
        button.Parent = brainrotList
    end
    
    teleportContent.CanvasSize = UDim2.new(0, 0, 0, (#brainrots * 45) + 180)
end

-- Deteksi platform
local function detectPlatform()
    if UserInputService.TouchEnabled then
        return "Mobile (Touch)"
    elseif UserInputService.MouseEnabled then
        return "Desktop (Mouse)"
    else
        return "Unknown"
    end
end

-- Update platform label
platformLabel.Text = "Platform: " .. detectPlatform()

-- ============================================
-- TOOLS CONTROLS LOGIC
-- ============================================

-- Infinite Jump Toggle
infJumpToggle.MouseButton1Click:Connect(function()
    if not isKeyActivated then return end
    
    if not infJumpEnabled then
        infJumpConnection = toggleInfiniteJump()
        infJumpToggle.Text = "Infinite Jump: ON"
        infJumpToggle.BackgroundColor3 = Color3.fromRGB(70, 200, 120)
        infJumpIcon.ImageColor3 = Color3.fromRGB(100, 255, 150)
    else
        if infJumpConnection then
            infJumpConnection:Disconnect()
        end
        infJumpEnabled = false
        infJumpToggle.Text = "Infinite Jump: OFF"
        infJumpToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        infJumpIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        print("Infinite Jump: OFF")
    end
end)

-- Noclip Toggle
noclipToggle.MouseButton1Click:Connect(function()
    if not isKeyActivated then return end
    
    if not noclip then
        toggleNoclip()
        noclipToggle.Text = "Noclip: ON"
        noclipToggle.BackgroundColor3 = Color3.fromRGB(70, 200, 120)
        noclipIcon.ImageColor3 = Color3.fromRGB(100, 255, 150)
    else
        toggleNoclip()
        noclipToggle.Text = "Noclip: OFF"
        noclipToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        noclipIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- TpTool Toggle
tpToolToggle.MouseButton1Click:Connect(function()
    if not isKeyActivated then return end
    
    if not tpToolEnabled then
        toggleTpTool()
        tpToolToggle.Text = "TpTool: ON"
        tpToolToggle.BackgroundColor3 = Color3.fromRGB(70, 200, 120)
        tpToolIcon.ImageColor3 = Color3.fromRGB(100, 255, 150)
    else
        toggleTpTool()
        tpToolToggle.Text = "TpTool: OFF"
        tpToolToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        tpToolIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- ============================================
-- EVENT CONNECTIONS
-- ============================================

-- Key Activation
activateButton.MouseButton1Click:Connect(function()
    local inputKey = keyInputBox.Text
    if activateKey(inputKey) then
        updateToolsVisibility()
        keyInputBox.Text = ""
    end
end)

-- Enter key untuk activate
keyInputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local inputKey = keyInputBox.Text
        if activateKey(inputKey) then
            updateToolsVisibility()
            keyInputBox.Text = ""
        end
    end
end)

-- Minimize button event
minimizeButton.MouseButton1Click:Connect(toggleMinimize)

-- Close button event
closeButton.MouseButton1Click:Connect(function()
    -- Clean up connections
    if infJumpConnection then
        infJumpConnection:Disconnect()
    end
    if noclipConnection then
        noclipConnection:Disconnect()
    end
    if tpTool then
        tpTool:Destroy()
    end
    
    screenGui:Destroy()
end)

-- Tab events
teleportTab.MouseButton1Click:Connect(function()
    switchTab("teleport")
end)

toolsTab.MouseButton1Click:Connect(function()
    switchTab("tools")
end)

settingsTab.MouseButton1Click:Connect(function()
    switchTab("settings")
end)

-- Teleport all button event
teleportAllButton.MouseButton1Click:Connect(function()
    teleportToAllBrainrots()
end)

-- Refresh button event
refreshButton.MouseButton1Click:Connect(updateBrainrotList)

-- UI Scale slider logic
local isSliding = false
uiScaleButton.MouseButton1Down:Connect(function()
    isSliding = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isSliding = false
    end
end)

Mouse.Move:Connect(function()
    if isSliding then
        local x = math.clamp(Mouse.X - uiScaleSlider.AbsolutePosition.X, 0, uiScaleSlider.AbsoluteSize.X)
        local scale = x / uiScaleSlider.AbsoluteSize.X
        scale = math.clamp(scale, 0.5, 1.5)
        
        uiScaleFill.Size = UDim2.new(scale, 0, 1, 0)
        uiScaleButton.Position = UDim2.new(scale, -10, 0, 0)
        
        local scaleValue = 0.5 + scale
        mainFrame.Size = UDim2.new(
            originalSize.X.Scale,
            originalSize.X.Offset * scaleValue,
            originalSize.Y.Scale,
            originalSize.Y.Offset * scaleValue
        )
        
        uiScaleLabel.Text = "UI Scale: " .. math.floor(scale * 100) .. "%"
    end
end)

-- Drag window functionality
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        frameStart = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            frameStart.X.Scale,
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale,
            frameStart.Y.Offset + delta.Y
        )
    end
end)

-- Double click header untuk minimize
local lastClickTime = 0
header.MouseButton1Click:Connect(function()
    local currentTime = tick()
    if currentTime - lastClickTime < 0.3 then
        toggleMinimize()
    end
    lastClickTime = currentTime
end)

-- ============================================
-- INITIALIZATION
-- ============================================

-- Set tab awal
switchTab("teleport")

-- Update brainrot list pertama kali
updateBrainrotList()

-- Update tools visibility
updateToolsVisibility()

-- Responsif untuk mobile
if UserInputService.TouchEnabled then
    mainFrame.Size = UDim2.new(0, 420, 0, 500)
    originalSize = mainFrame.Size
    teleportAllButton.TextSize = 18
    refreshButton.TextSize = 18
    infJumpToggle.TextSize = 18
    noclipToggle.TextSize = 18
    tpToolToggle.TextSize = 18
end

print("Find The Brainrot UI Loaded Successfully!")
print("Universal Support: Windows & Android")
print("Features: Teleport System, Tools (Inf Jump, Noclip, TpTool), Key System")
print("Required Key: WYKEY_k9X63kbHegHSS6ovuU9F")