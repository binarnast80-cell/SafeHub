-- =====================================================
-- 🛡️ SAFE HUB V1.16.2: MATERIAL DESIGN | MOBILE-FIRST
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

-- Cleanup on re-execution (stealth name — looks like Roblox internal)
local GUI_NAME = "RbxAnalyticsUI"
pcall(function()
    if CoreGui:FindFirstChild(GUI_NAME) then CoreGui[GUI_NAME]:Destroy() end
end)

-- ================= TRACKED RESOURCES =================
local allHighlights = {}
local allConnections = {}

local function trackConnection(connection)
    table.insert(allConnections, connection)
    return connection
end

local function trackHighlight(highlight)
    table.insert(allHighlights, highlight)
    return highlight
end

-- ================= COLOR PALETTE (dark gradient purple) =================
local Colors = {
    Background      = Color3.fromRGB(14, 14, 20),
    Card            = Color3.fromRGB(22, 22, 32),
    CardHover       = Color3.fromRGB(34, 34, 48),
    Header          = Color3.fromRGB(8, 8, 14),
    Accent          = Color3.fromRGB(108, 92, 231),
    AccentLight     = Color3.fromRGB(167, 139, 250),
    TextWhite       = Color3.fromRGB(232, 233, 237),
    TextDim         = Color3.fromRGB(139, 141, 150),
    ToggleOff       = Color3.fromRGB(38, 38, 48),
    ToggleKnob      = Color3.fromRGB(204, 208, 216),
    Separator       = Color3.fromRGB(60, 60, 72),
    Red             = Color3.fromRGB(255, 77, 106),
    Green           = Color3.fromRGB(52, 211, 153),
    DisabledOverlay = Color3.fromRGB(6, 6, 10),
}

-- ================= TWEEN HELPERS =================
local tweenFast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenSmooth = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local tweenBounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function tweenTo(object, properties, info)
    TweenService:Create(object, info or tweenFast, properties):Play()
end

-- ================= SCREEN GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.Parent = CoreGui

-- ================= MAIN FRAME =================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BackgroundTransparency = 0.60
MainFrame.Position = UDim2.new(0.01, 0, 0.04, 0)
MainFrame.Size = UDim2.new(0, 310, 0, 195)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- ================= HEADER (opaque) =================
local HeaderBar = Instance.new("Frame")
HeaderBar.Parent = MainFrame
HeaderBar.BackgroundColor3 = Colors.Header
HeaderBar.BackgroundTransparency = 0
HeaderBar.Size = UDim2.new(1, 0, 0, 22)
HeaderBar.BorderSizePixel = 0
HeaderBar.ZIndex = 10
Instance.new("UICorner", HeaderBar).CornerRadius = UDim.new(0, 12)

-- Fill bottom corners
local headerFill = Instance.new("Frame")
headerFill.Parent = HeaderBar
headerFill.BackgroundColor3 = Colors.Header
headerFill.Size = UDim2.new(1, 0, 0, 11)
headerFill.Position = UDim2.new(0, 0, 1, -11)
headerFill.BorderSizePixel = 0
headerFill.ZIndex = 10

-- Accent line (purple gradient glow)
local accentLine = Instance.new("Frame")
accentLine.Parent = MainFrame
accentLine.BackgroundColor3 = Colors.Accent
accentLine.BackgroundTransparency = 0.4
accentLine.Size = UDim2.new(1, 0, 0, 1)
accentLine.Position = UDim2.new(0, 0, 0, 22)
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 10

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = HeaderBar
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "🛡️ SAFE HUB  v1.16.2"
titleLabel.TextColor3 = Colors.AccentLight
titleLabel.TextSize = 9
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 11

-- Minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Parent = HeaderBar
minimizeButton.BackgroundTransparency = 1
minimizeButton.Position = UDim2.new(1, -24, 0, 0)
minimizeButton.Size = UDim2.new(0, 24, 0, 22)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Text = "–"
minimizeButton.TextColor3 = Colors.Red
minimizeButton.TextSize = 14
minimizeButton.ZIndex = 11

-- ================= TAB BAR (top, opaque like header) =================
local tabBar = Instance.new("Frame")
tabBar.Parent = MainFrame
tabBar.BackgroundColor3 = Colors.Header
tabBar.BackgroundTransparency = 0
tabBar.Size = UDim2.new(1, 0, 0, 20)
tabBar.Position = UDim2.new(0, 0, 0, 23)
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 5

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Padding = UDim.new(0, 3)
local tabPad = Instance.new("UIPadding", tabBar)
tabPad.PaddingLeft = UDim.new(0, 4)
tabPad.PaddingRight = UDim.new(0, 4)
tabPad.PaddingTop = UDim.new(0, 2)
tabPad.PaddingBottom = UDim.new(0, 2)

local tabConfig = {
    {key = "Player",   label = "Player"},
    {key = "Visuals",  label = "Visuals"},
    {key = "Exploits", label = "Exploits"},
}

local tabButtons = {}
local tabFrames = {}
local currentTab = "Player"

for _, config in ipairs(tabConfig) do
    local button = Instance.new("TextButton")
    button.Name = config.key
    button.Parent = tabBar
    button.Size = UDim2.new(0.32, 0, 1, 0)
    button.Font = Enum.Font.GothamBold
    button.Text = config.label
    button.TextSize = 8
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.ZIndex = 6
    button.LayoutOrder = _
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

    if config.key == "Player" then
        -- Active: purple gradient pill
        button.BackgroundColor3 = Colors.Accent
        button.BackgroundTransparency = 0
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        local grad = Instance.new("UIGradient", button)
        grad.Color = ColorSequence.new(Colors.Accent, Color3.fromRGB(129, 140, 248))
        grad.Rotation = 135
    else
        -- Inactive: transparent
        button.BackgroundTransparency = 1
        button.TextColor3 = Colors.TextDim
    end
    tabButtons[config.key] = button
end

-- ================= CONTENT CONTAINER =================
local contentBox = Instance.new("Frame")
contentBox.Parent = MainFrame
contentBox.BackgroundTransparency = 1
contentBox.Position = UDim2.new(0, 0, 0, 44)
contentBox.Size = UDim2.new(1, 0, 1, -46)
contentBox.BorderSizePixel = 0

