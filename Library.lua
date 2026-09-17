-- N3 mogg hub — UI Library
-- Full loading animation, compact topbar with FPS/ping, sub-tabs, drag blur

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService       = game:GetService("GuiService")
local Players          = game:GetService("Players")
local Stats            = game:GetService("Stats")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")

local DEFAULT_LOGO = "rbxassetid://120464926691610"
local TWEEN = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local NOTIFICATION_TWEEN = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local DRAG_FADE_TWEEN = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local WIN_TWEEN = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TOPBAR_TWEEN = TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local ICONS = {
    home = "rbxassetid://4562959382", settings = "rbxassetid://4738901432",
    gear = "rbxassetid://117427252698455", menu = "rbxassetid://10734896206",
    grid = "rbxassetid://10734950309", sliders = "rbxassetid://10734897102",
    sword = "rbxassetid://10747384394", combat = "rbxassetid://10747384394",
    shield = "rbxassetid://98206735878224", target = "rbxassetid://123292899197910",
    crosshair = "rbxassetid://10723434538", bolt = "rbxassetid://79160363518966",
    star = "rbxassetid://10734924532", player = "rbxassetid://82179723353246",
    person = "rbxassetid://77052607579460", users = "rbxassetid://10747387298",
    eye = "rbxassetid://131012605615689", visible = "rbxassetid://10709790644",
    esp = "rbxassetid://10709790644", globe = "rbxassetid://13567318216",
    world = "rbxassetid://10709778567", map = "rbxassetid://84513890895579",
    move = "rbxassetid://10723422998", bell = "rbxassetid://10723345067",
    warning = "rbxassetid://10747387522", check = "rbxassetid://5180860280",
    lock = "rbxassetid://10723417148", refresh = "rbxassetid://10723417783",
    folder = "rbxassetid://10709791437", save = "rbxassetid://10709791258",
    clipboard = "rbxassetid://10709751190", music = "rbxassetid://10723421745",
    clock = "rbxassetid://10723345037", tool = "rbxassetid://10734950309",
    bug = "rbxassetid://10723415903", coin = "rbxassetid://13522871708",
    skull = "rbxassetid://10747384394", teleport = "rbxassetid://10090587519",
    speed = "rbxassetid://10723422998", crown = "rbxassetid://10734924532",
    gem = "rbxassetid://10723421745", layers = "rbxassetid://10723417148",
}

local NOTIFICATION_STYLES = {
    info    = { Name = "Info",    Color = Color3.fromRGB(150, 120, 220), Icon = ICONS.bell },
    success = { Name = "Success", Color = Color3.fromRGB(120, 180, 130), Icon = ICONS.check },
    warning = { Name = "Warning", Color = Color3.fromRGB(200, 160, 90),  Icon = ICONS.warning },
    error   = { Name = "Error",   Color = Color3.fromRGB(200, 100, 100), Icon = ICONS.warning },
}

local C = {
    WindowBg     = Color3.fromRGB(18, 15, 26),
    CardBg       = Color3.fromRGB(23, 19, 32),
    Border       = Color3.fromRGB(38, 32, 52),
    Element      = Color3.fromRGB(32, 26, 44),
    ElementHover = Color3.fromRGB(40, 33, 54),
    Badge        = Color3.fromRGB(46, 38, 62),
    BadgeIdle    = Color3.fromRGB(36, 30, 48),
    NavActive    = Color3.fromRGB(32, 26, 44),
    NavHover     = Color3.fromRGB(28, 22, 38),
    PillActive   = Color3.fromRGB(42, 34, 58),
    White        = Color3.fromRGB(255, 255, 255),
    TextGray     = Color3.fromRGB(160, 150, 180),
    TextDim      = Color3.fromRGB(120, 110, 145),
    KnobOff      = Color3.fromRGB(90, 80, 110),
    KnobOn       = Color3.fromRGB(15, 10, 25),
    TrackBg      = Color3.fromRGB(46, 38, 62),
    Placeholder  = Color3.fromRGB(95, 85, 120),
    HotbarBg     = Color3.fromRGB(23, 19, 32),
    HotbarBorder = Color3.fromRGB(38, 32, 52),
    HotbarActive = Color3.fromRGB(32, 26, 44),
    HotbarHover  = Color3.fromRGB(40, 33, 54),
    HotbarDot    = Color3.fromRGB(220, 210, 240),
    Accent       = Color3.fromRGB(168, 120, 245),
    AccentDim    = Color3.fromRGB(50, 30, 80),
    AccentText   = Color3.fromRGB(15, 8, 25),
    KnobAccent   = Color3.fromRGB(20, 12, 32),
}

local THEMES = {
    Dark = table.clone(C),
    Light = {
        WindowBg = Color3.fromRGB(245, 243, 250), CardBg = Color3.fromRGB(250, 248, 253),
        Border = Color3.fromRGB(218, 212, 228), Element = Color3.fromRGB(235, 230, 242),
        ElementHover = Color3.fromRGB(228, 222, 238), Badge = Color3.fromRGB(224, 218, 234),
        BadgeIdle = Color3.fromRGB(232, 227, 240), NavActive = Color3.fromRGB(238, 233, 245),
        NavHover = Color3.fromRGB(242, 238, 249), PillActive = Color3.fromRGB(226, 220, 238),
        White = Color3.fromRGB(30, 22, 45), TextGray = Color3.fromRGB(90, 80, 110),
        TextDim = Color3.fromRGB(110, 100, 130), KnobOff = Color3.fromRGB(150, 140, 170),
        KnobOn = Color3.fromRGB(250, 248, 255), TrackBg = Color3.fromRGB(210, 204, 222),
        Placeholder = Color3.fromRGB(140, 130, 160), HotbarBg = Color3.fromRGB(250, 248, 253),
        HotbarBorder = Color3.fromRGB(218, 212, 228), HotbarActive = Color3.fromRGB(235, 230, 242),
        HotbarHover = Color3.fromRGB(228, 222, 238), HotbarDot = Color3.fromRGB(70, 60, 90),
        Accent = Color3.fromRGB(140, 90, 220), AccentDim = Color3.fromRGB(215, 200, 240),
        AccentText = Color3.fromRGB(255, 255, 255), KnobAccent = Color3.fromRGB(255, 255, 255),
    },
    OLED = {
        WindowBg = Color3.fromRGB(0, 0, 0), CardBg = Color3.fromRGB(5, 3, 10),
        Border = Color3.fromRGB(25, 20, 38), Element = Color3.fromRGB(12, 9, 18),
        ElementHover = Color3.fromRGB(20, 15, 30), Badge = Color3.fromRGB(30, 24, 44),
        BadgeIdle = Color3.fromRGB(16, 12, 24), NavActive = Color3.fromRGB(10, 7, 16),
        NavHover = Color3.fromRGB(6, 4, 10), PillActive = Color3.fromRGB(24, 18, 36),
        White = Color3.fromRGB(255, 255, 255), TextGray = Color3.fromRGB(170, 160, 190),
        TextDim = Color3.fromRGB(130, 120, 150), KnobOff = Color3.fromRGB(80, 70, 100),
        KnobOn = Color3.fromRGB(3, 2, 6), TrackBg = Color3.fromRGB(34, 28, 48),
        Placeholder = Color3.fromRGB(95, 85, 120), HotbarBg = Color3.fromRGB(5, 3, 10),
        HotbarBorder = Color3.fromRGB(25, 20, 38), HotbarActive = Color3.fromRGB(12, 9, 18),
        HotbarHover = Color3.fromRGB(20, 15, 30), HotbarDot = Color3.fromRGB(200, 190, 220),
        Accent = Color3.fromRGB(180, 140, 255), AccentDim = Color3.fromRGB(40, 24, 70),
        AccentText = Color3.fromRGB(10, 5, 20), KnobAccent = Color3.fromRGB(12, 8, 22),
    },
}

local REVERSE = {}
local function rebuildReverse()
    table.clear(REVERSE)
    for key, color in pairs(C) do REVERSE[color:ToHex()] = key end
end
rebuildReverse()

local function tween(inst, props) TweenService:Create(inst, TWEEN, props):Play() end
local function paint(inst, prop, key, instant)
    inst:SetAttribute("Theme_" .. prop, key)
    if instant then inst[prop] = C[key] else tween(inst, { [prop] = C[key] }) end
