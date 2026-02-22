-- =====================================================
-- 🛡️ SAFE HUB V1.04: MATERIAL DESIGN | MOBILE-FIRST
-- 🎮 Game: The Rake / Horror Games
-- 📱 Target: Delta, Arceus X (Android)
-- =====================================================

-- ================= SERVICES =================
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ================= CLEANUP ON RE-EXECUTION =================
pcall(function()
    if CoreGui:FindFirstChild("G_SH4") then
        CoreGui.G_SH4:Destroy()
    end
end)

-- ================= TRACKED RESOURCES =================
local activeHighlights = {}
local activeConnections = {}

local function trackConn(conn)
    table.insert(activeConnections, conn)
    return conn
end

local function trackHL(hl)
    table.insert(activeHighlights, hl)
    return hl
end

-- ================= COLORS =================
local C = {
    Bg        = Color3.fromRGB(28, 28, 30),
    Card      = Color3.fromRGB(44, 44, 46),
    CardHov   = Color3.fromRGB(55, 55, 60),
    Header    = Color3.fromRGB(22, 22, 24),
    Accent    = Color3.fromRGB(138, 180, 248),
    Text      = Color3.fromRGB(232, 234, 237),
    TextDim   = Color3.fromRGB(160, 160, 170),
    TextDark  = Color3.fromRGB(28, 28, 30),
    Off       = Color3.fromRGB(55, 55, 60),
    On        = Color3.fromRGB(138, 180, 248),
    Red       = Color3.fromRGB(255, 82, 82),
    Sep       = Color3.fromRGB(60, 60, 65),
}

-- ================= TWEEN =================
local twFast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local twSmooth = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function tw(obj, props, info)
    local t = TweenService:Create(obj, info or twFast, props)
    t:Play()
    return t
end

-- ================= GUI ROOT =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "G_SH4"
ScreenGui.Parent = CoreGui

-- ================= MAIN FRAME =================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "M"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = C.Bg
MainFrame.BackgroundTransparency = 0.05
MainFrame.Position = UDim2.new(0.5, -110, 0.15, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 370)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 14)
mc.Parent = MainFrame

-- ================= HEADER (OPAQUE) =================
local Header = Instance.new("Frame")
Header.Name = "H"
Header.Parent = MainFrame
Header.BackgroundColor3 = C.Header
Header.BackgroundTransparency = 0
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BorderSizePixel = 0
Header.ZIndex = 10

local hc = Instance.new("UICorner")
hc.CornerRadius = UDim.new(0, 14)
hc.Parent = Header

-- Fill bottom corners of header
local hb = Instance.new("Frame")
hb.Parent = Header
hb.BackgroundColor3 = C.Header
hb.BackgroundTransparency = 0
hb.Size = UDim2.new(1, 0, 0, 14)
hb.Position = UDim2.new(0, 0, 1, -14)
hb.BorderSizePixel = 0
hb.ZIndex = 10

-- Accent line
local al = Instance.new("Frame")
al.Name = "AL"
al.Parent = MainFrame
al.BackgroundColor3 = C.Accent
al.BackgroundTransparency = 0.3
al.Size = UDim2.new(1, 0, 0, 2)
al.Position = UDim2.new(0, 0, 0, 38)
al.BorderSizePixel = 0
al.ZIndex = 10

-- Title
local title = Instance.new("TextLabel")
title.Parent = Header
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 12, 0, 0)
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Font = Enum.Font.GothamMedium
title.Text = "🛡️ Safe Hub V4"
title.TextColor3 = C.Text
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 11

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Name = "Min"
minBtn.Parent = Header
minBtn.BackgroundTransparency = 1
minBtn.Position = UDim2.new(1, -38, 0, 0)
minBtn.Size = UDim2.new(0, 38, 0, 38)
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "–"
minBtn.TextColor3 = C.Accent
minBtn.TextSize = 20
minBtn.ZIndex = 11

