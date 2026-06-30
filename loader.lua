local Env = getgenv()
if not Env.MM2Configuration then
    Env.MM2Configuration = {
        ESPEnabled = true,
        WalkWander = false,
        AutoGrabGun = false,
        MovementSpeed = 20,
        Noclip = false
    }
end
local Config = Env.MM2Configuration
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
MainFrame.Size = UDim2.new(0, 260, 0, 340)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -80, 1, 0)
HeaderTitle.Position = UDim2.new(0, 16, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "MM2"
HeaderTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
HeaderTitle.TextSize = 17
HeaderTitle.Font = Enum.Font.SourceSansSemibold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
MinimizeBtn.Position = UDim2.new(1, -56, 0, 10)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.TextSize = 14
MinimizeBtn.Font = Enum.Font.SourceSansSemibold
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = Header
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(1, 0)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -28, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.SourceSansSemibold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -16, 1, -52)
Content.Position = UDim2.new(0, 8, 0, 48)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 2
Content.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.Parent = MainFrame
local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.Parent = Content

local Minimized = false
local FullSize = UDim2.new(0, 260, 0, 340)
local MiniSize = UDim2.new(0, 260, 0, 44)
MinimizeBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        MainFrame:TweenSize(MiniSize, "Out", "Quad", 0.3)
        Content.Visible = false
        MinimizeBtn.Text = "+"
    else
        MainFrame:TweenSize(FullSize, "Out", "Quad", 0.3)
        Content.Visible = true
        MinimizeBtn.Text = "—"
    end
end)

local function AddSection(title)
    local sec = Instance.new("Frame")
    sec.Size = UDim2.new(1, 0, 0, 18)
    sec.BackgroundTransparency = 1
    sec.Parent = Content
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title:upper()
    lbl.TextColor3 = Color3.fromRGB(0, 200, 0)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.SourceSansSemibold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = sec
    Content.CanvasSize = UDim2.new(0, 0, 0, Content.CanvasSize.Y.Offset + 24)
end

local function AddToggle(name, default, callback)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 38)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    box.BorderSizePixel = 0
    box.Parent = Content
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 140, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = box
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 42, 0, 26)
    toggle.Position = UDim2.new(1, -56, 0.5, -13)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 220, 0) or Color3.fromRGB(60, 60, 60)
    toggle.BorderSizePixel = 0
    toggle.Parent = box
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.Position = default and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
    knob.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    knob.BorderSizePixel = 0
    knob.Parent = toggle
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local enabled = default
    local function updateVisual()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = enabled and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)}):Play()
        toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 220, 0) or Color3.fromRGB(60, 60, 60)
    end
    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            enabled = not enabled
            updateVisual()
            pcall(callback, enabled)
        end
    end)
    Content.CanvasSize = UDim2.new(0, 0, 0, Content.CanvasSize.Y.Offset + 44)
end

local function AddButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSansSemibold
    btn.BorderSizePixel = 0
    btn.Parent = Content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(callback)
    Content.CanvasSize = UDim2.new(0, 0, 0, Content.CanvasSize.Y.Offset + 42)
end

local CoinCounterLabel = Instance.new("TextLabel")
CoinCounterLabel.Size = UDim2.new(1, 0, 0, 20)
CoinCounterLabel.BackgroundTransparency = 1
CoinCounterLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
CoinCounterLabel.TextSize = 12
CoinCounterLabel.Font = Enum.Font.SourceSansBold
CoinCounterLabel.Text = "Coins: 0/40"
CoinCounterLabel.Parent = Content
Content.CanvasSize = UDim2.new(0, 0, 0, Content.CanvasSize.Y.Offset + 26)

AddSection("Sensors")
AddToggle("ESP", true, function(v) Config.ESPEnabled = v end)
AddToggle("Noclip", false, function(v) Config.Noclip = v end)
AddSection("Actions")
AddToggle("Walk Wander", false, function(v) Config.WalkWander = v end)
AddToggle("Grab Gun", false, function(v) Config.AutoGrabGun = v end)
AddButton("Reset All", function()
    Config.ESPEnabled = false
    Config.WalkWander = false
    Config.AutoGrabGun = false
    Config.Noclip = false
end)

local dragging, dragStart, frameStart = false, nil, nil
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        frameStart = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local IsScriptActive = true
local PlayerHighlights = {}
local RolesCache = {}
local CollectedCount = 0
local MAX_COINS = 40

local function FetchRoles()
    local remote = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
    if remote and remote:IsA("RemoteFunction") then
        local success, data = pcall(function() return remote:InvokeServer() end)
        if success and data then RolesCache = data end
    end
end

