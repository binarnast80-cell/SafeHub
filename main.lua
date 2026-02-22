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
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

pcall(function()
    if CoreGui:FindFirstChild("G_SH") then CoreGui.G_SH:Destroy() end
end)

-- ================= TRACKED =================
local allHL = {}
local allConn = {}

local function tC(c) table.insert(allConn, c) return c end
local function tH(h) table.insert(allHL, h) return h end

-- ================= COLORS =================
local C = {
    Bg      = Color3.fromRGB(20, 20, 22),
    Card    = Color3.fromRGB(38, 38, 42),
    Hover   = Color3.fromRGB(50, 50, 55),
    Head    = Color3.fromRGB(16, 16, 18),
    Accent  = Color3.fromRGB(130, 170, 240),
    Txt     = Color3.fromRGB(225, 227, 230),
    Dim     = Color3.fromRGB(140, 140, 150),
    Dark    = Color3.fromRGB(20, 20, 22),
    Off     = Color3.fromRGB(48, 48, 52),
    Sep     = Color3.fromRGB(55, 55, 60),
    Red     = Color3.fromRGB(255, 75, 75),
}

local twF = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local twS = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local function tw(o, p, i) TweenService:Create(o, i or twF, p):Play() end

-- ================= SCREEN GUI =================
local SG = Instance.new("ScreenGui")
SG.Name = "G_SH"
SG.Parent = CoreGui

-- ================= MAIN FRAME (compact horizontal) =================
local MF = Instance.new("Frame")
MF.Name = "M"
MF.Parent = SG
MF.BackgroundColor3 = C.Bg
MF.BackgroundTransparency = 0.15
MF.Position = UDim2.new(0.01, 0, 0.05, 0)
MF.Size = UDim2.new(0, 295, 0, 195)
MF.Active = true
MF.Draggable = true
MF.BorderSizePixel = 0
MF.ClipsDescendants = true
Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 12)

-- ================= HEADER (opaque, 24px) =================
local HD = Instance.new("Frame")
HD.Parent = MF
HD.BackgroundColor3 = C.Head
HD.BackgroundTransparency = 0
HD.Size = UDim2.new(1, 0, 0, 24)
HD.BorderSizePixel = 0
HD.ZIndex = 10
Instance.new("UICorner", HD).CornerRadius = UDim.new(0, 12)

local HDB = Instance.new("Frame")
HDB.Parent = HD
HDB.BackgroundColor3 = C.Head
HDB.Size = UDim2.new(1, 0, 0, 12)
HDB.Position = UDim2.new(0, 0, 1, -12)
HDB.BorderSizePixel = 0
HDB.ZIndex = 10

-- Accent line
local AL = Instance.new("Frame")
AL.Parent = MF
AL.BackgroundColor3 = C.Accent
AL.BackgroundTransparency = 0.4
AL.Size = UDim2.new(1, 0, 0, 1)
AL.Position = UDim2.new(0, 0, 0, 24)
AL.BorderSizePixel = 0
AL.ZIndex = 10

-- Title
local TT = Instance.new("TextLabel")
TT.Parent = HD
TT.BackgroundTransparency = 1
TT.Position = UDim2.new(0, 10, 0, 0)
TT.Size = UDim2.new(0.7, 0, 1, 0)
TT.Font = Enum.Font.GothamMedium
TT.Text = "🛡️ V1.04"
TT.TextColor3 = C.Txt
TT.TextSize = 10
TT.TextXAlignment = Enum.TextXAlignment.Left
TT.ZIndex = 11

-- Minimize
local MB = Instance.new("TextButton")
MB.Parent = HD
MB.BackgroundTransparency = 1
MB.Position = UDim2.new(1, -28, 0, 0)
MB.Size = UDim2.new(0, 28, 0, 24)
MB.Font = Enum.Font.GothamBold
MB.Text = "–"
MB.TextColor3 = C.Accent
MB.TextSize = 16
MB.ZIndex = 11

