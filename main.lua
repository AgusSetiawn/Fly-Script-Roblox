-- Fly GUI Clean Version
-- By Agus (dibersihkan & diperbaiki)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Vars
local flying = false
local flySpeed = 50
local bodyGyro, bodyVelocity

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui"
screenGui.Parent = game.CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 120)
mainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 25)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(45,45,45)
title.Text = "🚀 Fly Menu"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = mainFrame

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -25, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = mainFrame

-- Fly Toggle Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 200, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 35)
flyButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
flyButton.Text = "Fly: OFF"
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 18
flyButton.Parent = mainFrame

-- Speed Slider (simple version, + and - buttons)
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 200, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 80)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: "..flySpeed
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 16
speedLabel.Parent = mainFrame

-- Fly Function
local function startFly()
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = humanoidRootPart.CFrame
    bodyGyro.Parent = humanoidRootPart

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = humanoidRootPart

    RunService.RenderStepped:Connect(function()
        if flying then
            local camCF = workspace.CurrentCamera.CFrame
            bodyGyro.CFrame = camCF

            local move = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                move = move + camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                move = move - camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                move = move - camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                move = move + camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                move = move + Vector3.new(0,1,0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                move = move - Vector3.new(0,1,0)
            end
            bodyVelocity.Velocity = move.Unit * flySpeed
        end
    end)
end

local function stopFly()
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
end

-- Toggle Fly Button
flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyButton.Text = "Fly: ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(0,200,0)
        startFly()
    else
        flyButton.Text = "Fly: OFF"
        flyButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
        stopFly()
    end
end)

-- Minimize
local minimized = false
local miniBtn
minimizeBtn.MouseButton1Click:Connect(function()
    if not minimized then
        mainFrame.Visible = false
        miniBtn = Instance.new("TextButton")
        miniBtn.Size = UDim2.new(0,40,0,40)
        miniBtn.Position = UDim2.new(0.05,0,0.5,0)
        miniBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        miniBtn.Text = "X"
        miniBtn.TextColor3 = Color3.new(1,1,1)
        miniBtn.Font = Enum.Font.SourceSansBold
        miniBtn.TextSize = 20
        miniBtn.Parent = screenGui
        miniBtn.MouseButton1Click:Connect(function()
            mainFrame.Visible = true
            miniBtn:Destroy()
            minimized = false
        end)
        minimized = true
    end
end)
