--[[ 
    TSUNAMI ESCAPE FOR BRAINROTS GUI - V3 ULTIMATE RE-FIX
    Made by @SilentExecute
    Fix: Deep Scan All Categories (Common to Secret) + Auto-Scrolling Fix
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // UI SETUP \\ --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SilentExecute_Brainrot_V3"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local oldUI = game.CoreGui:FindFirstChild(ScreenGui.Name) or LocalPlayer.PlayerGui:FindFirstChild(ScreenGui.Name)
if oldUI then oldUI:Destroy() end

pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

-- // MAIN FRAME \\ --
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 480)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true 
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(45, 45, 45)

-- // TITLE BAR \\ --
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner", TitleBar)
TitleCorner.CornerRadius = UDim.new(0, 10)

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Tsunami Escape For Brainrots!"
TitleText.Font = Enum.Font.Code
TitleText.TextSize = 16
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

task.spawn(function()
    while TitleText.Parent do
        local hue = tick() % 5 / 5
        TitleText.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
        task.wait()
    end
end)

-- // CONTENT HOLDER \\ --
local ContentHolder = Instance.new("Frame")
ContentHolder.Size = UDim2.new(1, 0, 1, -45)
ContentHolder.Position = UDim2.new(0, 0, 0, 45)
ContentHolder.BackgroundTransparency = 1
ContentHolder.ClipsDescendants = false 
ContentHolder.Parent = MainFrame

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 10)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 2
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.ClipsDescendants = false 
Content.Parent = ContentHolder

local Layout = Instance.new("UIListLayout")
Layout.Parent = Content
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- // TOP BUTTONS \\ --
local function CreateTopBtn(text, pos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(1, pos, 0.5, -15)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TitleBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

CreateTopBtn("X", -40, Color3.fromRGB(150, 50, 50), function() ScreenGui:Destroy() end)

local minimized = false
CreateTopBtn("-", -75, Color3.fromRGB(60, 60, 60), function()
    minimized = not minimized
    if minimized then
        ContentHolder.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.4), {Size = UDim2.new(0, 350, 0, 45)}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4), {Size = UDim2.new(0, 350, 0, 480)}):Play()
        task.wait(0.3)
        ContentHolder.Visible = true
    end
end)

-- // DRAG LOGIC \\ --
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- // UI COMPONENTS \\ --
local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = text
    btn.Font = Enum.Font.Code
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Parent = Content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

local function CreateToggle(text, callback)
    local active = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = text .. " [OFF]"
    btn.Font = Enum.Font.Code
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.TextSize = 14
    btn.Parent = Content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = text .. (active and " [ON]" or " [OFF]")
        btn.TextColor3 = active and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        callback(active)
    end)
end

