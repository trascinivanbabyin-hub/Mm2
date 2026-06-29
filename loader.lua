local Env = getgenv()
if not Env.MM2Configuration then
    Env.MM2Configuration = {
        ESPEnabled = true,
        AutofarmEnabled = false,
        AutoGrabGun = false,
        MovementSpeed = 22,
        Noclip = false
    }
end
local Config = Env.MM2Configuration
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("MM2Hub_GUI") then CoreGui.MM2Hub_GUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2Hub_GUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -32, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
CloseBtn.Text = ""
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, 0, 1, -40)
PageContainer.Position = UDim2.new(0, 0, 0, 40)
PageContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
PageContainer.BorderSizePixel = 0
PageContainer.Parent = MainFrame

local Page = Instance.new("ScrollingFrame")
Page.Size = UDim2.new(1, -10, 1, -10)
Page.Position = UDim2.new(0, 5, 0, 5)
Page.BackgroundTransparency = 1
Page.ScrollBarThickness = 3
Page.ScrollBarImageColor3 = Color3.fromRGB(120, 80, 255)
Page.CanvasSize = UDim2.new(0, 0, 0, 0)
Page.Parent = PageContainer
local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 10)
Layout.Parent = Page

local function AddToggle(default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 36)
    f.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    f.BorderSizePixel = 0
    f.Parent = Page
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 44, 0, 24)
    bg.Position = UDim2.new(0.5, -22, 0.5, -12)
    bg.BackgroundColor3 = default and Color3.fromRGB(120, 80, 255) or Color3.fromRGB(60, 60, 65)
    bg.BorderSizePixel = 0
    bg.Parent = f
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 18, 0, 18)
    dot.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BorderSizePixel = 0
    dot.Parent = bg
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local enabled = default
    bg.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            enabled = not enabled
            TweenService:Create(dot, TweenInfo.new(0.2), {Position = enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}):Play()
            TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = enabled and Color3.fromRGB(120, 80, 255) or Color3.fromRGB(60, 60, 65)}):Play()
            pcall(callback, enabled)
        end
    end)
    Page.CanvasSize = UDim2.new(0, 0, 0, Page.CanvasSize.Y.Offset + 46)
end

local function AddSlider(min, max, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 50)
    f.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    f.BorderSizePixel = 0
    f.Parent = Page
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, 6)
    bar.Position = UDim2.new(0, 10, 0.5, -3)
    bar.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    bar.BorderSizePixel = 0
    bar.Parent = f
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BorderSizePixel = 0
    dot.Parent = bar
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function update(inp)
        local pct = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + (max - min) * pct)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        dot.Position = UDim2.new(pct, -7, 0.5, -7)
        pcall(callback, v)
    end
    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(inp) end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then update(inp) end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    Page.CanvasSize = UDim2.new(0, 0, 0, Page.CanvasSize.Y.Offset + 60)
end

local function AddButton(callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.Parent = Page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    Page.CanvasSize = UDim2.new(0, 0, 0, Page.CanvasSize.Y.Offset + 46)
end

-- 3 toggles: Auto Farm, Auto Grab Gun, Noclip
AddToggle(false, function(v) Config.AutofarmEnabled = v end)
AddToggle(false, function(v) Config.AutoGrabGun = v end)
AddToggle(false, function(v) Config.Noclip = v end)

-- ESP toggle (default on)
AddToggle(true, function(v) Config.ESPEnabled = v end)

-- Speed slider
AddSlider(10, 40, 22, function(v) Config.MovementSpeed = v end)

-- Stop all button
AddButton(function()
    Config.AutofarmEnabled = false
    Config.AutoGrabGun = false
    Config.ESPEnabled = false
    Config.Noclip = false
end)

-- Dragging
local dragging, dragStart, frameStart = false, nil, nil
TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = inp.Position; frameStart = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = inp.Position - dragStart
        MainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- ==================== CORE ====================
local IsScriptActive = true
local PlayerHighlights = {}
local CoinBlacklist = {}

local function GetRole(plr)
    local char = plr.Character
    local bp = plr:FindFirstChild("Backpack")
    local function has(container, name)
        return container and container:FindFirstChild(name) ~= nil
    end
    if has(bp, "Knife") or has(char, "Knife") then return "Murderer" end
    if has(bp, "Gun") or has(char, "Gun") then return "Sheriff" end
    return "Innocent"
end

local function ApplyESP(plr)
    if not Config.ESPEnabled or plr == LocalPlayer then return end
    local char = plr.Character
    if not char then
        if PlayerHighlights[plr] then PlayerHighlights[plr]:Destroy(); PlayerHighlights[plr] = nil end
        return
    end
    local hl = PlayerHighlights[plr]
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "ESP"
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = 0.4
        hl.OutlineTransparency = 0.2
        PlayerHighlights[plr] = hl
    end
    hl.Adornee = char
    hl.Parent = char
    local role = GetRole(plr)
    hl.FillColor = role == "Murderer" and Color3.fromRGB(255,0,0) or role == "Sheriff" and Color3.fromRGB(0,0,255) or Color3.fromRGB(0,255,0)
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function() ApplyESP(plr) end)
        plr.CharacterRemoving:Connect(function() if PlayerHighlights[plr] then PlayerHighlights[plr].Adornee = nil end end)
        task.spawn(function() ApplyESP(plr) end)
    end
