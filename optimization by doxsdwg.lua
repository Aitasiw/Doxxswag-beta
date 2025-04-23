local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Optimization Hub",
    LoadingTitle = "Оптимизация",
    LoadingSubtitle = "Максимальная производительность",
    ConfigurationSaving = {Enabled = true, FolderName = "OptimizationHub", FileName = "config"},
    Discord = {Enabled = false},
    KeySystem = false
})

local MainTab = Window:CreateTab("Управление", 4483362458)

MainTab:CreateButton({
    Name = "Opt",
    Callback = function()
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
        
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material.SmoothPlastic
                part.TextureId = ""
                part.Reflectance = 0
                part.Transparency = math.max(part.Transparency, 0.7)
                part.CastShadow = false
                part.Anchored = true
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part:Destroy()
            end
        end
        
        Lighting.GlobalShadows = false
        Lighting.ShadowSoftness = 0
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        
        for _, effect in pairs(workspace:GetDescendants()) do
            if effect:IsA("ParticleEmitter") or effect:IsA("Fire") or effect:IsA("Smoke") or effect:IsA("Sparkles") then
                effect:Destroy()
            end
        end
        
        Camera.MaxAxisFieldOfView = 120
        Camera.FieldOfView = 120
        LocalPlayer.CameraMaxZoomDistance = 50
        
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        pcall(function() settings().Rendering.EnableFRM = false end)
        
        game:GetService("SoundService").AmbientReverb = Enum.ReverbType.NoReverb
        game:GetService("SoundService").DistanceFactor = 10000
        for _, sound in pairs(workspace:GetDescendants()) do
            if sound:IsA("Sound") then
                sound:Stop()
                sound.Volume = 0
            end
        end
        
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and (obj.Name:lower():find("decor") or obj.Name:lower():find("prop")) then
                obj:Destroy()
            end
        end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                    humanoid.WalkSpeed = 0
                end
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then rootPart.Anchored = true end
            end
        end
        
        for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "Rayfield" then
                gui.Enabled = false
            end
        end
        
        RunService:UnbindFromRenderStep("HeavyTasks")
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviroPhysicsThrottle.Disabled
        
        Rayfield:Notify({
            Title = "Оптимизация",
            Content = "Включена!",
            Duration = 3
        })
    end
})

MainTab:CreateButton({
    Name = "DelOpt",
    Callback = function()
        Lighting.FogEnd = 500
        Lighting.FogStart = 0
        
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material.Plastic
                part.Transparency = 0
                part.CastShadow = true
                part.Anchored = false
            end
        end
        
        Lighting.GlobalShadows = true
        Lighting.ShadowSoftness = 0.5
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Brightness = 0
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 1
        
        Camera.MaxAxisFieldOfView = 70
        Camera.FieldOfView = 70
        LocalPlayer.CameraMaxZoomDistance = 128
        
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level21
        pcall(function() settings().Rendering.EnableFRM = true end)
        
        game:GetService("SoundService").AmbientReverb = Enum.ReverbType.SmallRoom
        game:GetService("SoundService").DistanceFactor = 10
        for _, sound in pairs(workspace:GetDescendants()) do
            if sound:IsA("Sound") then
                sound.Volume = 1
                sound:Play()
            end
        end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    humanoid.WalkSpeed = 16
                end
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then rootPart.Anchored = false end
            end
        end
        
        for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                gui.Enabled = true
            end
        end
        
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviroPhysicsThrottle.Default
        
        Rayfield:Notify({
            Title = "Оптимизация",
            Content = "Отключена!",
            Duration = 3
        })
    end
})

Rayfield:Notify({
    Title = "Optimization Hub",
    Content = "Скрипт загружен! Нажми Opt для оптимизации.",
    Duration = 5
})
