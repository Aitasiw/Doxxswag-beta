local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
if not Rayfield then return end

local Window = Rayfield:CreateWindow({
	Name = "doxxswag Hub",
	LoadingTitle = "doxxswag Hub",
	LoadingSubtitle = "by doxxswag",
	ConfigurationSaving = {Enabled = true, FolderName = "doxxswagHub", FileName = "doxxswagConfig"},
	Discord = {Enabled = true, Invite = "your_discord_invite", RememberJoins = true},
	KeySystem = false
})

local UniversalTab = Window:CreateTab("Universal", 4483362458)
local DaHoodTab = Window:CreateTab("Da Hood", 4483362458)
local WarTycoonTab = Window:CreateTab("War Tycoon", 4483362458)
local MurderMystery2Tab = Window:CreateTab("Murder Mystery 2", 4483362458)
local DeepwokenTab = Window:CreateTab("Deepwoken", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

UniversalTab:CreateToggle({
	Name = "Aimbot",
	CurrentValue = false,
	Flag = "Aimbot",
	Callback = function(Value)
		if Value then
			getgenv().AimbotConnection = RunService.RenderStepped:Connect(function()
				local target, minDist = nil, math.huge
				for _, player in pairs(Players:GetPlayers()) do
					if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
						local head = player.Character.Head
						local dist = (Camera.CFrame.Position - head.Position).Magnitude
						if dist < minDist then
							minDist = dist
							target = head
						end
					end
				end
				if target then
					Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
				end
			end)
		else
			if getgenv().AimbotConnection then
				getgenv().AimbotConnection:Disconnect()
				getgenv().AimbotConnection = nil
			end
		end
	end
})

local ESPHighlights = {}
local ESPConnections = {}

local function addESP(player)
	if player ~= LocalPlayer and player.Character then
		local highlight = Instance.new("Highlight")
		highlight.FillColor = Color3.fromRGB(255, 0, 0)
		highlight.FillTransparency = 0.5
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = player.Character
		ESPHighlights[player] = highlight
	end
end

local function removeESP(player)
	if ESPHighlights[player] then
		ESPHighlights[player]:Destroy()
		ESPHighlights[player] = nil
	end
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character) addESP(player) end)
	addESP(player)
end

local function setupESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then onPlayerAdded(player) end
	end
	table.insert(ESPConnections, Players.PlayerAdded:Connect(onPlayerAdded))
end

local function cleanupESP()
	for _, player in pairs(Players:GetPlayers()) do removeESP(player) end
	for _, connection in pairs(ESPConnections) do connection:Disconnect() end
	ESPConnections = {}
end

UniversalTab:CreateToggle({
	Name = "ESP",
	CurrentValue = false,
	Flag = "ESP",
	Callback = function(Value)
		if Value then setupESP() else cleanupESP() end
	end
})

local FarESPLabels = {}
local FarESPConnections = {}

local function addFarESP(player)
	if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
		local screenGui = Instance.new("ScreenGui")
		screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
		screenGui.ResetOnSpawn = false
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0, 200, 0, 50)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextStrokeTransparency = 0.5
		label.TextScaled = true
		label.Parent = screenGui
		FarESPLabels[player] = {Gui = screenGui, Label = label}
	end
end

local function removeFarESP(player)
	if FarESPLabels[player] then
		FarESPLabels[player].Gui:Destroy()
		FarESPLabels[player] = nil
	end
end

local function updateFarESP()
	for player, data in pairs(FarESPLabels) do
		if player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") and (head.Position - LocalPlayer.Character.Head.Position).Magnitude) or math.huge
			if distance > 50 then
				local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
				if onScreen then
					data.Label.Visible = true
					data.Label.Position = UDim2.new(0, screenPos.X - 100, 0, screenPos.Y - 25)
					data.Label.Text = player.Name .. "\n" .. math.floor(distance * 0.28) .. "m"
				else
					data.Label.Visible = false
				end
			else
				data.Label.Visible = false
			end
		else
			data.Label.Visible = false
		end
	end
end