local function GetRole(plr)
    if RolesCache[plr.Name] and RolesCache[plr.Name].Role then return RolesCache[plr.Name].Role end
    local char = plr.Character
    if not char then return "Innocent" end
    local bp = plr:FindFirstChild("Backpack")
    local function hasTool(c, n)
        if not c then return false end
        for _, x in ipairs(c:GetChildren()) do if x:IsA("Tool") and x.Name == n then return true end end
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
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0.2
        PlayerHighlights[plr] = hl
    end
    hl.Adornee = char
    hl.Parent = char
    local role = GetRole(plr)
    hl.FillColor = role == "Murderer" and Color3.fromRGB(255, 0, 0) or role == "Sheriff" and Color3.fromRGB(0, 0, 255) or Color3.fromRGB(0, 255, 0)
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

task.spawn(function()
    while IsScriptActive do
        pcall(FetchRoles)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then pcall(ApplyESP, plr) end
        end
        task.wait(5)
    end
end)

local Blacklist = {}
local MaxRetries = 3

local function findAllCollectibles()
    local items = {}
    local myChar = LocalPlayer.Character
    if not myChar then return items end
    local hrp = myChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return items end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") then
            local isPlayerPart = false
            local current = obj
            while current do
                if current:IsA("Model") and Players:GetPlayerFromCharacter(current) then
                    isPlayerPart = true
                    break
                end
                current = current.Parent
            end
            if not isPlayerPart and not Blacklist[obj] then
                table.insert(items, obj)
            end
        end
    end

    table.sort(items, function(a, b)
        return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
    end)

    return items
end

task.spawn(function()
    while IsScriptActive do
        if Config.WalkWander then
            if CollectedCount >= MAX_COINS then
                Config.WalkWander = false
                CoinCounterLabel.Text = "Coins: " .. CollectedCount .. "/" .. MAX_COINS .. " DONE"
                task.wait(1)
                continue
            end

            local char = LocalPlayer.Character
            if not char then task.wait(0.5); continue end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then task.wait(0.5); continue end

            local items = findAllCollectibles()
            if #items == 0 then task.wait(2); continue end

            local target = items[1]
            local targetPos = target.Position
            local myPos = hrp.Position
            local safeY = math.max(targetPos.Y, 3)
            if math.abs(targetPos.Y - myPos.Y) > 10 then safeY = myPos.Y end
            local destination = Vector3.new(targetPos.X, safeY, targetPos.Z)

            local distToTarget = (destination - myPos).Magnitude
            if distToTarget > 3 then
                local speed = Config.MovementSpeed
                local duration = distToTarget / speed
                local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = CFrame.new(destination)})
                tween:Play()
                tween.Completed:Wait()
            end

            local collected = false
            for attempt = 1, MaxRetries do
                if not target.Parent or not target:FindFirstChild("TouchInterest") then break end
                pcall(function()
                    firetouchinterest(hrp, target, 0)
                    firetouchinterest(hrp, target, 1)
                end)
                task.wait(0.3)
                if not target.Parent or not target:FindFirstChild("TouchInterest") then
                    collected = true
                    CollectedCount = CollectedCount + 1
                    CoinCounterLabel.Text = "Coins: " .. CollectedCount .. "/" .. MAX_COINS
                    break
                end
            end

            if not collected then
                Blacklist[target] = true
                task.delay(10, function() Blacklist[target] = nil end)
            end

            task.wait(0.2)
        else
            task.wait(0.5)
        end
    end
end)

task.spawn(function()
    while IsScriptActive do
        if Config.AutoGrabGun then
            local gunDrop = Workspace:FindFirstChild("GunDrop")
            if gunDrop and gunDrop:IsA("Model") then
                local gunPart = nil
                for _, part in ipairs(gunDrop:GetDescendants()) do
                    if part:IsA("BasePart") and part:FindFirstChild("TouchInterest") then gunPart = part; break end
                end
                if gunPart then
                    local wasWander = Config.WalkWander
                    Config.WalkWander = false
                    local char = LocalPlayer.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local safePos = hrp.Position
                            local tween = TweenService:Create(hrp, TweenInfo.new((gunPart.Position - hrp.Position).Magnitude / Config.MovementSpeed), {CFrame = CFrame.new(gunPart.Position)})
                            tween:Play()
                            tween.Completed:Wait()
                            pcall(function() firetouchinterest(hrp, gunPart, 0); firetouchinterest(hrp, gunPart, 1) end)
                            task.wait(0.3)
                            tween = TweenService:Create(hrp, TweenInfo.new((safePos - hrp.Position).Magnitude / Config.MovementSpeed), {CFrame = CFrame.new(safePos)})
                            tween:Play()
                            tween.Completed:Wait()
                        end
                    end
                    if wasWander then Config.WalkWander = true end
                end
            end
        end
        task.wait(2)
    end
end)

RunService.Stepped:Connect(function()
    if not IsScriptActive then return end
    local char = LocalPlayer.Character
    if not char then return end
    if Config.Noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)