-- ================= TAB BAR =================
local tabBar = Instance.new("Frame")
tabBar.Name = "TB"
tabBar.Parent = MainFrame
tabBar.BackgroundColor3 = C.Bg
tabBar.BackgroundTransparency = 0.15
tabBar.Size = UDim2.new(1, 0, 0, 32)
tabBar.Position = UDim2.new(0, 0, 0, 40)
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 5

local tbl = Instance.new("UIListLayout")
tbl.Parent = tabBar
tbl.FillDirection = Enum.FillDirection.Horizontal
tbl.HorizontalAlignment = Enum.HorizontalAlignment.Center
tbl.Padding = UDim.new(0, 2)

local tabNames = {"⚡ Player", "👁️ Visuals", "⚔️ Exploits"}
local tabKeys = {"Player", "Visuals", "Exploits"}
local tabBtns = {}
local tabFrames = {}
local curTab = "Player"

-- Tab indicator
local tabInd = Instance.new("Frame")
tabInd.Name = "TI"
tabInd.Parent = tabBar
tabInd.BackgroundColor3 = C.Accent
tabInd.Size = UDim2.new(0, 60, 0, 2)
tabInd.Position = UDim2.new(0, 0, 1, -2)
tabInd.BorderSizePixel = 0
tabInd.ZIndex = 6

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Name = "T" .. i
    btn.Parent = tabBar
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(0, 70, 1, 0)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = name
    btn.TextSize = 10
    btn.TextColor3 = (i == 1) and C.Accent or C.TextDim
    btn.ZIndex = 6
    btn.AutoButtonColor = false
    tabBtns[tabKeys[i]] = btn
end

-- ================= CONTENT FRAMES =================
local contentBox = Instance.new("Frame")
contentBox.Name = "CB"
contentBox.Parent = MainFrame
contentBox.BackgroundTransparency = 1
contentBox.Position = UDim2.new(0, 0, 0, 74)
contentBox.Size = UDim2.new(1, 0, 1, -80)
contentBox.BorderSizePixel = 0

local function makeTab(key)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "F" .. key
    scroll.Parent = contentBox
    scroll.BackgroundColor3 = C.Card
    scroll.BackgroundTransparency = 0.3
    scroll.Size = UDim2.new(1, -8, 1, -4)
    scroll.Position = UDim2.new(0, 4, 0, 2)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 800)
    scroll.ScrollBarThickness = 2
    scroll.ScrollBarImageColor3 = C.Accent
    scroll.ScrollBarImageTransparency = 0.5
    scroll.BorderSizePixel = 0
    scroll.Visible = (key == "Player")
    scroll.ClipsDescendants = true

    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0, 10)
    cr.Parent = scroll

    local ly = Instance.new("UIListLayout")
    ly.Parent = scroll
    ly.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ly.Padding = UDim.new(0, 6)
    ly.SortOrder = Enum.SortOrder.LayoutOrder

    local pd = Instance.new("UIPadding")
    pd.Parent = scroll
    pd.PaddingTop = UDim.new(0, 6)
    pd.PaddingBottom = UDim.new(0, 6)

    tabFrames[key] = scroll
    return scroll
end

for _, key in ipairs(tabKeys) do
    makeTab(key)
end

-- ================= TAB SWITCHING =================
local function switchTab(key)
    if curTab == key then return end
    curTab = key
    for k, f in pairs(tabFrames) do
        f.Visible = (k == key)
    end
    for k, b in pairs(tabBtns) do
        tw(b, {TextColor3 = (k == key) and C.Accent or C.TextDim})
    end
    pcall(function()
        local ab = tabBtns[key]
        if ab then
            local rx = ab.AbsolutePosition.X - tabBar.AbsolutePosition.X
            tw(tabInd, {
                Position = UDim2.new(0, rx + 5, 1, -2),
                Size = UDim2.new(0, ab.AbsoluteSize.X - 10, 0, 2)
            })
        end
    end)
end

for key, btn in pairs(tabBtns) do
    btn.MouseButton1Click:Connect(function()
        switchTab(key)
    end)