local function setupFarESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			addFarESP(player)
			player.CharacterAdded:Connect(function() addFarESP(player) end)
		end
	end
	local playerAddedConnection = Players.PlayerAdded:Connect(function(player)
		if player ~= LocalPlayer then
			addFarESP(player)
			player.CharacterAdded:Connect(function() addFarESP(player) end)
		end
	end)
	local updateConnection = RunService.Heartbeat:Connect(updateFarESP)
	table.insert(FarESPConnections, playerAddedConnection)
	table.insert(FarESPConnections, updateConnection)
end

local function cleanupFarESP()
	for _, player in pairs(Players:GetPlayers()) do removeFarESP(player) end
	for _, connection in pairs(FarESPConnections) do connection:Disconnect() end
	FarESPConnections = {}
	FarESPLabels = {}
end

UniversalTab:CreateToggle({
	Name = "Far ESP",
	CurrentValue = false,
	Flag = "FarESP",
	Callback = function(Value)
		if Value then setupFarESP() else cleanupFarESP() end
	end
})

UniversalTab:CreateSlider({
	Name = "WalkSpeed",
	Range = {0, 250},
	Increment = 1,
	Suffix = "Speed",
	CurrentValue = 16,
	Flag = "WalkSpeed",
	Callback = function(Value) getgenv().WalkSpeedValue = Value end
})

local function updateWalkSpeed()
	local character = LocalPlayer.Character
	if character and character:FindFirstChildOfClass("Humanoid") then
		character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue or 16
	end
end

LocalPlayer.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid")
	updateWalkSpeed()
end)

UniversalTab:CreateToggle({
	Name = "Enable WalkSpeed",
	CurrentValue = false,
	Flag = "EnableWalkSpeed",
	Callback = function(Value)
		if Value then
			getgenv().WalkSpeedConnection = RunService.Heartbeat:Connect(updateWalkSpeed)
		else
			if getgenv().WalkSpeedConnection then
				getgenv().WalkSpeedConnection:Disconnect()
				getgenv().WalkSpeedConnection = nil
			end
			local character = LocalPlayer.Character
			if character and character:FindFirstChildOfClass("Humanoid") then
				character.Humanoid.WalkSpeed = 16
			end
		end
	end
})

UniversalTab:CreateSlider({
	Name = "JumpPower",
	Range = {0, 250},
	Increment = 1,
	Suffix = "Power",
	CurrentValue = 50,
	Flag = "JumpPower",
	Callback = function(Value) getgenv().JumpPowerValue = Value end
})

local function updateJumpPower()
	local character = LocalPlayer.Character
	if character and character:FindFirstChildOfClass("Humanoid") then
		character.Humanoid.JumpPower = getgenv().JumpPowerValue or 50
	end
end

LocalPlayer.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid")
	updateJumpPower()
end)

UniversalTab:CreateToggle({
	Name = "Enable JumpPower",
	CurrentValue = false,
	Flag = "EnableJumpPower",
	Callback = function(Value)
		if Value then
			getgenv().JumpPowerConnection = RunService.Heartbeat:Connect(updateJumpPower)
		else
			if getgenv().JumpPowerConnection then
				getgenv().JumpPowerConnection:Disconnect()
				getgenv().JumpPowerConnection = nil
			end
			local character = LocalPlayer.Character
			if character and character:FindFirstChildOfClass("Humanoid") then
				character.Humanoid.JumpPower = 50
			end
		end
	end
})

UniversalTab:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Flag = "InfiniteJump",
	Callback = function(Value)
		if Value then
			getgenv().InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
				local character = LocalPlayer.Character
				if character and character:FindFirstChildOfClass("Humanoid") then
					character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
		else
			if getgenv().InfiniteJumpConnection then
				getgenv().InfiniteJumpConnection:Disconnect()
				getgenv().InfiniteJumpConnection = nil
			end
		end
	end
})

getgenv().keys = {W = false, S = false, A = false, D = false, Space = false, LeftControl = false}

