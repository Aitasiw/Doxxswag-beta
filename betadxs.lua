local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Загружаем Rayfield
local RayfieldSuccess, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)
if not RayfieldSuccess or not Rayfield then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Ошибка",
        Text = "Не удалось загрузить Rayfield. Проверь URL или повтори позже.",
        Duration = 10
    })
    return
end

-- Создаём окно
local Window = Rayfield:CreateWindow({
    Name = "doxxswag Hub",
    LoadingTitle = "doxxswag Hub",
    LoadingSubtitle = "by doxxswag",
    ConfigurationSaving = {Enabled = true, FolderName = "doxxswagHub", FileName = "doxxswagConfig"},
    Discord = {Enabled = true, Invite = "your_discord_invite", RememberJoins = true},
    KeySystem = false
})

-- Создаём вкладки
local MainTab = Window:CreateTab("Main", 4483362458)
local OtherHubsTab = Window:CreateTab("Other Hubs", 4483362458)

-- Проверка создания вкладок
if not MainTab or not OtherHubsTab then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Ошибка",
        Text = "Не удалось создать вкладки.",
        Duration = 10
    })
    return
end

-- **Секция: Модификации игрока**
MainTab:CreateSection("Модификации игрока")

-- Fly (Полет)
local flying = false
local flySpeed = 50
MainTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        flying = Value
        if flying then
            local gui = Rayfield:CreateWindow({
                Name = "Настройки полета",
                LoadingTitle = "Управление полетом",
                LoadingSubtitle = "Настрой скорость"
            })
            gui:CreateSlider({
                Name = "Скорость полета",
                Range = {1, 100},
                Increment = 1,
                CurrentValue = 50,
                Flag = "FlySpeed",
                Callback = function(Value) flySpeed = Value end
            })
            gui:CreateButton({
                Name = "Выключить полет",
                Callback = function()
                    flying = false
                    gui:Destroy()
                end
            })
            spawn(function()
                while flying do
                    local character = LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local hrp = character.HumanoidRootPart
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then humanoid.PlatformStand = true end
                        local velocity = Vector3.new()
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + Camera.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - Camera.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - Camera.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + Camera.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity = velocity + Vector3.new(0, 1, 0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then velocity = velocity - Vector3.new(0, 1, 0) end
                        hrp.Velocity = velocity * flySpeed
                    end
                    RunService.Heartbeat:Wait()
                end
                local character = LocalPlayer.Character
                if character and character:FindFirstChildOfClass("Humanoid") then
                    character.Humanoid.PlatformStand = false
                end
            end)
        end
    end
})

-- Fling (Разброс игроков)
local flingSpeed = 100
MainTab:CreateButton({
    Name = "Fling всех игроков",
    Callback = function()
        local gui = Rayfield:CreateWindow({
            Name = "Настройки Fling",
            LoadingTitle = "Управление Fling",
            LoadingSubtitle = "Настрой силу"
        })
        gui:CreateSlider({
            Name = "Сила Fling",
            Range = {50, 500},
            Increment = 10,
            CurrentValue = 100,
            Flag = "FlingSpeed",
            Callback = function(Value) flingSpeed = Value end
        })
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character.HumanoidRootPart
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Velocity = Vector3.new(math.random(-1, 1), 1, math.random(-1, 1)) * flingSpeed
                bodyVelocity.Parent = root
                game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
            end
        end
        Rayfield:Notify({Title = "Fling", Content = "Все игроки разбросаны!", Duration = 3, Image = 4483362458})
    end
})

-- WalkSpeed (Скорость ходьбы)
MainTab:CreateSlider({
    Name = "Скорость ходьбы",
    Range = {0, 250},
    Increment = 1,
    Suffix = "Скорость",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value) getgenv().WalkSpeedValue = Value end
})
MainTab:CreateToggle({
    Name = "Включить WalkSpeed",
    CurrentValue = false,
    Flag = "EnableWalkSpeed",
    Callback = function(Value)
        if Value then
            getgenv().WalkSpeedConnection = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChildOfClass("Humanoid") then
                    character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue or 16
                end
            end)
        else
            if getgenv().WalkSpeedConnection then getgenv().WalkSpeedConnection:Disconnect() end
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then character.Humanoid.WalkSpeed = 16 end
        end
    end
})

