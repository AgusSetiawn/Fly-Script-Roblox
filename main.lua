--// Fly GUI Script (LocalScript)
-- Taruh di StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Buat GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.Position = UDim2.new(0.35, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
MainFrame.Visible = true

-- Header
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 25)
Header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Header.Text = "Fly Script by Xzonee_001"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 14
Header.Parent = MainFrame

-- Tombol minimize
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 25, 0, 25)
Minimize.Position = UDim2.new(1, -25, 0, 0)
Minimize.Text = "_"
Minimize.TextColor3 = Color3.fromRGB(255,255,255)
Minimize.BackgroundColor3 = Color3.fromRGB(100,0,0)
Minimize.Parent = Header

-- Bulatan restore
local RestoreBtn = Instance.new("TextButton")
RestoreBtn.Size = UDim2.new(0, 40, 0, 40)
RestoreBtn.Position = UDim2.new(0.5, -20, 0.1, 0)
RestoreBtn.Text = "X"
RestoreBtn.TextSize = 18
RestoreBtn.TextColor3 = Color3.fromRGB(255,255,255)
RestoreBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
RestoreBtn.Visible = false
RestoreBtn.Parent = ScreenGui

Minimize.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	RestoreBtn.Visible = true
end)

RestoreBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	RestoreBtn.Visible = false
end)

-- Tombol toggle fly
local ToggleFly = Instance.new("TextButton")
ToggleFly.Size = UDim2.new(0.5, -5, 0, 30)
ToggleFly.Position = UDim2.new(0, 5, 0, 35)
ToggleFly.Text = "Fly: OFF"
ToggleFly.TextColor3 = Color3.fromRGB(255,255,255)
ToggleFly.BackgroundColor3 = Color3.fromRGB(200,0,0)
ToggleFly.Parent = MainFrame

-- Speed slider (sederhana pake textbox)
local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.5, -5, 0, 30)
SpeedBox.Position = UDim2.new(0.5, 0, 0, 35)
SpeedBox.PlaceholderText = "Speed"
SpeedBox.Text = "50"
SpeedBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
SpeedBox.TextColor3 = Color3.fromRGB(255,255,255)
SpeedBox.Parent = MainFrame

-- Toggle NoClip
local NoClipBtn = Instance.new("TextButton")
NoClipBtn.Size = UDim2.new(1, -10, 0, 30)
NoClipBtn.Position = UDim2.new(0, 5, 0, 75)
NoClipBtn.Text = "NoClip: OFF"
NoClipBtn.TextColor3 = Color3.fromRGB(255,255,255)
NoClipBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
NoClipBtn.Parent = MainFrame

-- Fly Logic
local flying = false
local noclip = false
local flySpeed = 50
local keysDown = {}
local bodyVel

-- Input key listener
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

		bodyVel = Instance.new("BodyVelocity")
		bodyVel.MaxForce = Vector3.new(1e5,1e5,1e5)
		bodyVel.Velocity = Vector3.zero
		bodyVel.Parent = root
	else
		ToggleFly.Text = "Fly: OFF"
		ToggleFly.BackgroundColor3 = Color3.fromRGB(200,0,0)

		if bodyVel then
			bodyVel:Destroy()
			bodyVel = nil
		end
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

-- Update Loop
RunService.RenderStepped:Connect(function(dt)
	if flying and bodyVel then
		-- Update speed dari TextBox
		local speedVal = tonumber(SpeedBox.Text)
		if speedVal then flySpeed = speedVal end

		-- Ambil arah kamera
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
			moveDir = moveDir.Unit
		end

		bodyVel.Velocity = moveDir * flySpeed
	end

	-- Noclip logic
	if noclip and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)