-- ================= TAB BAR (18px, manual position) =================
local TB = Instance.new("Frame")
TB.Parent = MF
TB.BackgroundColor3 = C.Bg
TB.BackgroundTransparency = 0.2
TB.Size = UDim2.new(1, 0, 0, 18)
TB.Position = UDim2.new(0, 0, 0, 25)
TB.BorderSizePixel = 0
TB.ZIndex = 5

local tabCfg = {
    {key="Player",   label="Player",   x=0.03},
    {key="Visuals",  label="Visuals",  x=0.35},
    {key="Exploits", label="Exploits", x=0.67},
}

local tabBtns = {}
local tabFrames = {}
local curTab = "Player"

-- Tab indicator
local TI = Instance.new("Frame")
TI.Parent = TB
TI.BackgroundColor3 = C.Accent
TI.Size = UDim2.new(0.28, 0, 0, 2)
TI.Position = UDim2.new(0.03, 0, 1, -2)
TI.BorderSizePixel = 0
TI.ZIndex = 7

for _, cfg in ipairs(tabCfg) do
    local b = Instance.new("TextButton")
    b.Name = cfg.key
    b.Parent = TB
    b.BackgroundTransparency = 1
    b.Position = UDim2.new(cfg.x, 0, 0, 0)
    b.Size = UDim2.new(0.30, 0, 1, 0)
    b.Font = Enum.Font.GothamMedium
    b.Text = cfg.label
    b.TextSize = 9
    b.TextColor3 = (cfg.key == "Player") and C.Accent or C.Dim
    b.ZIndex = 6
    b.AutoButtonColor = false
    tabBtns[cfg.key] = b
end

-- ================= CONTENT =================
local CB = Instance.new("Frame")
CB.Parent = MF
CB.BackgroundTransparency = 1
CB.Position = UDim2.new(0, 0, 0, 44)
CB.Size = UDim2.new(1, 0, 1, -48)
CB.BorderSizePixel = 0

local function makeTab(key)
    local s = Instance.new("ScrollingFrame")
    s.Name = key
    s.Parent = CB
    s.BackgroundColor3 = C.Card
    s.BackgroundTransparency = 0.4
    s.Size = UDim2.new(1, -6, 1, -3)
    s.Position = UDim2.new(0, 3, 0, 1)
    s.CanvasSize = UDim2.new(0, 0, 0, 500)
    s.ScrollBarThickness = 2
    s.ScrollBarImageColor3 = C.Accent
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
    pd.PaddingTop = UDim.new(0, 4)
    pd.PaddingBottom = UDim.new(0, 4)
    tabFrames[key] = s
end

for _, cfg in ipairs(tabCfg) do makeTab(cfg.key) end

-- ================= TAB SWITCH =================
local function switchTab(key)
    curTab = key
    for k, f in pairs(tabFrames) do f.Visible = (k == key) end
    for k, b in pairs(tabBtns) do
        tw(b, {TextColor3 = (k == key) and C.Accent or C.Dim})
    end
    local idx = 1
    for i, cfg in ipairs(tabCfg) do
        if cfg.key == key then idx = i break end
    end
    tw(TI, {Position = UDim2.new(tabCfg[idx].x, 0, 1, -2)})
end

for key, btn in pairs(tabBtns) do
    btn.MouseButton1Click:Connect(function() switchTab(key) end)
end

-- ================= MINIMIZE =================
local isMin = false
local fullSz = UDim2.new(0, 295, 0, 195)
local pillSz = UDim2.new(0, 90, 0, 24)

MB.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then
        TB.Visible = false
        CB.Visible = false
        AL.Visible = false
        tw(MF, {Size = pillSz}, twS)
        MB.Text = "+"
    else
        tw(MF, {Size = fullSz}, twS)
        MB.Text = "–"
        task.delay(0.3, function()
            TB.Visible = true
            CB.Visible = true
            AL.Visible = true
        end)
    end
end)

-- ================= UI FACTORIES =================