end

task.defer(function()
    task.wait(0.1)
    switchTab("Player")
end)

-- ================= MINIMIZE / PILL =================
local isMin = false
local fullSize = UDim2.new(0, 220, 0, 370)
local pillSize = UDim2.new(0, 130, 0, 36)

minBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then
        tabBar.Visible = false
        contentBox.Visible = false
        al.Visible = false
        tw(MainFrame, {Size = pillSize}, twSmooth)
        minBtn.Text = "+"
    else
        tw(MainFrame, {Size = fullSize}, twSmooth)
        minBtn.Text = "–"
        task.delay(0.35, function()
            tabBar.Visible = true
            contentBox.Visible = true
            al.Visible = true
            switchTab(curTab)
        end)
    end
end)

-- ================= UI FACTORIES =================

local function CreateToggle(parent, text, callback, order)
    local h = Instance.new("Frame")
    h.Parent = parent
    h.BackgroundColor3 = C.Off
    h.BackgroundTransparency = 0.25
    h.Size = UDim2.new(0.92, 0, 0, 34)
    h.BorderSizePixel = 0
    h.LayoutOrder = order or 0

    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 10)

    local lbl = Instance.new("TextLabel")
    lbl.Parent = h
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text
    lbl.TextColor3 = C.Text
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd

    -- Switch track
    local swBg = Instance.new("Frame")
    swBg.Parent = h
    swBg.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
    swBg.BackgroundTransparency = 0.2
    swBg.Size = UDim2.new(0, 32, 0, 16)
    swBg.Position = UDim2.new(1, -40, 0.5, -8)
    swBg.BorderSizePixel = 0
    Instance.new("UICorner", swBg).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame")
    dot.Parent = swBg
    dot.BackgroundColor3 = C.TextDim
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 2, 0.5, -6)
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local hitBtn = Instance.new("TextButton")
    hitBtn.Parent = h
    hitBtn.BackgroundTransparency = 1
    hitBtn.Size = UDim2.new(1, 0, 1, 0)
    hitBtn.Text = ""
    hitBtn.ZIndex = 3

    local on = false
    hitBtn.MouseButton1Click:Connect(function()
        on = not on
        if on then
            tw(swBg, {BackgroundColor3 = C.Accent, BackgroundTransparency = 0.3})
            tw(dot, {Position = UDim2.new(1, -14, 0.5, -6), BackgroundColor3 = C.Accent})
            tw(h, {BackgroundColor3 = Color3.fromRGB(50, 60, 75), BackgroundTransparency = 0.15})
        else
            tw(swBg, {BackgroundColor3 = Color3.fromRGB(70, 70, 75), BackgroundTransparency = 0.2})
            tw(dot, {Position = UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = C.TextDim})
            tw(h, {BackgroundColor3 = C.Off, BackgroundTransparency = 0.25})
        end
        pcall(callback, on)
    end)

    return {Frame = h, GetState = function() return on end}
end

local function CreateButton(parent, text, callback, order)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = C.CardHov
    btn.BackgroundTransparency = 0.2
    btn.Size = UDim2.new(0.92, 0, 0, 34)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = text
    btn.TextColor3 = C.Text
    btn.TextSize = 11
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order or 0

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        tw(btn, {BackgroundColor3 = C.Accent, BackgroundTransparency = 0})
        task.wait(0.12)
        tw(btn, {BackgroundColor3 = C.CardHov, BackgroundTransparency = 0.2})
        pcall(callback)
    end)
    return btn
end

local function CreateSep(parent, order)
    local s = Instance.new("Frame")
    s.Parent = parent
    s.BackgroundColor3 = C.Sep
    s.BackgroundTransparency = 0.5
    s.Size = UDim2.new(0.85, 0, 0, 1)
    s.BorderSizePixel = 0
    s.LayoutOrder = order or 0
end

