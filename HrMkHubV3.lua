-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/HrMk-GG/HrMkHubV3/refs/heads/main/HrMkHubV3.lua'))()

-- Create main window
local MainWindow = Rayfield:CreateWindow({
    Name = "HrMkHubV3",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by HrMk",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "HrMkHubV3_Config"
    },
    KeySystem = false,
})

-- Create main tab
local MainTab = MainWindow:CreateTab("Main", 4483362458) -- icon unchanged

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- ====================
-- Infinite Jump
-- ====================
local InfiniteJumpEnabled = false
UIS.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and char and hum then
        hum:ChangeState("Jumping")
    end
end)
MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(state)
        InfiniteJumpEnabled = state
    end,
})

-- ====================
-- WalkSpeed
-- ====================
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 250},
    Increment = 5,
    CurrentValue = 16,
    Suffix = "WS",
    Flag = "WalkSpeedSlider",
    Callback = function(v)
        if hum then hum.WalkSpeed = v end
    end
})

-- ====================
-- JumpPower
-- ====================
MainTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 500},
    Increment = 5,
    CurrentValue = 50,
    Suffix = "JP",
    Flag = "JumpPowerSlider",
    Callback = function(v)
        if hum then hum.JumpPower = v end
    end
})

-- ====================
-- Kill All (Test)
-- ====================
MainTab:CreateButton({
    Name = "Kill All (Test)",
    Callback = function()
        local Players = game:GetService("Players")
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                p.Character.Humanoid.Health = 0
            end
        end
        print("Kill All executed (Test)")
    end
})

-- ====================
-- No Clip
-- ====================
local NoClipEnabled = false
MainTab:CreateToggle({
    Name = "No Clip",
    CurrentValue = false,
    Flag = "NoClipToggle",
    Callback = function(state)
        NoClipEnabled = state
    end
})
RunService.Stepped:Connect(function()
    if NoClipEnabled and char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ====================
-- Fly
-- ====================
local FlyEnabled = false
local FlySpeed = 50
local flying = false

MainTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(state)
        FlyEnabled = state
    end
})
MainTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 500},
    Increment = 10,
    CurrentValue = 50,
    Suffix = "Speed",
    Flag = "FlySpeedSlider",
    Callback = function(v)
        FlySpeed = v
    end
})

UIS.InputBegan:Connect(function(input, gameProcessed)
    if FlyEnabled and not gameProcessed then
        if input.KeyCode == Enum.KeyCode.Space then flying = true end
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then flying = false end
end)
RunService.RenderStepped:Connect(function(delta)
    if FlyEnabled and flying and char and hrp then
        hrp.CFrame = hrp.CFrame + Vector3.new(0, FlySpeed * delta, 0)
    end
end)

-- ====================
-- Teleport to Mouse (Z)
-- ====================
local TeleportEnabled = false
MainTab:CreateToggle({
    Name = "Teleport to Mouse (Z)",
    CurrentValue = false,
    Flag = "TeleportToggle",
    Callback = function(state)
        TeleportEnabled = state
    end
})

UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and TeleportEnabled and input.KeyCode == Enum.KeyCode.Z then
        local mousePos = UIS:GetMouseLocation()
        local ray = camera:ScreenPointToRay(mousePos.X, mousePos.Y)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {char}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
        if result and hrp then
            hrp.CFrame = CFrame.new(result.Position + Vector3.new(0,3,0))
        end
    end
end)
