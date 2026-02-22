-- =====================================================
-- 🛡️ SAFE HUB V1.04: MATERIAL DESIGN | MOBILE-FIRST
-- 🎮 Game: The Rake / Horror Games
-- 📱 Target: Delta, Arceus X (Android)
-- =====================================================

local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local WS = game:GetService("Workspace")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

pcall(function() if CoreGui:FindFirstChild("G_SH") then CoreGui.G_SH:Destroy() end end)

-- ================= TRACKED =================
local allHL, allConn = {}, {}
local function tC(c) table.insert(allConn, c) return c end
local function tH(h) table.insert(allHL, h) return h end

-- ================= COLORS (darker + more transparent) =================
local C = {
    Bg    = Color3.fromRGB(12, 12, 14),
    Card  = Color3.fromRGB(26, 26, 30),
    Hover = Color3.fromRGB(40, 40, 44),
    Head  = Color3.fromRGB(10, 10, 12),
    Acc   = Color3.fromRGB(120, 160, 235),
    Txt   = Color3.fromRGB(220, 222, 225),
    Dim   = Color3.fromRGB(120, 120, 130),
    Off   = Color3.fromRGB(38, 38, 42),
    Sep   = Color3.fromRGB(48, 48, 52),
    Red   = Color3.fromRGB(255, 70, 70),
}

local twF = TweenInfo.new(0.12, Enum.EasingStyle.Quad)
local twS = TweenInfo.new(0.25, Enum.EasingStyle.Quint)
local function tw(o, p, i) TweenService:Create(o, i or twF, p):Play() end

-- ================= GUI =================
local SG = Instance.new("ScreenGui")
SG.Name = "G_SH"
SG.Parent = CoreGui

local MF = Instance.new("Frame")
MF.Name = "M"
MF.Parent = SG
MF.BackgroundColor3 = C.Bg
MF.BackgroundTransparency = 0.25
MF.Position = UDim2.new(0.01, 0, 0.04, 0)
MF.Size = UDim2.new(0, 295, 0, 195)
MF.Active = true
MF.Draggable = true
MF.BorderSizePixel = 0
MF.ClipsDescendants = true
Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 12)

-- Header (opaque)
local HD = Instance.new("Frame")
HD.Parent = MF
HD.BackgroundColor3 = C.Head
HD.BackgroundTransparency = 0
HD.Size = UDim2.new(1, 0, 0, 22)
HD.BorderSizePixel = 0
HD.ZIndex = 10
Instance.new("UICorner", HD).CornerRadius = UDim.new(0, 12)

local HDB = Instance.new("Frame")
HDB.Parent = HD
HDB.BackgroundColor3 = C.Head
HDB.Size = UDim2.new(1, 0, 0, 11)
HDB.Position = UDim2.new(0, 0, 1, -11)
HDB.BorderSizePixel = 0
HDB.ZIndex = 10

local aL = Instance.new("Frame")
aL.Parent = MF
aL.BackgroundColor3 = C.Acc
aL.BackgroundTransparency = 0.5
aL.Size = UDim2.new(1, 0, 0, 1)
aL.Position = UDim2.new(0, 0, 0, 22)
aL.BorderSizePixel = 0
aL.ZIndex = 10

local TT = Instance.new("TextLabel")
TT.Parent = HD
TT.BackgroundTransparency = 1
TT.Position = UDim2.new(0, 8, 0, 0)
TT.Size = UDim2.new(0.7, 0, 1, 0)
TT.Font = Enum.Font.GothamMedium
TT.Text = "🛡️ V1.04"
TT.TextColor3 = C.Txt
TT.TextSize = 9
TT.TextXAlignment = Enum.TextXAlignment.Left
TT.ZIndex = 11

local MB = Instance.new("TextButton")
MB.Parent = HD
MB.BackgroundTransparency = 1
MB.Position = UDim2.new(1, -24, 0, 0)
MB.Size = UDim2.new(0, 24, 0, 22)
MB.Font = Enum.Font.GothamBold
MB.Text = "–"
MB.TextColor3 = C.Acc
MB.TextSize = 14
MB.ZIndex = 11