end
local function safeHex(value)
    if typeof(value) ~= "Color3" then return nil end
    local ok, result = pcall(function() return value:ToHex() end)
    return ok and result or nil
end

local function make(className, props)
    local inst = Instance.new(className)
    if inst:IsA("GuiObject") then
        inst.BorderSizePixel = 0
        inst.BackgroundColor3 = C.WindowBg
    end
    if inst:IsA("GuiButton") then inst.AutoButtonColor = false end
    if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
        inst.Font = Enum.Font.Gotham
        inst.TextColor3 = C.White
        inst.TextSize = 13
    end
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    if inst:IsA("GuiObject") then
        local key = REVERSE[safeHex(inst.BackgroundColor3)]
        if key then inst:SetAttribute("Theme_BackgroundColor3", key) end
    end
    if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
        local key = REVERSE[safeHex(inst.TextColor3)]
        if key then inst:SetAttribute("Theme_TextColor3", key) end
    end
    if inst:IsA("TextBox") then
        local key = REVERSE[safeHex(inst.PlaceholderColor3)]
        if key then inst:SetAttribute("Theme_PlaceholderColor3", key) end
    end
    if inst:IsA("ScrollingFrame") then
        local key = REVERSE[safeHex(inst.ScrollBarImageColor3)]
        if key then inst:SetAttribute("Theme_ScrollBarImageColor3", key) end
    end
    if inst:IsA("UIStroke") then
        local key = REVERSE[safeHex(inst.Color)]
        if key then inst:SetAttribute("Theme_Color", key) end
    end
    inst.Parent = props.Parent
    return inst
end

local function corner(parent, radius) return make("UICorner", { CornerRadius = UDim.new(0, radius), Parent = parent }) end
local function circle(parent) return make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = parent }) end
local function stroke(parent, color)
    return make("UIStroke", { Color = color or C.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent })
end
local function pad(parent, top, bottom, left, right)
    return make("UIPadding", { PaddingTop = UDim.new(0, top), PaddingBottom = UDim.new(0, bottom), PaddingLeft = UDim.new(0, left), PaddingRight = UDim.new(0, right), Parent = parent })
end

local function refreshEdgeGradient(g)
    local edgeKey = g:GetAttribute("ThemeGradient_Edge")
    if not edgeKey then return end
    local edge = C[edgeKey]; if not edge then return end
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, edge), ColorSequenceKeypoint.new(0.42, edge),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.58, edge), ColorSequenceKeypoint.new(1.00, edge),
    })
end
local function edgeAccentGradient(parent, edgeKey)
    local g = make("UIGradient", { Rotation = 0, Parent = parent })
    g:SetAttribute("ThemeGradient_Edge", edgeKey or "Accent")
    refreshEdgeGradient(g)
    return g
end

local function autoOrder(inst) inst.LayoutOrder = #inst.Parent:GetChildren() end
local function isInside(gui, pos)
    local p, s = gui.AbsolutePosition, gui.AbsoluteSize
    return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
end
local function fire(callback, ...) if typeof(callback) == "function" then task.spawn(callback, ...) end end

local function normalizeAssetId(value)
    if value == nil or value == "" then return DEFAULT_LOGO end
    if type(value) == "number" then return "rbxassetid://" .. tostring(math.floor(value)) end
    local text = tostring(value)
    if string.match(text, "^rbxassetid://") or string.match(text, "^rbxthumb://") or string.match(text, "^https?://") then return text end
    local id = string.match(text, "%d+")
    return id and ("rbxassetid://" .. id) or DEFAULT_LOGO
end
local function getNotificationStyle(kind)
    local key = string.lower(tostring(kind or "Info"))
    return NOTIFICATION_STYLES[key] or NOTIFICATION_STYLES.info
end
local function guiVisible(gui)
    local node = gui
    while node and node:IsA("GuiObject") do
        if not node.Visible then return false end
        node = node.Parent
    end
    return true
end