local function Toggle(par, txt, cb, ord)
    local h = Instance.new("Frame")
    h.Parent = par
    h.BackgroundColor3 = C.Off
    h.BackgroundTransparency = 0.35
    h.Size = UDim2.new(0.95, 0, 0, 22)
    h.BorderSizePixel = 0
    h.LayoutOrder = ord or 0
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 7)

    local l = Instance.new("TextLabel")
    l.Parent = h
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 7, 0, 0)
    l.Size = UDim2.new(1, -42, 1, 0)
    l.Font = Enum.Font.Gotham
    l.Text = txt
    l.TextColor3 = C.Txt
    l.TextSize = 9
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd

    local sw = Instance.new("Frame")
    sw.Parent = h
    sw.BackgroundColor3 = Color3.fromRGB(65, 65, 70)
    sw.BackgroundTransparency = 0.2
    sw.Size = UDim2.new(0, 26, 0, 12)
    sw.Position = UDim2.new(1, -32, 0.5, -6)
    sw.BorderSizePixel = 0
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame")
    dot.Parent = sw
    dot.BackgroundColor3 = C.Dim
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(0, 1, 0.5, -5)
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Parent = h
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""
    btn.ZIndex = 3

    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        if on then
            tw(sw, {BackgroundColor3 = C.Accent, BackgroundTransparency = 0.3})
            tw(dot, {Position = UDim2.new(1, -11, 0.5, -5), BackgroundColor3 = C.Accent})
            tw(h, {BackgroundTransparency = 0.2})
        else
            tw(sw, {BackgroundColor3 = Color3.fromRGB(65, 65, 70), BackgroundTransparency = 0.2})
            tw(dot, {Position = UDim2.new(0, 1, 0.5, -5), BackgroundColor3 = C.Dim})
            tw(h, {BackgroundTransparency = 0.35})
        end
        pcall(cb, on)
    end)
    return h
end

local function Btn(par, txt, cb, ord)
    local b = Instance.new("TextButton")
    b.Parent = par
    b.BackgroundColor3 = C.Hover
    b.BackgroundTransparency = 0.3
    b.Size = UDim2.new(0.95, 0, 0, 22)
    b.Font = Enum.Font.GothamMedium
    b.Text = txt
    b.TextColor3 = C.Txt
    b.TextSize = 9
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.LayoutOrder = ord or 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    b.MouseButton1Click:Connect(function()
        tw(b, {BackgroundColor3 = C.Accent, BackgroundTransparency = 0})
        task.wait(0.1)
        tw(b, {BackgroundColor3 = C.Hover, BackgroundTransparency = 0.3})
        pcall(cb)
    end)
    return b
end

local function Sep(par, ord)
    local s = Instance.new("Frame")
    s.Parent = par
    s.BackgroundColor3 = C.Sep
    s.BackgroundTransparency = 0.6
    s.Size = UDim2.new(0.88, 0, 0, 1)
    s.BorderSizePixel = 0
    s.LayoutOrder = ord or 0
end

local function Lbl(par, txt, ord)
    local l = Instance.new("TextLabel")
    l.Parent = par
    l.BackgroundColor3 = C.Dark
    l.BackgroundTransparency = 0.5
    l.Size = UDim2.new(0.95, 0, 0, 18)
    l.Font = Enum.Font.Gotham
    l.Text = "  " .. txt
    l.TextColor3 = C.Dim
    l.TextSize = 8
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BorderSizePixel = 0
    l.LayoutOrder = ord or 0
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 6)
    return l
end