local function CreateLabel(parent, txt, order)
    local l = Instance.new("TextLabel")
    l.Parent = parent
    l.BackgroundColor3 = C.Bg
    l.BackgroundTransparency = 0.4
    l.Size = UDim2.new(0.92, 0, 0, 26)
    l.Font = Enum.Font.Gotham
    l.Text = txt
    l.TextColor3 = C.TextDim
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BorderSizePixel = 0
    l.LayoutOrder = order or 0
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 8)
    local p = Instance.new("UIPadding")
    p.Parent = l
    p.PaddingLeft = UDim.new(0, 8)
    return l
end

local function CreateSlider(parent, text, minV, maxV, def, callback, order)
    local h = Instance.new("Frame")
    h.Parent = parent
    h.BackgroundColor3 = C.Off
    h.BackgroundTransparency = 0.25
    h.Size = UDim2.new(0.92, 0, 0, 50)
    h.BorderSizePixel = 0
    h.LayoutOrder = order or 0
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 10)

    local lbl = Instance.new("TextLabel")
    lbl.Parent = h
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 10, 0, 2)
    lbl.Size = UDim2.new(1, -50, 0, 18)
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text
    lbl.TextColor3 = C.Text
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local vl = Instance.new("TextLabel")
    vl.Parent = h
    vl.BackgroundTransparency = 1
    vl.Position = UDim2.new(1, -45, 0, 2)
    vl.Size = UDim2.new(0, 35, 0, 18)
    vl.Font = Enum.Font.GothamMedium
    vl.Text = tostring(def)
    vl.TextColor3 = C.Accent
    vl.TextSize = 10
    vl.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame")
    track.Parent = h
    track.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
    track.BackgroundTransparency = 0.3
    track.Size = UDim2.new(0.85, 0, 0, 6)
    track.Position = UDim2.new(0.075, 0, 0, 32)
    track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Parent = track
    fill.BackgroundColor3 = C.Accent
    fill.BackgroundTransparency = 0.2
    fill.BorderSizePixel = 0
    local initP = math.clamp((def - minV) / (maxV - minV), 0, 1)
    fill.Size = UDim2.new(initP, 0, 1, 0)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("TextButton")
    knob.Parent = track
    knob.BackgroundColor3 = C.Accent
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(initP, -7, 0.5, -7)
    knob.BorderSizePixel = 0
    knob.Text = ""
    knob.AutoButtonColor = false
    knob.ZIndex = 3
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    knob.MouseButton1Down:Connect(function() dragging = true end)

    local uis = game:GetService("UserInputService")
    uis.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local tX = track.AbsolutePosition.X
            local tW = track.AbsoluteSize.X
            local pct = math.clamp((input.Position.X - tX) / tW, 0, 1)
            local val = math.floor(minV + pct * (maxV - minV) + 0.5)
            pct = (val - minV) / (maxV - minV)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            knob.Position = UDim2.new(pct, -7, 0.5, -7)
            vl.Text = tostring(val)
            pcall(callback, val)
        end
    end)
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end


-- ============================================================
--                     CHEAT LOGIC
-- ============================================================

local pTab = tabFrames["Player"]
local vTab = tabFrames["Visuals"]
local eTab = tabFrames["Exploits"]

-- ===================== PLAYER TAB =====================

-- 1. INFINITE STAMINA (periodic getgc re-scan — survives respawn)
local staminaOn = false
CreateToggle(pTab, "⚡ Inf Stamina", function(state)
    staminaOn = state
    if state then
        task.spawn(function()
            while staminaOn do
                pcall(function()
                    for _, v in pairs(getgc(true)) do
                        if type(v) == "table" then
                            if rawget(v, "STAMINA_REGEN") then
                                v.STAMINA_REGEN = 100
                                v.JUMP_STAMINA = 0
                                v.JUMP_COOLDOWN = 0
                                v.STAMINA_TAKE = 0
                                v.stamina = 100
                            end
                        end
                    end
                end)
                task.wait(3)
            end
        end)
    end
end, 1)