UniversalTab:CreateToggle({
	Name = "Fly",
	CurrentValue = false,
	Flag = "Fly",
	Callback = function(Value)
		if Value then
			getgenv().IsFlying = true
			getgenv().FlyConnection = RunService.Stepped:Connect(function()
				local character = LocalPlayer.Character
				if character and character:FindFirstChild("HumanoidRootPart") then
					local hrp = character.HumanoidRootPart
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					if humanoid then humanoid.PlatformStand = true end
					local speed = 50
					local velocity = Vector3.new()
					if getgenv().keys.W then velocity = velocity + Camera.CFrame.LookVector end
					if getgenv().keys.S then velocity = velocity - Camera.CFrame.LookVector end
					if getgenv().keys.A then velocity = velocity - Camera.CFrame.RightVector end
					if getgenv().keys.D then velocity = velocity + Camera.CFrame.RightVector end
					if getgenv().keys.Space then velocity = velocity + Vector3.new(0, 1, 0) end
					if getgenv().keys.LeftControl then velocity = velocity - Vector3.new(0, 1, 0) end
					hrp.Velocity = velocity * speed
				end
			end)
		else
			getgenv().IsFlying = false
			if getgenv().FlyConnection then
				getgenv().FlyConnection:Disconnect()
				getgenv().FlyConnection = nil
			end
			local character = LocalPlayer.Character
			if character then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then humanoid.PlatformStand = false end
			end
		end
	end
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed then
		if input.KeyCode == Enum.KeyCode.W then getgenv().keys.W = true end
		if input.KeyCode == Enum.KeyCode.S then getgenv().keys.S = true end
		if input.KeyCode == Enum.KeyCode.A then getgenv().keys.A = true end
		if input.KeyCode == Enum.KeyCode.D then getgenv().keys.D = true end
		if input.KeyCode == Enum.KeyCode.Space then getgenv().keys.Space = true end
		if input.KeyCode == Enum.KeyCode.LeftControl then getgenv().keys.LeftControl = true end
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if not gameProcessed then
		if input.KeyCode == Enum.KeyCode.W then getgenv().keys.W = false end
		if input.KeyCode == Enum.KeyCode.S then getgenv().keys.S = false end
		if input.KeyCode == Enum.KeyCode.A then getgenv().keys.A = false end
		if input.KeyCode == Enum.KeyCode.D then getgenv().keys.D = false end
		if input.KeyCode == Enum.KeyCode.Space then getgenv().keys.Space = false end
		if input.KeyCode == Enum.KeyCode.LeftControl then getgenv().keys.LeftControl = false end
	end
end)

UniversalTab:CreateToggle({
	Name = "Godmode",
	CurrentValue = false,
	Flag = "Godmode",
	Callback = function(Value)
		if Value then
			local character = LocalPlayer.Character
			if character and character:FindFirstChildOfClass("Humanoid") then
				character.Humanoid.MaxHealth = math.huge
				character.Humanoid.Health = math.huge
			end
			getgenv().GodmodeConnection = LocalPlayer.CharacterAdded:Connect(function(char)
				char:WaitForChild("Humanoid")
				char.Humanoid.MaxHealth = math.huge
				char.Humanoid.Health = math.huge
			end)
		else
			if getgenv().GodmodeConnection then
				getgenv().GodmodeConnection:Disconnect()
				getgenv().GodmodeConnection = nil
			end
			local character = LocalPlayer.Character
			if character and character:FindFirstChildOfClass("Humanoid") then
				character.Humanoid.MaxHealth = 100
				character.Humanoid.Health = 100
			end
		end
	end
})

UniversalTab:CreateButton({
	Name = "Fling All Players",
	Callback = function()
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 1000, 0)
			end
		end
		Rayfield:Notify({Title = "Fling", Content = "Flung all players!", Duration = 3, Image = 4483362458})
	end
})

UniversalTab:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Flag = "Noclip",
	Callback = function(Value)
		if Value then
			getgenv().NoclipConnection = RunService.Stepped:Connect(function()
				local character = LocalPlayer.Character
				if character then
					for _, part in pairs(character:GetDescendants()) do
						if part:IsA("BasePart") then part.CanCollide = false end
					end
				end
			end)
		else
			if getgenv().NoclipConnection then
				getgenv().NoclipConnection:Disconnect()
				getgenv().NoclipConnection = nil
			end
			local character = LocalPlayer.Character
			if character then
				for _, part in pairs(character:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = true end
				end
			end
		end
	end
})

