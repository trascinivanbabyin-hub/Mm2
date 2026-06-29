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
MainFrame.Size = UDim2.new(0, 280, 0, 390)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -195)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Position = UDim2.new(0, 14, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "MM2 Hub"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 14
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0, 11)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Text = "x"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Page = Instance.new("ScrollingFrame")
Page.Size = UDim2.new(1, -14, 1, -54)
Page.Position = UDim2.new(0, 7, 0, 49)
Page.BackgroundTransparency = 1
Page.ScrollBarThickness = 2
Page.ScrollBarImageColor3 = Color3.fromRGB(120, 80, 255)
Page.CanvasSize = UDim2.new(0, 0, 0, 0)
Page.Parent = MainFrame
local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.Parent = Page

local function AddLabel(text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Color3.fromRGB(150, 150, 160)
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Page
    Page.CanvasSize = UDim2.new(0, 0, 0, Page.CanvasSize.Y.Offset + 22)
end

local function AddToggle(text, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 38)
    f.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
    f.BorderSizePixel = 0
    f.Parent = Page
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 120, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 225)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 40, 0, 22)
    bg.Position = UDim2.new(1, -50, 0.5, -11)
    bg.BackgroundColor3 = default and Color3.fromRGB(120, 80, 255) or Color3.fromRGB(50, 50, 55)
    bg.BorderSizePixel = 0
    bg.Parent = f
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BorderSizePixel = 0
    dot.Parent = bg
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local enabled = default
    bg.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            enabled = not enabled
            TweenService:Create(dot, TweenInfo.new(0.2), {Position = enabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
            TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = enabled and Color3.fromRGB(120, 80, 255) or Color3.fromRGB(50, 50, 55)}):Play()
            pcall(callback, enabled)
        end
    end)
    Page.CanvasSize = UDim2.new(0, 0, 0, Page.CanvasSize.Y.Offset + 44)
end

local function AddSlider(text, min, max, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 62)
    f.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
    f.BorderSizePixel = 0
    f.Parent = Page
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 14)
    lbl.Position = UDim2.new(0, 10, 0, 6)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(default)
    lbl.TextColor3 = Color3.fromRGB(200, 200, 205)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f
    local bar = Instance.new("TextButton")
    bar.Size = UDim2.new(1, -20, 0, 30)
    bar.Position = UDim2.new(0, 10, 0, 24)
    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    bar.BorderSizePixel = 0
    bar.Text = ""
    bar.AutoButtonColor = false
    bar.Parent = f
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 6)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 6)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BorderSizePixel = 0
    dot.Parent = bar
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local function update(val)
        local pct = (val - min) / (max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        dot.Position = UDim2.new(pct, -8, 0.5, -8)
        lbl.Text = text .. ": " .. tostring(val)
        pcall(callback, val)
    end
    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            local pct = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            update(math.floor(min + (max - min) * pct))
        end
    end)
    bar.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.Touch) then
                connection:Disconnect()
                return
            end
            local mousePos = UserInputService:GetMouseLocation()
            local barPos = bar.AbsolutePosition
            local barSize = bar.AbsoluteSize
            local pct = math.clamp((mousePos.X - barPos.X) / barSize.X, 0, 1)
            update(math.floor(min + (max - min) * pct))
        end)
    end)
    Page.CanvasSize = UDim2.new(0, 0, 0, Page.CanvasSize.Y.Offset + 68)
end

local function AddButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = color or Color3.fromRGB(120, 80, 255)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = Page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    Page.CanvasSize = UDim2.new(0, 0, 0, Page.CanvasSize.Y.Offset + 40)
end