-- 2. INFINITE NVG
local nvgOn = false
CreateToggle(pTab, "🔋 Inf Night Vision", function(state)
    nvgOn = state
    if state then
        task.spawn(function()
            while nvgOn do
                pcall(function()
                    for _, v in pairs(getgc(true)) do
                        if type(v) == "table" then
                            if rawget(v, "NVG_TAKE") then
                                v.NVG_TAKE = 0
                                v.NVG_REGEN = 100
                            end
                        end
                    end
                end)
                task.wait(3)
            end
        end)
    end
end, 2)

-- 3. NO FALL DAMAGE (metatable hook — identical pattern to working v3)
local noFall = false
CreateToggle(pTab, "🛡️ No Fall Damage", function(state)
    noFall = state
end, 3)

-- Hook __namecall EXACTLY like original v3 — no newcclosure, no getnamecallmethod
if not _G._SH4Hook then
    _G._SH4Hook = true
    local mt = getrawmetatable(game)
    local oldNc = mt.__namecall
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
        return oldNc(self, ...)
    end
    setreadonly(mt, true)
end

CreateSep(pTab, 4)

-- 4. WALKSPEED
local speedOn = false
local speedVal = 16
CreateSlider(pTab, "🏃 WalkSpeed", 10, 35, 16, function(v)
    speedVal = v
end, 5)

CreateToggle(pTab, "🏃 Enable WalkSpeed", function(state)
    speedOn = state
end, 6)

trackConn(RunService.Heartbeat:Connect(function()
    if speedOn then
        pcall(function()
            local ch = LocalPlayer.Character
            if ch then
                local hum = ch:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = speedVal end
            end
        end)
    end
end))

-- 5. FOV
local fovOn = false
local fovVal = 70
CreateSlider(pTab, "🔭 Field Of View", 50, 120, 70, function(v)
    fovVal = v
end, 7)

CreateToggle(pTab, "🔭 Enable FOV", function(state)
    fovOn = state
    if not state then
        pcall(function() Workspace.CurrentCamera.FieldOfView = 70 end)
    end
end, 8)

trackConn(RunService.Heartbeat:Connect(function()
    if fovOn then
        pcall(function() Workspace.CurrentCamera.FieldOfView = fovVal end)
    end
end))


-- ===================== VISUALS TAB =====================

-- 1. ESP
local espOn = false
CreateToggle(vTab, "👁️ ESP (All)", function(state)
    espOn = state
    if not state then
        for i = #activeHighlights, 1, -1 do
            pcall(function()
                if activeHighlights[i] and activeHighlights[i].Parent then
                    activeHighlights[i]:Destroy()
                end
            end)
            table.remove(activeHighlights, i)
        end
    end
end, 1)

local function safeHL(parent, color, name)
    if not parent or parent:FindFirstChild(name) then return end
    local hl = Instance.new("Highlight")
    hl.Name = name
    hl.FillColor = color
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
    hl.Parent = parent
    trackHL(hl)
end

task.spawn(function()
    while task.wait(1) do
        if espOn then
            pcall(function()
                for _, p in pairs(Players:GetChildren()) do
                    if p ~= LocalPlayer and p.Character then
                        safeHL(p.Character, Color3.fromRGB(0, 255, 0), "SH4E")
                    end
                end
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name:match("Rake") or obj.Name == "Monster" then
                        safeHL(obj, Color3.fromRGB(255, 0, 0), "SH4E")
                    end
                    if obj.Name == "FlareGunPickUp" then
                        safeHL(obj, Color3.fromRGB(0, 225, 255), "SH4E")
                    end
                end
                if Workspace:FindFirstChild("Filter") and Workspace.Filter:FindFirstChild("ScrapSpawns") then
                    for _, s in pairs(Workspace.Filter.ScrapSpawns:GetDescendants()) do
                        if s.Name == "Scrap" then
                            safeHL(s, Color3.fromRGB(139, 69, 19), "SH4E")
                        end
                    end
                end
                if Workspace:FindFirstChild("Debris") and Workspace.Debris:FindFirstChild("SupplyCrates") then
                    for _, b in pairs(Workspace.Debris.SupplyCrates:GetChildren()) do
                        if b.Name == "Box" then
                            safeHL(b, Color3.fromRGB(255, 255, 0), "SH4E")
                        end
                    end
                end
            end)
        end
    end
end)

