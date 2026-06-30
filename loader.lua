-- [[ MM2 PREMIUM CHEAT: AUTOFARM + ESP — iOS 18 CONCEPT ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

_G.SuperAutoFarm = false
_G.EspEnabled = false
_G.MoveSpeed = 22

if CoreGui:FindFirstChild("iOS18_PremiumMenu") then
    CoreGui.iOS18_PremiumMenu:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "iOS18_PremiumMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 180)
Frame.Position = UDim2.new(0.5, -120, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

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
SubTitle.Text = "iOS 18 Squircle Edition"
SubTitle.TextColor3 = Color3.fromRGB(150, 150, 160)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.SourceSans
SubTitle.Parent = Frame

local function createiOSButton(text, yPos)
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

local FarmBtn, FarmGrad = createiOSButton("АВТОФАРМ: ВЫКЛ", 65)
local EspBtn, EspGrad = createiOSButton("ESP РАДАР: ВЫКЛ", 115)

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

local function startFarmLoop()
    task.spawn(function()
        while _G.SuperAutoFarm do
            task.wait(0.2)
            local coinContainer = workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("CoinContainer")
            
            if coinContainer and #coinContainer:GetChildren() > 0 then
                for _, coinData in pairs(coinContainer:GetChildren()) do
                    if not _G.SuperAutoFarm then break end
                    
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local target = coinData:IsA("BasePart") and coinData or coinData:FindFirstChildWhichIsA("BasePart")
                        if target then
                            smoothFly(target)
                            task.wait(0.05)
                        end
                    else
                        task.wait(1)
                    end
                end
            else
                task.wait(0.5)
            end
        end
    end)
end

local function cleanESP(character)
    if character and character:FindFirstChild("iOS_ESP") then
        character.iOS_ESP:Destroy()
    end
end

local function applyESP(player)
    if player == LocalPlayer then return end
    
    local function setupHighlight(character)
        if not character then return end
        task.wait(0.5)
        cleanESP(character)
        
        if not _G.EspEnabled then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "iOS_ESP"
        highlight.Parent = character
        highlight.Adornee = character
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not _G.EspEnabled or not character or not character.Parent or not highlight or not highlight.Parent then
                if connection then connection:Disconnect() end
                return
            end
            
            local hasKnife = character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")
            local hasGun = character:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun")
            
            if hasKnife then
                highlight.FillColor = Color3.fromRGB(255, 59, 48)
                highlight.OutlineColor = Color3.fromRGB(255, 59, 48)
            elseif hasGun then
                highlight.FillColor = Color3.fromRGB(0, 122, 255)
                highlight.OutlineColor = Color3.fromRGB(0, 122, 255)
            else
                highlight.FillColor = Color3.fromRGB(52, 199, 89)
                highlight.OutlineColor = Color3.fromRGB(52, 199, 89)
            end
        end)
    end
    
    player.CharacterAdded:Connect(setupHighlight)
    if player.Character then setupHighlight(player.Character) end
end

for _, p in pairs(Players:GetPlayers()) do applyESP(p) end
Players.PlayerAdded:Connect(applyESP)

local function updateAllESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            if _G.EspEnabled then applyESP(p) else cleanESP(p.Character) end
        end
    end
end

FarmBtn.MouseButton1Click:Connect(function()
    _G.SuperAutoFarm = not _G.SuperAutoFarm
    if _G.SuperAutoFarm then
        FarmGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(52, 211, 153)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 197, 94))
        })
        FarmBtn.Text = "АВТОФАРМ: РАБОТАЕТ"
        FarmBtn.TextColor3 = Color3.fromRGB(10, 30, 10)
        startFarmLoop()
    else
        FarmGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 28, 30))
        })
        FarmBtn.Text = "АВТОФАРМ: ВЫКЛ"
        FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

EspBtn.MouseButton1Click:Connect(function()
    _G.EspEnabled = not _G.EspEnabled
    updateAllESP()
    if _G.EspEnabled then
        EspGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 165, 233)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 132, 199))
        })
        EspBtn.Text = "ESP РАДАР: ВКЛ"
        EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        EspGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 28, 30))
        })
        EspBtn.Text = "ESP РАДАР: ВЫКЛ"
        EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)