-- Tab bar (16px)
local TB = Instance.new("Frame")
TB.Parent = MF
TB.BackgroundColor3 = C.Bg
TB.BackgroundTransparency = 0.3
TB.Size = UDim2.new(1, 0, 0, 16)
TB.Position = UDim2.new(0, 0, 0, 23)
TB.BorderSizePixel = 0
TB.ZIndex = 5

local tabCfg = {
    {key="Player",  label="Player",  x=0.03},
    {key="Visuals", label="Visuals", x=0.35},
    {key="Exploits",label="Exploits",x=0.67},
}
local tabBtns, tabFrames = {}, {}
local curTab = "Player"

local TI = Instance.new("Frame")
TI.Parent = TB
TI.BackgroundColor3 = C.Acc
TI.Size = UDim2.new(0.28, 0, 0, 2)
TI.Position = UDim2.new(0.03, 0, 1, -2)
TI.BorderSizePixel = 0
TI.ZIndex = 7

for _, cfg in ipairs(tabCfg) do
    local b = Instance.new("TextButton")
    b.Parent = TB
    b.BackgroundTransparency = 1
    b.Position = UDim2.new(cfg.x, 0, 0, 0)
    b.Size = UDim2.new(0.30, 0, 1, 0)
    b.Font = Enum.Font.GothamMedium
    b.Text = cfg.label
    b.TextSize = 8
    b.TextColor3 = (cfg.key == "Player") and C.Acc or C.Dim
    b.ZIndex = 6
    b.AutoButtonColor = false
    tabBtns[cfg.key] = b
end

-- Content container
local CB = Instance.new("Frame")
CB.Parent = MF
CB.BackgroundTransparency = 1
CB.Position = UDim2.new(0, 0, 0, 40)
CB.Size = UDim2.new(1, 0, 1, -43)
CB.BorderSizePixel = 0

local function makeTab(key)
    local s = Instance.new("ScrollingFrame")
    s.Name = key
    s.Parent = CB
    s.BackgroundColor3 = C.Card
    s.BackgroundTransparency = 0.5
    s.Size = UDim2.new(1, -6, 1, -2)
    s.Position = UDim2.new(0, 3, 0, 1)
    s.CanvasSize = UDim2.new(0, 0, 0, 450)
    s.ScrollBarThickness = 2
    s.ScrollBarImageColor3 = C.Acc
    s.ScrollBarImageTransparency = 0.6
    s.BorderSizePixel = 0
    s.Visible = (key == "Player")
    s.ClipsDescendants = true
    Instance.new("UICorner", s).CornerRadius = UDim.new(0, 8)
    local ly = Instance.new("UIListLayout", s)
    ly.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ly.Padding = UDim.new(0, 3)
    ly.SortOrder = Enum.SortOrder.LayoutOrder
    local pd = Instance.new("UIPadding", s)
    pd.PaddingTop = UDim.new(0, 3)
    pd.PaddingBottom = UDim.new(0, 3)
    tabFrames[key] = s
end
for _, c in ipairs(tabCfg) do makeTab(c.key) end

local function switchTab(k)
    curTab = k
    for n, f in pairs(tabFrames) do f.Visible = (n == k) end
    for n, b in pairs(tabBtns) do tw(b, {TextColor3 = (n == k) and C.Acc or C.Dim}) end
    for i, c in ipairs(tabCfg) do
        if c.key == k then tw(TI, {Position = UDim2.new(c.x, 0, 1, -2)}) end
    end
end
for k, b in pairs(tabBtns) do b.MouseButton1Click:Connect(function() switchTab(k) end) end

-- Minimize
local isMin = false
MB.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then
        TB.Visible = false; CB.Visible = false; aL.Visible = false
        tw(MF, {Size = UDim2.new(0, 85, 0, 22)}, twS)
        MB.Text = "+"
    else
        tw(MF, {Size = UDim2.new(0, 295, 0, 195)}, twS)
        MB.Text = "–"
        task.delay(0.25, function() TB.Visible = true; CB.Visible = true; aL.Visible = true end)
    end