-- JumpPower (Сила прыжка)
MainTab:CreateSlider({
    Name = "Сила прыжка",
    Range = {0, 250},
    Increment = 1,
    Suffix = "Сила",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value) getgenv().JumpPowerValue = Value end
})
MainTab:CreateToggle({
    Name = "Включить JumpPower",
    CurrentValue = false,
    Flag = "EnableJumpPower",
    Callback = function(Value)
        if Value then
            getgenv().JumpPowerConnection = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChildOfClass("Humanoid") then
                    character.Humanoid.JumpPower = getgenv().JumpPowerValue or 50
                    character.Humanoid.UseJumpPower = true
                end
            end)
        else
            if getgenv().JumpPowerConnection then getgenv().JumpPowerConnection:Disconnect() end
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then character.Humanoid.JumpPower = 50 end
        end
    end
})

-- Infinite Jump (Бесконечный прыжок)
MainTab:CreateToggle({
    Name = "Бесконечный прыжок",
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
            if getgenv().InfiniteJumpConnection then getgenv().InfiniteJumpConnection:Disconnect() end
        end
    end
})

-- Godmode (Бессмертие)
MainTab:CreateToggle({
    Name = "Бессмертие",
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
            if getgenv().GodmodeConnection then getgenv().GodmodeConnection:Disconnect() end
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character.Humanoid.MaxHealth = 100
                character.Humanoid.Health = 100
            end
        end
    end
})

-- Noclip (Прохождение сквозь стены)
MainTab:CreateToggle({
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
            if getgenv().NoclipConnection then getgenv().NoclipConnection:Disconnect() end
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end
})

-- Invisibility (Невидимость)
MainTab:CreateToggle({
    Name = "Невидимость",
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
            if getgenv().InvisibilityConnection then getgenv().InvisibilityConnection:Disconnect() end
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then part.Transparency = 0 end
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.NameDisplayDistance = 100 end
            end
        end
    end
})

-- Rainbow Character (Радужный персонаж)
MainTab:CreateToggle({
    Name = "Радужный персонаж",
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
            if getgenv().RainbowConnection then getgenv().RainbowConnection:Disconnect() end
        end
    end
})

-- Click Teleport (Телепорт по клику)
MainTab:CreateToggle({
    Name = "Телепорт по клику",
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
            if getgenv().ClickTPConnection then getgenv().ClickTPConnection:Disconnect() end
        end
    end
})

-- Kill Aura (Аура убийства)
MainTab:CreateToggle({
    Name = "Аура убийства",
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
            if getgenv().KillAuraConnection then getgenv().KillAuraConnection:Disconnect() end
        end
    end
})

-- Auto Clicker (Автокликер)
MainTab:CreateToggle({
    Name = "Автокликер",
    CurrentValue = false,
    Flag = "AutoClicker",
    Callback = function(Value)
        if Value then
            getgenv().AutoClickerConnection = RunService.Heartbeat:Connect(function()
                LocalPlayer:GetMouse():click()
            end)
        else
            if getgenv().AutoClickerConnection then getgenv().AutoClickerConnection:Disconnect() end
        end
    end
})

-- No Fall Damage (Без урона от падения)
MainTab:CreateToggle({
    Name = "Без урона от падения",
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
            if getgenv().NoFallDamageConnection then getgenv().NoFallDamageConnection:Disconnect() end
        end
    end
})