local function createTabFrame(key)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = key
    scroll.Parent = contentBox
    scroll.BackgroundColor3 = Colors.Card
    scroll.BackgroundTransparency = 0.65
    scroll.Size = UDim2.new(1, -6, 1, -2)
    scroll.Position = UDim2.new(0, 3, 0, 1)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 550)
    scroll.ScrollBarThickness = 2
    scroll.ScrollBarImageColor3 = Colors.Accent
    scroll.ScrollBarImageTransparency = 0.6
    scroll.BorderSizePixel = 0
    scroll.Visible = (key == "Player")
    scroll.ClipsDescendants = true
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 8)
    local layout = Instance.new("UIListLayout", scroll)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local padding = Instance.new("UIPadding", scroll)
    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 4)
    tabFrames[key] = scroll
end

for _, config in ipairs(tabConfig) do createTabFrame(config.key) end

-- ================= TAB SWITCHING =================
local function switchTab(key)
    currentTab = key
    for name, frame in pairs(tabFrames) do frame.Visible = (name == key) end
    for name, button in pairs(tabButtons) do
        if name == key then
            -- Active: purple gradient pill
            tweenTo(button, {BackgroundColor3 = Colors.Accent, BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)})
            -- Ensure gradient exists
            if not button:FindFirstChildOfClass("UIGradient") then
                local grad = Instance.new("UIGradient", button)
                grad.Color = ColorSequence.new(Colors.Accent, Color3.fromRGB(129, 140, 248))
                grad.Rotation = 135
            end
        else
            -- Inactive: transparent
            tweenTo(button, {BackgroundTransparency = 1, TextColor3 = Colors.TextDim})
            local grad = button:FindFirstChildOfClass("UIGradient")
            if grad then grad:Destroy() end
        end
    end
end

for key, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function() switchTab(key) end)
end

-- ================= MINIMIZE / SHIELD PILL =================
-- Shield pill = single TextButton (no child buttons blocking drag!)
local shieldPill = Instance.new("TextButton")
shieldPill.Name = "ShieldPill"
shieldPill.Parent = ScreenGui
shieldPill.BackgroundColor3 = Colors.Background
shieldPill.BackgroundTransparency = 0.1
shieldPill.Size = UDim2.new(0, 38, 0, 38)
shieldPill.Position = UDim2.new(0, 10, 0, 10)
shieldPill.BorderSizePixel = 0
shieldPill.Active = true
shieldPill.Draggable = true
shieldPill.Visible = false
shieldPill.ZIndex = 20
shieldPill.AutoButtonColor = false
shieldPill.Text = "SH"
shieldPill.Font = Enum.Font.GothamBold
shieldPill.TextColor3 = Colors.AccentLight
shieldPill.TextSize = 13
Instance.new("UICorner", shieldPill).CornerRadius = UDim.new(1, 0)
local shieldStroke = Instance.new("UIStroke", shieldPill)
shieldStroke.Color = Colors.AccentLight
shieldStroke.Transparency = 0.35
shieldStroke.Thickness = 1.5

local isMinimized = false
local shieldDragStart = nil -- track position to distinguish tap vs drag

local function openPanel()
    isMinimized = false
    shieldPill.Visible = false
    MainFrame.Visible = true
end

local function closePanel()
    isMinimized = true
    MainFrame.Visible = false
    shieldPill.Visible = true
end

minimizeButton.MouseButton1Click:Connect(function()
    closePanel()
end)

-- Track where the pill was when press started
shieldPill.MouseButton1Down:Connect(function()
    shieldDragStart = shieldPill.Position
end)

-- On release: only open if pill didn't move (= tap, not drag)
shieldPill.MouseButton1Click:Connect(function()
    if isMinimized and shieldDragStart then
        local dx = math.abs(shieldPill.Position.X.Offset - shieldDragStart.X.Offset)
        local dy = math.abs(shieldPill.Position.Y.Offset - shieldDragStart.Y.Offset)
        if dx < 5 and dy < 5 then
            openPanel()
        end
    end
    shieldDragStart = nil
end)


-- ================= UI FACTORY FUNCTIONS =================