end)

-- ================= UI FACTORIES =================

local function Toggle(par, txt, cb, ord)
    local h = Instance.new("Frame")
    h.Parent = par; h.BackgroundColor3 = C.Off; h.BackgroundTransparency = 0.4
    h.Size = UDim2.new(0.96, 0, 0, 20); h.BorderSizePixel = 0; h.LayoutOrder = ord or 0
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", h)
    l.BackgroundTransparency = 1; l.Position = UDim2.new(0, 6, 0, 0)
    l.Size = UDim2.new(1, -36, 1, 0); l.Font = Enum.Font.Gotham; l.Text = txt
    l.TextColor3 = C.Txt; l.TextSize = 8; l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd

    local sw = Instance.new("Frame", h)
    sw.BackgroundColor3 = Color3.fromRGB(55, 55, 60); sw.BackgroundTransparency = 0.3
    sw.Size = UDim2.new(0, 24, 0, 11); sw.Position = UDim2.new(1, -28, 0.5, -5)
    sw.BorderSizePixel = 0
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local dt = Instance.new("Frame", sw)
    dt.BackgroundColor3 = C.Dim; dt.Size = UDim2.new(0, 9, 0, 9)
    dt.Position = UDim2.new(0, 1, 0.5, -4); dt.BorderSizePixel = 0
    Instance.new("UICorner", dt).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", h)
    btn.BackgroundTransparency = 1; btn.Size = UDim2.new(1, 0, 1, 0); btn.Text = ""; btn.ZIndex = 3

    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        if on then
            tw(sw, {BackgroundColor3 = C.Acc, BackgroundTransparency = 0.3})
            tw(dt, {Position = UDim2.new(1, -10, 0.5, -4), BackgroundColor3 = C.Acc})
            tw(h, {BackgroundTransparency = 0.25})
        else
            tw(sw, {BackgroundColor3 = Color3.fromRGB(55, 55, 60), BackgroundTransparency = 0.3})
            tw(dt, {Position = UDim2.new(0, 1, 0.5, -4), BackgroundColor3 = C.Dim})
            tw(h, {BackgroundTransparency = 0.4})
        end
        pcall(cb, on)
    end)
end

local function Btn(par, txt, cb, ord)
    local b = Instance.new("TextButton")
    b.Parent = par; b.BackgroundColor3 = C.Hover; b.BackgroundTransparency = 0.4
    b.Size = UDim2.new(0.96, 0, 0, 20); b.Font = Enum.Font.GothamMedium; b.Text = txt
    b.TextColor3 = C.Txt; b.TextSize = 8; b.AutoButtonColor = false
    b.BorderSizePixel = 0; b.LayoutOrder = ord or 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function()
        tw(b, {BackgroundColor3 = C.Acc, BackgroundTransparency = 0})
        task.wait(0.1)
        tw(b, {BackgroundColor3 = C.Hover, BackgroundTransparency = 0.4})
        pcall(cb)
    end)
end

local function Sep(par, ord)
    local s = Instance.new("Frame", par)
    s.BackgroundColor3 = C.Sep; s.BackgroundTransparency = 0.6
    s.Size = UDim2.new(0.88, 0, 0, 1); s.BorderSizePixel = 0; s.LayoutOrder = ord or 0
end

local function Lbl(par, txt, ord)
    local l = Instance.new("TextLabel", par)
    l.BackgroundColor3 = C.Bg; l.BackgroundTransparency = 0.55
    l.Size = UDim2.new(0.96, 0, 0, 16); l.Font = Enum.Font.Gotham; l.Text = "  " .. txt
    l.TextColor3 = C.Dim; l.TextSize = 7; l.TextXAlignment = Enum.TextXAlignment.Left
    l.BorderSizePixel = 0; l.LayoutOrder = ord or 0
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 5)
    return l
end