UniversalTab:CreateToggle({
	Name = "Invisibility",
	CurrentValue = false,
	Flag = "Invisibility",
	Callback = function(Value)
		if Value then
			local character = LocalPlayer.Character
			if character then
				for _, part in pairs(character:GetDescendants()) do
					if part:IsA("BasePart") or part:IsA("Decal") then part.Transparency = 1 end
				end
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then humanoid.NameDisplayDistance = 0 end
			end
			getgenv().InvisibilityConnection = LocalPlayer.CharacterAdded:Connect(function(char)
				char:WaitForChild("Humanoid")
				for _, part in pairs(char:GetDescendants()) do
					if part:IsA("BasePart") or part:IsA("Decal") then part.Transparency = 1 end
				end
				char.Humanoid.NameDisplayDistance = 0
			end)
		else
			if getgenv().InvisibilityConnection then
				getgenv().InvisibilityConnection:Disconnect()
				getgenv().InvisibilityConnection = nil
			end
			local character = LocalPlayer.Character
			if character then
				for _, part in pairs(character:GetDescendants()) do
					if part:IsA("BasePart") then part.Transparency = 0
					elseif part:IsA("Decal") then part.Transparency = part:GetAttribute("OriginalTransparency") or 0 end
				end
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then humanoid.NameDisplayDistance = 100 end
			end
		end
	end
})

UniversalTab:CreateToggle({
	Name = "Rainbow Character",
	CurrentValue = false,
	Flag = "RainbowCharacter",
	Callback = function(Value)
		if Value then
			getgenv().RainbowConnection = RunService.RenderStepped:Connect(function()
				local character = LocalPlayer.Character
				if character then
					for _, part in pairs(character:GetChildren()) do
						if part:IsA("BasePart") then
							part.BrickColor = BrickColor.new(Color3.fromHSV(tick() % 5 / 5, 1, 1))
						end
					end
				end
			end)
		else
			if getgenv().RainbowConnection then
				getgenv().RainbowConnection:Disconnect()
				getgenv().RainbowConnection = nil
			end
		end
	end
})

UniversalTab:CreateToggle({
	Name = "Click Teleport",
	CurrentValue = false,
	Flag = "ClickTP",
	Callback = function(Value)
		if Value then
			local mouse = LocalPlayer:GetMouse()
			getgenv().ClickTPConnection = mouse.Button1Down:Connect(function()
				local character = LocalPlayer.Character
				if character and character:FindFirstChild("HumanoidRootPart") then
					character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
				end
			end)
		else
			if getgenv().ClickTPConnection then
				getgenv().ClickTPConnection:Disconnect()
				getgenv().ClickTPConnection = nil
			end
		end
	end
})