CreateSep(vTab, 2)

-- 2. DAY + NOFOG + 3RD PERSON
CreateToggle(vTab, "☀️ Day + NoFog + 3rdPerson", function(state)
    if state then
        Lighting.ClockTime = 14
        Lighting.FogEnd = 9e9
        Lighting.GlobalShadows = false
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMaxZoomDistance = 100
        pcall(function()
            game:GetService("ReplicatedStorage").CurrentLightingProperties.FogEnd.Value = 9e9
        end)
    else
        Lighting.ClockTime = 0
        Lighting.FogEnd = 200
        Lighting.GlobalShadows = true
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
        pcall(function()
            game:GetService("ReplicatedStorage").CurrentLightingProperties.FogEnd.Value = 75
        end)
    end
end, 3)

-- 3. PERSIST NOFOG (overrides game resetting fog)
local fogOn = false
CreateToggle(vTab, "🌫️ Persist NoFog", function(state)
    fogOn = state
end, 4)

trackConn(RunService.Heartbeat:Connect(function()
    if fogOn then
        pcall(function()
            game:GetService("ReplicatedStorage").CurrentLightingProperties.FogEnd.Value = 9e9
            Lighting.FogEnd = 9e9
        end)
    end
end))


-- ===================== EXPLOITS TAB =====================

-- 1. KILLAURA
local kaOn = false
CreateToggle(eTab, "⚔️ Smart KillAura (200m)", function(state)
    kaOn = state
end, 1)

task.spawn(function()
    while task.wait(0.1) do
        if kaOn then
            pcall(function()
                local rake = Workspace:FindFirstChild("Rake") or Workspace:FindFirstChild("Monster")
                local ch = LocalPlayer.Character
                if rake and ch and ch:FindFirstChild("StunStick") and ch:FindFirstChild("HumanoidRootPart") then
                    local rh = rake:FindFirstChild("HumanoidRootPart")
                    if rh and (rh.Position - ch.HumanoidRootPart.Position).Magnitude < 200 then
                        ch.StunStick.Event:FireServer("S")
                        task.wait(0.05)
                        ch.StunStick.Event:FireServer("H", rh)
                    end
                end
            end)
        end
    end
end)

CreateSep(eTab, 2)

-- 2. BRING SCRAP
CreateButton(eTab, "🧲 Bring All Scrap", function()
    pcall(function()
        local ch = LocalPlayer.Character
        if not ch then return end
        for _, v in pairs(Workspace.Filter.ScrapSpawns:GetDescendants()) do
            if v.Name:lower() == "scrap" then
                v:PivotTo(ch:GetPivot())
            end
        end
    end)
end, 3)

-- 3. INSTA OPEN ALL BOXES
CreateButton(eTab, "📦 Insta-Open ALL Boxes", function()
    pcall(function()
        for _, box in pairs(Workspace.Debris.SupplyCrates:GetChildren()) do
            if box.Name == "Box" then
                local gp = box:FindFirstChild("GUIPart")
                if gp and gp:FindFirstChild("ProximityPrompt") then
                    for attr, _ in pairs(gp.ProximityPrompt:GetAttributes()) do
                        gp.ProximityPrompt:SetAttribute(tostring(attr), false)
                    end
                end
                local uv = box:FindFirstChild("UnlockValue")
                if uv then uv.Value = 100 end
            end
        end
    end)
end, 4)

-- 4. REMOVE INVIS WALLS
CreateButton(eTab, "🧱 Remove Invisible Walls", function()
    pcall(function()
        for _, v in pairs(Workspace.Filter.InvisibleWalls:GetChildren()) do
            if v.Name:lower():match("invis") then
                v:Destroy()
            end
        end
    end)
end, 5)