local function Stepper(par, txt, lo, hi, step, def, cb, ord)
    local h = Instance.new("Frame", par)
    h.BackgroundColor3 = C.Off; h.BackgroundTransparency = 0.4
    h.Size = UDim2.new(0.96, 0, 0, 20); h.BorderSizePixel = 0; h.LayoutOrder = ord or 0
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", h)
    l.BackgroundTransparency = 1; l.Position = UDim2.new(0, 6, 0, 0)
    l.Size = UDim2.new(0.5, 0, 1, 0); l.Font = Enum.Font.Gotham; l.Text = txt
    l.TextColor3 = C.Txt; l.TextSize = 8; l.TextXAlignment = Enum.TextXAlignment.Left

    local val = def
    local vl = Instance.new("TextLabel", h)
    vl.BackgroundTransparency = 1; vl.Position = UDim2.new(0.6, 0, 0, 0)
    vl.Size = UDim2.new(0.14, 0, 1, 0); vl.Font = Enum.Font.GothamMedium
    vl.Text = tostring(val); vl.TextColor3 = C.Acc; vl.TextSize = 8

    local function mkSB(t, xp, d)
        local s = Instance.new("TextButton", h)
        s.BackgroundColor3 = C.Hover; s.BackgroundTransparency = 0.3
        s.Size = UDim2.new(0, 16, 0, 13); s.Position = UDim2.new(xp, 0, 0.5, -6)
        s.Font = Enum.Font.GothamBold; s.Text = t; s.TextColor3 = C.Txt; s.TextSize = 11
        s.AutoButtonColor = false; s.BorderSizePixel = 0; s.ZIndex = 3
        Instance.new("UICorner", s).CornerRadius = UDim.new(0, 4)
        s.MouseButton1Click:Connect(function()
            val = math.clamp(val + d, lo, hi)
            vl.Text = tostring(val)
            pcall(cb, val)
            tw(s, {BackgroundColor3 = C.Acc})
            task.wait(0.06)
            tw(s, {BackgroundColor3 = C.Hover})
        end)
    end
    mkSB("–", 0.52, -step)
    mkSB("+", 0.82, step)
end

-- ============================================================
--                         LOGIC
-- ============================================================

local pT = tabFrames["Player"]
local vT = tabFrames["Visuals"]
local eT = tabFrames["Exploits"]

-- ==================== PLAYER ====================

local stamOn = false
Toggle(pT, "⚡ Inf Stamina", function(s)
    stamOn = s
    if s then task.spawn(function()
        while stamOn do
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" and rawget(v, "STAMINA_REGEN") then
                        v.STAMINA_REGEN = 100; v.JUMP_STAMINA = 0
                        v.JUMP_COOLDOWN = 0; v.STAMINA_TAKE = 0; v.stamina = 100
                    end
                end
            end)
            task.wait(3)
        end
    end) end
end, 1)

local nvgOn = false
Toggle(pT, "🔋 Inf Night Vision", function(s)
    nvgOn = s
    if s then task.spawn(function()
        while nvgOn do
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" and rawget(v, "NVG_TAKE") then
                        v.NVG_TAKE = 0; v.NVG_REGEN = 100
                    end
                end
            end)
            task.wait(3)
        end
    end) end
end, 2)

local noFall = false
Toggle(pT, "🛡️ No Fall Damage", function(s) noFall = s end, 3)

if not _G._SH1Hook then
    _G._SH1Hook = true
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = function(self, ...)
        if noFall == true then
            local args = {...}
            if tostring(self) == "FD_Event" then
                args[1] = 0; args[2] = 0
                return self.FireServer(self, unpack(args))
            end
        end
        return old(self, ...)
    end
    setreadonly(mt, true)
end

Sep(pT, 4)

local spdOn, spdVal = false, 16
Stepper(pT, "🏃 Speed", 10, 40, 2, 16, function(v) spdVal = v end, 5)
Toggle(pT, "🏃 Enable Speed", function(s) spdOn = s end, 6)