local function Stepper(par, txt, lo, hi, step, def, cb, ord)
    local h = Instance.new("Frame")
    h.Parent = par
    h.BackgroundColor3 = C.Off
    h.BackgroundTransparency = 0.35
    h.Size = UDim2.new(0.95, 0, 0, 22)
    h.BorderSizePixel = 0
    h.LayoutOrder = ord or 0
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 7)

    local l = Instance.new("TextLabel")
    l.Parent = h
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 7, 0, 0)
    l.Size = UDim2.new(0.5, 0, 1, 0)
    l.Font = Enum.Font.Gotham
    l.Text = txt
    l.TextColor3 = C.Txt
    l.TextSize = 9
    l.TextXAlignment = Enum.TextXAlignment.Left

    local val = def

    local vl = Instance.new("TextLabel")
    vl.Parent = h
    vl.BackgroundTransparency = 1
    vl.Position = UDim2.new(0.62, 0, 0, 0)
    vl.Size = UDim2.new(0.15, 0, 1, 0)
    vl.Font = Enum.Font.GothamMedium
    vl.Text = tostring(val)
    vl.TextColor3 = C.Accent
    vl.TextSize = 9

    local function makeStepBtn(txt2, xPos, delta)
        local sb = Instance.new("TextButton")
        sb.Parent = h
        sb.BackgroundColor3 = C.Hover
        sb.BackgroundTransparency = 0.3
        sb.Size = UDim2.new(0, 18, 0, 14)
        sb.Position = UDim2.new(xPos, 0, 0.5, -7)
        sb.Font = Enum.Font.GothamBold
        sb.Text = txt2
        sb.TextColor3 = C.Txt
        sb.TextSize = 12
        sb.AutoButtonColor = false
        sb.BorderSizePixel = 0
        sb.ZIndex = 3
        Instance.new("UICorner", sb).CornerRadius = UDim.new(0, 5)
        sb.MouseButton1Click:Connect(function()
            val = math.clamp(val + delta, lo, hi)
            vl.Text = tostring(val)
            pcall(cb, val)
            tw(sb, {BackgroundColor3 = C.Accent})
            task.wait(0.08)
            tw(sb, {BackgroundColor3 = C.Hover})
        end)
    end

    makeStepBtn("–", 0.54, -step)
    makeStepBtn("+", 0.85, step)
end


-- ============================================================
--                    LOGIC & FEATURES
-- ============================================================

local pT = tabFrames["Player"]
local vT = tabFrames["Visuals"]
local eT = tabFrames["Exploits"]

-- ==================== PLAYER TAB ====================

-- 1. INF STAMINA
local stamOn = false
Toggle(pT, "⚡ Inf Stamina", function(s)
    stamOn = s
    if s then
        task.spawn(function()
            while stamOn do
                pcall(function()
                    for _, v in pairs(getgc(true)) do
                        if type(v) == "table" and rawget(v, "STAMINA_REGEN") then
                            v.STAMINA_REGEN = 100
                            v.JUMP_STAMINA = 0
                            v.JUMP_COOLDOWN = 0
                            v.STAMINA_TAKE = 0
                            v.stamina = 100
                        end
                    end
                end)
                task.wait(3)
            end
        end)
    end
end, 1)

-- 2. INF NVG
local nvgOn = false
Toggle(pT, "🔋 Inf Night Vision", function(s)
    nvgOn = s
    if s then
        task.spawn(function()
            while nvgOn do
                pcall(function()
                    for _, v in pairs(getgc(true)) do
                        if type(v) == "table" and rawget(v, "NVG_TAKE") then
                            v.NVG_TAKE = 0
                            v.NVG_REGEN = 100
                        end
                    end
                end)
                task.wait(3)
            end
        end)
    end
end, 2)

-- 3. NO FALL DAMAGE
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
                args[1] = 0
                args[2] = 0
                return self.FireServer(self, unpack(args))
            end
        end
        return old(self, ...)
    end
    setreadonly(mt, true)
end

Sep(pT, 4)

-- 4. WALKSPEED
local spdOn = false
local spdVal = 16
Stepper(pT, "🏃 WalkSpeed", 10, 40, 2, 16, function(v) spdVal = v end, 5)
Toggle(pT, "🏃 Enable Speed", function(s) spdOn = s end, 6)