-- X-Ray (Рентген)
MainTab:CreateToggle({
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

-- Respawn (Возрождение)
MainTab:CreateButton({
    Name = "Возродиться",
    Callback = function()
        local character = LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.Health = 0
        end
        Rayfield:Notify({Title = "Возрождение", Content = "Персонаж возродился!", Duration = 3, Image = 4483362458})
    end
})

-- Anti-AFK (Анти-AFK)
MainTab:CreateToggle({
    Name = "Анти-AFK",
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
            if getgenv().AntiAFKConnection then getgenv().AntiAFKConnection:Disconnect() end
        end
    end
})

-- **Секция: Телепортация**
MainTab:CreateSection("Телепортация")

-- Телепорт к игроку
MainTab:CreateDropdown({
    Name = "Телепорт к игроку",
    Options = (function()
        local players = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then table.insert(players, player.Name) end
        end
        return players
    end)(),
    CurrentOption = "",
    Flag = "TeleportPlayer",
    Callback = function(Option)
        local targetPlayer = Players:FindFirstChild(Option)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
})

-- Телепорт по координатам
MainTab:CreateInput({
    Name = "Телепорт по координатам",
    PlaceholderText = "X,Y,Z",
    CurrentValue = "",
    Flag = "TeleportCoords",
    Callback = function(Value)
        local coords = {}
        for coord in string.gmatch(Value, "[^,]+") do
            table.insert(coords, tonumber(coord))
        end
        if #coords == 3 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(coords[1], coords[2], coords[3]))
        end
    end
})

-- **Секция: Модификации окружения**
MainTab:CreateSection("Модификации окружения")

-- Gravity (Гравитация)
MainTab:CreateSlider({
    Name = "Гравитация",
    Range = {0, 500},
    Increment = 1,
    Suffix = "Гравитация",
    CurrentValue = 196.2,
    Flag = "Gravity",
    Callback = function(Value)
        workspace.Gravity = Value
    end
})

-- Field of View (Поле зрения)
MainTab:CreateSlider({
    Name = "Поле зрения",
    Range = {30, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70,
    Flag = "FOV",
    Callback = function(Value)
        Camera.FieldOfView = Value
    end
})

-- Day/Night Time (День/Ночь)
MainTab:CreateButton({
    Name = "День",
    Callback = function()
        game:GetService("Lighting").ClockTime = 12
    end
})
MainTab:CreateButton({
    Name = "Ночь",
    Callback = function()
        game:GetService("Lighting").ClockTime = 0
    end
})

-- **Секция: Визуальные эффекты**
MainTab:CreateSection("Визуальные эффекты")

-- Full Bright (Полная яркость)
MainTab:CreateToggle({
    Name = "Полная яркость",
    CurrentValue = false,
    Flag = "FullBright",
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").GlobalShadows = false
        else
            game:GetService("Lighting").Brightness = 0
            game:GetService("Lighting").GlobalShadows = true
        end
    end
})

-- Fog Removal (Удаление тумана)
MainTab:CreateToggle({
    Name = "Удаление тумана",
    CurrentValue = false,
    Flag = "FogRemoval",
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").FogEnd = 100000
        else
            game:GetService("Lighting").FogEnd = 500
        end
    end
})

-- **Секция: ESP**
MainTab:CreateSection("ESP функции")

-- ESP (Обычный ESP)
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
    if ESPHighlights[player] then ESPHighlights[player]:Destroy() ESPHighlights[player] = nil end
end
local function setupESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            addESP(player)
            player.CharacterAdded:Connect(function() addESP(player) end)
        end
    end
    table.insert(ESPConnections, Players.PlayerAdded:Connect(function(player) addESP(player) end))
end
local function cleanupESP()
    for _, player in pairs(Players:GetPlayers()) do removeESP(player) end
    for _, conn in pairs(ESPConnections) do conn:Disconnect() end
    ESPConnections = {}
end
MainTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        if Value then setupESP() else cleanupESP() end
    end
})

-- Far ESP (Дальний ESP с метрами)
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
    if FarESPLabels[player] then FarESPLabels[player].Gui:Destroy() FarESPLabels[player] = nil end
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
                    data.Label.Text = player.Name .. "\n" .. math.floor(distance * 0.28) .. "м"
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
    table.insert(FarESPConnections, Players.PlayerAdded:Connect(function(player) addFarESP(player) end))
    table.insert(FarESPConnections, RunService.Heartbeat:Connect(updateFarESP))
end
local function cleanupFarESP()
    for _, player in pairs(Players:GetPlayers()) do removeFarESP(player) end
    for _, conn in pairs(FarESPConnections) do conn:Disconnect() end
    FarESPConnections = {}
    FarESPLabels = {}
end
MainTab:CreateToggle({
    Name = "Дальний ESP",
    CurrentValue = false,
    Flag = "FarESP",
    Callback = function(Value)
        if Value then setupFarESP() else cleanupFarESP() end
    end
})

-- **Секция: Aimbot**
MainTab:CreateSection("Aimbot")

-- Aimbot (Автоприцел)
MainTab:CreateToggle({
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
            if getgenv().AimbotConnection then getgenv().AimbotConnection:Disconnect() end
        end
    end
})

-- **Секция: Разное**
MainTab:CreateSection("Разное")

-- Kill All (Убить всех)
MainTab:CreateButton({
    Name = "Убить всех",
    Callback = function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character.Humanoid.Health = 0
            end
        end
    end
})

-- Reset Character (Сброс персонажа)
MainTab:CreateButton({
    Name = "Сбросить персонажа",
    Callback = function()
        LocalPlayer.Character:BreakJoints()
    end
})

-- Third Person View (Вид от третьего лица)
MainTab:CreateToggle({
    Name = "Вид от третьего лица",
    CurrentValue = false,
    Flag = "ThirdPerson",
    Callback = function(Value)
        if Value then
            Camera.CameraType = Enum.CameraType.Scriptable
            getgenv().ThirdPersonConnection = RunService.RenderStepped:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    Camera.CFrame = CFrame.new(character.HumanoidRootPart.Position - (character.HumanoidRootPart.CFrame.LookVector * 10), character.HumanoidRootPart.Position)
                end
            end)
        else
            if getgenv().ThirdPersonConnection then getgenv().ThirdPersonConnection:Disconnect() end
            Camera.CameraType = Enum.CameraType.Custom
        end
    end
})

