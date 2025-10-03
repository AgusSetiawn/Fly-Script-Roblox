--// Fly GUI Script by Xzonee_001

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local flying = false
local anticlip = false
local speed = 10

local ctrl = {f=0,b=0,l=0,r=0,u=0,d=0}
local bg, bv, flyConn

-- GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "FlyGUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,300,0,180)
MainFrame.Position = UDim2.new(0.35,0,0.3,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,170,255)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
local UIGradient = Instance.new("UIGradient", MainFrame)
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,200,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,100,255))
}
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0,20)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,-60,0,30)
Title.Position = UDim2.new(0,10,0,5)
Title.BackgroundTransparency = 1
Title.Text = "🚀 FLY-SCRIPT\nBy xzonee_001"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Top

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0,25,0,25)
MinBtn.Position = UDim2.new(1,-55,0,5)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1,0)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0,25,0,25)
CloseBtn.Position = UDim2.new(1,-30,0,5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,40,40)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)

-- Fly button
local FlyToggle = Instance.new("TextButton", MainFrame)
FlyToggle.Size = UDim2.new(0,120,0,40)
FlyToggle.Position = UDim2.new(0.05,0,0.3,0)
FlyToggle.Text = "OFF"
FlyToggle.TextColor3 = Color3.new(1,1,1)
FlyToggle.BackgroundColor3 = Color3.fromRGB(200,40,40)
FlyToggle.Font = Enum.Font.GothamBold
FlyToggle.TextSize = 18
Instance.new("UICorner", FlyToggle).CornerRadius = UDim.new(1,0)

local FlyLabel = Instance.new("TextLabel", MainFrame)
FlyLabel.Size = UDim2.new(0,120,0,20)
FlyLabel.Position = UDim2.new(0.05,0,0.22,0)
FlyLabel.BackgroundTransparency = 1
FlyLabel.Text = "FLY BUTTON"
FlyLabel.TextColor3 = Color3.new(1,1,1)
FlyLabel.Font = Enum.Font.GothamBold
FlyLabel.TextSize = 12

-- Noclip button
local ClipToggle = Instance.new("TextButton", MainFrame)
ClipToggle.Size = UDim2.new(0,120,0,40)
ClipToggle.Position = UDim2.new(0.55,0,0.3,0)
ClipToggle.Text = "OFF"
ClipToggle.TextColor3 = Color3.new(1,1,1)
ClipToggle.BackgroundColor3 = Color3.fromRGB(200,40,40)
ClipToggle.Font = Enum.Font.GothamBold
ClipToggle.TextSize = 18
Instance.new("UICorner", ClipToggle).CornerRadius = UDim.new(1,0)

local ClipLabel = Instance.new("TextLabel", MainFrame)
ClipLabel.Size = UDim2.new(0,120,0,20)
ClipLabel.Position = UDim2.new(0.55,0,0.22,0)
ClipLabel.BackgroundTransparency = 1
ClipLabel.Text = "NOCLIP BUTTON"
ClipLabel.TextColor3 = Color3.new(1,1,1)
ClipLabel.Font = Enum.Font.GothamBold
ClipLabel.TextSize = 12

-- Speed label
local SpeedLabel = Instance.new("TextLabel", MainFrame)
SpeedLabel.Size = UDim2.new(1,0,0,20)
SpeedLabel.Position = UDim2.new(0,0,0.65,0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "SPEED"
SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 14
SpeedLabel.TextYAlignment = Enum.TextYAlignment.Top
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Speed slider (fake bar style)
local SliderBack = Instance.new("Frame", MainFrame)
SliderBack.Size = UDim2.new(0.8,0,0,30)
SliderBack.Position = UDim2.new(0.1,0,0.78,0)
SliderBack.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(1,0)

local SliderKnob = Instance.new("TextButton", SliderBack)
SliderKnob.Size = UDim2.new(0,40,0,30)
SliderKnob.Position = UDim2.new(0,0,0,0)
SliderKnob.Text = ""
SliderKnob.BackgroundColor3 = Color3.fromRGB(240,240,240)
Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1,0)
SliderKnob.AutoButtonColor = false

-- Minimize bubble
local MiniBubble = Instance.new("TextButton", ScreenGui)
MiniBubble.Size = UDim2.new(0,40,0,40)
MiniBubble.Position = UDim2.new(0.02,0,0.2,0)
MiniBubble.Text = "X"
MiniBubble.TextColor3 = Color3.new(1,1,1)
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