-- 5. FOV
local fovOn = false
local fovVal = 70
Stepper(pT, "🔭 FOV", 50, 120, 5, 70, function(v) fovVal = v end, 7)
Toggle(pT, "🔭 Enable FOV", function(s)
    fovOn = s
    if not s then pcall(function() Workspace.CurrentCamera.FieldOfView = 70 end) end
end, 8)


-- ==================== VISUALS TAB ====================

-- ESP tracked per type
local espP = {} -- player
local espR = {} -- rake
local espS = {} -- scrap
local espL = {} -- loot

local function clearESP(tbl)
    for i = #tbl, 1, -1 do
        pcall(function() if tbl[i] and tbl[i].Parent then tbl[i]:Destroy() end end)
        table.remove(tbl, i)
    end
end

local function mkHL(par, color, name, tbl)
    if not par or par:FindFirstChild(name) then return end
    local h = Instance.new("Highlight")
    h.Name = name
    h.FillColor = color
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    h.FillTransparency = 0.5
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = par
    table.insert(tbl, h)
    table.insert(allHL, h)
end

local function mkBB(par, txt, color, name, tbl)
    if not par or par:FindFirstChild(name) then
        -- update text if exists
        local existing = par and par:FindFirstChild(name)
        if existing then
            local tl = existing:FindFirstChild("T")
            if tl then tl.Text = txt end
        end
        return
    end
    local bb = Instance.new("BillboardGui")
    bb.Name = name
    bb.Size = UDim2.new(0, 120, 0, 22)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 500
    bb.Parent = par
    local tl = Instance.new("TextLabel")
    tl.Name = "T"
    tl.Parent = bb
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.BackgroundTransparency = 1
    tl.TextColor3 = color
    tl.Text = txt
    tl.TextSize = 11
    tl.Font = Enum.Font.GothamBold
    tl.TextStrokeTransparency = 0.6
    tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    table.insert(tbl, bb)
    table.insert(allHL, bb)
end

-- Separate ESP toggles
local pEspOn = false
Toggle(vT, "👤 Player ESP (blue)", function(s)
    pEspOn = s
    if not s then clearESP(espP) end
end, 1)

local rEspOn = false
Toggle(vT, "👹 Rake ESP (red)", function(s)
    rEspOn = s
    if not s then clearESP(espR) end
end, 2)

local sEspOn = false
Toggle(vT, "🔧 Scrap ESP (brown)", function(s)
    sEspOn = s
    if not s then clearESP(espS) end
end, 3)

local lEspOn = false
Toggle(vT, "🔫 Loot ESP (yellow)", function(s)
    lEspOn = s
    if not s then clearESP(espL) end
end, 4)

Sep(vT, 5)

-- DAY + NOFOG (persistent via Heartbeat)
local dayOn = false
Toggle(vT, "☀️ Day + NoFog", function(s)
    dayOn = s
    if not s then
        pcall(function()
            Lighting.ClockTime = 0
            Lighting.FogEnd = 200
            Lighting.GlobalShadows = true
            game:GetService("ReplicatedStorage").CurrentLightingProperties.FogEnd.Value = 75
        end)
    end
end, 6)

-- 3RD PERSON (persistent — enforced every frame)
local tpOn = false
Toggle(vT, "📷 3rd Person", function(s)
    tpOn = s
    if s then
        -- ragdoll trick to kick out of 1st person initially
        pcall(function()
            local ch = LocalPlayer.Character
            if ch and ch:FindFirstChild("RagdollTime") then
                ch.RagdollTime.RagdollSwitch.Value = true
                task.wait()
                ch.RagdollTime.RagdollSwitch.Value = false
            end
        end)
    else
        pcall(function()
            LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
        end)
    end
end, 7)


-- ==================== EXPLOITS TAB ====================

-- 1. KILLAURA
local kaOn = false
Toggle(eT, "⚔️ KillAura (200m)", function(s) kaOn = s end, 1)

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

-- 2. INSTA-OPEN BOXES (persistent toggle)
local ioOn = false
Toggle(eT, "📦 Insta-Open Boxes", function(s) ioOn = s end, 2)

Sep(eT, 3)

