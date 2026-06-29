local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local results = {}

local function sep(title)
    table.insert(results, "")
    table.insert(results, "========== " .. title .. " ==========")
end

sep("WORKSPACE ROOT")
for _, child in ipairs(Workspace:GetChildren()) do
    local info = "[" .. child.ClassName .. "] " .. child.Name
    if child:IsA("Model") then
        local children = {}
        for _, sub in ipairs(child:GetChildren()) do
            table.insert(children, sub.Name .. "(" .. sub.ClassName .. ")")
        end
        info = info .. " | children: " .. table.concat(children, ", ")
    end
    table.insert(results, info)
end

sep("COIN SEARCH")
local coinFound = false
for _, obj in ipairs(Workspace:GetDescendants()) do
    if string.find(obj.Name:lower(), "coin") then
        coinFound = true
        table.insert(results, "[ByName] " .. obj:GetFullName() .. " | " .. obj.ClassName)
    end
end
if not coinFound then
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "TouchInterest" then
            local parent = obj.Parent
            local parentPath = parent and parent:GetFullName() or "NIL"
            local parentClass = parent and parent.ClassName or "NIL"
            local grandParent = parent and parent.Parent
            local gpName = grandParent and grandParent.Name or "NIL"
            table.insert(results, "[TouchInterest] Parent: " .. parentPath .. " | ParentClass: " .. parentClass .. " | GrandParent: " .. gpName)
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Transparency < 0.5 then
            local c = obj.BrickColor.Name:lower()
            if c:find("yellow") or c:find("gold") then
                if not obj.Name:lower():find("wall") and not obj.Name:lower():find("floor") and not obj.Name:lower():find("door") then
                    table.insert(results, "[YellowPart] " .. obj:GetFullName() .. " | Color: " .. obj.BrickColor.Name)
                end
            end
        end
    end
    table.insert(results, "WARNING: No objects with 'coin' in name found!")
end

sep("DROPPED GUN SEARCH")
local droppedFound = false
for _, obj in ipairs(Workspace:GetChildren()) do
    if string.find(obj.Name:lower(), "gun") or string.find(obj.Name:lower(), "drop") then
        droppedFound = true
        local info = "[Dropped] " .. obj.Name .. " | " .. obj.ClassName
        if obj:IsA("Model") then
            for _, sub in ipairs(obj:GetDescendants()) do
                if sub:IsA("BasePart") and sub:FindFirstChild("TouchInterest") then
                    info = info .. " | TouchPart: " .. sub.Name
                end
            end
        end
        table.insert(results, info)
    end
end
if not droppedFound then
    table.insert(results, "No dropped guns found")
end

sep("PLAYER WEAPONS")
for _, player in ipairs(Players:GetPlayers()) do
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")
    local function scan(container, location)
        if not container then return end
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(results, "[Weapon] " .. player.Name .. " | " .. location .. " | " .. item.Name)
            end
        end
    end
    scan(char, "Character")
    scan(backpack, "Backpack")
end

sep("LOCAL PLAYER DATA")
table.insert(results, "Name: " .. LocalPlayer.Name)
table.insert(results, "Character: " .. (LocalPlayer.Character and "Exists" or "NIL"))
for _, child in ipairs(LocalPlayer:GetChildren()) do
    if child:IsA("StringValue") or child:IsA("BoolValue") or child:IsA("IntValue") then
        table.insert(results, "[PlayerValue] " .. child.Name .. " = " .. tostring(child.Value) .. " | " .. child.ClassName)
    end
end

sep("NETWORK EVENTS")
local function scanNetwork(container, depth)
    if depth > 3 then return end
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            table.insert(results, "[" .. child.ClassName .. "] " .. child:GetFullName())
        end
        if #child:GetChildren() > 0 then scanNetwork(child, depth + 1) end
    end
end
scanNetwork(ReplicatedStorage, 0)

sep("END")
for _, line in ipairs(results) do print(line) end
