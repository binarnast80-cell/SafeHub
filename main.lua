-- =====================================================
-- 🛡️ SAFE HUB V4: MATERIAL DESIGN | MOBILE-FIRST
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ================= CLEANUP ON RE-EXECUTION =================
if CoreGui:FindFirstChild("SafeHubV4") then
    CoreGui.SafeHubV4:Destroy()
end

-- ================= TRACKED RESOURCES =================
local activeHighlights = {}  -- track all created Highlights for clean removal
local activeConnections = {} -- track RBXScriptConnections for unload
local activeCoroutines = {}  -- track spawned coroutines

local function trackConnection(conn)
    table.insert(activeConnections, conn)
    return conn
end

local function trackHighlight(hl)
    table.insert(activeHighlights, hl)
    return hl
end

-- ================= COLOR PALETTE =================
local Colors = {
    BgDark       = Color3.fromRGB(28, 28, 30),
    BgCard       = Color3.fromRGB(44, 44, 46),
    BgCardHover  = Color3.fromRGB(55, 55, 60),
    HeaderBg     = Color3.fromRGB(22, 22, 24),
    Accent       = Color3.fromRGB(138, 180, 248),
    AccentDim    = Color3.fromRGB(80, 120, 200),
    TextPrimary  = Color3.fromRGB(232, 234, 237),
    TextSecondary= Color3.fromRGB(160, 160, 170),
    TextDark     = Color3.fromRGB(28, 28, 30),
    ToggleOff    = Color3.fromRGB(55, 55, 60),
    ToggleOn     = Color3.fromRGB(138, 180, 248),
    Danger       = Color3.fromRGB(255, 82, 82),
    Success      = Color3.fromRGB(105, 240, 174),
    Warning      = Color3.fromRGB(255, 214, 0),
    Separator    = Color3.fromRGB(60, 60, 65),
}

-- ================= TWEEN HELPERS =================
local tweenFast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenSmooth = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function tween(obj, props, info)
    local t = TweenService:Create(obj, info or tweenFast, props)
    t:Play()
    return t
end

-- ================= SCREENGU =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SafeHubV4"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- ================= MAIN FRAME =================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Colors.BgDark
MainFrame.BackgroundTransparency = 0.05
MainFrame.Position = UDim2.new(0.5, -110, 0.15, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 370)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true  -- clean pill animation

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

-- Subtle drop shadow effect via UIStroke
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 0, 0)
MainStroke.Transparency = 0.6
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- ================= HEADER BAR (OPAQUE) =================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Colors.HeaderBg
Header.BackgroundTransparency = 0
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BorderSizePixel = 0
Header.ZIndex = 10

-- Round only top corners
local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

-- Cover bottom corner rounding with a thin frame
local HeaderBottom = Instance.new("Frame")
HeaderBottom.Parent = Header
HeaderBottom.BackgroundColor3 = Colors.HeaderBg
HeaderBottom.BackgroundTransparency = 0
HeaderBottom.Size = UDim2.new(1, 0, 0, 14)
HeaderBottom.Position = UDim2.new(0, 0, 1, -14)
HeaderBottom.BorderSizePixel = 0
HeaderBottom.ZIndex = 10

-- Accent underline
local AccentLine = Instance.new("Frame")
AccentLine.Name = "AccentLine"
AccentLine.Parent = MainFrame
AccentLine.BackgroundColor3 = Colors.Accent
AccentLine.BackgroundTransparency = 0.3
AccentLine.Size = UDim2.new(1, 0, 0, 2)
AccentLine.Position = UDim2.new(0, 0, 0, 38)
AccentLine.BorderSizePixel = 0
AccentLine.ZIndex = 10

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.GothamMedium
Title.Text = "🛡️ Safe Hub V4"
Title.TextColor3 = Colors.TextPrimary
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 11

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Parent = Header
MinBtn.BackgroundTransparency = 1
MinBtn.Position = UDim2.new(1, -38, 0, 0)
MinBtn.Size = UDim2.new(0, 38, 0, 38)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "–"
MinBtn.TextColor3 = Colors.Accent
MinBtn.TextSize = 20
MinBtn.ZIndex = 11