-- 3. BRING SCRAP
Btn(eT, "🧲 Bring Scrap", function()
    pcall(function()
        local ch = LocalPlayer.Character
        if not ch then return end
        for _, v in pairs(Workspace.Filter.ScrapSpawns:GetDescendants()) do
            if v.Name:lower() == "scrap" then
                v:PivotTo(ch:GetPivot())
            end
        end
    end)
end, 4)

-- 4. REMOVE WALLS
Btn(eT, "🧱 Remove Walls", function()
    pcall(function()
        for _, v in pairs(Workspace.Filter.InvisibleWalls:GetChildren()) do
            if v.Name:lower():match("invis") then v:Destroy() end
        end
    end)
end, 5)

-- 5. OPEN SAFEHOUSE DOOR (remote only, no teleport)
Btn(eT, "🚪 Open SafeHouse", function()
    pcall(function()
        Workspace.Map.SafeHouse.Door.RemoteEvent:FireServer("Door")
    end)
end, 6)

-- 6. RESTORE POWER (needs proximity — quick TP)
Btn(eT, "⚡ Fix Power (20s)", function()
    task.spawn(function()
        pcall(function()
            local ch = LocalPlayer.Character
            if not ch then return end
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local saved = hrp.CFrame
            hrp.CFrame = CFrame.new(-280.8, 20.4, -212.2)
            hrp.Anchored = true
            task.wait(0.2)
            Workspace.Map.PowerStation.StationFolder.RemoteEvent:FireServer("StationStart")
            task.wait(20)
            hrp.CFrame = saved
            task.wait()
            hrp.Anchored = false
        end)
    end)
end, 7)

Sep(eT, 8)

-- 7. INFO LABELS
local rkL = Lbl(eT, "🎯 Target: ...", 9)
local tmL = Lbl(eT, "⏰ Timer: ...", 10)
local bhL = Lbl(eT, "🩸 Blood Hour: No", 11)

Sep(eT, 12)

-- 8. UNLOAD
Btn(eT, "🗑️ Unload", function()
    for _, h in pairs(allHL) do pcall(function() h:Destroy() end) end
    allHL = {}
    for _, c in pairs(allConn) do pcall(function() c:Disconnect() end) end
    allConn = {}
    stamOn, nvgOn, kaOn, pEspOn, rEspOn, sEspOn, lEspOn = false, false, false, false, false, false, false
    dayOn, tpOn, spdOn, fovOn, ioOn, noFall = false, false, false, false, false, false
    pcall(function() Workspace.CurrentCamera.FieldOfView = 70 end)
    pcall(function() LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson end)
    pcall(function()
        Lighting.ClockTime = 0
        Lighting.FogEnd = 200
        Lighting.GlobalShadows = true
    end)
    pcall(function() SG:Destroy() end)
end, 13)


-- ============================================================
--           HEARTBEAT: ENFORCEMENT & ESP LOOP
-- ============================================================

-- Camera enforcement — every frame (prevents flicker on damage/pickup)
tC(RunService.Heartbeat:Connect(function()
    if tpOn then
        pcall(function()
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = 100
        end)
    end
end))