local function makeDraggable(frame, blockers, onStart, onEnd)
    local dragging = false
    local dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local pos = Vector2.new(input.Position.X, input.Position.Y)
        for _, gui in ipairs(blockers) do
            if guiVisible(gui) and isInside(gui, pos) then return end
        end
        dragging = true; dragStart = input.Position; startPos = frame.Position
        if typeof(onStart) == "function" then onStart() end
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End and dragging then
                dragging = false
                if typeof(onEnd) == "function" then onEnd() end
            end
        end)
    end)
    return UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function sortIcon(parent)
    local holder = make("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -7, 0.5, 0), Size = UDim2.fromOffset(9, 7), Parent = parent })
    for i, width in ipairs({ 9, 7, 5 }) do
        make("Frame", { Position = UDim2.fromOffset(0, (i - 1) * 3), Size = UDim2.fromOffset(width, 1), BackgroundColor3 = C.TextDim, Parent = holder })
    end
end
local function inputIcon(parent)
    local holder = make("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -7, 0.5, 0), Size = UDim2.fromOffset(10, 10), Parent = parent })
    local box = make("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = holder }); corner(box, 2); stroke(box, C.TextDim)
    make("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(1, 4), BackgroundColor3 = C.TextDim, Parent = holder })
end

local TagSystem = { _running = false, OnUsersUpdated = function() end, RemoveListener = function() end }
local function stopTagSystem() end

-- ════════════════════════════════════════════════════════════════════════════
local Library = {
    Version = "2.2", ChatFree = true, Themes = THEMES, Icons = ICONS, DefaultLogo = DEFAULT_LOGO,
    Flags = {}, State = {}, _stateListeners = {}, ConfigFolder = "N3MoggHub/configs",
    _windows = {}, _windowObjects = {}, _currentTheme = "Dark", TagSystem = TagSystem,
}
local Window = {}; Window.__index = Window
local Tab = {}; Tab.__index = Tab
local SubTab = {}; SubTab.__index = SubTab

function Library:SetState(key, val)
    local k = tostring(key); Library.State[k] = val
    if Library._stateListeners[k] then for _, fn in ipairs(Library._stateListeners[k]) do pcall(fn, val) end end
    return val
end
function Library:GetState(key, default)
    local v = Library.State[tostring(key)]; if v == nil then return default end; return v
end
function Library:BindState(key, fn)
    local k = tostring(key)
    if not Library._stateListeners[k] then Library._stateListeners[k] = {} end
    table.insert(Library._stateListeners[k], fn)
    if Library.State[k] ~= nil then pcall(fn, Library.State[k]) end
    return fn
end
function Library:Get(flag, default)
    local entry = Library.Flags[tostring(flag)]
    if entry and entry.api and entry.api.Get then
        local v = entry.api.Get(); if v ~= nil then return v end
    end
    return default
end
function Library:Set(flag, value)
    local entry = Library.Flags[tostring(flag)]
    if entry and entry.api and entry.api.Set then entry.api.Set(entry.api, value); return true end
    return false
end
local function registerFlag(flag, kind, api)
    if flag ~= nil and api then Library.Flags[tostring(flag)] = { kind = kind, api = api } end
    return api
end

local THEME_PROPS = { "BackgroundColor3", "TextColor3", "PlaceholderColor3", "ScrollBarImageColor3", "Color", "ImageColor3" }
function Library:SetTheme(theme)
    local themeName = nil
    if type(theme) == "string" then themeName = theme; theme = THEMES[theme]; if not theme then return false end
    elseif type(theme) ~= "table" then return false end
    for key in pairs(C) do if theme[key] ~= nil then C[key] = theme[key] end end
    Library._currentTheme = themeName or "Custom"
    rebuildReverse()
    for _, gui in ipairs(Library._windows) do
        if gui and gui.Parent then
            for _, inst in ipairs(gui:GetDescendants()) do
                if inst:IsA("UIGradient") then refreshEdgeGradient(inst) end
                local goal
                for _, prop in ipairs(THEME_PROPS) do
                    local key = inst:GetAttribute("Theme_" .. prop)
                    if key and C[key] then goal = goal or {}; goal[prop] = C[key] end
                end
                if goal then tween(inst, goal) end
            end
        end
    end
    return true
end
function Library:GetTheme() return Library._currentTheme end
function Library:SetAccent(color)
    if typeof(color) ~= "Color3" then return false end
    C.Accent = color
    C.AccentDim = color:Lerp(Color3.fromRGB(0, 0, 0), 0.75)
    local h, s, v = color:ToHSV()
    C.KnobAccent = Color3.fromHSV(h, math.min(s * 0.8, 0.6), math.max(v * 0.15, 0.08))
    C.AccentText = (v > 0.7) and Color3.fromRGB(10, 5, 20) or Color3.fromRGB(255, 255, 255)
    rebuildReverse()
    for _, gui in ipairs(Library._windows) do
        if gui and gui.Parent then
            for _, inst in ipairs(gui:GetDescendants()) do
                if inst:IsA("UIGradient") then refreshEdgeGradient(inst) end
                local goal
                for _, prop in ipairs(THEME_PROPS) do
                    local key = inst:GetAttribute("Theme_" .. prop)
                    if key and C[key] then goal = goal or {}; goal[prop] = C[key] end
                end
                if goal then tween(inst, goal) end
            end
        end
    end
    return true
end
function Library:GetAccent() return C.Accent end
function Library:Notify(opts)
    for index = #Library._windowObjects, 1, -1 do
        local window = Library._windowObjects[index]
        if window and window.ScreenGui and window.ScreenGui.Parent then return window:Notify(opts) end
    end
    return nil
end

-- ═══ CREATE WINDOW ═══
function Library:CreateWindow(opts)
    opts = opts or {}
    local logoAsset = normalizeAssetId(opts.Logo or DEFAULT_LOGO)
    local logoZoom = math.clamp(tonumber(opts.LogoZoom) or 1, 1, 6)
    local windowSize = opts.Size or UDim2.fromOffset(700, 490)
    local windowPosition = opts.Position or UDim2.fromScale(0.5, 0.5)
    local guiName = opts.GuiName or "N3MoggHub"

    local targetParent
    if typeof(opts.Parent) == "Instance" then targetParent = opts.Parent
    else
        pcall(function() targetParent = (gethui and gethui()) or game:GetService("CoreGui") end)
        if not targetParent then targetParent = Players.LocalPlayer:WaitForChild("PlayerGui") end
    end
    for _, child in ipairs(targetParent:GetChildren()) do
        if child:IsA("ScreenGui") and child.Name == guiName then child:Destroy() end
    end

    local screenGui = make("ScreenGui", {
        Name = guiName, ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = opts.DisplayOrder or 10,
    })
    local parented = pcall(function() screenGui.Parent = targetParent end)
    if not parented then
        targetParent = Players.LocalPlayer:WaitForChild("PlayerGui")
        screenGui.Parent = targetParent
    end
    table.insert(Library._windows, screenGui)

    local containerW = windowSize.X.Offset
    local containerH = windowSize.Y.Offset

    local container = make("Frame", {
        Name = "Container", Size = UDim2.fromOffset(containerW, containerH),
        Position = windowPosition, AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1, ZIndex = 2, Parent = screenGui,
    })
    local containerScale = make("UIScale", { Scale = 1, Parent = container })

    -- ═══ FULL LOADING ANIMATION ═══
    local loadingEnabled  = opts.LoadingAnimation ~= false
    local loadingDuration = math.clamp(tonumber(opts.LoadingDuration) or 1.5, 0.6, 8)
    local loadingText     = tostring(opts.LoadingText or opts.Name or "N3 mogg hub")
    local loadingSub      = tostring(opts.LoadingSubtitle or "HUB")
    local loadingFooter   = tostring(opts.LoadingFooter or "N3 mogg hub")
    local ACC       = C.Accent
    local ACC_DARK  = C.AccentDim or Color3.fromRGB(50, 30, 80)
    local ACC_LIGHT = Color3.fromRGB(255, 255, 255)
    local loadingComplete = not loadingEnabled
    local loadingMotionComplete = not loadingEnabled
    local loadingLayer

    if loadingEnabled then
        loadingLayer = make("CanvasGroup", {
            Name = "StartupLoader", Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1,
            GroupTransparency = 0, ZIndex = 500, Parent = screenGui,
        })
        local loadingBlur = Instance.new("BlurEffect")
        loadingBlur.Size = 0
        pcall(function() loadingBlur.Parent = game:GetService("Lighting") end)

        local function sideLabel(anchorX)
            local lbl = make("TextLabel", {
                Size = UDim2.fromOffset(260, 54), Position = UDim2.new(anchorX, 0, 0.5, -27),
                AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
                Text = loadingText, Font = Enum.Font.GothamBlack, TextScaled = true,
                TextColor3 = C.White, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), TextStrokeTransparency = 0.45,
                TextTransparency = 1, ZIndex = 508, Parent = loadingLayer,
            })
            make("UIGradient", { Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, ACC_DARK),
                ColorSequenceKeypoint.new(0.5, ACC_LIGHT),
                ColorSequenceKeypoint.new(1, ACC_DARK),
            }), Parent = lbl })
            return lbl
        end
        local leftLbl  = sideLabel(0.18)
        local rightLbl = sideLabel(0.82)

        local mainWrap = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(80, 36),
            Position = UDim2.new(0.5, 0, 0.5, -20), BackgroundTransparency = 1, ZIndex = 510, Parent = loadingLayer,
        })
        local tag = make("TextLabel", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = loadingText,
            Font = Enum.Font.GothamBlack, TextScaled = true, TextColor3 = C.White,
            TextStrokeColor3 = Color3.fromRGB(0, 0, 0), TextStrokeTransparency = 0.3,
            TextXAlignment = Enum.TextXAlignment.Center, TextTransparency = 1, ZIndex = 510, Parent = mainWrap,
        })
        local tagGrad = make("UIGradient", { Rotation = 0, Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, ACC_DARK),
            ColorSequenceKeypoint.new(0.35, ACC),
            ColorSequenceKeypoint.new(0.5, ACC_LIGHT),
            ColorSequenceKeypoint.new(0.65, ACC),
            ColorSequenceKeypoint.new(1, ACC_DARK),
        }), Parent = tag })

        local line = make("Frame", {
            Size = UDim2.fromOffset(0, 2), Position = UDim2.new(0.5, 0, 0.5, 60), AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = ACC, BackgroundTransparency = 1, ZIndex = 510, Parent = loadingLayer,
        })
        make("UIGradient", { Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1),
        }), Parent = line })

        local sub = make("TextLabel", {
            Size = UDim2.fromOffset(400, 22), Position = UDim2.new(0.5, 0, 0.5, 82), AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1, Text = loadingSub, Font = Enum.Font.GothamBold, TextSize = 16,
            TextColor3 = ACC_LIGHT, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), TextStrokeTransparency = 0.5,
            TextXAlignment = Enum.TextXAlignment.Center, TextTransparency = 1, ZIndex = 510, Parent = loadingLayer,
        })
        local footer = make("TextLabel", {
            Size = UDim2.fromOffset(400, 16), Position = UDim2.new(0.5, 0, 0.5, 112), AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1, Text = loadingFooter, Font = Enum.Font.GothamMedium, TextSize = 11,
            TextColor3 = Color3.fromRGB(200, 150, 90), TextStrokeColor3 = Color3.fromRGB(0, 0, 0), TextStrokeTransparency = 0.6,
            TextXAlignment = Enum.TextXAlignment.Center, TextTransparency = 1, ZIndex = 510, Parent = loadingLayer,
        })

        task.spawn(function()
            if loadingBlur then TweenService:Create(loadingBlur, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Size = 10 }):Play() end
            TweenService:Create(loadingLayer, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { BackgroundTransparency = 0.35 }):Play()
            TweenService:Create(leftLbl, TweenInfo.new(0.15, Enum.EasingStyle.Quad), { TextTransparency = 0 }):Play()
            task.wait(0.08)
            TweenService:Create(rightLbl, TweenInfo.new(0.15, Enum.EasingStyle.Quad), { TextTransparency = 0 }):Play()
            task.wait(math.clamp(loadingDuration * 0.25, 0.15, 0.8))
            if not loadingLayer.Parent then return end
            local slideInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            TweenService:Create(leftLbl, slideInfo, { Position = UDim2.new(0.5, 0, 0.5, -27) }):Play()
            TweenService:Create(rightLbl, slideInfo, { Position = UDim2.new(0.5, 0, 0.5, -27) }):Play()
            task.wait(0.22)
            leftLbl.Visible = false; rightLbl.Visible = false
            tag.TextTransparency = 0
            TweenService:Create(mainWrap, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(820, 140) }):Play()
            task.wait(0.15)
            line.BackgroundTransparency = 0
            TweenService:Create(line, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(380, 2) }):Play()
            TweenService:Create(sub, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { TextTransparency = 0 }):Play()
            task.wait(0.08)
            TweenService:Create(footer, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { TextTransparency = 0.1 }):Play()
            task.spawn(function()
                local off = -0.5
                while loadingLayer.Parent and not loadingComplete and tag.Parent do
                    off = off + 0.018; if off > 1.5 then off = -0.5 end
                    tagGrad.Offset = Vector2.new(off, 0)
                    task.wait()
                end
            end)
            task.wait(math.clamp(loadingDuration * 0.35, 0.15, 1.0))
            loadingMotionComplete = true
        end)
    end

    -- ═══ MAIN WINDOW ═══
    local main = make("Frame", {
        Name = "Main", Size = windowSize, Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = C.WindowBg, ClipsDescendants = true,
        Visible = not loadingEnabled, ZIndex = 2, Parent = container,
    })
    corner(main, 12); stroke(main, C.Border)

    local mainGlowStroke = make("UIStroke", { Color = C.Accent, Thickness = 1.6, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = main })
    local mainGlowGradient = edgeAccentGradient(mainGlowStroke, "Accent")
    mainGlowGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 1.0), NumberSequenceKeypoint.new(0.36, 1.0),
        NumberSequenceKeypoint.new(0.50, 0.0), NumberSequenceKeypoint.new(0.64, 1.0),
        NumberSequenceKeypoint.new(1.00, 1.0),
    })
    local mainRevealScale = make("UIScale", { Scale = loadingEnabled and 0.965 or 1, Parent = main })

    -- ═══ CONTROLS (close / minimize) ═══
    local controls = make("Frame", {
        Name = "CornerControls", AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -6, 0, 8), Size = UDim2.fromOffset(36, 16),
        BackgroundTransparency = 1, ZIndex = 10, Parent = main,
    })
    local closeBtn = make("TextButton", {
        Text = "", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(14, 14), BackgroundColor3 = Color3.fromRGB(190, 60, 60), ZIndex = 12, Parent = controls,
    })
    circle(closeBtn)
    local minimizeBtn = make("TextButton", {
        Text = "", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.fromOffset(14, 14), BackgroundColor3 = Color3.fromRGB(255, 195, 0), ZIndex = 12, Parent = controls,
    })
    circle(minimizeBtn)

    local noDrag = { closeBtn, minimizeBtn }

    -- ═══ SIDEBAR ═══
    local sidebar = make("Frame", { Size = UDim2.new(0, 190, 1, 0), BackgroundTransparency = 1, Parent = main })
    local brand = make("Frame", { Name = "Brand", Position = UDim2.fromOffset(12, 12), Size = UDim2.new(1, -24, 0, 64), BackgroundColor3 = C.CardBg, Parent = sidebar })
    corner(brand, 10); stroke(brand, C.Border)
    local logoHolder = make("Frame", { Position = UDim2.fromOffset(9, 9), Size = UDim2.fromOffset(46, 46), BackgroundTransparency = 1, ClipsDescendants = true, Parent = brand })
    local logoImg = make("ImageLabel", { Image = logoAsset, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(logoZoom, logoZoom), ScaleType = Enum.ScaleType.Fit, Parent = logoHolder })
    local logoFallback = make("TextLabel", { Text = "N", Font = Enum.Font.GothamBlack, TextSize = 28, TextColor3 = C.Accent, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = false, Parent = logoHolder })
    task.delay(2, function()
        if not logoImg.IsLoaded then logoFallback.Visible = true; logoImg.Visible = false end
    end)
    make("TextLabel", { Text = opts.Name or "N3 mogg hub", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(64, 16), Size = UDim2.new(1, -72, 0, 17), Parent = brand })
    make("TextLabel", { Text = opts.BrandSubtitle or ("v" .. Library.Version), Font = Enum.Font.GothamMedium, TextSize = 9, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(64, 35), Size = UDim2.new(1, -72, 0, 13), Parent = brand })

    local lp = Players.LocalPlayer
    local pcard = make("Frame", { Position = UDim2.fromOffset(12, 88), Size = UDim2.new(1, -24, 0, 52), BackgroundColor3 = C.CardBg, Parent = sidebar })
    corner(pcard, 10); stroke(pcard, C.Border)
    local avH = make("Frame", { Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(36, 36), BackgroundColor3 = C.Element, Parent = pcard })
    corner(avH, 8)
    make("ImageLabel", { Image = "rbxthumb://type=AvatarHeadShot&id=" .. lp.UserId .. "&w=150&h=150", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop, Parent = avH })
    stroke(avH, C.Accent).Transparency = 0.4
    make("TextLabel", { Text = lp.DisplayName, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(52, 10), Size = UDim2.new(1, -60, 0, 15), Parent = pcard })
    make("TextLabel", { Text = "@" .. lp.Name, Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(52, 28), Size = UDim2.new(1, -60, 0, 13), Parent = pcard })

    local wmHolder = make("Frame", { BackgroundTransparency = 1, ClipsDescendants = true, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 24), Size = UDim2.fromOffset(156, 156), ZIndex = 0, Parent = sidebar })
    local wmImg = make("ImageLabel", { Image = logoAsset, BackgroundTransparency = 1, ImageTransparency = 0.88, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(logoZoom, logoZoom), ScaleType = Enum.ScaleType.Fit, ZIndex = 3, Parent = wmHolder })

    make("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 16, 1, -19), Size = UDim2.fromOffset(6, 6), BackgroundColor3 = NOTIFICATION_STYLES.success.Color, Parent = sidebar })
    make("TextLabel", { Text = opts.StatusText or "N3 mogg hub ready", Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.new(0, 28, 1, -27), Size = UDim2.new(1, -40, 0, 16), Parent = sidebar })

    local divLine = make("Frame", { Position = UDim2.fromOffset(190, 0), Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = C.Accent, Parent = main })
    make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.5), NumberSequenceKeypoint.new(1, 1) }), Parent = divLine })
    local content = make("Frame", { Position = UDim2.fromOffset(191, 0), Size = UDim2.new(1, -191, 1, 0), BackgroundTransparency = 1, Parent = main })

    -- ═══ DRAG WITH BLUR ═══
    local fadeRoots = { controls, sidebar, divLine, content }
    local fadeOrig = {}
    local innerHidden = false
    local FADE_PROPS = {
        { prop = "BackgroundTransparency", test = function(d) return d:IsA("GuiObject") end },
        { prop = "TextTransparency", test = function(d) return d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") end },
        { prop = "ImageTransparency", test = function(d) return d:IsA("ImageLabel") or d:IsA("ImageButton") end },
        { prop = "ScrollBarImageTransparency", test = function(d) return d:IsA("ScrollingFrame") end },
        { prop = "Transparency", test = function(d) return d:IsA("UIStroke") end },
    }
    local function eachFadeInst(fn)
        for _, root in ipairs(fadeRoots) do
            if root and root.Parent then
                fn(root)
                for _, d in ipairs(root:GetDescendants()) do fn(d) end
            end
        end
    end
    local function setInnerHidden(hide)
        if hide == innerHidden then return end
        innerHidden = hide
        eachFadeInst(function(d)
            for _, entry in ipairs(FADE_PROPS) do
                if entry.test(d) then
                    local prop = entry.prop
                    if hide then
                        local cur = d[prop]
                        if cur < 1 then
                            fadeOrig[d] = fadeOrig[d] or {}
                            if fadeOrig[d][prop] == nil then fadeOrig[d][prop] = cur end
                            TweenService:Create(d, DRAG_FADE_TWEEN, { [prop] = 1 }):Play()
                        end
                    else
                        local o = fadeOrig[d]
                        if o and o[prop] ~= nil then
                            TweenService:Create(d, DRAG_FADE_TWEEN, { [prop] = o[prop] }):Play()
                        end
                    end
                end
            end
        end)
    end
    local dragConn = makeDraggable(container, noDrag, function() setInnerHidden(true) end, function() setInnerHidden(false) end)

    -- ═══ TOPBAR (compact, with FPS + ping) ═══
    local topbar = make("Frame", {
        Name = "Topbar", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 10),
        Size = UDim2.fromOffset(0, 34), AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = C.CardBg, Visible = false, ZIndex = 200, Parent = screenGui,
    })
    corner(topbar, 10)
    local topbarStroke = stroke(topbar, C.Border)
    pad(topbar, 0, 0, 14, 14)
    make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), Parent = topbar })

    local pillLogoHolder = make("Frame", { Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1, ClipsDescendants = true, LayoutOrder = 1, Parent = topbar })
    make("ImageLabel", { Image = logoAsset, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(logoZoom, logoZoom), ScaleType = Enum.ScaleType.Fit, Parent = pillLogoHolder })

    make("Frame", { Size = UDim2.fromOffset(1, 14), BackgroundColor3 = C.Border, LayoutOrder = 2, Parent = topbar })

    local pingFrame = make("Frame", { Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, LayoutOrder = 3, Parent = topbar })
    make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), Parent = pingFrame })
    local wifiIcon = make("ImageLabel", { Image = "rbxassetid://105253464688580", ImageColor3 = Color3.fromRGB(75, 215, 125), BackgroundTransparency = 1, Size = UDim2.fromOffset(15, 15), ScaleType = Enum.ScaleType.Fit, LayoutOrder = 1, Parent = pingFrame })
    local pingLabel = make("TextLabel", { Text = "0ms", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.White, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 20), LayoutOrder = 2, Parent = pingFrame })

    make("Frame", { Size = UDim2.fromOffset(1, 14), BackgroundColor3 = C.Border, LayoutOrder = 4, Parent = topbar })

    local fpsFrame = make("Frame", { Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, LayoutOrder = 5, Parent = topbar })
    make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), Parent = fpsFrame })
    local fpsIcon = make("ImageLabel", { Image = "rbxassetid://10709772833", ImageColor3 = Color3.fromRGB(75, 215, 125), BackgroundTransparency = 1, Size = UDim2.fromOffset(14, 14), ScaleType = Enum.ScaleType.Fit, LayoutOrder = 1, Parent = fpsFrame })
    local fpsLabel = make("TextLabel", { Text = "60 FPS", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.White, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 20), LayoutOrder = 2, Parent = fpsFrame })

    make("Frame", { Size = UDim2.fromOffset(1, 14), BackgroundColor3 = C.Border, LayoutOrder = 6, Parent = topbar })

    make("TextLabel", { Text = "click to open", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.TextDim, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 20), LayoutOrder = 7, Parent = topbar })

    local topbarBtn = make("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 201, Parent = topbar })

    -- ═══ LIVE PING + FPS ═══
    local PingStat = Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerStatsItem") and Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
    local fpsFrames, fpsTime = 0, os.clock()
    RunService.RenderStepped:Connect(function()
        fpsFrames = fpsFrames + 1
        local now = os.clock()
        if now - fpsTime >= 0.5 then
            local fps = math.floor(fpsFrames / (now - fpsTime) + 0.5)
            fpsFrames = 0; fpsTime = now
            if fpsLabel and fpsLabel.Parent then
                fpsLabel.Text = tostring(fps) .. " FPS"
                if fps >= 50 then fpsIcon.ImageColor3 = Color3.fromRGB(75, 215, 125)
                elseif fps >= 30 then fpsIcon.ImageColor3 = Color3.fromRGB(240, 190, 50)
                else fpsIcon.ImageColor3 = Color3.fromRGB(235, 75, 75) end
            end
        end
    end)
    task.spawn(function()
        while topbar and topbar.Parent do
            task.wait(0.5)
            if pingLabel and pingLabel.Parent then
                local ping = 0
                if PingStat then
                    local ok, v = pcall(function() return math.floor(PingStat:GetValue() + 0.5) end)
                    if ok and v then ping = v end
                end
                pingLabel.Text = tostring(ping) .. "ms"
                if ping <= 90 then wifiIcon.ImageColor3 = Color3.fromRGB(75, 215, 125)
                elseif ping <= 160 then wifiIcon.ImageColor3 = Color3.fromRGB(240, 190, 50)
                else wifiIcon.ImageColor3 = Color3.fromRGB(235, 75, 75) end
            end
        end
    end)

    -- ═══ NOTIFICATIONS ═══
    local notificationHolder = make("Frame", {
        Name = "Notifications", AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, 16), Size = UDim2.new(0, 300, 1, -32),
        BackgroundTransparency = 1, ZIndex = 300, Parent = screenGui,
    })
    make("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = notificationHolder })

    local windowRef = setmetatable({
        ScreenGui = screenGui, Main = main, Container = container,
        _content = content, _topbar = topbar, _topbarStroke = topbarStroke,
        _notificationHolder = notificationHolder, _notificationOrder = 0,
        _connections = {}, _noDrag = noDrag, _tabs = {}, _activeTab = nil,
        _containerScale = containerScale, _uiVisible = true,
        _destroyed = false, _minimized = false,
        _mainRevealScale = mainRevealScale, _dragConn = dragConn,
    }, Window)

    table.insert(Library._windowObjects, windowRef)

    -- ═══ MINIMIZE / RESTORE with smooth animation ═══
    local function setMinimized(state)
        state = state == true
        windowRef._minimized = state
        if state then
            -- collapse: shrink + fade out container, show topbar
            TweenService:Create(containerScale, WIN_TWEEN, { Scale = 0.96 }):Play()
            TweenService:Create(container, WIN_TWEEN, { BackgroundTransparency = 1 }):Play()
            main.Visible = false
            topbar.Visible = true
            topbarStroke.Transparency = 1
            TweenService:Create(topbarStroke, TOPBAR_TWEEN, { Transparency = 0 }):Play()
        else
            -- expand: hide topbar, grow container
            topbar.Visible = false
            main.Visible = true
            containerScale.Scale = 0.96
            TweenService:Create(containerScale, WIN_TWEEN, { Scale = 1 }):Play()
        end
    end
    windowRef._setMinimized = setMinimized

    minimizeBtn.MouseButton1Click:Connect(function() setMinimized(true) end)
    topbarBtn.MouseButton1Click:Connect(function() setMinimized(false) end)
    closeBtn.MouseButton1Click:Connect(function() windowRef:Destroy() end)

    -- finish loading
    task.spawn(function()
        if loadingEnabled then
            while not loadingMotionComplete do RunService.Heartbeat:Wait() end
            if not screenGui.Parent or not loadingLayer or not loadingLayer.Parent then return end
            main.Visible = true
            TweenService:Create(mainRevealScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Scale = 1 }):Play()
            local fo = TweenService:Create(loadingLayer, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), { GroupTransparency = 1 })
            fo:Play()
            fo.Completed:Wait()
            if loadingLayer and loadingLayer.Parent then loadingLayer:Destroy() end
            if loadingBlur then pcall(function() loadingBlur:Destroy() end) end
            loadingComplete = true
        end
    end)

    return windowRef