-- ================= TAB BAR =================
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Colors.BgDark
TabBar.BackgroundTransparency = 0.15
TabBar.Size = UDim2.new(1, 0, 0, 32)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 5

local TabBarLayout = Instance.new("UIListLayout")
TabBarLayout.Parent = TabBar
TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
TabBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabBarLayout.Padding = UDim.new(0, 2)

local tabNames = {"⚡ Player", "👁️ Visuals", "⚔️ Exploits"}
local tabKeys = {"Player", "Visuals", "Exploits"}
local tabButtons = {}
local tabFrames = {}
local currentTab = "Player"

-- Tab indicator (accent underline that moves with active tab)
local TabIndicator = Instance.new("Frame")
TabIndicator.Name = "TabIndicator"
TabIndicator.Parent = TabBar
TabIndicator.BackgroundColor3 = Colors.Accent
TabIndicator.Size = UDim2.new(0, 60, 0, 2)
TabIndicator.Position = UDim2.new(0, 0, 1, -2)
TabIndicator.BorderSizePixel = 0
TabIndicator.ZIndex = 6

-- Create tab buttons
for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. tabKeys[i]
    btn.Parent = TabBar
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(0, 70, 1, 0)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = name
    btn.TextSize = 10
    btn.TextColor3 = (i == 1) and Colors.Accent or Colors.TextSecondary
    btn.ZIndex = 6
    btn.AutoButtonColor = false
    tabButtons[tabKeys[i]] = btn
end

-- ================= CONTENT FRAMES (one per tab) =================
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 0, 0, 74)
ContentContainer.Size = UDim2.new(1, 0, 1, -80)
ContentContainer.BorderSizePixel = 0

local function createTabContent(key)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "Tab_" .. key
    scroll.Parent = ContentContainer
    scroll.BackgroundColor3 = Colors.BgCard
    scroll.BackgroundTransparency = 0.3
    scroll.Size = UDim2.new(1, -8, 1, -4)
    scroll.Position = UDim2.new(0, 4, 0, 2)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- auto-sized
    scroll.ScrollBarThickness = 2
    scroll.ScrollBarImageColor3 = Colors.Accent
    scroll.ScrollBarImageTransparency = 0.5
    scroll.BorderSizePixel = 0
    scroll.Visible = (key == "Player")
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = scroll

    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding")
    pad.Parent = scroll
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 6)

    tabFrames[key] = scroll
    return scroll
end

for _, key in ipairs(tabKeys) do
    createTabContent(key)
end

-- ================= TAB SWITCHING =================
local function switchTab(key)
    if currentTab == key then return end
    currentTab = key

    for k, frame in pairs(tabFrames) do
        frame.Visible = (k == key)
    end

    for k, btn in pairs(tabButtons) do
        tween(btn, {TextColor3 = (k == key) and Colors.Accent or Colors.TextSecondary})
    end

    -- Move indicator under active tab
    local activeBtn = tabButtons[key]
    if activeBtn then
        local pos = activeBtn.AbsolutePosition
        local barPos = TabBar.AbsolutePosition
        local relX = pos.X - barPos.X
        tween(TabIndicator, {
            Position = UDim2.new(0, relX + 5, 1, -2),
            Size = UDim2.new(0, activeBtn.AbsoluteSize.X - 10, 0, 2)
        })
    end
end

-- Hook tab clicks
for key, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(key)
    end)
end

-- Initial indicator position (deferred to let layout compute)
task.defer(function()
    task.wait(0.1)
    switchTab("Player")
end)

-- ================= MINIMIZE / PILL =================
local isMinimized = false
local expandedSize = UDim2.new(0, 220, 0, 370)
local pillSize = UDim2.new(0, 130, 0, 36)

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TabBar.Visible = false
        ContentContainer.Visible = false
        AccentLine.Visible = false
        tween(MainFrame, {Size = pillSize}, tweenSmooth)
        MinBtn.Text = "+"
    else
        tween(MainFrame, {Size = expandedSize}, tweenSmooth)
        MinBtn.Text = "–"
        task.delay(0.35, function()
            TabBar.Visible = true
            ContentContainer.Visible = true
            AccentLine.Visible = true
            -- Re-sync tab indicator
            switchTab(currentTab)
        end)
    end