-- Throttled enforcement: day, speed, fov, instaopen, info labels
local tick1 = 0
tC(RunService.Heartbeat:Connect(function(dt)
    tick1 = tick1 + dt
    if tick1 < 0.25 then return end
    tick1 = 0

    -- Day + NoFog
    if dayOn then
        pcall(function()
            Lighting.ClockTime = 14
            Lighting.FogEnd = 9e9
            Lighting.GlobalShadows = false
            game:GetService("ReplicatedStorage").CurrentLightingProperties.FogEnd.Value = 9e9
        end)
    end

    -- WalkSpeed
    if spdOn then
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = spdVal end
        end)
    end

    -- FOV
    if fovOn then
        pcall(function() Workspace.CurrentCamera.FieldOfView = fovVal end)
    end

    -- InstaOpen boxes
    if ioOn then
        pcall(function()
            for _, box in pairs(Workspace.Debris.SupplyCrates:GetChildren()) do
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
        end)
    end

    -- Info labels
    pcall(function()
        local rake = Workspace:FindFirstChild("Rake")
        if rake and rake:FindFirstChild("TargetVal") and rake.TargetVal.Value then
            rkL.Text = "  🎯 Target: " .. tostring(rake.TargetVal.Value.Parent)
        else
            rkL.Text = "  🎯 Target: None"
        end
    end)

    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        if rs:FindFirstChild("Night") and rs:FindFirstChild("Timer") then
            local p = rs.Night.Value and "⏰ Day: " or "⏰ Night: "
            tmL.Text = "  " .. p .. tostring(rs.Timer.Value)
        end
    end)

    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        if rs:FindFirstChild("InitiateBloodHour") then
            if rs.InitiateBloodHour.Value == true then
                bhL.Text = "  🩸 ⚠️ BLOOD HOUR!"
                bhL.TextColor3 = C.Red
            else
                bhL.Text = "  🩸 Blood Hour: No"
                bhL.TextColor3 = C.Dim
            end
        end
    end)
end))

-- ESP scanning loop (every 1.2s)
task.spawn(function()
    while task.wait(1.2) do
        -- Player ESP
        if pEspOn then
            pcall(function()
                for _, p in pairs(Players:GetChildren()) do
                    if p ~= LocalPlayer and p.Character then
                        mkHL(p.Character, Color3.fromRGB(0, 120, 255), "SE_P", espP)
                        mkBB(p.Character, p.Name, Color3.fromRGB(100, 180, 255), "SB_P", espP)
                    end
                end
            end)
        end

        -- Rake ESP
        if rEspOn then
            pcall(function()
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name:match("Rake") or obj.Name == "Monster" then
                        mkHL(obj, Color3.fromRGB(255, 0, 0), "SE_R", espR)
                        local hpTxt = "Rake"
                        pcall(function()
                            if obj:FindFirstChild("Monster") then
                                hpTxt = "Rake HP: " .. tostring(math.floor(obj.Monster.Health))
                            end
                        end)
                        mkBB(obj, hpTxt, Color3.fromRGB(255, 80, 80), "SB_R", espR)
                    end
                end
            end)
        end

        -- Scrap ESP
        if sEspOn then
            pcall(function()
                if Workspace:FindFirstChild("Filter") and Workspace.Filter:FindFirstChild("ScrapSpawns") then
                    for _, s in pairs(Workspace.Filter.ScrapSpawns:GetDescendants()) do
                        if s.Name == "Scrap" then
                            local lvl = "?"
                            pcall(function()
                                if s.Parent and s.Parent:FindFirstChild("LevelVal") then
                                    lvl = tostring(s.Parent.LevelVal.Value)
                                end
                            end)
                            mkHL(s, Color3.fromRGB(139, 69, 19), "SE_S", espS)
                            mkBB(s, "Scrap Lvl " .. lvl, Color3.fromRGB(180, 120, 60), "SB_S", espS)
                        end
                    end
                end
            end)
        end

        -- Loot ESP (FlareGun + Boxes)
        if lEspOn then
            pcall(function()
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name == "FlareGunPickUp" then
                        mkHL(obj, Color3.fromRGB(255, 220, 0), "SE_L", espL)
                        mkBB(obj, "Flare Gun", Color3.fromRGB(255, 220, 0), "SB_L", espL)
                    end
                end
                if Workspace:FindFirstChild("Debris") and Workspace.Debris:FindFirstChild("SupplyCrates") then
                    for _, b in pairs(Workspace.Debris.SupplyCrates:GetChildren()) do
                        if b.Name == "Box" then
                            mkHL(b, Color3.fromRGB(255, 180, 0), "SE_L", espL)
                            mkBB(b, "Supply Box", Color3.fromRGB(255, 200, 50), "SB_L", espL)
                        end
                    end
                end
            end)
        end
    end
end)