end

function Window:SetVisible(v) self.ScreenGui.Enabled = v == true end
function Window:Toggle() self.ScreenGui.Enabled = not self.ScreenGui.Enabled; return self.ScreenGui.Enabled end
function Window:SetMinimized(v) if self._setMinimized then self._setMinimized(v) end end
function Window:Destroy()
    self._destroyed = true
    for _, c in ipairs(self._connections or {}) do pcall(function() c:Disconnect() end) end
    table.clear(self._connections or {})
    local i = table.find(Library._windows, self.ScreenGui); if i then table.remove(Library._windows, i) end
    local j = table.find(Library._windowObjects, self); if j then table.remove(Library._windowObjects, j) end
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

function Window:Notify(opts)
    if type(opts) == "string" then opts = { Content = opts } end
    opts = opts or {}
    local holder = self._notificationHolder
    if not holder or not holder.Parent then return nil end
    local style = getNotificationStyle(opts.Type)
    local dur = tonumber(opts.Duration); if dur == nil then dur = 4 end; dur = math.max(dur, 0)
    self._notificationOrder = self._notificationOrder + 1
    local title = tostring(opts.Title or style.Name)
    local body = tostring(opts.Content or opts.Description or opts.Message or "Notification")
    local slot = make("Frame", { Size = UDim2.new(1, 0, 0, 62), BackgroundTransparency = 1, LayoutOrder = self._notificationOrder, ZIndex = 300, Parent = holder })
    local card = make("CanvasGroup", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 12, 0, 0), Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.CardBg, GroupTransparency = 1, ClipsDescendants = true, ZIndex = 301, Parent = slot })
    corner(card, 6); stroke(card, C.Border)
    local accentBar = make("Frame", { Position = UDim2.fromOffset(0, 10), Size = UDim2.fromOffset(3, 42), BackgroundColor3 = style.Color, ZIndex = 302, Parent = card })
    corner(accentBar, 2)
    make("TextLabel", { Text = title, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = style.Color, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -46, 0, 16), ZIndex = 302, Parent = card })
    make("TextLabel", { Text = body, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 27), Size = UDim2.new(1, -26, 0, 26), ZIndex = 302, Parent = card })
    local xb = make("TextButton", { Text = "×", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = C.TextDim, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -7, 0, 5), Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, ZIndex = 304, Parent = card })
    local closed = false
    local function close()
        if closed then return end; closed = true
        TweenService:Create(card, NOTIFICATION_TWEEN, { Position = UDim2.new(1, 12, 0, 0), GroupTransparency = 1 }):Play()
        task.delay(0.2, function() if slot and slot.Parent then slot:Destroy() end end)
    end
    xb.MouseButton1Click:Connect(close)
    TweenService:Create(card, NOTIFICATION_TWEEN, { Position = UDim2.new(1, 0, 0, 0), GroupTransparency = 0 }):Play()
    if dur > 0 then task.delay(dur, close) end
    return { Close = close }