local fovOn, fovVal = false, 70
Stepper(pT, "🔭 FOV", 50, 120, 5, 70, function(v) fovVal = v end, 7)
Toggle(pT, "🔭 Enable FOV", function(s)
    fovOn = s
    if not s then pcall(function() WS.CurrentCamera.FieldOfView = 70 end) end
end, 8)


-- ==================== VISUALS ====================

local espP, espR, espS, espL = {}, {}, {}, {}

local function clearESP(t)
    for i = #t, 1, -1 do pcall(function() if t[i] and t[i].Parent then t[i]:Destroy() end end); table.remove(t, i) end
end

local function mkHL(par, col, nm, t)
    if not par or par:FindFirstChild(nm) then return end
    local h = Instance.new("Highlight")
    h.Name = nm; h.FillColor = col; h.OutlineColor = Color3.new(1, 1, 1)
    h.FillTransparency = 0.5; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = par
    table.insert(t, h); table.insert(allHL, h)
end

local function mkBB(par, txt, col, nm, t)
    if not par then return end
    local ex = par:FindFirstChild(nm)
    if ex then
        local tl = ex:FindFirstChild("T")
        if tl then tl.Text = txt end
        return
    end
    local bb = Instance.new("BillboardGui")
    bb.Name = nm; bb.Size = UDim2.new(0, 140, 0, 20)
    bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true
    bb.MaxDistance = 2000; bb.Parent = par
    local tl = Instance.new("TextLabel", bb)
    tl.Name = "T"; tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1
    tl.TextColor3 = col; tl.Text = txt; tl.TextSize = 11
    tl.Font = Enum.Font.GothamBold
    tl.TextStrokeTransparency = 0.5; tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    table.insert(t, bb); table.insert(allHL, bb)
end

local pEsp = false
Toggle(vT, "👤 Player ESP (blue)", function(s) pEsp = s; if not s then clearESP(espP) end end, 1)
local rEsp = false
Toggle(vT, "👹 Rake ESP (red)", function(s) rEsp = s; if not s then clearESP(espR) end end, 2)
local sEsp = false
Toggle(vT, "🔧 Scrap ESP (brown)", function(s) sEsp = s; if not s then clearESP(espS) end end, 3)
local lEsp = false
Toggle(vT, "🔫 Loot ESP (yellow)", function(s) lEsp = s; if not s then clearESP(espL) end end, 4)

-- Location ESP
local locOn = false
local locParts = {}
local LOCS = {
    {"Safe House",    Vector3.new(-363.5, 20, 70.3)},
    {"Shop",          Vector3.new(-25.2, 20, -258.4)},
    {"Power Station", Vector3.new(-281.7, 24, -212.7)},
    {"Base Camp",     Vector3.new(-70.7, 20, 209.0)},
}

Toggle(vT, "📍 Location Names", function(s)
    locOn = s
    if s then
        for _, loc in ipairs(LOCS) do
            local p = Instance.new("Part")
            p.Anchored = true; p.Transparency = 1; p.CanCollide = false
            p.Size = Vector3.new(0.1, 0.1, 0.1); p.Position = loc[2]; p.Parent = WS
            local bb = Instance.new("BillboardGui", p)
            bb.Size = UDim2.new(0, 110, 0, 18); bb.StudsOffset = Vector3.new(0, 6, 0)
            bb.AlwaysOnTop = true; bb.MaxDistance = 2000
            local tl = Instance.new("TextLabel", bb)
            tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1
            tl.TextColor3 = Color3.fromRGB(255, 160, 0); tl.Text = "📍 " .. loc[1]
            tl.TextSize = 11; tl.Font = Enum.Font.GothamBold
            tl.TextStrokeTransparency = 0.4; tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            table.insert(locParts, p); table.insert(allHL, p)
        end
    else
        for _, m in pairs(locParts) do pcall(function() m:Destroy() end) end
        locParts = {}
    end
end, 5)

Sep(vT, 6)

