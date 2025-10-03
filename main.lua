--// Fly GUI Script by Xzonee_001
-- Taruh di StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- GUI utama
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.Position = UDim2.new(0.35, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Header = Instance.new("TextLabel", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 25)
Header.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Header.Text = "Fly Script by Xzonee_001"
Header.TextColor3 = Color3.fromRGB(255,255,255)
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 14

-- Tombol minimize
local Minimize = Instance.new("TextButton", Header)
Minimize.Size = UDim2.new(0, 25, 0, 25)
Minimize.Position = UDim2.new(1, -25, 0, 0)
Minimize.Text = "-"
Minimize.TextColor3 = Color3.new(1,1,1)
Minimize.BackgroundColor3 = Color3.fromRGB(200,0,0)

-- Bulatan restore
local RestoreBtn = Instance.new("TextButton", ScreenGui)
RestoreBtn.Size = UDim2.new(0, 40, 0, 40)
RestoreBtn.Position = UDim2.new(0.5, -20, 0.1, 0)
RestoreBtn.Text = "X"
RestoreBtn.TextSize = 20
RestoreBtn.Font = Enum.Font.SourceSansBold
RestoreBtn.TextColor3 = Color3.new(1,1,1)
RestoreBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
RestoreBtn.Visible = false
RestoreBtn.Active = true
RestoreBtn.Draggable = true
RestoreBtn.AutoButtonColor = true
RestoreBtn.TextScaled = true
RestoreBtn.ClipsDescendants = true
RestoreBtn.BorderSizePixel = 0
RestoreBtn.TextWrapped = true
RestoreBtn.TextXAlignment = Enum.TextXAlignment.Center
RestoreBtn.TextYAlignment = Enum.TextYAlignment.Center
RestoreBtn.TextStrokeTransparency = 0.5
RestoreBtn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
RestoreBtn.UICorner = Instance.new("UICorner", RestoreBtn)
RestoreBtn.UICorner.CornerRadius = UDim.new(1,0)

Minimize.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	RestoreBtn.Visible = true
end)

RestoreBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	RestoreBtn.Visible = false
end)

-- Tombol toggle Fly
local ToggleFly = Instance.new("TextButton", MainFrame)
ToggleFly.Size = UDim2.new(0.5, -5, 0, 30)
ToggleFly.Position = UDim2.new(0, 5, 0, 35)
ToggleFly.Text = "Fly: OFF"
ToggleFly.BackgroundColor3 = Color3.fromRGB(200,0,0)
ToggleFly.TextColor3 = Color3.new(1,1,1)

-- Speed box
local SpeedBox = Instance.new("TextBox", MainFrame)
SpeedBox.Size = UDim2.new(0.5, -5, 0, 30)
SpeedBox.Position = UDim2.new(0.5, 0, 0, 35)
SpeedBox.PlaceholderText = "Speed"
SpeedBox.Text = "50"
SpeedBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
SpeedBox.TextColor3 = Color3.new(1,1,1)

-- Toggle NoClip
local NoClipBtn = Instance.new("TextButton", MainFrame)
NoClipBtn.Size = UDim2.new(1, -10, 0, 30)
NoClipBtn.Position = UDim2.new(0, 5, 0, 75)
NoClipBtn.Text = "NoClip: OFF"
NoClipBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
NoClipBtn.TextColor3 = Color3.new(1,1,1)

-- Logic
local flying = false
local noclip = false
local flySpeed = 50
local keysDown = {}

-- Input listener
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		keysDown[input.KeyCode] = true
	end
end)

UserInputService.InputEnded:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		keysDown[input.KeyCode] = false
	end
end)

-- Toggle Fly
ToggleFly.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		ToggleFly.Text = "Fly: ON"
		ToggleFly.BackgroundColor3 = Color3.fromRGB(0,200,0)
	else
		ToggleFly.Text = "Fly: OFF"
		ToggleFly.BackgroundColor3 = Color3.fromRGB(200,0,0)
		root.AssemblyLinearVelocity = Vector3.zero
	end
end)

-- Toggle NoClip
NoClipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	if noclip then
		NoClipBtn.Text = "NoClip: ON"
		NoClipBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
	else
		NoClipBtn.Text = "NoClip: OFF"
		NoClipBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
	end
end)

-- Loop update
RunService.RenderStepped:Connect(function()
	if flying then
		-- Speed update
		local spd = tonumber(SpeedBox.Text)
		if spd then flySpeed = spd end

		local cam = workspace.CurrentCamera
		local forward = cam.CFrame.LookVector
		local right = cam.CFrame.RightVector
		local up = Vector3.new(0,1,0)

		local moveDir = Vector3.zero
		if keysDown[Enum.KeyCode.W] then moveDir += forward end
		if keysDown[Enum.KeyCode.S] then moveDir -= forward end
		if keysDown[Enum.KeyCode.A] then moveDir -= right end
		if keysDown[Enum.KeyCode.D] then moveDir += right end
		if keysDown[Enum.KeyCode.Space] then moveDir += up end
		if keysDown[Enum.KeyCode.LeftShift] then moveDir -= up end

		if moveDir.Magnitude > 0 then
			moveDir = moveDir.Unit * flySpeed
		else
			moveDir = Vector3.zero
		end

		root.AssemblyLinearVelocity = moveDir
	end

	-- NoClip logic
	if noclip and character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)