-- Camera Shake (Тряска камеры)
MainTab:CreateToggle({
    Name = "Тряска камеры",
    CurrentValue = false,
    Flag = "CameraShake",
    Callback = function(Value)
        if Value then
            getgenv().CameraShakeConnection = RunService.RenderStepped:Connect(function()
                Camera.CFrame = Camera.CFrame * CFrame.Angles(math.random(-0.1, 0.1), math.random(-0.1, 0.1), math.random(-0.1, 0.1))
            end)
        else
            if getgenv().CameraShakeConnection then getgenv().CameraShakeConnection:Disconnect() end
        end
    end
})

-- **Вкладка Other Hubs**
local OtherHubsScripts = {
    {Name = "Vortex Hub", URL = "https://raw.githubusercontent.com/xyz/vortex.lua"},
    {Name = "Eclipse Hub", URL = "https://raw.githubusercontent.com/xyz/eclipse.lua"},
    {Name = "Phantom Hub", URL = "https://raw.githubusercontent.com/xyz/phantom.lua"}
}

for _, script in ipairs(OtherHubsScripts) do
    OtherHubsTab:CreateButton({
        Name = "Загрузить " .. script.Name,
        Callback = function()
            local success, err = pcall(function() loadstring(game:HttpGet(script.URL))() end)
            Rayfield:Notify({
                Title = script.Name,
                Content = success and "Успешно загружен " .. script.Name .. "!" or "Ошибка загрузки: " .. err,
                Duration = 5,
                Image = 4483362458
            })
        end
    })
end

-- Уведомление о загрузке
Rayfield:Notify({Title = "doxxswag Hub загружен", Content = "Добро пожаловать в doxxswag Hub!", Duration = 5, Image = 4483362458})
