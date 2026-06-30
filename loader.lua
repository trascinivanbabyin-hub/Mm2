-- [[ FIXED MM2 MULTIHACK: AUTOFARM + ESP ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

_G.SuperAutoFarm = false
_G.EspEnabled = false
_G.MoveSpeed = 22

if PlayerGui:FindFirstChild("PremiumMenu") then
    PlayerGui.PremiumMenu:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumMenu"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 180)
Frame.Position = UDim2.new(0.5, -120, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.Active = true
Frame.Parent = ScreenGui

local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 28)
FrameCorner.Parent = Frame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 18, 36)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 14))
})
MainGradient.Rotation = 45
MainGradient.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.5
UIStroke.Parent = Frame

local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(173, 93, 235)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(46, 182, 255))
})
StrokeGradient.Parent = UIStroke

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 12)
Title.BackgroundTransparency = 1
Title.Text = "MM2 MULTIHACK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 12)
SubTitle.Position = UDim2.new(0, 0, 0, 34)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Squircle Edition"
SubTitle.TextColor3 = Color3.fromRGB(150, 150, 160)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.SourceSans
SubTitle.Parent = Frame

local function createMenuButton(text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 190, 0, 38)
    btn.Position = UDim2.new(0.5, -95, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSansBold
    btn.AutoButtonColor = false
    btn.Parent = Frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 28, 30))
    })
    grad.Rotation = 90
    grad.Parent = btn

    return btn, grad
end

local FarmBtn, FarmGrad = createMenuButton("АВТОФАРМ: ВЫКЛ", 65)
local EspBtn, EspGrad = createMenuButton("ESP РАДАР: ВЫКЛ", 115)

local noclipConnection
noclipConnection = RunService.Stepped:Connect(function()
    if _G.SuperAutoFarm and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

local function smoothFly(targetPart)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if root and hum and hum.Health > 0 and targetPart and targetPart.Parent then
        local distance = (root.Position - targetPart.Position).Magnitude
        local duration = distance / _G.MoveSpeed
        
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, tweenInfo, {CFrame = targetPart.CFrame})
        tween:Play()
        
        while tween.PlaybackState == Enum.PlaybackState.Playing and _G.SuperAutoFarm do
            if not targetPart.Parent or not hum or hum.Health <= 0 then
                tween:Cancel()
                break
            end
            task.wait()
        end
    end
end

local function getCoinContainer()
    local normal = workspace:FindFirstChild("Normal")
    if normal and normal:FindFirstChild("CoinContainer") then
        return normal.CoinContainer
    end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "CoinContainer" or obj.Name == "CoinVisuals" then
            return obj
        end
    end
    return nil
end

local function startFarmLoop()
    task.spawn(function()
        while _G.SuperAutoFarm do
            task.wait(0.3)
            local container = getCoinContainer()
            
            if container and #container:GetChildren() > 0 then
                for _, coinData in pairs(container:GetChildren()) do
                    if not _G.SuperAutoFarm then break end
                    
                    local hum = LocalPlayer
                        