-- 5. OPEN SAFEHOUSE DOOR
CreateButton(eTab, "🚪 Open SafeHouse Door", function()
    task.spawn(function()
        pcall(function()
            local ch = LocalPlayer.Character
            if not ch then return end
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local saved = hrp.CFrame
            local door = Workspace:FindFirstChild("Map")
                and Workspace.Map:FindFirstChild("SafeHouse")
                and Workspace.Map.SafeHouse:FindFirstChild("Door")
            if not door then return end

            hrp.CFrame = door.Door.CFrame + Vector3.new(0, -7, 0)
            task.wait(0.1)
            hrp.Anchored = true
            task.wait(0.4)
            door.RemoteEvent:FireServer("Door")
            task.wait(0.4)
            hrp.CFrame = saved
            task.wait()
            hrp.Anchored = false
        end)
    end)
end, 6)

-- 6. RESTORE POWER
CreateButton(eTab, "⚡ Restore Power", function()
    task.spawn(function()
        pcall(function()
            local ch = LocalPlayer.Character
            if not ch then return end
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local saved = hrp.CFrame
            local st = Workspace:FindFirstChild("Map")
                and Workspace.Map:FindFirstChild("PowerStation")
                and Workspace.Map.PowerStation:FindFirstChild("StationFolder")
            if not st then return end

            hrp.CFrame = CFrame.new(-280.8, 20.4, -212.2)
            hrp.Anchored = true
            task.wait(0.2)
            st.RemoteEvent:FireServer("StationStart")
            task.wait(20)
            hrp.CFrame = saved
            task.wait()
            hrp.Anchored = false
        end)
    end)
end, 7)

CreateSep(eTab, 8)

-- 7. INFO LABELS
local rkLabel = CreateLabel(eTab, "🎯 Rake Target: ...", 9)
local tmLabel = CreateLabel(eTab, "⏰ Timer: ...", 10)
local bhLabel = CreateLabel(eTab, "🩸 Blood Hour: No", 11)

local infoTick = 0
trackConn(RunService.Heartbeat:Connect(function(dt)
    infoTick = infoTick + dt
    if infoTick < 0.5 then return end
    infoTick = 0

    pcall(function()
        local rake = Workspace:FindFirstChild("Rake")
        if rake and rake:FindFirstChild("TargetVal") and rake.TargetVal.Value then
            rkLabel.Text = "  🎯 Target: " .. tostring(rake.TargetVal.Value.Parent)
        else
            rkLabel.Text = "  🎯 Target: None"
        end

        local rs = game:GetService("ReplicatedStorage")
        if rs:FindFirstChild("Night") and rs:FindFirstChild("Timer") then
            local pfx = rs.Night.Value and "⏰ Day in: " or "⏰ Night in: "
            tmLabel.Text = "  " .. pfx .. tostring(rs.Timer.Value)
        end

        if rs:FindFirstChild("InitiateBloodHour") then
            if rs.InitiateBloodHour.Value == true then
                bhLabel.Text = "  🩸 ⚠️ BLOOD HOUR!"
                bhLabel.TextColor3 = C.Red
            else
                bhLabel.Text = "  🩸 Blood Hour: No"
                bhLabel.TextColor3 = C.TextDim
            end
        end
    end)
end))

CreateSep(eTab, 12)

-- 8. UNLOAD
CreateButton(eTab, "🗑️ Unload Hub", function()
    for _, hl in pairs(activeHighlights) do
        pcall(function() hl:Destroy() end)
    end
    activeHighlights = {}

    for _, conn in pairs(activeConnections) do
        pcall(function() conn:Disconnect() end)
    end
    activeConnections = {}

    staminaOn = false
    nvgOn = false
    kaOn = false
    espOn = false
    speedOn = false
    fovOn = false
    fogOn = false
    noFall = false

    pcall(function() Workspace.CurrentCamera.FieldOfView = 70 end)
    pcall(function() ScreenGui:Destroy() end)
end, 13)