end

-- ═══ TAB SYSTEM ═══
function Window:_selectTab(tab)
    if self._activeTab == tab then return end
    local prev = self._activeTab; self._activeTab = tab
    if prev then
        prev._page.Visible = false
        paint(prev._pill, "BackgroundColor3", "HotbarBg")
        paint(prev._pill, "TextColor3", "TextGray")
    end
    tab._page.Visible = true
    paint(tab._pill, "BackgroundColor3", "HotbarActive")
    paint(tab._pill, "TextColor3", "White")
end

function Window:AddTab(opts)
    if type(opts) == "string" then opts = { Name = opts } end
    opts = opts or {}
    local name = opts.Name or "Tab"
    local win = self

    -- top-level pill in a header row
    local page = make("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Parent = self._content })
    local header = make("Frame", { Size = UDim2.new(1, 0, 0, 88), BackgroundTransparency = 1, Parent = page })

    -- top-tab bar (above the header)
    local topBar = make("Frame", { Position = UDim2.fromOffset(16, 12), Size = UDim2.new(1, -32, 0, 26), BackgroundTransparency = 1, Parent = page })
    local topScroll = make("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.X, AutomaticCanvasSize = Enum.AutomaticSize.X, CanvasSize = UDim2.new(), Parent = topBar })
    local topRow = make("Frame", { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1, Parent = topScroll })
    make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = topRow })

    -- big header title below the top tab bar
    make("TextLabel", { Text = name, Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(20, 44), Size = UDim2.new(1, -40, 0, 18), Parent = header })
    make("TextLabel", { Text = opts.Subtitle or "", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(20, 62), Size = UDim2.new(1, -40, 0, 14), Parent = header })

    -- sub-tab pill bar
    local pillBar = make("Frame", { Position = UDim2.fromOffset(16, 60), Size = UDim2.new(1, -32, 0, 22), BackgroundTransparency = 1, Parent = header })
    local pillScroll = make("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.X, AutomaticCanvasSize = Enum.AutomaticSize.X, CanvasSize = UDim2.new(), Parent = pillBar })
    local pillRow = make("Frame", { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1, Parent = pillScroll })
    make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = pillRow })

    local pagesHolder = make("Frame", { Position = UDim2.fromOffset(0, 88), Size = UDim2.new(1, 0, 1, -88), BackgroundTransparency = 1, Parent = page })

    -- the pill that switches to this tab (hidden, placed in header top bar)
    local pill = make("TextButton", { Text = name, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.TextGray, BackgroundColor3 = C.HotbarBg, Size = UDim2.new(0, 0, 0, 22), AutomaticSize = Enum.AutomaticSize.X, Parent = topRow })
    autoOrder(pill); corner(pill, 6); pad(pill, 0, 0, 12, 12)

    table.insert(win._noDrag, pillScroll)
    table.insert(win._noDrag, topScroll)

    local tab = setmetatable({
        _window = win, _pill = pill,
        _page = page, _pillRow = pillRow, _pillScroll = pillScroll,
        _topRow = topRow, _pagesHolder = pagesHolder,
        _subTabs = {}, _activeSub = nil,
    }, Tab)

    pill.MouseButton1Click:Connect(function() win:_selectTab(tab) end)
    pill.MouseEnter:Connect(function() if win._activeTab ~= tab then tween(pill, { BackgroundColor3 = C.HotbarHover }) end end)
    pill.MouseLeave:Connect(function() tween(pill, { BackgroundColor3 = win._activeTab == tab and C.HotbarActive or C.HotbarBg }) end)

    table.insert(self._tabs, tab)
    if not self._activeTab then self:_selectTab(tab) end
    return tab