local function CreateToggle(parent, text, callback, layoutOrder)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Colors.Card
    frame.BackgroundTransparency = 0.60
    frame.Size = UDim2.new(0.96, 0, 0, 22)
    frame.BorderSizePixel = 0
    frame.LayoutOrder = layoutOrder or 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local frameStroke = Instance.new("UIStroke", frame)
    frameStroke.Color = Color3.fromRGB(255, 255, 255)
    frameStroke.Transparency = 0.92
    frameStroke.Thickness = 1

    local label = Instance.new("TextLabel", frame)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 8, 0, 0)
    label.Size = UDim2.new(1, -42, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = Colors.TextWhite
    label.TextSize = 8
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd

    local switchTrack = Instance.new("Frame", frame)
    switchTrack.BackgroundColor3 = Colors.ToggleOff
    switchTrack.BackgroundTransparency = 0.2
    switchTrack.Size = UDim2.new(0, 28, 0, 13)
    switchTrack.Position = UDim2.new(1, -33, 0.5, -6)
    switchTrack.BorderSizePixel = 0
    Instance.new("UICorner", switchTrack).CornerRadius = UDim.new(1, 0)
    local trackStroke = Instance.new("UIStroke", switchTrack)
    trackStroke.Color = Color3.fromRGB(255, 255, 255)
    trackStroke.Transparency = 0.92
    trackStroke.Thickness = 1

    local switchDot = Instance.new("Frame", switchTrack)
    switchDot.BackgroundColor3 = Colors.ToggleKnob
    switchDot.Size = UDim2.new(0, 11, 0, 11)
    switchDot.Position = UDim2.new(0, 1, 0.5, -5)
    switchDot.BorderSizePixel = 0
    Instance.new("UICorner", switchDot).CornerRadius = UDim.new(1, 0)

    local hitButton = Instance.new("TextButton", frame)
    hitButton.BackgroundTransparency = 1
    hitButton.Size = UDim2.new(1, 0, 1, 0)
    hitButton.Text = ""
    hitButton.ZIndex = 3

    local isOn = false
    hitButton.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            tweenTo(switchTrack, {BackgroundColor3 = Colors.Accent, BackgroundTransparency = 0})
            tweenTo(switchDot, {Position = UDim2.new(1, -12, 0.5, -5), BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
            tweenTo(frame, {BackgroundTransparency = 0.40})
        else
            tweenTo(switchTrack, {BackgroundColor3 = Colors.ToggleOff, BackgroundTransparency = 0.2})
            tweenTo(switchDot, {Position = UDim2.new(0, 1, 0.5, -5), BackgroundColor3 = Colors.ToggleKnob})
            tweenTo(frame, {BackgroundTransparency = 0.60})
        end
        pcall(callback, isOn)
    end)

    return frame
end

local function CreateButton(parent, text, callback, layoutOrder)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.BackgroundColor3 = Colors.Accent
    button.BackgroundTransparency = 0.85
    button.Size = UDim2.new(0.96, 0, 0, 22)
    button.Font = Enum.Font.GothamMedium
    button.Text = text
    button.TextColor3 = Colors.TextWhite
    button.TextSize = 8
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.LayoutOrder = layoutOrder or 0
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    local btnStroke = Instance.new("UIStroke", button)
    btnStroke.Color = Colors.Accent
    btnStroke.Transparency = 0.75
    btnStroke.Thickness = 1

    button.MouseButton1Click:Connect(function()
        tweenTo(button, {BackgroundColor3 = Colors.Accent, BackgroundTransparency = 0.3})
        task.wait(0.12)
        tweenTo(button, {BackgroundColor3 = Colors.Accent, BackgroundTransparency = 0.85})
        pcall(callback)
    end)

    return button
end

local function CreateSeparator(parent, layoutOrder)
    local sep = Instance.new("Frame", parent)
    sep.BackgroundColor3 = Colors.Separator
    sep.BackgroundTransparency = 0.6
    sep.Size = UDim2.new(0.88, 0, 0, 1)
    sep.BorderSizePixel = 0
    sep.LayoutOrder = layoutOrder or 0
end

local function CreateInfoLabel(parent, text, layoutOrder)
    local label = Instance.new("TextLabel", parent)
    label.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
    label.BackgroundTransparency = 0.65
    label.Size = UDim2.new(0.96, 0, 0, 16)
    label.Font = Enum.Font.GothamMedium
    label.Text = "  " .. text
    label.TextColor3 = Colors.TextDim
    label.TextSize = 7
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BorderSizePixel = 0
    label.LayoutOrder = layoutOrder or 0
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 6)
    local infoStroke = Instance.new("UIStroke", label)
    infoStroke.Color = Color3.fromRGB(255, 255, 255)
    infoStroke.Transparency = 0.92
    infoStroke.Thickness = 1
    return label
end

local function CreateStepper(parent, text, minVal, maxVal, step, default, callback, layoutOrder)
    local frame = Instance.new("Frame", parent)
    frame.BackgroundColor3 = Colors.Card
    frame.BackgroundTransparency = 0.60
    frame.Size = UDim2.new(0.96, 0, 0, 22)
    frame.BorderSizePixel = 0
    frame.LayoutOrder = layoutOrder or 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local stepFrameStroke = Instance.new("UIStroke", frame)
    stepFrameStroke.Color = Color3.fromRGB(255, 255, 255)
    stepFrameStroke.Transparency = 0.92
    stepFrameStroke.Thickness = 1

    local label = Instance.new("TextLabel", frame)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 6, 0, 0)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = Colors.TextWhite
    label.TextSize = 8
    label.TextXAlignment = Enum.TextXAlignment.Left

    local currentValue = default

    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0.6, 0, 0, 0)
    valueLabel.Size = UDim2.new(0.14, 0, 1, 0)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(currentValue)
    valueLabel.TextColor3 = Colors.AccentLight
    valueLabel.TextSize = 8

    local function makeStepButton(buttonText, xPosition, delta)
        local stepBtn = Instance.new("TextButton", frame)
        stepBtn.BackgroundColor3 = Colors.CardHover
        stepBtn.BackgroundTransparency = 0.3
        stepBtn.Size = UDim2.new(0, 16, 0, 13)
        stepBtn.Position = UDim2.new(xPosition, 0, 0.5, -6)
        stepBtn.Font = Enum.Font.GothamBold
        stepBtn.Text = buttonText
        stepBtn.TextColor3 = Colors.TextWhite
        stepBtn.TextSize = 11
        stepBtn.AutoButtonColor = false
        stepBtn.BorderSizePixel = 0
        stepBtn.ZIndex = 3
        Instance.new("UICorner", stepBtn).CornerRadius = UDim.new(0, 5)

        stepBtn.MouseButton1Click:Connect(function()
            currentValue = math.clamp(currentValue + delta, minVal, maxVal)
            valueLabel.Text = tostring(currentValue)
            pcall(callback, currentValue)
            tweenTo(stepBtn, {BackgroundColor3 = Colors.Accent, BackgroundTransparency = 0})
            task.wait(0.08)
            tweenTo(stepBtn, {BackgroundColor3 = Colors.CardHover, BackgroundTransparency = 0.3})
        end)
    end

    makeStepButton("–", 0.52, -step)
    makeStepButton("+", 0.82, step)
end

-- Disabled overlay for sub-functions
local function CreateDisabledOverlay(parentFrame)
    local overlay = Instance.new("Frame", parentFrame)
    overlay.Name = "DisabledOverlay"
    overlay.BackgroundColor3 = Colors.DisabledOverlay
    overlay.BackgroundTransparency = 0.35
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.ZIndex = 8
    overlay.Visible = true
    Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 6)

    local disabledLabel = Instance.new("TextLabel", overlay)
    disabledLabel.BackgroundTransparency = 1
    disabledLabel.Size = UDim2.new(1, 0, 1, 0)
    disabledLabel.Font = Enum.Font.GothamBold
    disabledLabel.Text = "DISABLED"
    disabledLabel.TextColor3 = Colors.Red
    disabledLabel.TextSize = 7
    disabledLabel.TextTransparency = 0.3
    disabledLabel.ZIndex = 9

    return overlay
end


-- ============================================================
--                    FEATURE LOGIC
-- ============================================================

local playerTab = tabFrames["Player"]
local visualsTab = tabFrames["Visuals"]
local exploitsTab = tabFrames["Exploits"]

-- ===================== PLAYER TAB =====================

-- 1. Infinite Stamina (periodic getgc re-scan, survives respawn)
local staminaEnabled = false
CreateToggle(playerTab, "⚡ Inf Stamina", function(state)
    staminaEnabled = state
    if state then
        task.spawn(function()
            while staminaEnabled do
                pcall(function()
                    for _, value in pairs(getgc(true)) do
                        if type(value) == "table" and rawget(value, "STAMINA_REGEN") then
                            value.STAMINA_REGEN = 100
                            value.JUMP_STAMINA = 0
                            value.JUMP_COOLDOWN = 0
                            value.STAMINA_TAKE = 0
                            value.stamina = 100
                        end
                    end
                end)
                task.wait(3)
            end
        end)
    end
end, 1)