local function CreateDropdown(name, items_func, callback)
    local expanded = false
    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(1, 0, 0, 35)
    dropFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dropFrame.ZIndex = 5
    dropFrame.Parent = Content
    Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 6)

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(1, 0, 1, 0)
    mainBtn.BackgroundTransparency = 1
    mainBtn.Text = name .. " [Buka]"
    mainBtn.Font = Enum.Font.Code
    mainBtn.TextColor3 = Color3.new(1, 1, 1)
    mainBtn.Parent = dropFrame

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 0, 0)
    scroll.Position = UDim2.new(0, 0, 1, 5)
    scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    scroll.Visible = false
    scroll.ZIndex = 100 
    scroll.ScrollBarThickness = 4
    scroll.Parent = dropFrame
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)
    Instance.new("UIListLayout", scroll)

    mainBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        scroll.Visible = expanded
        scroll.Size = expanded and UDim2.new(1, 0, 0, 180) or UDim2.new(1, 0, 0, 0)
        mainBtn.Text = expanded and name .. " [Tutup]" or name .. " [Buka]"
        
        if expanded then
            for _, v in pairs(Content:GetChildren()) do if v:IsA("Frame") then v.ZIndex = 5 end end
            dropFrame.ZIndex = 10 

            for _, v in pairs(scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
            local data = items_func()
            for _, item in pairs(data) do
                local itmBtn = Instance.new("TextButton")
                itmBtn.Size = UDim2.new(1, 0, 0, 35)
                itmBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                itmBtn.BorderSizePixel = 0
                itmBtn.Text = tostring(item.Name)
                itmBtn.Font = Enum.Font.Code
                itmBtn.TextColor3 = Color3.new(1, 1, 1)
                itmBtn.Parent = scroll
                itmBtn.MouseButton1Click:Connect(function()
                    callback(item.Value)
                    expanded = false
                    scroll.Visible = false
                    scroll.Size = UDim2.new(1, 0, 0, 0)
                    mainBtn.Text = name .. " [Buka]"
                end)
            end
            -- Auto-Canvas Size Fix
            scroll.CanvasSize = UDim2.new(0, 0, 0, #data * 35)
        end
    end)
end

-- // --- FEATURES (ORIGINAL) --- \\ --

CreateToggle("Auto Collect Money", function(state)
    getgenv().AutoCol = state
    task.spawn(function()
        while getgenv().AutoCol do
            for i = 1, 30 do
                if not getgenv().AutoCol then break end
                pcall(function() ReplicatedStorage.RemoteEvents.CollectMoney:FireServer("Slot"..i) end)
            end
            task.wait(1)
        end
    end)
end)

CreateButton("Remove VIP Walls & GUI", function()
    if Workspace:FindFirstChild("VIPWalls") then Workspace.VIPWalls:Destroy() end
    pcall(function() LocalPlayer.PlayerGui.Menus.Toggles.VIP:Destroy() end)
end)

CreateButton("Remove Active Tsunamis", function()
    local folder = Workspace:FindFirstChild("ActiveTsunamis")
    if folder then folder:Destroy() end
end)

local locs = {
    {Name = "Sell Area", Value = CFrame.new(127, 3, -98)},
    {Name = "Shop Area", Value = CFrame.new(140, 3, 0)},
    {Name = "Carry Shop", Value = CFrame.new(143, 3, 62)}
}
CreateDropdown("Teleport Locations", function() return locs end, function(cf)
    LocalPlayer.Character.HumanoidRootPart.CFrame = cf
end)

-- DEEP SCAN FIX: Memastikan folder Common sampai Secret terbaca semua
CreateDropdown("Teleport Brainrots", function()
    local list = {}
    local activeFolder = Workspace:FindFirstChild("ActiveBrainrots")
    
    if activeFolder then
        -- Mencari semua kategori (Common, Cosmic, Secret, dll)
        for _, categoryFolder in pairs(activeFolder:GetChildren()) do
            if categoryFolder:IsA("Folder") then
                local categoryName = categoryFolder.Name 
                
                -- Ambil semua brainrot di dalam folder kategori ini
                for _, model in pairs(categoryFolder:GetChildren()) do
                    if model:IsA("Model") then
                        table.insert(list, {
                            Name = categoryName .. ": " .. model.Name, 
                            Value = model
                        })
                    end
                end
            elseif categoryFolder:IsA("Model") then
                -- Jaga-jaga jika brainrot tidak ada di dalam folder kategori
                table.insert(list, {
                    Name = "Other: " .. categoryFolder.Name, 
                    Value = categoryFolder
                })
            end
        end
    end
    -- Sortir agar urutan Common ke Secret lebih rapi
    table.sort(list, function(a, b) return a.Name < b.Name end)
    return list
end, function(model)
    local p = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart")
    if p and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = p.CFrame
    end
end)

CreateButton("Save Position", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/rikobypassnya-ui/Script/refs/heads/main/SavePosition.lua"))()
end)

-- // FOOTER \\ --
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 30)
Footer.Position = UDim2.new(0, 0, 1, -35)
Footer.BackgroundTransparency = 1
Footer.Text = "Made By @SilentExecute"
Footer.Font = Enum.Font.Code
Footer.TextColor3 = Color3.new(1,1,1)
Footer.TextSize = 14
Footer.Parent = ContentHolder

task.spawn(function()
    while Footer.Parent do
        TweenService:Create(Footer, TweenInfo.new(1), {TextColor3 = Color3.new(1, 0, 0)}):Play()
        task.wait(1)
        TweenService:Create(Footer, TweenInfo.new(1), {TextColor3 = Color3.new(0.5, 0, 0)}):Play()
        task.wait(1)
    end
end)
