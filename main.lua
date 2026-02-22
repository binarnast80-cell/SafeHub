-- ==========================================
-- 🛡️ SAFE HUB V3: ANTI-CHEAT BYPASS EDITION
-- 🎮 Game: The Rake / Horror Games
-- ==========================================

-- Защита интерфейса от обнаружения античитом
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("GoogleSafeHub") then
    CoreGui.GoogleSafeHub:Destroy()
end

-- ================= ИНТЕРФЕЙС =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GoogleSafeHub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(32, 33, 36)
MainFrame.Position = UDim2.new(0.5, -90, 0.2, 0)
MainFrame.Size = UDim2.new(0, 190, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundTransparency = 1
TopBar.Size = UDim2.new(1, 0, 0, 40)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.GothamMedium
Title.Text = "🛡️ Safe Hub V3"
Title.TextColor3 = Color3.fromRGB(232, 234, 237)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = TopBar
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Position = UDim2.new(1, -40, 0, 0)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Font = Enum.Font.GothamMedium
ToggleBtn.Text = "–"
ToggleBtn.TextColor3 = Color3.fromRGB(138, 180, 248)
ToggleBtn.TextSize = 20

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.Size = UDim2.new(1, 0, 1, -50)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 680)
ContentFrame.ScrollBarThickness = 0

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ContentFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 8)
local Padding = Instance.new("UIPadding")
Padding.Parent = ContentFrame
Padding.PaddingTop = UDim.new(0, 5)

local isMinimized = false
ToggleBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ContentFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 140, 0, 40)
        ToggleBtn.Text = "+"
    else
        ContentFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 190, 0, 320)
        ToggleBtn.Text = "–"
    end
end)

local function CreateToggle(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = ContentFrame
    Btn.BackgroundColor3 = Color3.fromRGB(48, 49, 52)
    Btn.Size = UDim2.new(0.9, 0, 0, 38)
    Btn.Font = Enum.Font.Gotham
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(232, 234, 237)
    Btn.TextSize = 12
    Btn.AutoButtonColor = false
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 12)
    BtnCorner.Parent = Btn
    
    local isToggled = false
    Btn.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        if isToggled then
            Btn.BackgroundColor3 = Color3.fromRGB(138, 180, 248)
            Btn.TextColor3 = Color3.fromRGB(32, 33, 36)
        else
            Btn.BackgroundColor3 = Color3.fromRGB(48, 49, 52)
            Btn.TextColor3 = Color3.fromRGB(232, 234, 237)
        end
        callback(isToggled)
    end)
end

local function CreateButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = ContentFrame
    Btn.BackgroundColor3 = Color3.fromRGB(60, 64, 67)
    Btn.Size = UDim2.new(0.9, 0, 0, 38)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 12
    Btn.AutoButtonColor = false
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 12)
    BtnCorner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(138, 180, 248)
        task.wait(0.1)
        Btn.BackgroundColor3 = Color3.fromRGB(60, 64, 67)
        callback()
    end)
end

-- ================= ЛОГИКА С ОБХОДОМ АНТИЧИТА =================

-- 1. СУПЕР СТАМИНА (Выполняется 1 раз, чтобы не лагало)
CreateToggle("⚡ Беск. Стамина + ПНВ", function(state)
    if state then
        for i,v in pairs(getgc(true)) do
            if type(v) == "table" then
                if rawget(v, "STAMINA_REGEN") then
                    v.STAMINA_REGEN = 100
                    v.JUMP_STAMINA = 0
                    v.JUMP_COOLDOWN = 0
                    v.STAMINA_TAKE = 0
                    v.stamina = 100
                end
                if rawget(v, "NVG_TAKE") then
                    v.NVG_TAKE = 0
                    v.NVG_REGEN = 100
                end
            end
        end
    end
end)