end

function Tab:_selectSub(sub)
    if self._activeSub == sub then return end
    local prev = self._activeSub; self._activeSub = sub
    if prev then
        prev._page.Visible = false
        paint(prev._pill, "BackgroundColor3", "WindowBg")
        paint(prev._pill, "TextColor3", "TextGray")
    end
    sub._page.Visible = true
    paint(sub._pill, "BackgroundColor3", "PillActive")
    paint(sub._pill, "TextColor3", "White")
end

function Tab:AddSubTab(name)
    name = tostring(name or "General")
    local tab = self
    local pill = make("TextButton", { Text = name, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.TextGray, BackgroundColor3 = C.WindowBg, Size = UDim2.new(0, 0, 0, 22), AutomaticSize = Enum.AutomaticSize.X, Parent = self._pillRow })
    autoOrder(pill); corner(pill, 6); pad(pill, 0, 0, 12, 12)
    local page = make("ScrollingFrame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 2, ScrollBarImageColor3 = C.Border, Parent = self._pagesHolder })
    pad(page, 4, 16, 16, 16)
    local card = make("Frame", { Size = UDim2.new(1, -32, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.CardBg, Parent = page })
    corner(card, 10); stroke(card); pad(card, 14, 14, 16, 16)
    make("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = card })
    local sub = setmetatable({ _tab = tab, _window = tab._window, _pill = pill, _page = page, _card = card }, SubTab)
    pill.MouseButton1Click:Connect(function() tab:_selectSub(sub) end)
    pill.MouseEnter:Connect(function() if tab._activeSub ~= sub then tween(pill, { BackgroundColor3 = C.NavHover }) end end)
    pill.MouseLeave:Connect(function() tween(pill, { BackgroundColor3 = tab._activeSub == sub and C.PillActive or C.WindowBg }) end)
    table.insert(self._subTabs, sub)
    if not self._activeSub then self:_selectSub(sub) end
    return sub
end

local function newRow(card, h)
    local r = make("Frame", { Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1, Parent = card }); autoOrder(r); return r
end
local function rowLabels(row, name, desc, rr)
    rr = rr or 0
    make("TextLabel", { Text = name, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 0), Size = desc and UDim2.new(1, -rr, 0, 14) or UDim2.new(1, -rr, 1, 0), Parent = row })
    if desc then make("TextLabel", { Text = desc, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 16), Size = UDim2.new(1, -rr, 0, 12), Parent = row }) end
end

function SubTab:AddSection(opts)
    if type(opts) == "string" then opts = { Name = opts } end; opts = opts or {}
    local row = make("Frame", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Parent = self._card }); autoOrder(row)
    local tick = make("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, -4), Size = UDim2.fromOffset(3, 11), BackgroundColor3 = C.Accent, Parent = row }); corner(tick, 2)
    make("TextLabel", { Text = string.upper(tostring(opts.Name or "Section")), Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom, BackgroundTransparency = 1, Position = UDim2.fromOffset(9, 0), Size = UDim2.new(1, -9, 1, -3), Parent = row })
    make("Frame", { Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = C.Border, Parent = row })
    return row
end

function SubTab:AddToggle(opts)
    opts = opts or {}; local value = opts.Default == true
    local row = newRow(self._card, 30); rowLabels(row, opts.Name or "Toggle", opts.Description, 44)
    local pill = make("TextButton", { Text = "", Size = UDim2.fromOffset(34, 18), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = C.Badge, Parent = row })
    circle(pill); stroke(pill, C.Accent)
    local knob = make("Frame", { Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = C.KnobOff, Parent = pill })
    circle(knob)
    local function render(a)
        local kp = value and UDim2.new(0, 18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        paint(pill, "BackgroundColor3", value and "Accent" or "Badge", not a)
        paint(knob, "BackgroundColor3", value and "KnobAccent" or "KnobOff", not a)
        if a then tween(knob, { Position = kp }) else knob.Position = kp end
    end
    local function set(v) v = v == true; if v == value then return end; value = v; render(true); fire(opts.Callback, value) end
    pill.MouseButton1Click:Connect(function() set(not value) end); render(false)
    return registerFlag(opts.Flag, "toggle", { Set = function(_, v) set(v) end, Get = function() return value end })
end

function SubTab:AddButton(opts)
    opts = opts or {}
    local primary = opts.Primary == true
    local btn = make("TextButton", { Text = opts.Name or "Button", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = primary and C.AccentText or C.TextGray, Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = primary and C.Accent or C.Element, Parent = self._card })
    autoOrder(btn); corner(btn, 6)
    btn.MouseEnter:Connect(function() if primary then tween(btn, { BackgroundTransparency = 0.14 }) else tween(btn, { BackgroundColor3 = C.ElementHover }) end end)
    btn.MouseLeave:Connect(function() if primary then tween(btn, { BackgroundTransparency = 0 }) else tween(btn, { BackgroundColor3 = C.Element }) end end)
    btn.MouseButton1Click:Connect(function() fire(opts.Callback) end)
    return btn
end

function SubTab:AddParagraph(opts)
    opts = opts or {}
    local card = make("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = self._card }); autoOrder(card)
    make("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3), Parent = card })
    if opts.Title then
        make("TextLabel", { Text = tostring(opts.Title), Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 1, Parent = card })
    end
    local body = make("TextLabel", { Text = tostring(opts.Text or opts.Content or ""), Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), LayoutOrder = 2, Parent = card })
    return { Set = function(_, t) body.Text = tostring(t) end, Get = function() return body.Text end, Instance = body }
end

function SubTab:AddSlider(opts)
    opts = opts or {}
    local mn = opts.Min or 0; local mx = opts.Max or 100; local sf = opts.Suffix or ""
    local value = math.clamp(opts.Default or mn, mn, mx)
    local row = newRow(self._card, 32)
    make("TextLabel", { Text = opts.Name or "Slider", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 0), Size = UDim2.new(0.6, 0, 0, 14), Parent = row })
    local vl = make("TextLabel", { Text = tostring(value) .. sf, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 1), Size = UDim2.new(1, 0, 0, 13), Parent = row })
    local track = make("Frame", { Position = UDim2.fromOffset(0, 24), Size = UDim2.new(1, 0, 0, 4), BackgroundColor3 = C.TrackBg, Parent = row }); circle(track)
    local fill = make("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C.Accent, Parent = track }); circle(fill)
    local knob = make("Frame", { Size = UDim2.fromOffset(12, 12), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = C.White, ZIndex = 2, Parent = track }); circle(knob); stroke(knob, C.Accent)
    local hit = make("TextButton", { Text = "", BackgroundTransparency = 1, Position = UDim2.new(0, -6, 0, 16), Size = UDim2.new(1, 12, 0, 20), Parent = row })
    local function apply(v, a, fc)
        value = math.clamp(math.floor(v + 0.5), mn, mx)
        local pct = mx > mn and (value - mn) / (mx - mn) or 0
        vl.Text = tostring(value) .. sf
        if a then tween(fill, { Size = UDim2.new(pct, 0, 1, 0) }); tween(knob, { Position = UDim2.new(pct, 0, 0.5, 0) })
        else fill.Size = UDim2.new(pct, 0, 1, 0); knob.Position = UDim2.new(pct, 0, 0.5, 0) end
        if fc then fire(opts.Callback, value) end
    end
    local function fromX(x) return mn + (mx - mn) * math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1) end
    local dragging = false
    hit.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; apply(fromX(i.Position.X), true, true) end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then apply(fromX(i.Position.X), true, true) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    apply(value, false, false)
    return registerFlag(opts.Flag, "slider", { Set = function(_, v) apply(v, true, true) end, Get = function() return value end })
end

function SubTab:AddDropdown(opts)
    opts = opts or {}
    local options = opts.Options or {}; local value = opts.Default or options[1] or ""
    local IH = 22; local LW = 160
    local row = newRow(self._card, 30); rowLabels(row, opts.Name or "Dropdown", opts.Description, 130)
    local btn = make("TextButton", { Text = "", Size = UDim2.fromOffset(120, 22), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = C.Element, Parent = row })
    corner(btn, 6)
    local vl = make("TextLabel", { Text = tostring(value), Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -26, 1, 0), Parent = btn })
    sortIcon(btn)
    local win = self._window
    local list = make("Frame", { Visible = false, Active = true, Size = UDim2.new(0, LW, 0, 0), BackgroundColor3 = C.Element, ClipsDescendants = true, ZIndex = 100, Parent = win.ScreenGui })
    corner(list, 6); stroke(list)
    local sf = make("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = C.Border, ZIndex = 101, Parent = list })
    pad(sf, 4, 4, 4, 4)
    make("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = sf })
    local open = false; local oc = {}; local ob = {}
    local function repo()
        local inset = GuiService:GetGuiInset(); local p, s = btn.AbsolutePosition, btn.AbsoluteSize
        list.Position = UDim2.fromOffset(p.X + inset.X + s.X - LW, p.Y + inset.Y + s.Y + 4)
    end
    local function calcH()
        local vc = math.min(math.max(#options, 1), 5)
        return vc * IH + math.max(vc - 1, 0) * 2 + 8
    end
    local function closeDD()
        if not open then return end; open = false
        for _, c in ipairs(oc) do c:Disconnect() end; table.clear(oc)
        tween(list, { Size = UDim2.new(0, LW, 0, 0) })
        task.delay(0.16, function() if not open then list.Visible = false end end)
    end
    local function rebuild()
        for _, b in ipairs(ob) do if b and b.Parent then b:Destroy() end end; table.clear(ob)
        for _, o in ipairs(options) do
            local os = tostring(o)
            local ob2 = make("TextButton", { Text = os, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = C.TextGray, Size = UDim2.new(1, -8, 0, IH), BackgroundColor3 = C.Element, Parent = sf })
            autoOrder(ob2); corner(ob2, 4)
            make("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = ob2 })
            ob2.TextXAlignment = Enum.TextXAlignment.Left
            ob2.MouseEnter:Connect(function() tween(ob2, { BackgroundColor3 = C.ElementHover, TextColor3 = C.White }) end)
            ob2.MouseLeave:Connect(function() tween(ob2, { BackgroundColor3 = C.Element, TextColor3 = C.TextGray }) end)
            ob2.MouseButton1Click:Connect(function() value = o; vl.Text = os; closeDD(); fire(opts.Callback, o) end)
            table.insert(ob, ob2)
        end
    end
    rebuild()
    local function setOpen(o)
        if open == o then return end
        if o then
            open = true; repo(); list.Visible = true; tween(list, { Size = UDim2.new(0, LW, 0, calcH()) })
            table.insert(oc, UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local pos = Vector2.new(input.Position.X, input.Position.Y)
                    if not isInside(btn, pos) and not isInside(list, pos) then closeDD() end
                end
            end))
        else closeDD() end
    end
    btn.MouseButton1Click:Connect(function() setOpen(not open) end)
    return registerFlag(opts.Flag, "dropdown", {
        Set = function(_, o) value = o; vl.Text = tostring(o); fire(opts.Callback, o) end,
        Get = function() return value end,
        SetOptions = function(_, no) options = no or {}; rebuild(); if open then tween(list, { Size = UDim2.new(0, LW, 0, calcH()) }) end end,
    })
end

function SubTab:AddKeybind(opts)
    opts = opts or {}
    local key = opts.Default
    if typeof(key) ~= "EnumItem" then key = nil end
    local row = newRow(self._card, 30); rowLabels(row, opts.Name or "Keybind", opts.Description, 80)
    local btn = make("TextButton", { Text = key and key.Name or "None", Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.TextGray, Size = UDim2.fromOffset(70, 22), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = C.Element, Parent = row })
    corner(btn, 6)
    local listening = false; local conn
    local function setKey(k)
        if k ~= nil and typeof(k) ~= "EnumItem" then return end
        key = k; btn.Text = key and key.Name or "None"
        if opts.OnKeyChanged then fire(opts.OnKeyChanged, key) end
    end
    local function stopListening()
        listening = false
        if conn then conn:Disconnect(); conn = nil end
        btn.Text = key and key.Name or "None"
        tween(btn, { BackgroundColor3 = C.Element, TextColor3 = C.TextGray })
    end
    btn.MouseButton1Click:Connect(function()
        if listening then stopListening(); return end
        listening = true; btn.Text = "..."; tween(btn, { BackgroundColor3 = C.PillActive, TextColor3 = C.White })
        conn = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Escape then setKey(nil) else setKey(input.KeyCode) end
                stopListening()
            end
        end)
    end)
    local pressConn = UserInputService.InputBegan:Connect(function(input, gp)
        if gp or listening or not key then return end
        if UserInputService:GetFocusedTextBox() then return end
        if input.KeyCode == key then fire(opts.OnPress or opts.Callback, key) end
    end)
    return registerFlag(opts.Flag, "keybind", { Set = function(_, k) setKey(k) end, Get = function() return key end })
end

function SubTab:AddColorPicker(opts)
    opts = opts or {}
    local function hexToColor(hex)
        hex = string.gsub(tostring(hex or ""), "#", "")
        if #hex ~= 6 then return nil end
        local r = tonumber(hex:sub(1, 2), 16); local g = tonumber(hex:sub(3, 4), 16); local b = tonumber(hex:sub(5, 6), 16)
        if not (r and g and b) then return nil end
        return Color3.fromRGB(r, g, b)
    end
    local function colorToHex(c) return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)) end
    local value = (typeof(opts.Default) == "Color3" and opts.Default) or hexToColor(opts.Default) or Color3.fromRGB(255, 255, 255)
    local h, s, v = value:ToHSV()
    local row = newRow(self._card, 30); rowLabels(row, opts.Name or "Color", opts.Description, 44)
    local swatch = make("TextButton", { Text = "", Size = UDim2.fromOffset(34, 18), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = value, Parent = row })
    corner(swatch, 5); stroke(swatch, C.Border)
    local win = self._window
    local PW = 200
    local panel = make("Frame", { Visible = false, Active = true, Size = UDim2.fromOffset(PW, 0), BackgroundColor3 = C.Element, ClipsDescendants = true, ZIndex = 100, Parent = win.ScreenGui })
    corner(panel, 6); stroke(panel)
    local inner = make("Frame", { Size = UDim2.fromOffset(PW, 168), BackgroundTransparency = 1, ZIndex = 101, Parent = panel })
    pad(inner, 10, 10, 10, 10)
    local svBox = make("Frame", { Size = UDim2.new(1, 0, 0, 110), BackgroundColor3 = Color3.fromHSV(h, 1, 1), ZIndex = 101, Parent = inner })
    corner(svBox, 4)
    make("UIGradient", { Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromHSV(h, 1, 1)), Parent = svBox })
    local svBlack = make("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 102, Parent = svBox }); corner(svBlack, 4)
    make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }), Parent = svBlack })
    local svCursor = make("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(8, 8), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 103, Parent = svBox }); circle(svCursor); stroke(svCursor, Color3.new(0, 0, 0))
    local svHit = make("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 104, Parent = svBox })
    local hexHolder = make("Frame", { Position = UDim2.fromOffset(0, 140), Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = C.WindowBg, ZIndex = 101, Parent = inner }); corner(hexHolder, 5)
    local hexBox = make("TextBox", { Text = colorToHex(value), PlaceholderText = "#FFFFFF", PlaceholderColor3 = C.Placeholder, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Center, BackgroundTransparency = 1, ClearTextOnFocus = false, Size = UDim2.fromScale(1, 1), ZIndex = 102, Parent = hexHolder })
    local function applyVisuals()
        local hueColor = Color3.fromHSV(h, 1, 1)
        swatch.BackgroundColor3 = value
        svBox.BackgroundColor3 = hueColor
        svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
        hexBox.Text = colorToHex(value)
    end
    local function recompute(fc)
        value = Color3.fromHSV(h, s, v); applyVisuals()
        if fc then fire(opts.Callback, value) end
    end
    local svDragging = false
    local function svFrom(px, py)
        local p, sz = svBox.AbsolutePosition, svBox.AbsoluteSize
        s = math.clamp((px - p.X) / math.max(sz.X, 1), 0, 1)
        v = 1 - math.clamp((py - p.Y) / math.max(sz.Y, 1), 0, 1)
    end
    svHit.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then svDragging = true; svFrom(i.Position.X, i.Position.Y); recompute(false) end end)
    UserInputService.InputChanged:Connect(function(i)
        if svDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then svFrom(i.Position.X, i.Position.Y); recompute(false) end
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then svDragging = false end end)
    hexBox.FocusLost:Connect(function()
        local c = hexToColor(hexBox.Text)
        if c then value = c; h, s, v = c:ToHSV(); recompute(true) else hexBox.Text = colorToHex(value) end
    end)
    local open = false; local oc = {}
    local function repo()
        local inset = GuiService:GetGuiInset(); local p, sz = swatch.AbsolutePosition, swatch.AbsoluteSize
        panel.Position = UDim2.fromOffset(p.X + inset.X + sz.X - PW, p.Y + inset.Y + sz.Y + 4)
    end
    local function closePanel()
        if not open then return end; open = false
        for _, c in ipairs(oc) do c:Disconnect() end; table.clear(oc)
        tween(panel, { Size = UDim2.fromOffset(PW, 0) })
        task.delay(0.16, function() if not open then panel.Visible = false end end)
    end
    local function setOpen(o)
        if open == o then return end
        if o then
            open = true; repo(); panel.Visible = true; tween(panel, { Size = UDim2.fromOffset(PW, 168) })
            table.insert(oc, UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local pos = Vector2.new(input.Position.X, input.Position.Y)
                    if not isInside(swatch, pos) and not isInside(panel, pos) then closePanel() end
                end
            end))
        else closePanel() end
    end
    swatch.MouseButton1Click:Connect(function() setOpen(not open) end)
    recompute(false)
    return registerFlag(opts.Flag, "color", {
        Set = function(_, c) c = (typeof(c) == "Color3" and c) or hexToColor(c); if not c then return end; value = c; h, s, v = c:ToHSV(); recompute(true) end,
        Get = function() return value end, GetHex = function() return colorToHex(value) end,
    })
end

function SubTab:AddInput(opts)
    opts = opts or {}
    local row = newRow(self._card, 30); rowLabels(row, opts.Name or "Input", opts.Description, 120)
    local holder = make("Frame", { Size = UDim2.fromOffset(110, 22), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = C.Element, Parent = row })
    corner(holder, 6)
    local box = make("TextBox", { Text = opts.Default or "", PlaceholderText = opts.Placeholder or "...", PlaceholderColor3 = C.Placeholder, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, ClearTextOnFocus = false, ClipsDescendants = true, Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -30, 1, 0), Parent = holder })
    inputIcon(holder)
    box.FocusLost:Connect(function(ep) fire(opts.Callback, box.Text, ep) end)
    return registerFlag(opts.Flag, "input", { Set = function(_, t) box.Text = tostring(t) end, Get = function() return box.Text end })
end

function Library:AddSubTabPlaceholder(subTab, text)
    if not subTab or not subTab._card then return end
    local lbl = make("TextLabel", { Text = tostring(text or "soon..."), Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = C.TextDim, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 60), Parent = subTab._card })
    autoOrder(lbl); return lbl
end

return Library
