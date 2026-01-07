local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- // 1. MEMBUAT UI DASAR (INSTANCES) \\ --

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SilentExecuteUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 220) -- Ukuran Normal
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true -- Penting untuk animasi minimize
MainFrame.Parent = ScreenGui

-- Menambahkan Corner (Rounded)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Menambahkan Stroke (Garis Tepi)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- // TITLE BAR \\ --
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

-- Icon Bintang (Star)
local StarIcon = Instance.new("ImageLabel")
StarIcon.Size = UDim2.new(0, 24, 0, 24)
StarIcon.Position = UDim2.new(0, 10, 0.5, -12)
StarIcon.BackgroundTransparency = 1
StarIcon.Image = "rbxassetid://112833630169991" -- Asset Teleport
StarIcon.ImageColor3 = Color3.fromRGB(255, 255, 255) -- Warna kuning
StarIcon.Parent = TitleBar

-- Judul (Title)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -120, 1, 0)
TitleLabel.Position = UDim2.new(0, 40, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Save Position"
TitleLabel.Font = Enum.Font.Code -- Font Code
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Tombol Minimize (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0.5, -15)
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.AutoButtonColor = false -- Kita pakai tween manual
MinBtn.Parent = TitleBar
local MinCorner = Instance.new("UICorner"); MinCorner.CornerRadius = UDim.new(0, 6); MinCorner.Parent = MinBtn

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner"); CloseCorner.CornerRadius = UDim.new(0, 6); CloseCorner.Parent = CloseBtn

-- // CONTENT AREA (Tombol Save/TP) \\ --
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Tombol Save
local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(0.8, 0, 0, 35)
SaveBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
SaveBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SaveBtn.Text = "Save Position"
SaveBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
SaveBtn.Font = Enum.Font.GothamSemibold
SaveBtn.TextSize = 14
SaveBtn.Parent = ContentFrame
local SaveCorner = Instance.new("UICorner"); SaveCorner.CornerRadius = UDim.new(0, 6); SaveCorner.Parent = SaveBtn

-- Tombol Teleport
local TPBtn = Instance.new("TextButton")
TPBtn.Size = UDim2.new(0.8, 0, 0, 35)
TPBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
TPBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TPBtn.Text = "Teleport Back"
TPBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
TPBtn.Font = Enum.Font.GothamSemibold
TPBtn.TextSize = 14
TPBtn.Parent = ContentFrame
local TPCorner = Instance.new("UICorner"); TPCorner.CornerRadius = UDim.new(0, 6); TPCorner.Parent = TPBtn

-- // FOOTER (Credits) \\ --
local CreditLabel = Instance.new("TextLabel")
CreditLabel.Size = UDim2.new(1, 0, 0, 20)
CreditLabel.Position = UDim2.new(0, 0, 0.85, 0)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "Made By @SilentExecute"
CreditLabel.Font = Enum.Font.Code
CreditLabel.TextSize = 12
CreditLabel.Parent = ContentFrame

-- // 2. LOGIKA & ANIMASI \\ --

-- Variabel Posisi Tersimpan
local savedPosition = nil

-- Animasi Tombol (Hover Effect)
local function animateButton(btn)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        local originalSize = btn.Size
        TweenService:Create(btn, TweenInfo.new(0.05), {Size = UDim2.new(originalSize.X.Scale, -5, originalSize.Y.Scale, -2)}):Play()
        task.wait(0.05)
        TweenService:Create(btn, TweenInfo.new(0.05), {Size = originalSize}):Play()
    end)
end

animateButton(SaveBtn)
animateButton(TPBtn)

-- Close Button Logic
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize Logic
local isMinimized = false
local fullSize = UDim2.new(0, 300, 0, 220)
local minSize = UDim2.new(0, 300, 0, 40)

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        MinBtn.Text = "+"
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = minSize}):Play()
        ContentFrame.Visible = false
    else
        MinBtn.Text = "-"
        ContentFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = fullSize}):Play()
    end
end)

-- Dragging Logic (Android & Windows Support)
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    
    -- Menggunakan Tween agar gerakan drag terasa smooth
    TweenService:Create(MainFrame, TweenInfo.new(0.1), {Position = targetPos}):Play()
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- RGB Animation untuk Title
task.spawn(function()
    while true do
        for i = 0, 1, 0.001 do
            TitleLabel.TextColor3 = Color3.fromHSV(i, 1, 1) -- Warna Pelangi
            task.wait(0.005)
        end
    end
end)

-- Red & Black Animation untuk Footer Credit
task.spawn(function()
    while true do
        -- Merah ke Hitam
        TweenService:Create(CreditLabel, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {TextColor3 = Color3.new(1, 0, 0)}):Play()
        task.wait(1.5)
        -- Hitam ke Merah
        TweenService:Create(CreditLabel, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {TextColor3 = Color3.new(0, 0, 0)}):Play()
        task.wait(1.5)
    end
end)

-- // 3. FUNGSIONALITAS SAVE & TELEPORT \\ --

SaveBtn.MouseButton1Click:Connect(function()
    local Char = LocalPlayer.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        savedPosition = Char.HumanoidRootPart.CFrame
        SaveBtn.Text = "Position Saved!"
        SaveBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        task.wait(1)
        SaveBtn.Text = "Save Position"
        SaveBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

TPBtn.MouseButton1Click:Connect(function()
    local Char = LocalPlayer.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") and savedPosition then
        Char.HumanoidRootPart.CFrame = savedPosition + Vector3.new(0, 1, 0) -- Tambah sedikit tinggi agar tidak nyangkut
        TPBtn.Text = "Teleported!"
        TPBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        task.wait(1)
        TPBtn.Text = "Teleport Back"
        TPBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    elseif not savedPosition then
        TPBtn.Text = "No Position Saved"
        TPBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(1)
        TPBtn.Text = "Teleport Back"
        TPBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)