-- Day + NoFog (PERSISTENT — reactive override)
local dayOn = false
Toggle(vT, "☀️ Day + NoFog", function(s)
    dayOn = s
    if s then
        pcall(function()
            Lighting.ClockTime = 14; Lighting.FogEnd = 9e9; Lighting.GlobalShadows = false
            -- Override source values so game applies our values
            pcall(function()
                local clp = RS:FindFirstChild("CurrentLightingProperties")
                if clp then
                    if clp:FindFirstChild("FogEnd") then clp.FogEnd.Value = 9e9 end
                    if clp:FindFirstChild("ClockTime") then clp.ClockTime.Value = 14 end
                end
            end)
            -- Disable atmosphere effects
            for _, child in pairs(Lighting:GetChildren()) do
                if child:IsA("Atmosphere") then child.Density = 0; child.Offset = 0 end
                if child:IsA("BlurEffect") then child.Enabled = false end
                if child:IsA("ColorCorrectionEffect") then child.Brightness = 0; child.Contrast = 0 end
            end
        end)
    else
        pcall(function()
            Lighting.ClockTime = 0; Lighting.FogEnd = 200; Lighting.GlobalShadows = true
            pcall(function()
                local clp = RS:FindFirstChild("CurrentLightingProperties")
                if clp and clp:FindFirstChild("FogEnd") then clp.FogEnd.Value = 75 end
            end)
        end)
    end
end, 7)

-- 3rd Person (PERSISTENT — reactive override)
local tpOn = false
Toggle(vT, "📷 3rd Person", function(s)
    tpOn = s
    if s then
        -- ragdoll trick to kick out initially
        pcall(function()
            local ch = LP.Character
            if ch and ch:FindFirstChild("RagdollTime") then
                ch.RagdollTime.RagdollSwitch.Value = true
                task.wait()
                ch.RagdollTime.RagdollSwitch.Value = false
            end
        end)
        pcall(function()
            LP.CameraMode = Enum.CameraMode.Classic
            LP.CameraMaxZoomDistance = 100
            LP.CameraMinZoomDistance = 0.5
        end)
    else
        pcall(function() LP.CameraMode = Enum.CameraMode.LockFirstPerson end)
    end
end, 8)


-- ==================== EXPLOITS ====================

local kaOn = false
Toggle(eT, "⚔️ KillAura (200m)", function(s) kaOn = s end, 1)

task.spawn(function()
    while task.wait(0.1) do
        if kaOn then pcall(function()
            local rake = WS:FindFirstChild("Rake") or WS:FindFirstChild("Monster")
            local ch = LP.Character
            if rake and ch and ch:FindFirstChild("StunStick") and ch:FindFirstChild("HumanoidRootPart") then
                local rh = rake:FindFirstChild("HumanoidRootPart")
                if rh and (rh.Position - ch.HumanoidRootPart.Position).Magnitude < 200 then
                    ch.StunStick.Event:FireServer("S")
                    task.wait(0.05)
                    ch.StunStick.Event:FireServer("H", rh)
                end
            end
        end) end
    end
end)

local ioOn = false
Toggle(eT, "📦 Insta-Open Boxes", function(s) ioOn = s end, 2)

Sep(eT, 3)

Btn(eT, "🧲 Bring Scrap", function()
    pcall(function()
        local ch = LP.Character
        if ch then
            for _, v in pairs(WS.Filter.ScrapSpawns:GetDescendants()) do
                if v.Name:lower() == "scrap" then v:PivotTo(ch:GetPivot()) end
            end
        end
    end)
end, 4)

Btn(eT, "🧱 Remove Walls", function()
    pcall(function()
        for _, v in pairs(WS.Filter.InvisibleWalls:GetChildren()) do
            if v.Name:lower():match("invis") then v:Destroy() end
        end
    end)
end, 5)

-- Open SafeHouse door (just fire remote, no teleport)
Btn(eT, "🚪 Open SafeHouse", function()
    pcall(function() WS.Map.SafeHouse.Door.RemoteEvent:FireServer("Door") end)
end, 6)

