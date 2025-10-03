--// Fly GUI Script by Xzonee_001 (clean final version)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- fly state
local flying = false
local anticlip = false
local speed = 10

-- ctrl input
local ctrl = {f=0,b=0,l=0,r=0,u=0,d=0}
local bg, bv, flyConn

-- GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "FlyGUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 260)
MainFrame.Position = UDim2.new(0.35,0,0.3,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0,12)

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = MainFrame

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -120, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🚀 Fly Script - Xzonee_001"
Title.TextColor3 = Color3.fromRGB(200,200,200)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- minimize button
local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0,25,0,25)
MinBtn.Position = UDim2.new(1, -90, 0, 10)
MinBtn.Text = "_"
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1,0)

-- close button
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0,25,0,25)
CloseBtn.Position = UDim2.new(1, -45, 0, 10)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)

-- toggle fly
local FlyToggle = Instance.new("TextButton", MainFrame)
FlyToggle.Size = UDim2.new(0,100,0,30)
FlyToggle.Position = UDim2.new(0.05,0,0.3,0)
FlyToggle.Text = "Fly: OFF"
FlyToggle.TextColor3 = Color3.fromRGB(255,255,255)
FlyToggle.BackgroundColor3 = Color3.fromRGB(180,40,40)
FlyToggle.Font = Enum.Font.GothamBold
FlyToggle.TextSize = 14
Instance.new("UICorner", FlyToggle).CornerRadius = UDim.new(0,6)

-- toggle anticlip
local ClipToggle = Instance.new("TextButton", MainFrame)
ClipToggle.Size = UDim2.new(0,100,0,30)
ClipToggle.Position = UDim2.new(0.55,0,0.3,0)
ClipToggle.Text = "AntiClip: OFF"
ClipToggle.TextColor3 = Color3.fromRGB(255,255,255)
ClipToggle.BackgroundColor3 = Color3.fromRGB(180,40,40)
ClipToggle.Font = Enum.Font.GothamBold
ClipToggle.TextSize = 14
Instance.new("UICorner", ClipToggle).CornerRadius = UDim.new(0,6)

-- speed slider
local SpeedSlider = Instance.new("TextButton", MainFrame)
SpeedSlider.Size = UDim2.new(0,200,0,30)
SpeedSlider.Position = UDim2.new(0.1,0,0.65,0)
SpeedSlider.Text = "Speed: 10"
SpeedSlider.TextColor3 = Color3.fromRGB(255,255,255)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(60,60,60)
SpeedSlider.Font = Enum.Font.GothamBold
SpeedSlider.TextSize = 14
Instance.new("UICorner", SpeedSlider).CornerRadius = UDim.new(0,6)

-- minimize bubble
local MiniBubble = Instance.new("TextButton", ScreenGui)
MiniBubble.Size = UDim2.new(0,40,0,40)
MiniBubble.Position = UDim2.new(0.02,0,0.2,0)
MiniBubble.Text = "X"
MiniBubble.TextColor3 = Color3.fromRGB(255,255,255)
MiniBubble.BackgroundColor3 = Color3.fromRGB(40,40,40)
MiniBubble.Font = Enum.Font.GothamBold
MiniBubble.TextSize = 18
MiniBubble.Visible = false
Instance.new("UICorner", MiniBubble).CornerRadius = UDim.new(1,0)
MiniBubble.Active = true
MiniBubble.Draggable = true

-- fly function
local function startFly()
    local humanoid = char:WaitForChild("Humanoid")
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)

    bg = Instance.new("BodyGyro", hrp)
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.CFrame = hrp.CFrame

    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Velocity = Vector3.zero

    flyConn = RunService.RenderStepped:Connect(function()
        if flying then
            bg.CFrame = workspace.CurrentCamera.CFrame
            local moveDir = Vector3.new(ctrl.l+ctrl.r, ctrl.u+ctrl.d, -(ctrl.f-ctrl.b))
            if moveDir.Magnitude > 0 then
                moveDir = (workspace.CurrentCamera.CFrame:VectorToWorldSpace(moveDir)).Unit * speed * 5
            else
                moveDir = Vector3.zero
            end
            bv.Velocity = bv.Velocity:Lerp(moveDir, 0.25)
        else
            bv.Velocity = Vector3.zero
        end
    end)
end

local function stopFly()
    if flyConn then flyConn:Disconnect() flyConn=nil end
    if bg then bg:Destroy() bg=nil end
    if bv then bv:Destroy() bv=nil end
end

-- input
UserInputService.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then ctrl.f=1 end
    if input.KeyCode == Enum.KeyCode.S then ctrl.b=1 end
    if input.KeyCode == Enum.KeyCode.A then ctrl.l=-1 end
    if input.KeyCode == Enum.KeyCode.D then ctrl.r=1 end
    if input.KeyCode == Enum.KeyCode.Space then ctrl.u=1 end
    if input.KeyCode == Enum.KeyCode.LeftShift then ctrl.d=-1 end
end)
UserInputService.InputEnded:Connect(function(input,gp)
    if input.KeyCode == Enum.KeyCode.W then ctrl.f=0 end
    if input.KeyCode == Enum.KeyCode.S then ctrl.b=0 end
    if input.KeyCode == Enum.KeyCode.A then ctrl.l=0 end
    if input.KeyCode == Enum.KeyCode.D then ctrl.r=0 end
    if input.KeyCode == Enum.KeyCode.Space then ctrl.u=0 end
    if input.KeyCode == Enum.KeyCode.LeftShift then ctrl.d=0 end
end)

-- button binds
FlyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        FlyToggle.Text = "Fly: ON"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(40,180,40)
        startFly()
    else
        FlyToggle.Text = "Fly: OFF"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(180,40,40)
        stopFly()
    end
end)

ClipToggle.MouseButton1Click:Connect(function()
    anticlip = not anticlip
    if anticlip then
        ClipToggle.Text = "AntiClip: ON"
        ClipToggle.BackgroundColor3 = Color3.fromRGB(40,180,40)
    else
        ClipToggle.Text = "AntiClip: OFF"
        ClipToggle.BackgroundColor3 = Color3.fromRGB(180,40,40)
    end
end)

SpeedSlider.MouseButton1Click:Connect(function()
    speed = speed + 5
    if speed > 50 then speed = 5 end
    SpeedSlider.Text = "Speed: "..tostring(speed)
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniBubble.Visible = true
end)

MiniBubble.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniBubble.Visible = false
end)

-- anticlip handler
RunService.Stepped:Connect(function()
    if anticlip then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)