-- 2. Infinite Night Vision
local nightVisionEnabled = false
CreateToggle(playerTab, "🔋 Inf Night Vision", function(state)
    nightVisionEnabled = state
    if state then
        task.spawn(function()
            while nightVisionEnabled do
                pcall(function()
                    for _, value in pairs(getgc(true)) do
                        if type(value) == "table" and rawget(value, "NVG_TAKE") then
                            value.NVG_TAKE = 0
                            value.NVG_REGEN = 100
                        end
                    end
                end)
                task.wait(3)
            end
        end)
    end
end, 2)

-- 3. No Fall Damage (metatable hook — identical to working v3)
local noFallDamage = false
CreateToggle(playerTab, "🛡️ No Fall Damage", function(state)
    noFallDamage = state
end, 3)

-- Forward declarations for exploit state (used by __namecall hook below)
-- Actual toggles/values set later in EXPLOITS TAB
local noClipEnabled = false
local lastExploitOffTime = 0

-- ============================================================
--    __namecall HOOK: EXACT v3 PATTERN (proven safe)
-- ============================================================
-- IMPORTANT: ONLY the FD_Event check goes here!
-- Any extra checks = timing anomaly = DETECTED = KICKED.
local _hookInstalled = false
if not _hookInstalled then
    _hookInstalled = true
    local metatable = getrawmetatable(game)
    local originalNamecall = metatable.__namecall
    setreadonly(metatable, false)
    metatable.__namecall = function(self, ...)
        if noFallDamage == true then
            local args = {...}
            if tostring(self) == "FD_Event" then
                args[1] = 0; args[2] = 0
                return self.FireServer(self, unpack(args))
            end
        end
        return originalNamecall(self, ...)
    end
    setreadonly(metatable, true)
end

-- ============================================================
--    ANTI-CHEAT SCANNER: separate background thread (stealth)
-- ============================================================
-- Instead of modifying __namecall (detected!), we periodically
-- find and disable anti-clip scripts + destroy their remotes.
task.spawn(function()
    while task.wait(3) do
        if noClipEnabled or (tick() - lastExploitOffTime) < 30 then
            -- Disable anti-clip LocalScripts in character
            pcall(function()
                if LocalPlayer.Character then
                    for _, s in pairs(LocalPlayer.Character:GetDescendants()) do
                        if s:IsA("LocalScript") then
                            local n = s.Name:lower()
                            if n:match("bug") or n:match("clip") or n:match("cheat")
                            or n:match("exploit") or n:match("valid") or n:match("check")
                            or n:match("detect") or n:match("anti") then
                                s.Disabled = true
                            end
                        end
                    end
                end
            end)
            -- Disable in PlayerScripts
            pcall(function()
                for _, s in pairs(LocalPlayer.PlayerScripts:GetDescendants()) do
                    if s:IsA("LocalScript") then
                        local n = s.Name:lower()
                        if n:match("bug") or n:match("clip") or n:match("cheat")
                        or n:match("anticheat") or n:match("exploit") or n:match("valid") then
                            s.Disabled = true
                        end
                    end
                end
            end)
        end
    end
end)

CreateSeparator(playerTab, 4)

-- 4. WalkSpeed
local speedEnabled = false
local speedValue = 16
CreateStepper(playerTab, "🏃 Speed", 10, 40, 2, 16, function(value)
    speedValue = value
end, 5)
CreateToggle(playerTab, "🏃 Enable Speed", function(state)
    speedEnabled = state
end, 6)

-- 4b. JumpPower
local jumpEnabled = false
local jumpValue = 50
CreateStepper(playerTab, "🦘 Jump Power", 20, 80, 5, 50, function(value)
    jumpValue = value
end, 7)
CreateToggle(playerTab, "🦘 Enable Jump", function(state)
    jumpEnabled = state
    if not state then
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = 50 end
        end)
    end
end, 8)

-- 5. FOV
local fovEnabled = false
local fovValue = 70
CreateStepper(playerTab, "🔭 FOV", 50, 120, 5, 70, function(value)
    fovValue = value
end, 9)
CreateToggle(playerTab, "🔭 Enable FOV", function(state)
    fovEnabled = state
    if not state then
        pcall(function() Workspace.CurrentCamera.FieldOfView = 70 end)
    end
end, 10)


-- ===================== VISUALS TAB =====================

-- ESP tracked per type
local espPlayerList = {}
local espRakeList = {}
local espScrapList = {}
local espLootList = {}

local function clearESPList(list)
    for i = #list, 1, -1 do
        pcall(function() if list[i] and list[i].Parent then list[i]:Destroy() end end)
        table.remove(list, i)
    end
end

local function createHighlight(parent, color, name, list)
    if not parent or parent:FindFirstChild(name) then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = name
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = parent
    table.insert(list, highlight)
    table.insert(allHighlights, highlight)
end