end)

-- ================= UI FACTORY FUNCTIONS =================

local function CreateToggle(parent, text, callback, layoutOrder)
    local holder = Instance.new("Frame")
    holder.Name = "Toggle_" .. text
    holder.Parent = parent
    holder.BackgroundColor3 = Colors.ToggleOff
    holder.BackgroundTransparency = 0.25
    holder.Size = UDim2.new(0.92, 0, 0, 34)
    holder.BorderSizePixel = 0
    holder.LayoutOrder = layoutOrder or 0

    local hCorner = Instance.new("UICorner")
    hCorner.CornerRadius = UDim.new(0, 10)
    hCorner.Parent = holder

    local label = Instance.new("TextLabel")
    label.Parent = holder
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Colors.TextPrimary
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd

    -- Switch indicator (circle)
    local switchBg = Instance.new("Frame")
    switchBg.Parent = holder
    switchBg.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
    switchBg.BackgroundTransparency = 0.2
    switchBg.Size = UDim2.new(0, 32, 0, 16)
    switchBg.Position = UDim2.new(1, -40, 0.5, -8)
    switchBg.BorderSizePixel = 0
    local swBgCorner = Instance.new("UICorner")
    swBgCorner.CornerRadius = UDim.new(1, 0)
    swBgCorner.Parent = switchBg

    local switchDot = Instance.new("Frame")
    switchDot.Parent = switchBg
    switchDot.BackgroundColor3 = Colors.TextSecondary
    switchDot.Size = UDim2.new(0, 12, 0, 12)
    switchDot.Position = UDim2.new(0, 2, 0.5, -6)
    switchDot.BorderSizePixel = 0
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = switchDot

    local btn = Instance.new("TextButton")
    btn.Parent = holder
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""
    btn.ZIndex = 3

    local isToggled = false
    btn.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        if isToggled then
            tween(switchBg, {BackgroundColor3 = Colors.Accent, BackgroundTransparency = 0.3})
            tween(switchDot, {Position = UDim2.new(1, -14, 0.5, -6), BackgroundColor3 = Colors.Accent})
            tween(holder, {BackgroundColor3 = Color3.fromRGB(50, 60, 75), BackgroundTransparency = 0.15})
        else
            tween(switchBg, {BackgroundColor3 = Color3.fromRGB(70, 70, 75), BackgroundTransparency = 0.2})
            tween(switchDot, {Position = UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = Colors.TextSecondary})
            tween(holder, {BackgroundColor3 = Colors.ToggleOff, BackgroundTransparency = 0.25})
        end
        pcall(callback, isToggled)
    end)

    return {Frame = holder, GetState = function() return isToggled end}
end

local function CreateButton(parent, text, callback, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Name = "Btn_" .. text
    btn.Parent = parent
    btn.BackgroundColor3 = Colors.BgCardHover
    btn.BackgroundTransparency = 0.2
    btn.Size = UDim2.new(0.92, 0, 0, 34)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = text
    btn.TextColor3 = Colors.TextPrimary
    btn.TextSize = 11
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.LayoutOrder = layoutOrder or 0

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 10)
    bCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        -- Ripple-like flash
        tween(btn, {BackgroundColor3 = Colors.Accent, BackgroundTransparency = 0})
        task.wait(0.12)
        tween(btn, {BackgroundColor3 = Colors.BgCardHover, BackgroundTransparency = 0.2})
        pcall(callback)
    end)

    return btn
end

local function CreateSeparator(parent, layoutOrder)
    local sep = Instance.new("Frame")
    sep.Parent = parent
    sep.BackgroundColor3 = Colors.Separator
    sep.BackgroundTransparency = 0.5
    sep.Size = UDim2.new(0.85, 0, 0, 1)
    sep.BorderSizePixel = 0
    sep.LayoutOrder = layoutOrder or 0
    return sep
end

