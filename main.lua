--// Fly GUI Script by Xzonee_001
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")
local flying = false
local anticlip = false
local minSpeed = 5
local maxSpeed = 50
local speed = 10
local ctrl = {f=0,b=0,l=0,r=0,u=0,d=0}
local bg, bv, flyConn
local gui = Instance.new("ScreenGui")
gui.Name = "FlyGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")
local MainFrame = Instance.new("Frame", gui)
MainFrame.Size = UDim2.new(0,420,0,260)
MainFrame.Position = UDim2.new(0.28,0,0.2,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,170,255)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
local MainGradient = Instance.new("UIGradient", MainFrame)
MainGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(85,202,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(29,120,255))}
local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0,20)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0.7,0,0,70)
Title.Position = UDim2.new(0,20,0,10)
Title.BackgroundTransparency = 1
Title.Text = "🚀 FLY-SCRIPT\nBy xzonee_001"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextWrapped = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Top
local MinSquare = Instance.new("Frame", MainFrame)
MinSquare.Size = UDim2.new(0,90,0,40)
MinSquare.Position = UDim2.new(1,-110,0,10)
MinSquare.BackgroundTransparency = 1
local MinBtn = Instance.new("TextButton", MinSquare)
MinBtn.Size = UDim2.new(0,40,0,30)
MinBtn.Position = UDim2.new(0,0,0,0)
MinBtn.BackgroundColor3 = Color3.fromRGB(90,90,90)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1,0)
local CloseBtn = Instance.new("TextButton", MinSquare)
CloseBtn.Size = UDim2.new(0,40,0,30)
CloseBtn.Position = UDim2.new(1,-40,0,0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220,60,60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)
local FlyLabel = Instance.new("TextLabel", MainFrame)
FlyLabel.Size = UDim2.new(0,160,0,24)
FlyLabel.Position = UDim2.new(0.05,0,0.22,0)
FlyLabel.BackgroundTransparency = 1
FlyLabel.Text = "FLY BUTTON"
FlyLabel.TextColor3 = Color3.fromRGB(255,255,255)
FlyLabel.Font = Enum.Font.GothamBold
FlyLabel.TextSize = 14
FlyLabel.TextXAlignment = Enum.TextXAlignment.Center
local FlyToggle = Instance.new("TextButton", MainFrame)
FlyToggle.Size = UDim2.new(0,160,0,52)
FlyToggle.Position = UDim2.new(0.05,0,0.28,0)
FlyToggle.BackgroundColor3 = Color3.fromRGB(220,60,60)
FlyToggle.Text = "OFF"
FlyToggle.TextColor3 = Color3.fromRGB(255,255,255)
FlyToggle.Font = Enum.Font.GothamBold
FlyToggle.TextSize = 24
Instance.new("UICorner", FlyToggle).CornerRadius = UDim.new(1,0)
local ClipLabel = Instance.new("TextLabel", MainFrame)
ClipLabel.Size = UDim2.new(0,160,0,24)
ClipLabel.Position = UDim2.new(0.55,0,0.22,0)
ClipLabel.BackgroundTransparency = 1
ClipLabel.Text = "NOCLIP BUTTON"
ClipLabel.TextColor3 = Color3.fromRGB(255,255,255)
ClipLabel.Font = Enum.Font.GothamBold
ClipLabel.TextSize = 14
ClipLabel.TextXAlignment = Enum.TextXAlignment.Center
local ClipToggle = Instance.new("TextButton", MainFrame)
ClipToggle.Size = UDim2.new(0,160,0,52)
ClipToggle.Position = UDim2.new(0.55,0,0.28,0)
ClipToggle.BackgroundColor3 = Color3.fromRGB(220,60,60)
ClipToggle.Text = "OFF"
ClipToggle.TextColor3 = Color3.fromRGB(255,255,255)
ClipToggle.Font = Enum.Font.GothamBold
ClipToggle.TextSize = 24
Instance.new("UICorner", ClipToggle).CornerRadius = UDim.new(1,0)
local SpeedTitle = Instance.new("TextLabel", MainFrame)
SpeedTitle.Size = UDim2.new(1,0,0,30)
SpeedTitle.Position = UDim2.new(0,0,0.55,0)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "SPEED"
SpeedTitle.TextColor3 = Color3.fromRGB(255,255,255)
SpeedTitle.Font = Enum.Font.GothamBold
SpeedTitle.TextSize = 18
SpeedTitle.TextXAlignment = Enum.TextXAlignment.Center
local SliderBack = Instance.new("Frame", MainFrame)
SliderBack.Size = UDim2.new(0.8,0,0,42)
SliderBack.Position = UDim2.new(0.1,0,0.72,0)
SliderBack.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(1,0)
local SliderKnob = Instance.new("TextButton", SliderBack)
SliderKnob.Size = UDim2.new(0,68,0,36)
SliderKnob.Position = UDim2.new(0,0,0,3)
SliderKnob.BackgroundColor3 = Color3.fromRGB(250,250,250)
SliderKnob.Text = ""
Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1,0)
local SpeedValueLabel = Instance.new("TextLabel", MainFrame)
SpeedValueLabel.Size = UDim2.new(0,80,0,24)
SpeedValueLabel.Position = UDim2.new(0.82,0,0.72,0)
SpeedValueLabel.BackgroundTransparency = 1
SpeedValueLabel.Text = tostring(speed)
SpeedValueLabel.TextColor3 = Color3.fromRGB(255,255,255)
SpeedValueLabel.Font = Enum.Font.GothamBold
SpeedValueLabel.TextSize = 16
local MiniBubble = Instance.new("TextButton", gui)
MiniBubble.Size = UDim2.new(0,48,0,48)
MiniBubble.Position = UDim2.new(0.02,0,0.2,0)
MiniBubble.Text = "X"
MiniBubble.TextColor3 = Color3.fromRGB(255,255,255)
MiniBubble.BackgroundColor3 = Color3.fromRGB(40,40,40)
MiniBubble.Visible = false
Instance.new("UICorner", MiniBubble).CornerRadius = UDim.new(1,0)
MiniBubble.Active = true
MiniBubble.Draggable = true
local function updateSpeedUI()
    SpeedValueLabel.Text = tostring(speed)
    local proportion = 0
    if maxSpeed > minSpeed then
        proportion = (speed - minSpeed) / (maxSpeed - minSpeed)
    end
    SliderKnob.Position = UDim2.new(math.clamp(proportion,0,1), 0, 0, 3)
