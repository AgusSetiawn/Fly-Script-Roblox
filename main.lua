local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local flying = false
local anticlip = false
local flySpeed = 50
local keysDown = {}

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FlyGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 220, 0, 130)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local header = Instance.new("TextLabel", frame)
header.Size = UDim2.new(1, 0, 0, 25)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
header.Text = "Fly Menu - Xzonee_001"
header.TextColor3 = Color3.new(1,1,1)
header.Font = Enum.Font.SourceSansBold
header.TextSize = 14

local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -50, 0, 0)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.TextColor3 = Color3.new(1,1,1)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -25, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
closeBtn.TextColor3 = Color3.new(1,1,1)

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(0, 90, 0, 25)
flyBtn.Position = UDim2.new(0, 10, 0, 40)
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
flyBtn.TextColor3 = Color3.new(1,1,1)

local clipBtn = Instance.new("TextButton", frame)
clipBtn.Size = UDim2.new(0, 90, 0, 25)
clipBtn.Position = UDim2.new(0, 120, 0, 40)
clipBtn.Text = "AntiClip: OFF"
clipBtn.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
clipBtn.TextColor3 = Color3.new(1,1,1)

local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 200, 0, 25)
speedBox.Position = UDim2.new(0, 10, 0, 80)
speedBox.Text = tostring(flySpeed)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.ClearTextOnFocus = false

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyBtn.Text = "Fly: ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(50,170,50)
    else
        flyBtn.Text = "Fly: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(170,50,50)
        root.Velocity = Vector3.zero
    end
end)

clipBtn.MouseButton1Click:Connect(function()
    anticlip = not anticlip
    if anticlip then
        clipBtn.Text = "AntiClip: ON"
        clipBtn.BackgroundColor3 = Color3.fromRGB(50,170,50)
    else
        clipBtn.Text = "AntiClip: OFF"
        clipBtn.BackgroundColor3 = Color3.fromRGB(170,50,50)
    end
end)

speedBox.FocusLost:Connect(function()
    local val = tonumber(speedBox.Text)
    if val then flySpeed = val end
end)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, obj in ipairs(frame:GetChildren()) do
        if obj ~= header and obj ~= minimizeBtn and obj ~= closeBtn then
            obj.Visible = not minimized
        end
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

UserInputService.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        keysDown[input.KeyCode] = true
    end
end)

UserInputService.InputEnded:Connect(function(input,gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        keysDown[input.KeyCode] = false
    end
end)

RunService.RenderStepped:Connect(function()
    if not flying or not root then return end
    local camera = workspace.CurrentCamera
    local move = Vector3.zero
    if keysDown[Enum.KeyCode.W] then move += camera.CFrame.LookVector end
    if keysDown[Enum.KeyCode.S] then move -= camera.CFrame.LookVector end
    if keysDown[Enum.KeyCode.A] then move -= camera.CFrame.RightVector end
    if keysDown[Enum.KeyCode.D] then move += camera.CFrame.RightVector end
    if keysDown[Enum.KeyCode.Space] then move += Vector3.new(0,1,0) end
    if keysDown[Enum.KeyCode.LeftShift] then move -= Vector3.new(0,1,0) end
    if move.Magnitude > 0 then move = move.Unit * flySpeed end
    root.Velocity = move
end)

RunService.Stepped:Connect(function()
    if anticlip and character then
        for _,part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