UniversalTab:CreateToggle({
	Name = "Kill Aura",
	CurrentValue = false,
	Flag = "KillAura",
	Callback = function(Value)
		if Value then
			getgenv().KillAuraConnection = RunService.Heartbeat:Connect(function()
				local character = LocalPlayer.Character
				if character and character:FindFirstChild("HumanoidRootPart") then
					for _, player in pairs(Players:GetPlayers()) do
						if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
							if (player.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude <= 10 then
								player.Character.Humanoid.Health = 0
							end
						end
					end
				end
			end)
		else
			if getgenv().KillAuraConnection then
				getgenv().KillAuraConnection:Disconnect()
				getgenv().KillAuraConnection = nil
			end
		end
	end
})

UniversalTab:CreateToggle({
	Name = "Auto Clicker",
	CurrentValue = false,
	Flag = "AutoClicker",
	Callback = function(Value)
		if Value then
			getgenv().AutoClickerConnection = RunService.Heartbeat:Connect(function()
				LocalPlayer:GetMouse():click()
			end)
		else
			if getgenv().AutoClickerConnection then
				getgenv().AutoClickerConnection:Disconnect()
				getgenv().AutoClickerConnection = nil
			end
		end
	end
})

UniversalTab:CreateToggle({
	Name = "No Fall Damage",
	CurrentValue = false,
	Flag = "NoFallDamage",
	Callback = function(Value)
		if Value then
			getgenv().NoFallDamageConnection = LocalPlayer.CharacterAdded:Connect(function(char)
				char:WaitForChild("Humanoid")
				char.Humanoid.StateChanged:Connect(function(old, new)
					if new == Enum.HumanoidStateType.FallingDown or new == Enum.HumanoidStateType.Ragdoll then
						char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
					end
				end)
			end)
			local character = LocalPlayer.Character
			if character and character:FindFirstChildOfClass("Humanoid") then
				character.Humanoid.StateChanged:Connect(function(old, new)
					if new == Enum.HumanoidStateType.FallingDown or new == Enum.HumanoidStateType.Ragdoll then
						character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
					end
				end)
			end
		else
			if getgenv().NoFallDamageConnection then
				getgenv().NoFallDamageConnection:Disconnect()
				getgenv().NoFallDamageConnection = nil
			end
		end
	end
})

UniversalTab:CreateToggle({
	Name = "X-Ray",
	CurrentValue = false,
	Flag = "XRay",
	Callback = function(Value)
		if Value then
			for _, part in pairs(workspace:GetDescendants()) do
				if part:IsA("BasePart") and part.Transparency < 0.9 then
					part:SetAttribute("OriginalTransparency", part.Transparency)
					part.Transparency = 0.9
				end
			end
		else
			for _, part in pairs(workspace:GetDescendants()) do
				if part:IsA("BasePart") and part:GetAttribute("OriginalTransparency") then
					part.Transparency = part:GetAttribute("OriginalTransparency")
					part:SetAttribute("OriginalTransparency", nil)
				end
			end
		end
	end
})

UniversalTab:CreateButton({
	Name = "Respawn",
	Callback = function()
		local character = LocalPlayer.Character
		if character and character:FindFirstChildOfClass("Humanoid") then
			character.Humanoid.Health = 0
		end
		Rayfield:Notify({Title = "Respawn", Content = "Character respawned!", Duration = 3, Image = 4483362458})
	end
})

UniversalTab:CreateToggle({
	Name = "Anti-AFK",
	CurrentValue = false,
	Flag = "AntiAFK",
	Callback = function(Value)
		if Value then
			getgenv().AntiAFKConnection = RunService.Heartbeat:Connect(function()
				local character = LocalPlayer.Character
				if character and character:FindFirstChild("HumanoidRootPart") then
					character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + Vector3.new(0.01, 0, 0)
					wait(0.1)
					character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame - Vector3.new(0.01, 0, 0)
				end
			end)
		else
			if getgenv().AntiAFKConnection then
				getgenv().AntiAFKConnection:Disconnect()
				getgenv().AntiAFKConnection = nil
			end
		end
	end
})

local DaHoodScripts = {
	{Name = "Swag Mode", URL = "https://raw.githubusercontent.com/lerkermer/lua-projects/master/SwagModeV002.lua"},
	{Name = "ZAPPED V3 GUI", URL = "https://raw.githubusercontent.com/zapped-roblox/ZAPPED-V3/main/Script.lua"},
	{Name = "Vantra Hub", URL = "https://raw.githubusercontent.com/VantraHub/DaHood/main/Script.lua"}
}

for _, script in ipairs(DaHoodScripts) do
	DaHoodTab:CreateButton({
		Name = "Load " .. script.Name,
		Callback = function()
			local success, err = pcall(function() loadstring(game:HttpGet(script.URL))() end)
			Rayfield:Notify({
				Title = script.Name,
				Content = success and "Successfully loaded " .. script.Name .. "!" or "Failed to load: " .. err,
				Duration = 5,
				Image = 4483362458
			})
		end
	})
end

local WarTycoonScripts = {
	{Name = "MLoader", URL = "https://raw.githubusercontent.com/MLoader/WarTycoon/main/Script.lua"},
	{Name = "NeptuneHub", URL = "https://raw.githubusercontent.com/JinxTheCatto/Neptune/main/NeptuneHub.lua"}
}

for _, script in ipairs(WarTycoonScripts) do
	WarTycoonTab:CreateButton({
		Name = "Load " .. script.Name,
		Callback = function()
			local success, err = pcall(function() loadstring(game:HttpGet(script.URL))() end)
			Rayfield:Notify({
				Title = script.Name,
				Content = success and "Successfully loaded " .. script.Name .. "!" or "Failed to load: " .. err,
				Duration = 5,
				Image = 4483362458
			})
		end
	})
end

local MurderMystery2Scripts = {
	{Name = "Candy MM2", URL = "https://raw.githubusercontent.com/LOLking123456/Candy/main/MM2"},
	{Name = "Xhub MM2", URL = "https://raw.githubusercontent.com/Au0yX/Community/main/XhubMM2"},
	{Name = "Eclipse MM2", URL = "https://raw.githubusercontent.com/Ethanoj1/EclipseMM2/master/Script"}
}

for _, script in ipairs(MurderMystery2Scripts) do
	MurderMystery2Tab:CreateButton({
		Name = "Load " .. script.Name,
		Callback = function()
			local success, err = pcall(function() loadstring(game:HttpGet(script.URL))() end)
			Rayfield:Notify({
				Title = script.Name,
				Content = success and "Successfully loaded " .. script.Name .. "!" or "Failed to load: " .. err,
				Duration = 5,
				Image = 4483362458
			})
		end
	})
end

local DeepwokenScripts = {
	{Name = "Luarmor Deepwoken", URL = "https://api.luarmor.net/files/v3/loaders/5148416f636b41ddcb31e3eb53fcdfcf.lua"},
	{Name = "REEEPlayz Deepwoken", URL = "https://raw.githubusercontent.com/REEEPlayz/scripts/refs/heads/main/Protected_4193210726309669.txt"},
	{Name = "Swiffrr Deepwoken", URL = "https://raw.githubusercontent.com/swiffrr/scripts/main/deepwoken attach"}
}

for _, script in ipairs(DeepwokenScripts) do
	DeepwokenTab:CreateButton({
		Name = "Load " .. script.Name,
		Callback = function()
			local success, err = pcall(function() loadstring(game:HttpGet(script.URL))() end)
			Rayfield:Notify({
				Title = script.Name,
				Content = success and "Successfully loaded " .. script.Name .. "!" or "Failed to load: " .. err,
				Duration = 5,
				Image = 4483362458
			})
		end
	})
end

SettingsTab:CreateInput({
	Name = "Background R",
	PlaceholderText = "50",
	NumbersOnly = true,
	CurrentValue = "50",
	Flag = "BackgroundR",
	Callback = function(Value) getgenv().BackgroundR = tonumber(Value) or 50 end
})

SettingsTab:CreateInput({
	Name = "Background G",
	PlaceholderText = "0",
	NumbersOnly = true,
	CurrentValue = "0",
	Flag = "BackgroundG",
	Callback = function(Value) getgenv().BackgroundG = tonumber(Value) or 0 end
})

SettingsTab:CreateInput({
	Name = "Background B",
	PlaceholderText = "50",
	NumbersOnly = true,
	CurrentValue = "50",
	Flag = "BackgroundB",
	Callback = function(Value) getgenv().BackgroundB = tonumber(Value) or 50 end
})

SettingsTab:CreateInput({
	Name = "Accent R",
	PlaceholderText = "128",
	NumbersOnly = true,
	CurrentValue = "128",
	Flag = "AccentR",
	Callback = function(Value) getgenv().AccentR = tonumber(Value) or 128 end
})

SettingsTab:CreateInput({
	Name = "Accent G",
	PlaceholderText = "0",
	NumbersOnly = true,
	CurrentValue = "0",
	Flag = "AccentG",
	Callback = function(Value) getgenv().AccentG = tonumber(Value) or 0 end
})

SettingsTab:CreateInput({
	Name = "Accent B",
	PlaceholderText = "128",
	NumbersOnly = true,
	CurrentValue = "128",
	Flag = "AccentB",
	Callback = function(Value) getgenv().AccentB = tonumber(Value) or 128 end
})

SettingsTab:CreateButton({
	Name = "Apply Theme",
	Callback = function()
		local bgColor = Color3.fromRGB(getgenv().BackgroundR or 50, getgenv().BackgroundG or 0, getgenv().BackgroundB or 50)
		local accentColor = Color3.fromRGB(getgenv().AccentR or 128, getgenv().AccentG or 0, getgenv().AccentB or 128)
		Rayfield:SetTheme({Background = bgColor, Accent = accentColor, TextColor = Color3.fromRGB(255, 255, 255)})
		Rayfield:Notify({Title = "Theme Applied", Content = "Custom theme applied!", Duration = 5, Image = 4483362458})
	end
})

Rayfield:Notify({Title = "doxxswag Hub Loaded", Content = "Welcome to doxxswag Hub!", Duration = 5, Image = 4483362458})
