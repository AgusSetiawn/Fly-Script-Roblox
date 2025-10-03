-- Fly GUI Final Version
-- Dibersihkan + Fungsi Lengkap (Draggable, Minimize Bulat X, Close, Fly stabil)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Vars
local flying = false
local speed = 1
local ctrl = {f=0,b=0,l=0,r=0}
local lastctrl = {f=0,b=0,l=0,r=0}
local bv, bg
local frame, miniBtn

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "FlyGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
frame = Instance.new("Frame")
frame.Size = UDim2.new(0,200,0,120)
frame.Position = UDim2.new(0.3,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(60,60,60)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,25)
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.Text = "🚀 Fly GUI"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = frame

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-25,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Minimize button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,25,0,25)
minimizeBtn.Position = UDim2.new(1,-50,0,0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100,150,250)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Parent = frame

-- Fly toggle
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,180,0,30)
toggleBtn.Position = UDim2.new(0,10,0,35)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
toggleBtn.Text = "Fly: OFF"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 18
toggleBtn.Parent = frame

-- Speed label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0,180,0,20)
speedLabel.Position = UDim2.new(0,10,0,70)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: "..speed
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Parent = frame

-- + and - buttons
local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0,40,0,25)
plusBtn.Position = UDim2.new(0,10,0,95)
plusBtn.BackgroundColor3 = Color3.fromRGB(0,200,100)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.new(1,1,1)
plusBtn.Parent = frame

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0,40,0,25)
minusBtn.Position = UDim2.new(0,60,0,95)
minusBtn.BackgroundColor3 = Color3.fromRGB(200,150,0)
minusBtn.Text = "-"
minusBtn.TextColor3 = Color3.new(1,1,1)
minusBtn.Parent = frame

-- Fly Function
local function startFly()
    local torso = char:FindFirstChild("HumanoidRootPart")
    bg = Instance.new("BodyGyro", torso)
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.CFrame = torso.CFrame
    bv = Instance.new("BodyVelocity", torso)
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Velocity = Vector3.zero

    RunService.RenderStepped:Connect(function()
        if flying then
            bg.CFrame = workspace.CurrentCamera.CFrame
            local vel = Vector3.new()
            if ctrl.l+ctrl.r ~= 0 or ctrl.f+ctrl.b ~= 0 then
                vel = ((workspace.CurrentCamera.CFrame.LookVector * (ctrl.f+ctrl.b)) +
                    ((workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) -
                    workspace.CurrentCamera.CFrame.p))
                vel = vel * speed
                lastctrl = {f=ctrl.f,b=ctrl.b,l=ctrl.l,r=ctrl.r}
            elseif lastctrl.f+lastctrl.b ~= 0 or lastctrl.l+lastctrl.r ~= 0 then
                vel = ((workspace.CurrentCamera.CFrame.LookVector * (lastctrl.f+lastctrl.b)) +
                    ((workspace.CurrentCamera.CFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) -
                    workspace.CurrentCamera.CFrame.p))
                vel = vel * speed
            end
            bv.Velocity = vel
        else
            if bv then bv.Velocity = Vector3.zero end
        end
    end)
end

local function stopFly()
    if bg then bg:Destroy() end
    if bv then bv:Destroy() end
end

-- Toggle fly
toggleBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        toggleBtn.Text = "Fly: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
        startFly()
    else
        toggleBtn.Text = "Fly: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
        stopFly()
    end
end)

-- Speed control
plusBtn.MouseButton1Click:Connect(function()
    speed = speed + 1
    speedLabel.Text = "Speed: "..speed
end)
minusBtn.MouseButton1Click:Connect(function()
    if speed > 1 then
        speed = speed - 1
        speedLabel.Text = "Speed: "..speed
    end
end)

-- Controls
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.W then ctrl.f = 1 end
    if i.KeyCode == Enum.KeyCode.S then ctrl.b = -1 end
    if i.KeyCode == Enum.KeyCode.A then ctrl.l = -1 end
    if i.KeyCode == Enum.KeyCode.D then ctrl.r = 1 end
    if i.KeyCode == Enum.KeyCode.Space then ctrl.f = ctrl.f+1 end
    if i.KeyCode == Enum.KeyCode.LeftShift then ctrl.b = ctrl.b-1 end
end)

UIS.InputEnded:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.W then ctrl.f = 0 end
    if i.KeyCode == Enum.KeyCode.S then ctrl.b = 0 end
    if i.KeyCode == Enum.KeyCode.A then ctrl.l = 0 end
    if i.KeyCode == Enum.KeyCode.D then ctrl.r = 0 end
    if i.KeyCode == Enum.KeyCode.Space then ctrl.f = ctrl.f-1 end
    if i.KeyCode == Enum.KeyCode.LeftShift then ctrl.b = ctrl.b+1 end
end)

-- Minimize system (bulatan X)
minimizeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    miniBtn = Instance.new("TextButton")
    miniBtn.Size = UDim2.new(0,40,0,40)
    miniBtn.Position = UDim2.new(0.05,0,0.5,0)
    miniBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    miniBtn.Text = "X"
    miniBtn.TextColor3 = Color3.new(1,1,1)
    miniBtn.Font = Enum.Font.SourceSansBold
    miniBtn.TextSize = 20
    miniBtn.Parent = gui
    miniBtn.Active = true
    miniBtn.Draggable = true
    miniBtn.MouseButton1Click:Connect(function()
        frame.Visible = true
        miniBtn:Destroy()
    end)
end)