local function CreateInfoLabel(parent, initialText, layoutOrder)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = parent
    lbl.BackgroundColor3 = Colors.BgDark
    lbl.BackgroundTransparency = 0.4
    lbl.Size = UDim2.new(0.92, 0, 0, 26)
    lbl.Font = Enum.Font.Gotham
    lbl.Text = initialText
    lbl.TextColor3 = Colors.TextSecondary
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BorderSizePixel = 0
    lbl.LayoutOrder = layoutOrder or 0

    local lCorner = Instance.new("UICorner")
    lCorner.CornerRadius = UDim.new(0, 8)
    lCorner.Parent = lbl

    local lPad = Instance.new("UIPadding")
    lPad.Parent = lbl
    lPad.PaddingLeft = UDim.new(0, 8)

    return lbl
end

local function CreateSlider(parent, text, minVal, maxVal, default, callback, layoutOrder)
    local holder = Instance.new("Frame")
    holder.Name = "Slider_" .. text
    holder.Parent = parent
    holder.BackgroundColor3 = Colors.ToggleOff
    holder.BackgroundTransparency = 0.25
    holder.Size = UDim2.new(0.92, 0, 0, 50)
    holder.BorderSizePixel = 0
    holder.LayoutOrder = layoutOrder or 0

    local hCorner = Instance.new("UICorner")
    hCorner.CornerRadius = UDim.new(0, 10)
    hCorner.Parent = holder

    local label = Instance.new("TextLabel")
    label.Parent = holder
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 2)
    label.Size = UDim2.new(1, -50, 0, 18)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Colors.TextPrimary
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left

    local valLabel = Instance.new("TextLabel")
    valLabel.Parent = holder
    valLabel.BackgroundTransparency = 1
    valLabel.Position = UDim2.new(1, -45, 0, 2)
    valLabel.Size = UDim2.new(0, 35, 0, 18)
    valLabel.Font = Enum.Font.GothamMedium
    valLabel.Text = tostring(default)
    valLabel.TextColor3 = Colors.Accent
    valLabel.TextSize = 10
    valLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- Track bar
    local track = Instance.new("Frame")
    track.Parent = holder
    track.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
    track.BackgroundTransparency = 0.3
    track.Size = UDim2.new(0.85, 0, 0, 6)
    track.Position = UDim2.new(0.075, 0, 0, 32)
    track.BorderSizePixel = 0
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    -- Fill bar
    local fill = Instance.new("Frame")
    fill.Parent = track
    fill.BackgroundColor3 = Colors.Accent
    fill.BackgroundTransparency = 0.2
    fill.BorderSizePixel = 0
    local initPct = math.clamp((default - minVal) / (maxVal - minVal), 0, 1)
    fill.Size = UDim2.new(initPct, 0, 1, 0)
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    -- Drag knob
    local knob = Instance.new("TextButton")
    knob.Parent = track
    knob.BackgroundColor3 = Colors.Accent
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(initPct, -7, 0.5, -7)
    knob.BorderSizePixel = 0
    knob.Text = ""
    knob.AutoButtonColor = false
    knob.ZIndex = 3
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local dragging = false

    knob.MouseButton1Down:Connect(function()
        dragging = true
    end)

    local uis = game:GetService("UserInputService")
    trackConnection = uis.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local trackAbsPos = track.AbsolutePosition.X
            local trackAbsSize = track.AbsoluteSize.X
            local mouseX = input.Position.X
            local pct = math.clamp((mouseX - trackAbsPos) / trackAbsSize, 0, 1)
            local value = math.floor(minVal + pct * (maxVal - minVal) + 0.5)
            pct = (value - minVal) / (maxVal - minVal)

            fill.Size = UDim2.new(pct, 0, 1, 0)
            knob.Position = UDim2.new(pct, -7, 0.5, -7)
            valLabel.Text = tostring(value)
            pcall(callback, value)
        end
    end)
    trackConnection = trackConnection  -- keep reference

    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return holder
end


-- ============================================================
--                    CHEAT LOGIC
-- ============================================================

local playerTab = tabFrames["Player"]
local visualsTab = tabFrames["Visuals"]
local exploitsTab = tabFrames["Exploits"]

-- ===================== PLAYER TAB =====================