-- Fix Power (just fire remote, no teleport)
Btn(eT, "⚡ Fix Power", function()
    pcall(function() WS.Map.PowerStation.StationFolder.RemoteEvent:FireServer("StationStart") end)
end, 7)

-- Multi-loot: fire supply crate event
Btn(eT, "📦 Grab Crate Loot", function()
    pcall(function() RS.SupplyClientEvent:FireServer("Open", true) end)
end, 8)

Sep(eT, 9)

local rkL = Lbl(eT, "🎯 Target: ...", 10)
local tmL = Lbl(eT, "⏰ Timer: ...", 11)
local bhL = Lbl(eT, "🩸 Blood Hour: No", 12)

Sep(eT, 13)

Btn(eT, "🗑️ Unload", function()
    for _, h in pairs(allHL) do pcall(function() h:Destroy() end) end; allHL = {}
    for _, c in pairs(allConn) do pcall(function() c:Disconnect() end) end; allConn = {}
    for _, m in pairs(locParts) do pcall(function() m:Destroy() end) end; locParts = {}
    stamOn, nvgOn, kaOn, pEsp, rEsp, sEsp, lEsp = false, false, false, false, false, false, false
    dayOn, tpOn, spdOn, fovOn, ioOn, noFall, locOn = false, false, false, false, false, false, false
    pcall(function() WS.CurrentCamera.FieldOfView = 70 end)
    pcall(function() LP.CameraMode = Enum.CameraMode.LockFirstPerson end)
    pcall(function() Lighting.ClockTime = 0; Lighting.FogEnd = 200; Lighting.GlobalShadows = true end)
    pcall(function() SG:Destroy() end)
end, 14)


-- ============================================================
--              HEARTBEAT: EVERY-FRAME ENFORCEMENT
-- ============================================================

-- Camera, Speed, FOV — every frame to prevent game overrides
tC(RunService.Heartbeat:Connect(function()
    -- 3rd Person: enforce every frame
    if tpOn then
        pcall(function()
            LP.CameraMode = Enum.CameraMode.Classic
            LP.CameraMaxZoomDistance = 100
            LP.CameraMinZoomDistance = 0.5
        end)
    end

    -- WalkSpeed: enforce every frame
    if spdOn then
        pcall(function()
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = spdVal end
        end)
    end

    -- FOV: enforce every frame
    if fovOn then
        pcall(function() WS.CurrentCamera.FieldOfView = fovVal end)
    end
end))

-- Reactive overrides: catch game resetting camera properties instantly
tC(LP:GetPropertyChangedSignal("CameraMode"):Connect(function()
    if tpOn then LP.CameraMode = Enum.CameraMode.Classic end
end))

tC(LP:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
    if tpOn then LP.CameraMaxZoomDistance = 100 end
end))

-- Day lighting: override every frame to prevent flicker
tC(RunService.Heartbeat:Connect(function()
    if dayOn then
        pcall(function()
            Lighting.ClockTime = 14
            Lighting.FogEnd = 9e9
            Lighting.GlobalShadows = false
        end)
        pcall(function()
            local clp = RS:FindFirstChild("CurrentLightingProperties")
            if clp then
                if clp:FindFirstChild("FogEnd") then clp.FogEnd.Value = 9e9 end
            end
        end)
    end
end))

-- Reactive: if game changes lighting, override immediately
tC(Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
    if dayOn then Lighting.ClockTime = 14 end
end))

tC(Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
    if dayOn then Lighting.FogEnd = 9e9 end
end))

