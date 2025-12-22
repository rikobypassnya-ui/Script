-- Find The Brainrot UI Script
-- By DeepSeek Assistant
-- Using Rayfield UI Library
-- Support Universal: Windows & Android

-- ============================================
-- LOAD RAYFIELD UI LIBRARY
-- ============================================

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Key System
local WYKEY = "WYKEY_k9X63kbHegHSS6ovuU9F"
local isKeyActivated = false

-- Tools Variables
local noclip = false
local noclipConnection
local infJumpEnabled = false
local infJumpConnection
local tpToolEnabled = false
local tpTool

-- Cari workspace Brainrots
local function findBrainrots()
    local brainrots = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("brainrot") then
            table.insert(brainrots, obj)
        end
    end
    
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

-- Teleport ke semua brainrot
local function teleportToAllBrainrots()
    local brainrots = findBrainrots()
    if #brainrots == 0 then
        Rayfield:Notify({
            Title = "Brainrot Finder",
            Content = "No brainrots found!",
            Duration = 3,
            Image = 4483362458
        })
        return
    end
    
    for i, brainrot in ipairs(brainrots) do
        teleportToBrainrot(brainrot)
        task.wait(1)
    end
    
    Rayfield:Notify({
        Title = "Brainrot Finder",
        Content = "Teleported to " .. #brainrots .. " brainrots!",
        Duration = 3,
        Image = 4483362458
    })
end

-- ============================================
-- TOOLS FUNCTIONS
-- ============================================

local RunService = game:GetService("RunService")

-- Infinite Jump Function
local function toggleInfiniteJump()
    infJumpEnabled = not infJumpEnabled
    
    if infJumpEnabled then
        infJumpConnection = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    else
        if infJumpConnection then
            infJumpConnection:Disconnect()
            infJumpConnection = nil
        end
    end
end

-- Noclip Function
local function toggleNoclip()
    noclip = not noclip
    
    if noclip then
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
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- TpTool Function
local Mouse = LocalPlayer:GetMouse()
local function toggleTpTool()
    tpToolEnabled = not tpToolEnabled
    
    if tpToolEnabled then
        tpTool = Instance.new("Tool")
        tpTool.Name = "TpTool"
        tpTool.RequiresHandle = false
        tpTool.CanBeDropped = false
        
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(4, 0, 4, 0)
        billboard.Adornee = tpTool
        billboard.Parent = tpTool
        
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(1, 0, 1, 0)
        icon.Image = "rbxassetid://13337298324"
        icon.BackgroundTransparency = 1
        icon.Parent = billboard
        
        tpTool.Activated:Connect(function()
            local hit = Mouse.Hit
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(hit.p) + Vector3.new(0, 3, 0)
            end
        end)
        
        tpTool.Parent = LocalPlayer.Backpack
        
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:EquipTool(tpTool)
            end
        end
    else
        if tpTool then
            tpTool:Destroy()
            tpTool = nil
        end
    end
end

-- ============================================
-- RAYFIELD UI CREATION
-- ============================================

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Find The Brainrot",
   LoadingTitle = "Loading Brainrot Finder...",
   LoadingSubtitle = "by DeepSeek Assistant",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BrainrotFinder",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "Brainrot Finder",
      Subtitle = "Enter Key",
      Note = "Key required for tools access",
      FileName = "BrainrotKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {WYKEY}
   }
})

-- ============================================
-- TELEPORT TAB
-- ============================================

local TeleportTab = Window:CreateTab("Teleport", 4483362458)

-- Section for mass teleport
local TeleportSection = TeleportTab:CreateSection("Mass Teleport")

-- Button to teleport to all brainrots
TeleportTab:CreateButton({
   Name = "Teleport to All Brainrots",
   Callback = function()
       teleportToAllBrainrots()
   end,
})

-- Button to refresh brainrot list
TeleportTab:CreateButton({
   Name = "Refresh Brainrot List",
   Callback = function()
       local brainrots = findBrainrots()
       Rayfield:Notify({
           Title = "Brainrot Finder",
           Content = "Found " .. #brainrots .. " brainrots",
           Duration = 3,
           Image = 4483362458
       })
   end,
})

-- Section for individual brainrots
local BrainrotListSection = TeleportTab:CreateSection("Individual Brainrots")