local function createBillboard(parent, text, color, name, list)
    if not parent then return end
    local existing = parent:FindFirstChild(name)
    if existing then
        local textLabel = existing:FindFirstChild("T")
        if textLabel then textLabel.Text = text end
        return
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = name
    billboard.Size = UDim2.new(0, 140, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 2000
    billboard.Parent = parent
    local textLabel = Instance.new("TextLabel", billboard)
    textLabel.Name = "T"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = color
    textLabel.Text = text
    textLabel.TextSize = 11
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    table.insert(list, billboard)
    table.insert(allHighlights, billboard)
end

-- ESP toggles
local playerESPEnabled = false
CreateToggle(visualsTab, "👤 Player ESP (blue)", function(state)
    playerESPEnabled = state
    if not state then clearESPList(espPlayerList) end
end, 1)

local rakeESPEnabled = false
CreateToggle(visualsTab, "👹 Rake ESP (red)", function(state)
    rakeESPEnabled = state
    if not state then clearESPList(espRakeList) end
end, 2)

local scrapESPEnabled = false
CreateToggle(visualsTab, "🔧 Scrap ESP (brown)", function(state)
    scrapESPEnabled = state
    if not state then clearESPList(espScrapList) end
end, 3)

local lootESPEnabled = false
CreateToggle(visualsTab, "🔫 Loot ESP (yellow)", function(state)
    lootESPEnabled = state
    if not state then clearESPList(espLootList) end
end, 4)

-- Location ESP
local locationESPEnabled = false
local locationParts = {}
local powerStationSubLabel = nil -- live-updating power text on map
local LOCATIONS = {
    {"Safe House",    Vector3.new(-363.5, 20, 70.3)},
    {"Shop",          Vector3.new(-25.2, 20, -258.4)},
    {"Power Station", Vector3.new(-281.7, 24, -212.7)},
    {"Base Camp",     Vector3.new(-70.7, 20, 209.0)},
}

CreateToggle(visualsTab, "📍 Location Names", function(state)
    locationESPEnabled = state
    if state then
        for _, location in ipairs(LOCATIONS) do
            local part = Instance.new("Part")
            part.Anchored = true
            part.Transparency = 1
            part.CanCollide = false
            part.Size = Vector3.new(0.1, 0.1, 0.1)
            part.Position = location[2]
            part.Parent = Workspace

            -- Billboard: taller for Power Station (extra line)
            local isPowerStation = (location[1] == "Power Station")
            local billboard = Instance.new("BillboardGui", part)
            billboard.Size = isPowerStation and UDim2.new(0, 110, 0, 30) or UDim2.new(0, 110, 0, 18)
            billboard.StudsOffset = Vector3.new(0, 6, 0)
            billboard.AlwaysOnTop = true
            billboard.MaxDistance = 2000

            local textLabel = Instance.new("TextLabel", billboard)
            textLabel.Size = isPowerStation and UDim2.new(1, 0, 0, 16) or UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.fromRGB(255, 160, 0)
            textLabel.Text = "📍 " .. location[1]
            textLabel.TextSize = 9
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextStrokeTransparency = 0.4
            textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

            -- Power Station: add small power level text below
            if isPowerStation then
                local subLabel = Instance.new("TextLabel", billboard)
                subLabel.Size = UDim2.new(1, 0, 0, 12)
                subLabel.Position = UDim2.new(0, 0, 0, 16)
                subLabel.BackgroundTransparency = 1
                subLabel.TextColor3 = Color3.fromRGB(255, 220, 80)
                subLabel.Text = "⚡ ..."
                subLabel.TextSize = 6
                subLabel.Font = Enum.Font.Gotham
                subLabel.TextStrokeTransparency = 0.5
                subLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                powerStationSubLabel = subLabel
            end

            table.insert(locationParts, part)
            table.insert(allHighlights, part)
        end
    else
        for _, marker in pairs(locationParts) do
            pcall(function() marker:Destroy() end)
        end
        locationParts = {}
        powerStationSubLabel = nil
    end
end, 5)

CreateSeparator(visualsTab, 6)

-- Day + NoFog (persistent — every frame + reactive signals)
local dayModeEnabled = false
CreateToggle(visualsTab, "☀️ Day + NoFog", function(state)
    dayModeEnabled = state
    if state then
        pcall(function()
            Lighting.ClockTime = 14
            Lighting.FogEnd = 9e9
            Lighting.GlobalShadows = false
            -- Override source values
            pcall(function()
                local props = ReplicatedStorage:FindFirstChild("CurrentLightingProperties")
                if props then
                    if props:FindFirstChild("FogEnd") then props.FogEnd.Value = 9e9 end
                    if props:FindFirstChild("ClockTime") then props.ClockTime.Value = 14 end
                end
            end)
            -- Disable effects
            for _, child in pairs(Lighting:GetChildren()) do
                pcall(function()
                    if child:IsA("Atmosphere") then child.Density = 0 end
                    if child:IsA("BlurEffect") then child.Enabled = false end
                    if child:IsA("ColorCorrectionEffect") then child.Brightness = 0 end
                end)
            end
        end)
    else
        pcall(function()
            Lighting.ClockTime = 0
            Lighting.FogEnd = 200
            Lighting.GlobalShadows = true
            pcall(function()
                local props = ReplicatedStorage:FindFirstChild("CurrentLightingProperties")
                if props and props:FindFirstChild("FogEnd") then props.FogEnd.Value = 75 end
            end)
        end)
    end
end, 7)

-- 3rd Person (persistent — every frame + reactive signals)
local thirdPersonEnabled = false
CreateToggle(visualsTab, "📷 3rd Person", function(state)
    thirdPersonEnabled = state
    if state then
        pcall(function()
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("RagdollTime") then
                character.RagdollTime.RagdollSwitch.Value = true
                task.wait()
                character.RagdollTime.RagdollSwitch.Value = false
            end
        end)
        pcall(function()
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = 100
            LocalPlayer.CameraMinZoomDistance = 0.5
        end)
    else
        pcall(function()
            LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
        end)
    end
end, 8)


-- ===================== EXPLOITS TAB =====================

-- 1. KillAura
local killAuraEnabled = false
CreateToggle(exploitsTab, "⚔️ KillAura", function(state)
    killAuraEnabled = state
end, 1)

task.spawn(function()
    while task.wait(0.025) do
        if killAuraEnabled then
            pcall(function()
                local rake = Workspace:FindFirstChild("Rake") or Workspace:FindFirstChild("Monster")
                local character = LocalPlayer.Character
                if rake and character and character:FindFirstChild("StunStick") and character:FindFirstChild("HumanoidRootPart") then
                    local rakeHRP = rake:FindFirstChild("HumanoidRootPart")
                    if rakeHRP and (rakeHRP.Position - character.HumanoidRootPart.Position).Magnitude < 400 then
                        character.StunStick.Event:FireServer("S")
                        task.wait(0.01)
                        character.StunStick.Event:FireServer("H", rakeHRP)
                    end
                end
            end)
        end
    end
end)

-- 2. AntiDetect (blocks server position corrections after wall removal)
local antiDetectEnabled = false
local lastSafePosition = nil
local antiDetectStartTime = 0

CreateToggle(exploitsTab, "🔒 AntiDetect", function(state)
    antiDetectEnabled = state
    if state then
        antiDetectStartTime = tick()
        pcall(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then lastSafePosition = hrp.Position end
        end)
        -- Try to disable game anti-clip scripts on character
        pcall(function()
            for _, script in pairs(LocalPlayer.Character:GetDescendants()) do
                if script:IsA("LocalScript") then
                    local n = script.Name:lower()
                    if n:match("clip") or n:match("bug") or n:match("cheat")
                    or n:match("exploit") or n:match("valid") or n:match("check") then
                        script.Disabled = true
                    end
                end
            end
        end)
    else
        lastSafePosition = nil
    end
end, 2)

-- 2b. NoClip (walk through everything — character parts CanCollide=false)
-- noClipEnabled and lastExploitOffTime forward-declared above __namecall hook
CreateToggle(exploitsTab, "👻 NoClip (walk through)", function(state)
    noClipEnabled = state
    if not state then
        lastExploitOffTime = tick()
        -- Restore collision
        pcall(function()
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end)
    end
end, 2)

CreateSeparator(exploitsTab, 3)

-- 3. Insta-Open Boxes (persistent toggle)
local instaOpenEnabled = false
local multiLootOverlay = nil

CreateToggle(exploitsTab, "📦 Insta-Open Boxes", function(state)
    instaOpenEnabled = state
    -- When turning OFF, restore original values so boxes aren't permanently unlocked
    if not state then
        pcall(function()
            for _, box in pairs(Workspace.Debris.SupplyCrates:GetChildren()) do
                if box.Name == "Box" then
                    local unlockValue = box:FindFirstChild("UnlockValue")
                    if unlockValue and unlockValue:GetAttribute("_origVal") ~= nil then
                        unlockValue.Value = unlockValue:GetAttribute("_origVal")
                    end
                    local guiPart = box:FindFirstChild("GUIPart")
                    if guiPart and guiPart:FindFirstChild("ProximityPrompt") then
                        local origHold = guiPart.ProximityPrompt:GetAttribute("_origHold")
                        if origHold then
                            guiPart.ProximityPrompt.HoldDuration = origHold
                        end
                    end
                end
            end
        end)
    end
end, 4)

-- 4. Multi-Loot (sub-function — DISABLED when InstaOpen is off)
-- [COMMENTED OUT]
-- local multiLootEnabled = false
-- local multiLootFrame = CreateToggle(exploitsTab, "📦 Multi-Loot (grab all) {Beta}", function(state)
--     if not instaOpenEnabled then return end
--     multiLootEnabled = state
-- end, 5)
--
-- multiLootOverlay = CreateDisabledOverlay(multiLootFrame)

CreateSeparator(exploitsTab, 6)

-- 5. Bring Scrap (server-replicated via network ownership)
CreateButton(exploitsTab, "🧲 Bring Scrap", function()
    pcall(function()
        local character = LocalPlayer.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local targetCF = hrp.CFrame * CFrame.new(0, 0, -3)
        for _, item in pairs(Workspace.Filter.ScrapSpawns:GetDescendants()) do
            if item.Name:lower() == "scrap" and item:IsA("BasePart") then
                pcall(function()
                    item.Anchored = false
                    item.CanCollide = true
                    item.CFrame = targetCF
                end)
            elseif item.Name:lower() == "scrap" and item:IsA("Model") then
                pcall(function()
                    for _, part in pairs(item:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Anchored = false
                        end
                    end
                    item:PivotTo(targetCF)
                end)
            end
        end
    end)
end, 7)

-- 7. Open SafeHouse door (remote only, no teleport)
CreateButton(exploitsTab, "🚪 Open SafeHouse", function()
    pcall(function()
        Workspace.Map.SafeHouse.Door.RemoteEvent:FireServer("Door")
    end)
end, 9)

-- 8. Open ObservationTower door (try prompt first, fallback: TP → prompt → TP back)
CreateButton(exploitsTab, "🗼 Open Tower", function()
    task.spawn(function()
        local character = LocalPlayer.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local tower = Workspace.Map:FindFirstChild("ObservationTower")
        if not tower then return end
        local door = tower:FindFirstChild("Door")
        if not door then return end

        -- Collect all ProximityPrompts from levers
        local prompts = {}
        for _, childName in pairs({"DoorLever", "DoorLever2", "DeadBolt"}) do
            local part = door:FindFirstChild(childName)
            if part then
                for _, desc in pairs(part:GetDescendants()) do
                    if desc:IsA("ProximityPrompt") then
                        table.insert(prompts, desc)
                    end
                end
            end
        end
        if #prompts == 0 then return end

        -- Attempt 1: fire prompts from current position (no TP, fast)
        for _, prompt in pairs(prompts) do
            pcall(function() fireproximityprompt(prompt) end)
        end

        -- Check if door opened
        wait(0.5)
        local doorOpened = false
        pcall(function()
            doorOpened = door:FindFirstChild("DoorOpen") and door.DoorOpen.Value == true
        end)

        -- Attempt 2: if door didn't open, fallback to TP → prompt → TP back
        if not doorOpened then
            local lever = door:FindFirstChild("DoorLever") or door:FindFirstChild("DoorLever2")
            if not lever then return end
            local leverPart = lever:IsA("BasePart") and lever or lever:FindFirstChildWhichIsA("BasePart")
            if not leverPart then return end

            local lastpos = hrp.CFrame
            hrp.CFrame = leverPart.CFrame + Vector3.new(0, -3, 0)
            wait()
            hrp.Anchored = true
            wait(0.4)

            for _, prompt in pairs(prompts) do
                pcall(function() fireproximityprompt(prompt) end)
            end

            wait(0.4)
            hrp.CFrame = lastpos
            wait()
            hrp.Anchored = false
        end
    end)
end, 10)


-- 9. Auto Fix Power
local autoFixPowerActive = false

-- Auto Fix Power (fires repair remote, player can move freely)
CreateToggle(exploitsTab, "⚡ Auto Fix Power", function(state)
    autoFixPowerActive = state

    if state then
        task.spawn(function()
            -- Fire initial StationStart
            pcall(function()
                Workspace.Map.PowerStation.StationFolder.RemoteEvent:FireServer("StationStart")
            end)

            -- Monitor loop: keep firing + check PowerLevel, auto-stop at 1000
            while autoFixPowerActive do
                local level = nil
                pcall(function()
                    level = ReplicatedStorage.PowerValues.PowerLevel.Value
                end)
                if level and level >= 1000 then
                    autoFixPowerActive = false
                    break
                end
                pcall(function()
                    Workspace.Map.PowerStation.StationFolder.RemoteEvent:FireServer("StationStart")
                end)
                wait(1.5 + math.random() * 1.5)
            end
        end)
    end
end, 11)



CreateSeparator(exploitsTab, 12)

-- 10. Info Labels
local rakeTargetLabel = CreateInfoLabel(exploitsTab, "🎯 Target: ...", 13)
local timerLabel = CreateInfoLabel(exploitsTab, "⏰ Timer: ...", 14)
local bloodHourLabel = CreateInfoLabel(exploitsTab, "🩸 Blood Hour: No", 15)
local powerLabel = CreateInfoLabel(exploitsTab, "⚡ Power: Scanning...", 16)



-- Power display — direct read from ReplicatedStorage.PowerValues.PowerLevel
local function getPowerLevel()
    local ok, val = pcall(function()
        return ReplicatedStorage.PowerValues.PowerLevel.Value
    end)
    if ok and val then
        return math.floor(val)
    end
    return nil
end

CreateSeparator(exploitsTab, 17)

-- 11. Unload
CreateButton(exploitsTab, "🗑️ Unload", function()
    for _, highlight in pairs(allHighlights) do pcall(function() highlight:Destroy() end) end
    allHighlights = {}
    for _, connection in pairs(allConnections) do pcall(function() connection:Disconnect() end) end
    allConnections = {}
    for _, marker in pairs(locationParts) do pcall(function() marker:Destroy() end) end
    locationParts = {}

    staminaEnabled = false
    nightVisionEnabled = false
    killAuraEnabled = false
    playerESPEnabled = false
    rakeESPEnabled = false
    scrapESPEnabled = false
    lootESPEnabled = false
    dayModeEnabled = false
    thirdPersonEnabled = false
    speedEnabled = false
    fovEnabled = false
    instaOpenEnabled = false
    noFallDamage = false
    antiDetectEnabled = false
    noClipEnabled = false
    locationESPEnabled = false
    autoFixPowerActive = false
    tpToStationActive = false
    returnFromStation()

    pcall(function() Workspace.CurrentCamera.FieldOfView = 70 end)
    pcall(function() LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson end)
    pcall(function()
        Lighting.ClockTime = 0
        Lighting.FogEnd = 200
        Lighting.GlobalShadows = true
    end)
    pcall(function() ScreenGui:Destroy() end)
end, 17)


-- ============================================================
--           HEARTBEAT ENFORCEMENT (persistent features)
-- ============================================================

-- EVERY FRAME: Camera, Speed, FOV, AntiDetect
trackConnection(RunService.Heartbeat:Connect(function()
    -- 3rd Person: enforce every frame, prevents reset on damage/equip
    if thirdPersonEnabled then
        pcall(function()
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = 100
            LocalPlayer.CameraMinZoomDistance = 0.5
        end)
    end

    -- WalkSpeed: enforce every frame + remove trap constraints
    if speedEnabled then
        pcall(function()
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = speedValue
                end
                -- Remove trap/slowdown body movers
                for _, obj in pairs(character:GetDescendants()) do
                    if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition")
                    or obj:IsA("BodyGyro") or obj:IsA("LinearVelocity") then
                        obj:Destroy()
                    end
                end
            end
        end)
    end

    -- JumpPower: enforce every frame
    if jumpEnabled then
        pcall(function()
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = jumpValue
                    humanoid.UseJumpPower = true
                end
            end
        end)
    end

    -- FOV: enforce every frame
    if fovEnabled then
        pcall(function() Workspace.CurrentCamera.FieldOfView = fovValue end)
    end

    -- Day Mode: enforce every frame (prevents flicker)
    if dayModeEnabled then
        pcall(function()
            Lighting.ClockTime = 14
            Lighting.FogEnd = 9e9
            Lighting.GlobalShadows = false
        end)
        pcall(function()
            local props = ReplicatedStorage:FindFirstChild("CurrentLightingProperties")
            if props and props:FindFirstChild("FogEnd") then
                props.FogEnd.Value = 9e9
            end
        end)
    end

    -- AntiDetect: block server position corrections (threshold: 8 studs)
    if antiDetectEnabled then
        pcall(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and lastSafePosition then
                local current = hrp.Position
                local horizontalDist = (
                    Vector3.new(current.X, 0, current.Z) -
                    Vector3.new(lastSafePosition.X, 0, lastSafePosition.Z)
                ).Magnitude

                -- Server correction = sudden jump > 8 studs in one frame
                -- (wall thickness is 2-5 studs, server sends you further)
                if horizontalDist > 8 and (tick() - antiDetectStartTime) > 2 then
                    hrp.CFrame = CFrame.new(lastSafePosition)
                else
                    lastSafePosition = current
                end
            end
        end)
    end

    -- NoClip: keep character parts non-collidable every frame
    if noClipEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end

    -- (Fix Power logic moved to task.spawn in toggle callback)
end))

-- REACTIVE: instant response to game property changes
trackConnection(LocalPlayer:GetPropertyChangedSignal("CameraMode"):Connect(function()
    if thirdPersonEnabled then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end
end))

trackConnection(LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
    if thirdPersonEnabled then
        LocalPlayer.CameraMaxZoomDistance = 100
    end
end))

trackConnection(Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
    if dayModeEnabled then Lighting.ClockTime = 14 end
end))