-- InstaOpen boxes + Info labels — throttled (0.3s)
local tk = 0
tC(RunService.Heartbeat:Connect(function(dt)
    tk = tk + dt
    if tk < 0.3 then return end
    tk = 0

    if ioOn then pcall(function()
        for _, box in pairs(WS.Debris.SupplyCrates:GetChildren()) do
            if box.Name == "Box" then
                local gp = box:FindFirstChild("GUIPart")
                if gp and gp:FindFirstChild("ProximityPrompt") then
                    for attr, _ in pairs(gp.ProximityPrompt:GetAttributes()) do
                        gp.ProximityPrompt:SetAttribute(attr, false)
                    end
                end
                local uv = box:FindFirstChild("UnlockValue")
                if uv then uv.Value = 100 end
            end
        end
    end) end

    -- Info labels
    pcall(function()
        local rake = WS:FindFirstChild("Rake")
        if rake and rake:FindFirstChild("TargetVal") and rake.TargetVal.Value then
            rkL.Text = "  🎯 " .. tostring(rake.TargetVal.Value.Parent)
        else rkL.Text = "  🎯 Target: None" end
    end)
    pcall(function()
        if RS:FindFirstChild("Night") and RS:FindFirstChild("Timer") then
            local p = RS.Night.Value and "⏰ Day: " or "⏰ Night: "
            tmL.Text = "  " .. p .. tostring(RS.Timer.Value)
        end
    end)
    pcall(function()
        if RS:FindFirstChild("InitiateBloodHour") then
            if RS.InitiateBloodHour.Value == true then
                bhL.Text = "  🩸 ⚠️ BLOOD HOUR!"; bhL.TextColor3 = C.Red
            else
                bhL.Text = "  🩸 Blood Hour: No"; bhL.TextColor3 = C.Dim
            end
        end
    end)
end))

-- ESP scan (1.2s)
task.spawn(function()
    while task.wait(1.2) do
        if pEsp then pcall(function()
            for _, p in pairs(Players:GetChildren()) do
                if p ~= LP and p.Character then
                    mkHL(p.Character, Color3.fromRGB(0, 120, 255), "SE_P", espP)
                    mkBB(p.Character, p.Name, Color3.fromRGB(100, 180, 255), "SB_P", espP)
                end
            end
        end) end

        if rEsp then pcall(function()
            for _, obj in pairs(WS:GetChildren()) do
                if obj.Name:match("Rake") or obj.Name == "Monster" then
                    mkHL(obj, Color3.fromRGB(255, 0, 0), "SE_R", espR)
                    local hp = "Rake"
                    pcall(function()
                        if obj:FindFirstChild("Monster") then
                            hp = "Rake HP: " .. tostring(math.floor(obj.Monster.Health))
                        end
                    end)
                    mkBB(obj, hp, Color3.fromRGB(255, 80, 80), "SB_R", espR)
                end
            end
        end) end

        if sEsp then pcall(function()
            if WS:FindFirstChild("Filter") and WS.Filter:FindFirstChild("ScrapSpawns") then
                for _, s in pairs(WS.Filter.ScrapSpawns:GetDescendants()) do
                    if s.Name == "Scrap" then
                        local lv = "?"
                        pcall(function()
                            if s.Parent and s.Parent:FindFirstChild("LevelVal") then
                                lv = tostring(s.Parent.LevelVal.Value)
                            end
                        end)
                        mkHL(s, Color3.fromRGB(139, 69, 19), "SE_S", espS)
                        mkBB(s, "Scrap Lvl " .. lv, Color3.fromRGB(180, 120, 60), "SB_S", espS)
                    end
                end
            end
        end) end

        if lEsp then pcall(function()
            for _, obj in pairs(WS:GetChildren()) do
                if obj.Name == "FlareGunPickUp" then
                    mkHL(obj, Color3.fromRGB(255, 220, 0), "SE_L", espL)
                    mkBB(obj, "Flare Gun", Color3.fromRGB(255, 220, 0), "SB_L", espL)
                end
            end
            if WS:FindFirstChild("Debris") and WS.Debris:FindFirstChild("SupplyCrates") then
                for _, b in pairs(WS.Debris.SupplyCrates:GetChildren()) do
                    if b.Name == "Box" then
                        mkHL(b, Color3.fromRGB(255, 180, 0), "SE_L2", espL)
                        mkBB(b, "Supply Box", Color3.fromRGB(255, 200, 50), "SB_L2", espL)
                    end
                end
            end
        end) end
    end
end)