-- 1. INFINITE STAMINA (re-scanning getgc on a throttled loop)
local staminaActive = false
CreateToggle(playerTab, "⚡ Inf Stamina", function(state)
    staminaActive = state
    if state then
        task.spawn(function()
            while staminaActive do
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
                task.wait(3) -- re-scan every 3s (handles respawn)
            end
        end)
    end
end, 1)

-- 2. INFINITE NIGHT VISION
local nvgActive = false
CreateToggle(playerTab, "🔋 Inf Night Vision", function(state)
    nvgActive = state
    if state then
        task.spawn(function()
            while nvgActive do
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

-- 3. NO FALL DAMAGE (metatable hook with getnamecallmethod guard)
local noFall = false
CreateToggle(playerTab, "🛡️ No Fall Damage", function(state)
    noFall = state
end, 3)

-- Safe metatable hook (only once, guarded by _G flag)
if not _G.__SafeHubV4_Hooked then
    _G.__SafeHubV4_Hooked = true
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        if noFall then
            local method = getnamecallmethod()
            if method == "FireServer" and tostring(self) == "FD_Event" then
                local args = {...}
                args[1] = 0
                args[2] = 0
                return self.FireServer(self, unpack(args))
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end

CreateSeparator(playerTab, 4)

-- 4. WALKSPEED (Heartbeat-based, safe)
local speedEnabled = false
local speedValue = 16
CreateSlider(playerTab, "🏃 WalkSpeed", 10, 35, 16, function(val)
    speedValue = val
end, 5)

CreateToggle(playerTab, "🏃 Enable WalkSpeed", function(state)
    speedEnabled = state
end, 6)

trackConnection(RunService.Heartbeat:Connect(function()
    if speedEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = speedValue
                end
            end
        end)
    end
end))

-- 5. FOV SLIDER
local fovEnabled = false
local fovValue = 70
CreateSlider(playerTab, "🔭 Field Of View", 50, 120, 70, function(val)
    fovValue = val
end, 7)

CreateToggle(playerTab, "🔭 Enable FOV", function(state)
    fovEnabled = state
    if state then
        pcall(function()
            Workspace.CurrentCamera.FieldOfView = fovValue
        end)
    else
        pcall(function()
            Workspace.CurrentCamera.FieldOfView = 70
        end)
    end
end, 8)

trackConnection(RunService.Heartbeat:Connect(function()
    if fovEnabled then
        pcall(function()
            Workspace.CurrentCamera.FieldOfView = fovValue
        end)
    end
end))


-- ===================== VISUALS TAB =====================

-- 1. ESP (Highlights only, tracked for cleanup)
local espEnabled = false
CreateToggle(visualsTab, "👁️ ESP (All)", function(state)
    espEnabled = state
    if not state then
        -- Clean up all tracked highlights
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

local function safeCreateHighlight(parent, color, name)
    if not parent or parent:FindFirstChild(name) then return end
    local hl = Instance.new("Highlight")
    hl.Name = name
    hl.FillColor = color
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = parent
    trackHighlight(hl)
    return hl
end

task.spawn(function()
    while task.wait(1.5) do
        if espEnabled then
            pcall(function()
                -- Players (green)
                for _, p in pairs(Players:GetChildren()) do
                    if p ~= LocalPlayer and p.Character then
                        safeCreateHighlight(p.Character, Color3.fromRGB(0, 255, 0), "SH4_ESP")
                    end
                end
                -- Rake / Monster (red)
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name:match("Rake") or obj.Name == "Monster" then
                        safeCreateHighlight(obj, Color3.fromRGB(255, 0, 0), "SH4_ESP")
                    end
                    -- Flare Gun (cyan)
                    if obj.Name == "FlareGunPickUp" then
                        safeCreateHighlight(obj, Color3.fromRGB(0, 225, 255), "SH4_ESP")
                    end
                end
                -- Scrap (brown)
                if Workspace:FindFirstChild("Filter") and Workspace.Filter:FindFirstChild("ScrapSpawns") then
                    for _, scrap in pairs(Workspace.Filter.ScrapSpawns:GetDescendants()) do
                        if scrap.Name == "Scrap" then
                            safeCreateHighlight(scrap, Color3.fromRGB(139, 69, 19), "SH4_ESP")
                        end
                    end
                end
                -- Boxes (yellow)
                if Workspace:FindFirstChild("Debris") and Workspace.Debris:FindFirstChild("SupplyCrates") then
                    for _, box in pairs(Workspace.Debris.SupplyCrates:GetChildren()) do
                        if box.Name == "Box" then
                            safeCreateHighlight(box, Color3.fromRGB(255, 255, 0), "SH4_ESP")
                        end
                    end
                end
            end)
        end
    end
end)

CreateSeparator(visualsTab, 2)

-- 2. DAY MODE + NOFOG + 3RD PERSON
CreateToggle(visualsTab, "☀️ Day + NoFog + 3rdPerson", function(state)
    if state then
        Lighting.ClockTime = 14
        Lighting.FogEnd = 9e9
        Lighting.GlobalShadows = false
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMaxZoomDistance = 100
        -- Also override ReplicatedStorage fog if available
        pcall(function()
            ReplicatedStorage.CurrentLightingProperties.FogEnd.Value = 9e9
        end)
    else
        Lighting.ClockTime = 0
        Lighting.FogEnd = 200
        Lighting.GlobalShadows = true
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
        pcall(function()
            ReplicatedStorage.CurrentLightingProperties.FogEnd.Value = 75
        end)
    end
end, 3)

-- Keep fog overridden while enabled
local fogOverride = false
CreateToggle(visualsTab, "🌫️ Persist NoFog", function(state)
    fogOverride = state
end, 4)

trackConnection(RunService.Heartbeat:Connect(function()
    if fogOverride then
        pcall(function()
            ReplicatedStorage.CurrentLightingProperties.FogEnd.Value = 9e9
            Lighting.FogEnd = 9e9
        end)
    end
end))


-- ===================== EXPLOITS TAB =====================

-- 1. SMART KILLAURA
local killaura = false
CreateToggle(exploitsTab, "⚔️ Smart KillAura (200m)", function(state)
    killaura = state
end, 1)

task.spawn(function()
    while task.wait(0.1) do
        if killaura then
            pcall(function()
                local rake = Workspace:FindFirstChild("Rake") or Workspace:FindFirstChild("Monster")
                local char = LocalPlayer.Character
                if rake and char and char:FindFirstChild("StunStick") and char:FindFirstChild("HumanoidRootPart") then
                    local rakeHRP = rake:FindFirstChild("HumanoidRootPart")
                    if rakeHRP and (rakeHRP.Position - char.HumanoidRootPart.Position).Magnitude < 200 then
                        char.StunStick.Event:FireServer("S")
                        task.wait(0.05)
                        char.StunStick.Event:FireServer("H", rakeHRP)
                    end
                end
            end)
        end
    end
end)

CreateSeparator(exploitsTab, 2)

-- 2. BRING ALL SCRAP
CreateButton(exploitsTab, "🧲 Bring All Scrap", function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        for _, v in pairs(Workspace.Filter.ScrapSpawns:GetDescendants()) do
            if v.Name:lower() == "scrap" then
                v:PivotTo(char:GetPivot())
            end
        end
    end)
end, 3)

-- 3. INSTANT OPEN ALL BOXES (fixed: iterate ALL boxes)
CreateButton(exploitsTab, "📦 Insta-Open ALL Boxes", function()
    pcall(function()
        for _, box in pairs(Workspace.Debris.SupplyCrates:GetChildren()) do
            if box.Name == "Box" then
                local guiPart = box:FindFirstChild("GUIPart")
                if guiPart and guiPart:FindFirstChild("ProximityPrompt") then
                    for attr, _ in pairs(guiPart.ProximityPrompt:GetAttributes()) do
                        guiPart.ProximityPrompt:SetAttribute(tostring(attr), false)
                    end
                end
                local unlockVal = box:FindFirstChild("UnlockValue")
                if unlockVal then
                    unlockVal.Value = 100
                end
            end
        end
    end)
end, 4)

-- 4. REMOVE INVISIBLE WALLS
CreateButton(exploitsTab, "🧱 Remove Invisible Walls", function()
    pcall(function()
        for _, v in pairs(Workspace.Filter.InvisibleWalls:GetChildren()) do
            local name = v.Name:lower()
            if name:match("invis") then
                v:Destroy()
            end
        end
    end)
end, 5)

-- 5. OPEN SAFEHOUSE DOOR (ported from old script, rewritten safely)
CreateButton(exploitsTab, "🚪 Open SafeHouse Door", function()
    task.spawn(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local savedCFrame = hrp.CFrame
            -- Teleport near door, fire remote, return
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
            hrp.CFrame = savedCFrame
            task.wait()
            hrp.Anchored = false
        end)
    end)
end, 6)