-- 2. SMART KILL AURA (Без изменений, она безопасна)
local killaura = false
CreateToggle("⚔️ Smart KillAura (200m)", function(state)
    killaura = state
end)
task.spawn(function()
    while task.wait(0.1) do
        if killaura then
            pcall(function()
                local rake = Workspace:FindFirstChild("Rake") or Workspace:FindFirstChild("Monster")
                local char = LocalPlayer.Character
                if rake and char and char:FindFirstChild("StunStick") and char:FindFirstChild("HumanoidRootPart") then
                    if (rake.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude < 200 then
                        char.StunStick.Event:FireServer("S")
                        task.wait(0.05)
                        char.StunStick.Event:FireServer("H", rake.HumanoidRootPart)
                    end
                end
            end)
        end
    end
end)

-- 3. ОТКЛЮЧИТЬ УРОН ОТ ПАДЕНИЯ (Точная копия обхода из Desire)
local noFall = false
CreateToggle("🛡️ Нет урона от падения", function(state)
    noFall = state
end)

local mt = getrawmetatable(game)
local namecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(self, ...)
    if noFall == true then
        local args = {...}
        if tostring(self) == "FD_Event" then
            args[1] = 0
            args[2] = 0
            return self.FireServer(self, unpack(args))
        end
    end
    return namecall(self, ...)
end
setreadonly(mt, true)

-- 4. ESP (Оптимизированный)
local espEnabled = false
CreateToggle("👁️ ESP (Лут, Игроки, Рейк)", function(state)
    espEnabled = state
end)
local function createChams(part, color)
    if not part:FindFirstChild("SafeESP") then
        local hl = Instance.new("Highlight")
        hl.Name = "SafeESP"
        hl.FillColor = color
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        hl.Parent = part
    end
end
task.spawn(function()
    while task.wait(1) do
        if not espEnabled then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v.Name == "SafeESP" then v:Destroy() end
            end
        else
            for _, p in pairs(Players:GetChildren()) do
                if p ~= LocalPlayer and p.Character then createChams(p.Character, Color3.fromRGB(0, 255, 0)) end
            end
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj.Name:match("Rake") or obj.Name == "Monster" then createChams(obj, Color3.fromRGB(255, 0, 0)) end
                if obj.Name == "FlareGunPickUp" then createChams(obj, Color3.fromRGB(0, 225, 255)) end
            end
            pcall(function()
                for _, scrap in pairs(Workspace.Filter.ScrapSpawns:GetDescendants()) do
                    if scrap.Name == "Scrap" then createChams(scrap, Color3.fromRGB(139, 69, 19)) end
                end
                for _, box in pairs(Workspace.Debris.SupplyCrates:GetChildren()) do
                    if box.Name == "Box" then createChams(box, Color3.fromRGB(255, 255, 0)) end
                end
            end)
        end
    end
end)

-- 5. ТЕЛЕПОРТ СКРАПА К СЕБЕ
CreateButton("🧲 Притянуть весь Скрап", function()
    pcall(function()
        for _, v in pairs(Workspace.Filter.ScrapSpawns:GetDescendants()) do
            if v.Name:lower() == "scrap" and LocalPlayer.Character then
                v:PivotTo(LocalPlayer.Character:GetPivot())
            end
        end
    end)
end)

-- 6. МГНОВЕННЫЙ ВЗЛОМ ЯЩИКОВ
CreateButton("📦 Инста-открытие Ящиков", function()
    pcall(function()
        local box = Workspace.Debris.SupplyCrates:FindFirstChild("Box")
        if box and box:FindFirstChild("GUIPart") then
            for i, _ in pairs(box.GUIPart.ProximityPrompt:GetAttributes()) do
                box.GUIPart.ProximityPrompt:SetAttribute(tostring(i), false)
            end
            if box:FindFirstChild("UnlockValue") then box.UnlockValue.Value = 100 end
        end
    end)
end)

-- 7. УДАЛИТЬ НЕВИДИМЫЕ СТЕНЫ
CreateButton("🧱 Удалить невидимые стены", function()
    pcall(function()
        for _, v in pairs(Workspace.Filter.InvisibleWalls:GetChildren()) do
            if v.Name:lower() == "invisiblewall" or v.Name:lower() == "invis" then v:Destroy() end
        end
    end)
end)

-- 8. РЕЖИМ ПАНИКИ (ТП В НЕБО С ОБХОДОМ АНТИЧИТА)
local hidePart
CreateToggle("☁️ Спрятаться в небе (Hide)", function(state)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if state then
        if not hidePart then
            hidePart = Instance.new("Part")
            hidePart.Size = Vector3.new(20, 2, 20)
            hidePart.Position = Vector3.new(0, 5000, 0)
            hidePart.Anchored = true
            hidePart.Parent = Workspace
        end
        
        -- Тот самый "Танец" для сброса античита на телепорт
        hrp.Anchored = false
        for i = 1, 10 do
            hrp.CFrame = CFrame.new(hrp.Position) + Vector3.new(0, 5, 0)
            task.wait()
            hrp.CFrame = CFrame.new(hrp.Position) + Vector3.new(0, -5, 0)
        end
        hrp.CFrame = hidePart.CFrame + Vector3.new(0, 5, 0)
        task.wait()
        hrp.Anchored = true
    else
        -- Возвращаемся вниз тоже с "танцем"
        hrp.Anchored = false
        for i = 1, 10 do
            hrp.CFrame = CFrame.new(hrp.Position) + Vector3.new(0, 5, 0)
            task.wait()
            hrp.CFrame = CFrame.new(hrp.Position) + Vector3.new(0, -5, 0)
        end
        hrp.CFrame = CFrame.new(hrp.Position) + Vector3.new(0, 15, 0)
    end
end)

-- 9. ВИЗУАЛ (День + 3-е Лицо)
CreateToggle("☀️ День + 3-е Лицо + NoFog", function(state)
    if state then
        Lighting.ClockTime = 14
        Lighting.FogEnd = 9e9
        Lighting.GlobalShadows = false
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMaxZoomDistance = 100
    else
        Lighting.ClockTime = 0
        Lighting.FogEnd = 200
        Lighting.GlobalShadows = true
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    end
end)