trackConnection(Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
    if dayModeEnabled then Lighting.FogEnd = 9e9 end
end))

-- Watch for camera changes (FOV reset on new camera)
local function watchCameraFOV()
    pcall(function()
        local camera = Workspace.CurrentCamera
        if camera then
            trackConnection(camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
                if fovEnabled then camera.FieldOfView = fovValue end
            end))
        end
    end)
end
watchCameraFOV()

trackConnection(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    watchCameraFOV()
end))

-- CHARACTER RESPAWN: re-apply active features after death
trackConnection(LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    -- Wait for character to fully load
    task.wait(1.5)

    -- Reset AntiDetect safe position to new spawn point
    if antiDetectEnabled then
        pcall(function()
            local hrp = newCharacter:WaitForChild("HumanoidRootPart", 5)
            if hrp then
                lastSafePosition = hrp.Position
                antiDetectStartTime = tick()
            end
        end)
    end
end))

-- THROTTLED: InstaOpen, MultiLoot, Info Labels (0.3s)
local throttleTick = 0
trackConnection(RunService.Heartbeat:Connect(function(deltaTime)
    throttleTick = throttleTick + deltaTime
    if throttleTick < 0.3 then return end
    throttleTick = 0

    -- Insta-Open Boxes
    if instaOpenEnabled then
        pcall(function()
            for _, box in pairs(Workspace.Debris.SupplyCrates:GetChildren()) do
                if box.Name == "Box" then
                    local guiPart = box:FindFirstChild("GUIPart")
                    if guiPart and guiPart:FindFirstChild("ProximityPrompt") then
                        local prompt = guiPart.ProximityPrompt
                        -- Save original HoldDuration before changing
                        if prompt:GetAttribute("_origHold") == nil then
                            prompt:SetAttribute("_origHold", prompt.HoldDuration)
                        end
                        prompt.HoldDuration = 0
                        for attribute, _ in pairs(prompt:GetAttributes()) do
                            if attribute ~= "_origHold" then
                                prompt:SetAttribute(attribute, false)
                            end
                        end
                    end
                    local unlockValue = box:FindFirstChild("UnlockValue")
                    if unlockValue then
                        -- Save original value before changing
                        if unlockValue:GetAttribute("_origVal") == nil then
                            unlockValue:SetAttribute("_origVal", unlockValue.Value)
                        end
                        unlockValue.Value = 100
                    end
                end
            end
        end)
    end

    -- Multi-Loot: continuous grab when enabled
    -- [COMMENTED OUT]
    -- if multiLootEnabled and instaOpenEnabled then
    --     pcall(function()
    --         ReplicatedStorage.SupplyClientEvent:FireServer("Open", true)
    --     end)
    --     pcall(function()
    --         for _, box in pairs(Workspace.Debris.SupplyCrates:GetChildren()) do
    --             if box.Name == "Box" then
    --                 for _, sub in pairs(box:GetDescendants()) do
    --                     if sub:IsA("ProximityPrompt") then
    --                         sub.HoldDuration = 0
    --                         fireproximityprompt(sub)
    --                     end
    --                     if sub:IsA("ClickDetector") then
    --                         fireclickdetector(sub)
    --                     end
    --                 end
    --             end
    --         end
    --     end)
    -- end

    -- Info labels update
    pcall(function()
        local rake = Workspace:FindFirstChild("Rake")
        if rake and rake:FindFirstChild("TargetVal") and rake.TargetVal.Value then
            rakeTargetLabel.Text = "  🎯 " .. tostring(rake.TargetVal.Value.Parent)
        else
            rakeTargetLabel.Text = "  🎯 Target: None"
        end
    end)

    pcall(function()
        if ReplicatedStorage:FindFirstChild("Night") and ReplicatedStorage:FindFirstChild("Timer") then
            local prefix = ReplicatedStorage.Night.Value and "⏰ Day: " or "⏰ Night: "
            timerLabel.Text = "  " .. prefix .. tostring(ReplicatedStorage.Timer.Value)
        end
    end)

    pcall(function()
        if ReplicatedStorage:FindFirstChild("InitiateBloodHour") then
            if ReplicatedStorage.InitiateBloodHour.Value == true then
                bloodHourLabel.Text = "  🩸 ⚠️ BLOOD HOUR!"
                bloodHourLabel.TextColor3 = Colors.Red
            else
                bloodHourLabel.Text = "  🩸 Blood Hour: No"
                bloodHourLabel.TextColor3 = Colors.TextDim
            end
        end
    end)

    -- Power level display (direct read) + map marker update
    pcall(function()
        local level = getPowerLevel()
        if level then
            powerLabel.Text = "  ⚡ Power: " .. tostring(level) .. " / 1000"
            -- Update map marker sub-label if Location Names is active
            if powerStationSubLabel then
                powerStationSubLabel.Text = "⚡ " .. tostring(level) .. " / 1000"
            end
        else
            powerLabel.Text = "  ⚡ Power: N/A"
            if powerStationSubLabel then
                powerStationSubLabel.Text = "⚡ N/A"
            end
        end
    end)
end))