-- 6. RESTORE POWER STATION (ported, rewritten safely)
CreateButton(exploitsTab, "⚡ Restore Power", function()
    task.spawn(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local savedCFrame = hrp.CFrame
            local station = Workspace:FindFirstChild("Map")
                and Workspace.Map:FindFirstChild("PowerStation")
                and Workspace.Map.PowerStation:FindFirstChild("StationFolder")
            if not station then return end

            hrp.CFrame = CFrame.new(-280.8, 20.4, -212.2)
            hrp.Anchored = true
            task.wait(0.2)
            station.RemoteEvent:FireServer("StationStart")
            task.wait(20)
            hrp.CFrame = savedCFrame
            task.wait()
            hrp.Anchored = false
        end)
    end)
end, 7)

CreateSeparator(exploitsTab, 8)

-- 7. INFO LABELS
local rakeTargetLabel = CreateInfoLabel(exploitsTab, "🎯 Rake Target: ...", 9)
local timerLabel = CreateInfoLabel(exploitsTab, "⏰ Timer: ...", 10)
local bloodHourLabel = CreateInfoLabel(exploitsTab, "🩸 Blood Hour: No", 11)

-- Update info labels (throttled — every 0.5s via Heartbeat counter)
local infoTick = 0
trackConnection(RunService.Heartbeat:Connect(function(dt)
    infoTick = infoTick + dt
    if infoTick < 0.5 then return end
    infoTick = 0

    pcall(function()
        -- Rake target
        local rake = Workspace:FindFirstChild("Rake")
        if rake and rake:FindFirstChild("TargetVal") and rake.TargetVal.Value then
            rakeTargetLabel.Text = "🎯 Rake Target: " .. tostring(rake.TargetVal.Value.Parent)
        else
            rakeTargetLabel.Text = "🎯 Rake Target: None"
        end

        -- Timer
        if ReplicatedStorage:FindFirstChild("Night") and ReplicatedStorage:FindFirstChild("Timer") then
            local prefix = ReplicatedStorage.Night.Value and "⏰ Until Day: " or "⏰ Until Night: "
            timerLabel.Text = prefix .. tostring(ReplicatedStorage.Timer.Value)
        end

        -- Blood Hour
        if ReplicatedStorage:FindFirstChild("InitiateBloodHour") then
            if ReplicatedStorage.InitiateBloodHour.Value == true then
                bloodHourLabel.Text = "🩸 ⚠️ BLOOD HOUR ACTIVE!"
                bloodHourLabel.TextColor3 = Colors.Danger
            else
                bloodHourLabel.Text = "🩸 Blood Hour: No"
                bloodHourLabel.TextColor3 = Colors.TextSecondary
            end
        end
    end)
end))

CreateSeparator(exploitsTab, 12)

-- 8. UNLOAD GUI
CreateButton(exploitsTab, "🗑️ Unload Hub", function()
    -- Clean all highlights
    for _, hl in pairs(activeHighlights) do
        pcall(function() hl:Destroy() end)
    end
    activeHighlights = {}

    -- Disconnect all connections
    for _, conn in pairs(activeConnections) do
        pcall(function() conn:Disconnect() end)
    end
    activeConnections = {}

    -- Stop all loops
    staminaActive = false
    nvgActive = false
    killaura = false
    espEnabled = false
    speedEnabled = false
    fovEnabled = false
    fogOverride = false
    noFall = false

    -- Reset camera
    pcall(function()
        Workspace.CurrentCamera.FieldOfView = 70
    end)

    -- Destroy GUI
    pcall(function()
        ScreenGui:Destroy()
    end)
end, 13)