end
updateSpeedUI()
local dragging = false
SliderKnob.MouseButton1Down:Connect(function()
    dragging = true
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local x = UserInputService:GetMouseLocation().X
        local absPos = SliderBack.AbsolutePosition.X
        local absSize = SliderBack.AbsoluteSize.X - SliderKnob.AbsoluteSize.X
        local rel = math.clamp((x - absPos) / (absSize > 0 and absSize or 1), 0, 1)
        speed = math.floor(minSpeed + rel * (maxSpeed - minSpeed) + 0.5)
        updateSpeedUI()
    end
end)
SliderBack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local x = UserInputService:GetMouseLocation().X
        local absPos = SliderBack.AbsolutePosition.X
        local absSize = SliderBack.AbsoluteSize.X - SliderKnob.AbsoluteSize.X
        local rel = math.clamp((x - absPos) / (absSize > 0 and absSize or 1), 0, 1)
        speed = math.floor(minSpeed + rel * (maxSpeed - minSpeed) + 0.5)
        updateSpeedUI()
    end
end)
local function applyNoClip(state)
    if not char then return end
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state and true or false
        end
    end
end
local function startFly()
    if flyConn then return end
    humanoid.PlatformStand = true
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    bg = Instance.new("BodyGyro", hrp)
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.CFrame = hrp.CFrame
    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Velocity = Vector3.new(0,0.1,0)
    flyConn = RunService.RenderStepped:Connect(function()
        if not flying then
            if bv then bv.Velocity = Vector3.zero end
            return
        end
        bg.CFrame = workspace.CurrentCamera.CFrame
        local forward = (ctrl.f - ctrl.b)
        local right = (ctrl.r - ctrl.l)
        local up = (ctrl.u - ctrl.d)
        local move = Vector3.zero
        if math.abs(forward) + math.abs(right) + math.abs(up) > 0 then
            local cam = workspace.CurrentCamera.CFrame
            move = (cam.LookVector * forward) + (cam.RightVector * right) + (cam.UpVector * up)
            move = move.Unit * speed
        else
            move = Vector3.zero
        end
        bv.Velocity = bv.Velocity:Lerp(move, 0.2)
    end)
end
local function stopFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if bg then bg:Destroy() bg = nil end
    if bv then bv:Destroy() bv = nil end
    if humanoid and humanoid.Parent then
        humanoid.PlatformStand = false
    end
end
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then ctrl.f = 1 end
    if input.KeyCode == Enum.KeyCode.S then ctrl.b = 1 end
    if input.KeyCode == Enum.KeyCode.A then ctrl.l = 1 end
    if input.KeyCode == Enum.KeyCode.D then ctrl.r = 1 end
    if input.KeyCode == Enum.KeyCode.Space then ctrl.u = 1 end
    if input.KeyCode == Enum.KeyCode.LeftShift then ctrl.d = 1 end
end)
UserInputService.InputEnded:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.W then ctrl.f = 0 end
    if input.KeyCode == Enum.KeyCode.S then ctrl.b = 0 end
    if input.KeyCode == Enum.KeyCode.A then ctrl.l = 0 end
    if input.KeyCode == Enum.KeyCode.D then ctrl.r = 0 end
    if input.KeyCode == Enum.KeyCode.Space then ctrl.u = 0 end
    if input.KeyCode == Enum.KeyCode.LeftShift then ctrl.d = 0 end
end)
FlyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        FlyToggle.Text = "ON"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(50,220,120)
        startFly()
    else
        FlyToggle.Text = "OFF"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(220,60,60)
        stopFly()
    end
end)
ClipToggle.MouseButton1Click:Connect(function()
    anticlip = not anticlip
    if anticlip then
        ClipToggle.Text = "ON"
        ClipToggle.BackgroundColor3 = Color3.fromRGB(50,220,120)
        applyNoClip(true)
    else
        ClipToggle.Text = "OFF"
        ClipToggle.BackgroundColor3 = Color3.fromRGB(220,60,60)
        applyNoClip(false)
    end
end)
CloseBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniBubble.Visible = true
end)
MiniBubble.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniBubble.Visible = false
end)
player.CharacterAdded:Connect(function(c)
    char = c
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")
    if anticlip then applyNoClip(true) end
    if flying then
        stopFly()
        flying = false
        FlyToggle.Text = "OFF"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(220,60,60)
    end
end)
RunService.Stepped:Connect(function()
    if anticlip and char then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)
