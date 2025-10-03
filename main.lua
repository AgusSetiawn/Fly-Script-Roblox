-- Fly GUI Script by Xzonee_001

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyController"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local header = Instance.new("TextLabel")
header.Size = UDim2.new(0, 300, 0, 30)
header.Position = UDim2.new(0.5, -150, 0, 20)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Text = "Fly Script by Xzonee_001"
header.Font = Enum.Font.SourceSansBold
header.TextSize = 18
header.Parent = screenGui

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 100, 0, 40)
flyButton.Position = UDim2.new(0.5, -150, 0, 60)
flyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Text = "Fly: OFF"
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 16
flyButton.Parent = screenGui

local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0, 100, 0, 40)
noclipButton.Position = UDim2.new(0.5, -30, 0, 60)
noclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.Text = "AntiClip: OFF"
noclipButton.Font = Enum.Font.SourceSansBold
noclipButton.TextSize = 16
noclipButton.Parent = screenGui

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 100, 0, 40)
speedBox.Position = UDim2.new(0.5, 90, 0, 60)
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.Text = "50"
speedBox.PlaceholderText = "Speed"
speedBox.Font = Enum.Font.SourceSansBold
speedBox.TextSize = 16
speedBox.Parent = screenGui

local flyEnabled = false
local noclipEnabled = false
local flySpeed = 50
local keysDown = {}

flyButton.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	flyButton.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
end)

noclipButton.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipButton.Text = "AntiClip: " .. (noclipEnabled and "ON" or "OFF")
end)

speedBox.FocusLost:Connect(function()
	local newSpeed = tonumber(speedBox.Text)
	if newSpeed and newSpeed > 0 then
		flySpeed = newSpeed
	else
		speedBox.Text = tostring(flySpeed)
	end
end)

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

RunService.RenderStepped:Connect(function()
	if flyEnabled and root then
		local camera = workspace.CurrentCamera
		local forward = camera.CFrame.LookVector
		local right = camera.CFrame.RightVector
		local up = Vector3.new(0,1,0)

		local moveDirection = Vector3.zero
		if keysDown[Enum.KeyCode.W] then moveDirection += forward end
		if keysDown[Enum.KeyCode.S] then moveDirection -= forward end
		if keysDown[Enum.KeyCode.A] then moveDirection -= right end
		if keysDown[Enum.KeyCode.D] then moveDirection += right end
		if keysDown[Enum.KeyCode.Space] then moveDirection += up end
		if keysDown[Enum.KeyCode.LeftShift] then moveDirection -= up end

		if moveDirection.Magnitude > 0 then
			moveDirection = moveDirection.Unit
		end

		root.Velocity = moveDirection * flySpeed
	else
		root.Velocity = Vector3.zero
	end

	if noclipEnabled and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
	else
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end)