-- Dynamic brainrot buttons
local function updateBrainrotList()
    local brainrots = findBrainrots()
    
    -- Clear previous buttons if needed
    -- Note: Rayfield doesn't have built-in button removal
    -- So we'll just create new ones each time
    
    for i, brainrot in ipairs(brainrots) do
        TeleportTab:CreateButton({
            Name = "Teleport to Brainrot #" .. i,
            Callback = function()
                teleportToBrainrot(brainrot)
                Rayfield:Notify({
                    Title = "Brainrot Finder",
                    Content = "Teleported to brainrot #" .. i,
                    Duration = 2,
                    Image = 4483362458
                })
            end,
        })
    end
end

-- Initial update
updateBrainrotList()

-- ============================================
-- TOOLS TAB
-- ============================================

local ToolsTab = Window:CreateTab("Tools", 4483362458)

local ToolsSection = ToolsTab:CreateSection("Player Tools")

-- Infinite Jump Toggle
local InfJumpToggle = ToolsTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(Value)
       if Value then
           toggleInfiniteJump()
           Rayfield:Notify({
               Title = "Tools",
               Content = "Infinite Jump: ON",
               Duration = 2,
               Image = 4483362458
           })
       else
           toggleInfiniteJump()
           Rayfield:Notify({
               Title = "Tools",
               Content = "Infinite Jump: OFF",
               Duration = 2,
               Image = 4483362458
           })
       end
   end,
})

-- Noclip Toggle
local NoclipToggle = ToolsTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
       if Value then
           toggleNoclip()
           Rayfield:Notify({
               Title = "Tools",
               Content = "Noclip: ON",
               Duration = 2,
               Image = 4483362458
           })
       else
           toggleNoclip()
           Rayfield:Notify({
               Title = "Tools",
               Content = "Noclip: OFF",
               Duration = 2,
               Image = 4483362458
           })
       end
   end,
})

-- TpTool Toggle
local TpToolToggle = ToolsTab:CreateToggle({
   Name = "TpTool",
   CurrentValue = false,
   Flag = "TpToolToggle",
   Callback = function(Value)
       if Value then
           toggleTpTool()
           Rayfield:Notify({
               Title = "Tools",
               Content = "TpTool: ON (Click to teleport)",
               Duration = 3,
               Image = 4483362458
           })
       else
           toggleTpTool()
           Rayfield:Notify({
               Title = "Tools",
               Content = "TpTool: OFF",
               Duration = 2,
               Image = 4483362458
           })
       end
   end,
})

-- Instructions Section
local InstructionsSection = ToolsTab:CreateSection("Instructions")

ToolsTab:CreateLabel("Infinite Jump: Press space to jump infinitely")
ToolsTab:CreateLabel("Noclip: Walk through walls")
ToolsTab:CreateLabel("TpTool: Click where you want to teleport")

-- ============================================
-- SETTINGS TAB
-- ============================================

local SettingsTab = Window:CreateTab("Settings", 4483362458)

local UISection = SettingsTab:CreateSection("UI Settings")

-- UI Toggle
SettingsTab:CreateToggle({
   Name = "UI Toggle",
   CurrentValue = true,
   Flag = "UIToggle",
   Callback = function(Value)
       Window:Toggle(Value)
   end,
})

-- UI Transparency Slider
SettingsTab:CreateSlider({
   Name = "UI Transparency",
   Range = {0, 1},
   Increment = 0.1,
   Suffix = "%",
   CurrentValue = 0,
   Flag = "UITransparency",
   Callback = function(Value)
       Window:SetTransparency(Value)
   end,
})

-- Info Section
local InfoSection = SettingsTab:CreateSection("Information")

-- Platform detection
local platform = "Unknown"
if UserInputService.TouchEnabled then
    platform = "Mobile (Touch)"
elseif UserInputService.MouseEnabled then
    platform = "Desktop (Mouse)"
end

SettingsTab:CreateLabel("Platform: " .. platform)
SettingsTab:CreateLabel("Player: " .. LocalPlayer.Name)

-- Credits Section
local CreditsSection = SettingsTab:CreateSection("Credits")

SettingsTab:CreateLabel("Created by: DeepSeek Assistant")
SettingsTab:CreateLabel("UI Library: Rayfield")
SettingsTab:CreateLabel("For: Find The Brainrot Game")

-- ============================================
-- NOTIFICATION ON LOAD
-- ============================================

Rayfield:Notify({
   Title = "Brainrot Finder Loaded",
   Content = "Use key: WYKEY_k9X63kbHegHSS6ovuU9F",
   Duration = 6,
   Image = 4483362458
})

print("Find The Brainrot UI Loaded Successfully!")
print("Using Rayfield UI Library")
print("Features: Teleport System, Tools (Inf Jump, Noclip, TpTool), Key System")