AddLabel("FARM", Color3.fromRGB(120, 80, 255))
AddToggle("Auto Farm", false, function(v) Config.AutofarmEnabled = v end)
AddToggle("Auto Grab Gun", false, function(v) Config.AutoGrabGun = v end)
AddLabel("MOVEMENT", Color3.fromRGB(80, 180, 255))
AddToggle("Noclip", false, function(v) Config.Noclip = v end)
AddSlider("Speed", 10, 40, 22, function(v) Config.MovementSpeed = v end)
AddLabel("VISUALS", Color3.fromRGB(255, 120, 80))
AddToggle("ESP", true, function(v) Config.ESPEnabled = v end)
AddButton("Stop All", Color3.fromRGB(255, 60, 60), function()
    Config.AutofarmEnabled = false
    Config.AutoGrabGun = false
    Config.ESPEnabled = false
    Config.Noclip = false
end)

local dragging, dragStart, frameStart = false, nil, nil
TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = inp.Position; frameStart = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local delta = inp.Position - dragStart
        MainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- ==================== CORE ====================
local IsScriptActive = true
local PlayerHighlights = {}
local CoinBlacklist = {}

local function GetRole(plr)
    local char = plr.Character
    if not char then return "Innocent" end
    local bp = plr:FindFirstChild("Backpack")
    local function hasTool(container, toolName)
        if not container then return false end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") and child.Name == toolName then return true end
        end
        return false
    end
    if hasTool(char, "Knife") or hasTool(bp, "Knife") then return "Murderer" end
    if hasTool(char, "Gun") or hasTool(bp, "Gun") then return "Sheriff" end
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

local function GetCoinPart(coinServer)
    for _, child in ipairs(coinServer:GetDescendants()) do
        if (child.Name == "MainCoin" or child.Name == "Coin") and child:IsA("BasePart") and child:FindFirstChild("TouchInterest") then
            return child
        end
    end
    return nil
end

local function FindNearestCoin()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local curPos = hrp.Position
    local nearestPart, nearestDist = nil, math.huge
    for _, coinServer in ipairs(Workspace:GetDescendants()) do
        if coinServer.Name == "Coin_Server" and coinServer:IsA("Model") then
            local parent = coinServer.Parent
            if parent and parent.Name == "CoinContainer" then
                local part = GetCoinPart(coinServer)
                if part and not CoinBlacklist[coinServer] then
                    local dist = (part.Position - curPos).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestPart = part
                    end
                end
            end
        end
    end
    return nearestPart, nearestDist
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
            local coinPart, dist = FindNearestCoin()
            if coinPart then
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then task.wait(0.5); continue end
                if dist > 3 then TweenTo(coinPart.Position, Config.MovementSpeed) end
                if (coinPart.Position - hrp.Position).Magnitude < 5 then
                    pcall(function()
                        firetouchinterest(hrp, coinPart, 0)
                        firetouchinterest(hrp, coinPart, 1)
                    end)
                    task.wait(0.4)
                else
                    CoinBlacklist[coinPart.Parent] = true
                    task.delay(5, function() if coinPart.Parent then CoinBlacklist[coinPart.Parent] = nil end end)
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
            local gunDrop = Workspace:FindFirstChild("GunDrop")
            if gunDrop and gunDrop:IsA("Model") then
                local gunPart = nil
                for _, child in ipairs(gunDrop:GetDescendants()) do
                    if (child.Name == "Handle" or child.Name == "Gun") and child:IsA("BasePart") and child:FindFirstChild("TouchInterest") then
                        gunPart = child
                        break
                    end
                end
                if gunPart then
                    local wasFarming = Config.AutofarmEnabled
                    Config.AutofarmEnabled = false
                    local char = LocalPlayer.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local safePos = hrp.Position
                            TweenTo(gunPart.Position, Config.MovementSpeed)
                            pcall(function()
                                firetouchinterest(hrp, gunPart, 0)
                                firetouchinterest(hrp, gunPart, 1)
                            end)
                            task.wait(0.5)
                            TweenTo(safePos, Config.MovementSpeed)
                        end
                    end
                    if wasFarming then Config.AutofarmEnabled = true end
                end
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