-- ESP scan loop (1.2s)
task.spawn(function()
    while task.wait(1.2) do
        -- Player ESP
        if playerESPEnabled then
            pcall(function()
                for _, player in pairs(Players:GetChildren()) do
                    if player ~= LocalPlayer and player.Character then
                        createHighlight(player.Character, Color3.fromRGB(0, 120, 255), "SE_P", espPlayerList)
                        createBillboard(player.Character, player.Name, Color3.fromRGB(52, 211, 153), "SB_P", espPlayerList)
                    end
                end
            end)
        end

        -- Rake ESP
        if rakeESPEnabled then
            pcall(function()
                for _, object in pairs(Workspace:GetChildren()) do
                    if object.Name:match("Rake") or object.Name == "Monster" then
                        createHighlight(object, Color3.fromRGB(255, 0, 0), "SE_R", espRakeList)
                        local healthText = "Rake"
                        pcall(function()
                            if object:FindFirstChild("Monster") then
                                healthText = "Rake HP: " .. tostring(math.floor(object.Monster.Health))
                            end
                        end)
                        createBillboard(object, healthText, Color3.fromRGB(255, 80, 80), "SB_R", espRakeList)
                    end
                end
            end)
        end

        -- Scrap ESP
        if scrapESPEnabled then
            pcall(function()
                if Workspace:FindFirstChild("Filter") and Workspace.Filter:FindFirstChild("ScrapSpawns") then
                    for _, scrap in pairs(Workspace.Filter.ScrapSpawns:GetDescendants()) do
                        if scrap.Name == "Scrap" then
                            local level = "?"
                            pcall(function()
                                if scrap.Parent and scrap.Parent:FindFirstChild("LevelVal") then
                                    level = tostring(scrap.Parent.LevelVal.Value)
                                end
                            end)
                            createHighlight(scrap, Color3.fromRGB(139, 69, 19), "SE_S", espScrapList)
                            createBillboard(scrap, "Scrap Lvl " .. level, Color3.fromRGB(180, 120, 60), "SB_S", espScrapList)
                        end
                    end
                end
            end)
        end

        -- Loot ESP
        if lootESPEnabled then
            pcall(function()
                for _, object in pairs(Workspace:GetChildren()) do
                    if object.Name == "FlareGunPickUp" then
                        createHighlight(object, Color3.fromRGB(255, 220, 0), "SE_L", espLootList)
                        createBillboard(object, "Flare Gun", Color3.fromRGB(255, 220, 0), "SB_L", espLootList)
                    end
                end
                if Workspace:FindFirstChild("Debris") and Workspace.Debris:FindFirstChild("SupplyCrates") then
                    for _, box in pairs(Workspace.Debris.SupplyCrates:GetChildren()) do
                        if box.Name == "Box" then
                            createHighlight(box, Color3.fromRGB(255, 180, 0), "SE_L2", espLootList)
                            createBillboard(box, "Supply Box", Color3.fromRGB(255, 200, 50), "SB_L2", espLootList)
                        end
                    end
                end
            end)
        end
    end
end)