end
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() ApplyESP(plr) end)
    plr.CharacterRemoving:Connect(function() if PlayerHighlights[plr] then PlayerHighlights[plr].Adornee = nil end end)
end)

local function FindNearestCoin()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local curPos = hrp.Position
    local nearest, nearestDist = nil, math.huge
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Coin" then
            local parent = obj.Parent
            if parent and (parent.Name:find("Coin") or parent.Name:find("CoinContainer")) and obj:FindFirstChild("TouchInterest") and not CoinBlacklist[obj] then
                local dist = (obj.Position - curPos).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = obj
                end
            end
        end
    end
    return nearest, nearestDist
end

local function TweenTo(target, speed)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (target - hrp.Position).Magnitude
    if dist < 0.5 then return end
    local tween = TweenService:Create(hrp, TweenInfo.new(dist / speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(target)})
    local done = false
    tween.Completed:Connect(function() done = true end)
    tween:Play()
    local start = tick()
    while not done and IsScriptActive do
        if tick() - start > dist / speed + 2 then tween:Cancel(); break end
        task.wait()
    end
end

task.spawn(function()
    while IsScriptActive do
        if Config.AutofarmEnabled then
            local coin, dist = FindNearestCoin()
            if coin then
                if dist > 3 then
                    TweenTo(coin.Position, Config.MovementSpeed)
                    if coin and coin.Parent then
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and (coin.Position - hrp.Position).Magnitude < 5 then
                            pcall(function()
                                firetouchinterest(hrp, coin, 0)
                                firetouchinterest(hrp, coin, 1)
                            end)
                        else
                            CoinBlacklist[coin] = true
                            task.delay(5, function() CoinBlacklist[coin] = nil end)
                        end
                    end
                else
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        pcall(function()
                            firetouchinterest(hrp, coin, 0)
                            firetouchinterest(hrp, coin, 1)
                        end)
                    end
                end
            else
                task.wait(1)
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while IsScriptActive do
        if Config.AutoGrabGun then
            local gun = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("DroppedGun")
            if gun then
                local wasFarming = Config.AutofarmEnabled
                Config.AutofarmEnabled = false
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local safePos = hrp.Position
                        TweenTo(gun.Position, Config.MovementSpeed)
                        pcall(function()
                            firetouchinterest(hrp, gun, 0)
                            firetouchinterest(hrp, gun, 1)
                        end)
                        task.wait(1)
                        TweenTo(safePos, Config.MovementSpeed)
                    end
                end
                if wasFarming then Config.AutofarmEnabled = true end
            end
        end
        task.wait(3)
    end
end)

RunService.Stepped:Connect(function()
    if not IsScriptActive then return end
    local char = LocalPlayer.Character
    if not char then return end
    if Config.Noclip or Config.AutofarmEnabled then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

task.spawn(function()
    while IsScriptActive do
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then pcall(ApplyESP, plr) end
        end
        task.wait(2)
    end
end)
