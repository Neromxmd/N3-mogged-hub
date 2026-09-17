-- N3 mogg hub — UI Library (based on Oxide)
-- Customized: N3 mogg hub branding, purple accent, theme switching

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService       = game:GetService("GuiService")
local Players          = game:GetService("Players")
local Stats            = game:GetService("Stats")
local RunService       = game:GetService("RunService")
local AssetService     = game:GetService("AssetService")
local TextService      = game:GetService("TextService")
local HttpService      = game:GetService("HttpService")
local Workspace        = game:GetService("Workspace")

local DEFAULT_LOGO = "rbxassetid://120464926691610"
local TWEEN = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local NOTIFICATION_TWEEN = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local PROFILE_TWEEN = TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local ICONS = {
    home            = "rbxassetid://4562959382",
    dashboard       = "rbxassetid://115870883170035",
    search          = "rbxassetid://18733177504",
    settings        = "rbxassetid://4738901432",
    gear            = "rbxassetid://117427252698455",
    menu            = "rbxassetid://10734896206",
    list            = "rbxassetid://10709790373",
    grid            = "rbxassetid://10734950309",
    sliders         = "rbxassetid://10734897102",
    swords          = "rbxassetid://10747384394",
    sword           = "rbxassetid://10747384394",
    combat          = "rbxassetid://10747384394",
    shield          = "rbxassetid://98206735878224",
    target          = "rbxassetid://123292899197910",
    crosshair       = "rbxassetid://10723434538",
    aim             = "rbxassetid://10723434538",
    bolt            = "rbxassetid://79160363518966",
    lightning       = "rbxassetid://125222658692748",
    zap             = "rbxassetid://79160363518966",
    fire            = "rbxassetid://10723415285",
    flame           = "rbxassetid://10723415285",
    star            = "rbxassetid://10734924532",
    sparkle         = "rbxassetid://10723422246",
    player          = "rbxassetid://82179723353246",
    user            = "rbxassetid://10747387118",
    person          = "rbxassetid://77052607579460",
    users           = "rbxassetid://10747387298",
    team            = "rbxassetid://10747387298",
    group           = "rbxassetid://10747387298",
    eye             = "rbxassetid://131012605615689",
    visible         = "rbxassetid://10709790644",
    visuals         = "rbxassetid://10709790644",
    render          = "rbxassetid://10709790644",
    esp             = "rbxassetid://10709790644",
    eyeoff          = "rbxassetid://10709790497",
    hidden          = "rbxassetid://10709790497",
    globe           = "rbxassetid://13567318216",
    world           = "rbxassetid://10709778567",
    compass         = "rbxassetid://10709790373",
    map             = "rbxassetid://84513890895579",
    move            = "rbxassetid://10723422998",
    arrows          = "rbxassetid://10723422998",
    heart           = "rbxassetid://10723415389",
    like            = "rbxassetid://10723415389",
    bell            = "rbxassetid://10723345067",
    notification    = "rbxassetid://10723345067",
    alert           = "rbxassetid://10723345067",
    info            = "rbxassetid://10723415389",
    about           = "rbxassetid://10723415389",
    help            = "rbxassetid://10723415389",
    warning         = "rbxassetid://10747387522",
    caution         = "rbxassetid://10747387522",
    check           = "rbxassetid://5180860280",
    checkmark       = "rbxassetid://5180860280",
    lock            = "rbxassetid://10723417148",
    unlock          = "rbxassetid://10723422607",
    power           = "rbxassetid://10723422754",
    toggle          = "rbxassetid://10723422754",
    refresh         = "rbxassetid://10723417783",
    folder          = "rbxassetid://10709791437",
    file            = "rbxassetid://10709791258",
    save            = "rbxassetid://10709791258",
    download        = "rbxassetid://10709790497",
    clipboard       = "rbxassetid://10709751190",
    play            = "rbxassetid://10723422607",
    music           = "rbxassetid://10723421745",
    volume          = "rbxassetid://10723421745",
    camera          = "rbxassetid://10709778567",
    image           = "rbxassetid://10709791437",
    clock           = "rbxassetid://10723345037",
    time            = "rbxassetid://10723345037",
    timer           = "rbxassetid://10723345037",
    wrench          = "rbxassetid://100244385350031",
    tool            = "rbxassetid://10734950309",
    code            = "rbxassetid://10709751190",
    terminal        = "rbxassetid://10709751190",
    script          = "rbxassetid://10709751190",
    bug             = "rbxassetid://10723415903",
    debug           = "rbxassetid://10723415903",
    layers          = "rbxassetid://10723417148",
    inventory       = "rbxassetid://14118896735",
    backpack        = "rbxassetid://10723415285",
    box             = "rbxassetid://10723415285",
    package         = "rbxassetid://10723415285",
    gift            = "rbxassetid://10723415389",
    crown           = "rbxassetid://10734924532",
    gem             = "rbxassetid://10723421745",
    coin            = "rbxassetid://13522871708",
    magic           = "rbxassetid://11111111111",
    wand            = "rbxassetid://10734924532",
    potion          = "rbxassetid://10723415285",
    skull           = "rbxassetid://10747384394",
    death           = "rbxassetid://10747384394",
    gamepad         = "rbxassetid://10723422998",
    controller      = "rbxassetid://10723422998",
    teleport        = "rbxassetid://10090587519",
    speed           = "rbxassetid://11111111111",
    running         = "rbxassetid://10723422998",
    favorite        = "rbxassetid://10734924532",
}

local NOTIFICATION_STYLES = {
    info    = { Name = "Info",    Color = Color3.fromRGB(150, 120, 220), Icon = "rbxassetid://10723345067" },
    success = { Name = "Success", Color = Color3.fromRGB(120, 180, 130), Icon = "rbxassetid://5180860280" },
    warning = { Name = "Warning", Color = Color3.fromRGB(200, 160, 90),  Icon = "rbxassetid://10747387522" },
    error   = { Name = "Error",   Color = Color3.fromRGB(200, 100, 100), Icon = "rbxassetid://10747387522" },
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
        WindowBg     = Color3.fromRGB(245, 243, 250),
        CardBg       = Color3.fromRGB(250, 248, 253),
        Border       = Color3.fromRGB(218, 212, 228),
        Element      = Color3.fromRGB(235, 230, 242),
        ElementHover = Color3.fromRGB(228, 222, 238),
        Badge        = Color3.fromRGB(224, 218, 234),
        BadgeIdle    = Color3.fromRGB(232, 227, 240),
        NavActive    = Color3.fromRGB(238, 233, 245),
        NavHover     = Color3.fromRGB(242, 238, 249),
        PillActive   = Color3.fromRGB(226, 220, 238),
        White        = Color3.fromRGB(30, 22, 45),
        TextGray     = Color3.fromRGB(90, 80, 110),
        TextDim      = Color3.fromRGB(110, 100, 130),
        KnobOff      = Color3.fromRGB(150, 140, 170),
        KnobOn       = Color3.fromRGB(250, 248, 255),
        TrackBg      = Color3.fromRGB(210, 204, 222),
        Placeholder  = Color3.fromRGB(140, 130, 160),
        HotbarBg     = Color3.fromRGB(250, 248, 253),
        HotbarBorder = Color3.fromRGB(218, 212, 228),
        HotbarActive = Color3.fromRGB(235, 230, 242),
        HotbarHover  = Color3.fromRGB(228, 222, 238),
        HotbarDot    = Color3.fromRGB(70, 60, 90),
        Accent       = Color3.fromRGB(140, 90, 220),
        AccentDim    = Color3.fromRGB(215, 200, 240),
        AccentText   = Color3.fromRGB(255, 255, 255),
        KnobAccent   = Color3.fromRGB(255, 255, 255),
    },
    OLED = {
        WindowBg     = Color3.fromRGB(0, 0, 0),
        CardBg       = Color3.fromRGB(5, 3, 10),
        Border       = Color3.fromRGB(25, 20, 38),
        Element      = Color3.fromRGB(12, 9, 18),
        ElementHover = Color3.fromRGB(20, 15, 30),
        Badge        = Color3.fromRGB(30, 24, 44),
        BadgeIdle    = Color3.fromRGB(16, 12, 24),
        NavActive    = Color3.fromRGB(10, 7, 16),
        NavHover     = Color3.fromRGB(6, 4, 10),
        PillActive   = Color3.fromRGB(24, 18, 36),
        White        = Color3.fromRGB(255, 255, 255),
        TextGray     = Color3.fromRGB(170, 160, 190),
        TextDim      = Color3.fromRGB(130, 120, 150),
        KnobOff      = Color3.fromRGB(80, 70, 100),
        KnobOn       = Color3.fromRGB(3, 2, 6),
        TrackBg      = Color3.fromRGB(34, 28, 48),
        Placeholder  = Color3.fromRGB(95, 85, 120),
        HotbarBg     = Color3.fromRGB(5, 3, 10),
        HotbarBorder = Color3.fromRGB(25, 20, 38),
        HotbarActive = Color3.fromRGB(12, 9, 18),
        HotbarHover  = Color3.fromRGB(20, 15, 30),
        HotbarDot    = Color3.fromRGB(200, 190, 220),
        Accent       = Color3.fromRGB(180, 140, 255),
        AccentDim    = Color3.fromRGB(40, 24, 70),
        AccentText   = Color3.fromRGB(10, 5, 20),
        KnobAccent   = Color3.fromRGB(12, 8, 22),
    },
}

local REVERSE = {}
local function rebuildReverse()
    table.clear(REVERSE)
    for key, color in pairs(C) do
        REVERSE[color:ToHex()] = key
    end
end
rebuildReverse()

local function tween(inst, props)
    TweenService:Create(inst, TWEEN, props):Play()
end
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
    return make("UIStroke", {
        Color = color or C.Border, Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent,
    })
end
local function pad(parent, top, bottom, left, right)
    return make("UIPadding", {
        PaddingTop = UDim.new(0, top), PaddingBottom = UDim.new(0, bottom),
        PaddingLeft = UDim.new(0, left), PaddingRight = UDim.new(0, right),
        Parent = parent,
    })
end

local function refreshEdgeGradient(g)
    local edgeKey = g:GetAttribute("ThemeGradient_Edge")
    if not edgeKey then return end
    local edge = C[edgeKey]
    if not edge then return end
    local midKey = g:GetAttribute("ThemeGradient_Mid")
    if midKey then
        local mid = C[midKey]
        if not mid then return end
        local span = math.clamp(tonumber(g:GetAttribute("ThemeGradient_Span")) or 0.15, 0.02, 0.49)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, edge),
            ColorSequenceKeypoint.new(span, mid),
            ColorSequenceKeypoint.new(1 - span, mid),
            ColorSequenceKeypoint.new(1, edge),
        })
    else
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, edge),
            ColorSequenceKeypoint.new(0.42, edge),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.58, edge),
            ColorSequenceKeypoint.new(1.00, edge),
        })
    end
end

local function refreshVerticalFade(g)
    local topKey    = g:GetAttribute("ThemeGradient_Top")
    local bottomKey = g:GetAttribute("ThemeGradient_Bottom")
    if not (topKey and bottomKey) then return end
    local top = C[topKey]
    local bottom = C[bottomKey]
    if not (top and bottom) then return end
    local strength = math.clamp(tonumber(g:GetAttribute("ThemeGradient_Strength")) or 1, 0, 1)
    if strength < 1 then bottom = top:Lerp(bottom, strength) end
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, top),
        ColorSequenceKeypoint.new(1, bottom),
    })
end

local function edgeAccentGradient(parent, edgeKey, midKey, span)
    local g = make("UIGradient", { Rotation = 0, Parent = parent })
    g:SetAttribute("ThemeGradient_Edge", edgeKey or "Accent")
    g:SetAttribute("ThemeGradient_Mid", midKey or "Border")
    g:SetAttribute("ThemeGradient_Span", span or 0.15)
    refreshEdgeGradient(g)
    return g
end
local function autoOrder(inst) inst.LayoutOrder = #inst.Parent:GetChildren() end
local function isInside(gui, pos)
    local p, s = gui.AbsolutePosition, gui.AbsoluteSize
    return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
end
local function fire(callback, ...)
    if typeof(callback) == "function" then task.spawn(callback, ...) end
end
local function normalizeAssetId(value)
    if value == nil or value == "" then return DEFAULT_LOGO end
    if type(value) == "number" then return "rbxassetid://" .. tostring(math.floor(value)) end
    local text = tostring(value)
    if string.match(text, "^rbxassetid://")
        or string.match(text, "^rbxthumb://")
        or string.match(text, "^https?://") then
        return text
    end
    local id = string.match(text, "%d+")
    return id and ("rbxassetid://" .. id) or DEFAULT_LOGO
end

local function resolveIcon(value)
    if value == nil or value == "" then return nil, nil end
    local str = tostring(value)
    local key = string.lower(str)
    if ICONS[key] then return "image", ICONS[key] end
    if string.match(str, "^rbxassetid://") or string.match(str, "^rbxthumb://") or string.match(str, "^https?://") then
        return "image", str
    end
    if tonumber(str) then return "image", "rbxassetid://" .. str end
    local numId = string.match(str, "%d+")
    if numId and #numId > 5 then return "image", "rbxassetid://" .. numId end
    return "text", string.upper(string.sub(str, 1, 1))
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
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local pos = Vector2.new(input.Position.X, input.Position.Y)
        for _, gui in ipairs(blockers) do
            if guiVisible(gui) and isInside(gui, pos) then return end
        end
        dragging = true
        dragStart = input.Position
        startPos  = frame.Position
        if typeof(onStart) == "function" then onStart() end
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                if dragging then
                    dragging = false
                    if typeof(onEnd) == "function" then onEnd() end
                end
            end
        end)
    end)
    local dragConn = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    return dragConn
end

local function sortIcon(parent)
    local holder = make("Frame", {
        BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -7, 0.5, 0), Size = UDim2.fromOffset(9, 7), Parent = parent,
    })
    for i, width in ipairs({ 9, 7, 5 }) do
        make("Frame", {
            Position = UDim2.fromOffset(0, (i - 1) * 3),
            Size = UDim2.fromOffset(width, 1),
            BackgroundColor3 = C.TextDim, Parent = holder,
        })
    end
    return holder
end

local function inputIcon(parent)
    local holder = make("Frame", {
        BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -7, 0.5, 0), Size = UDim2.fromOffset(10, 10), Parent = parent,
    })
    local box = make("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = holder })
    corner(box, 2); stroke(box, C.TextDim)
    make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(1, 4), BackgroundColor3 = C.TextDim, Parent = holder,
    })
    return holder
end

local function createIconElement(parent, iconType, iconValue, size, zindex)
    size = size or 10
    zindex = zindex or 6
    if iconType == "image" then
        return make("ImageLabel", {
            Image = iconValue,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(size, size),
            ScaleType = Enum.ScaleType.Fit,
            ImageColor3 = C.TextGray,
            ZIndex = zindex,
            Parent = parent,
        })
    else
        return make("TextLabel", {
            Text = iconValue or "?",
            Font = Enum.Font.GothamBold,
            TextSize = math.floor(size * 0.7),
            TextColor3 = C.TextGray,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ZIndex = zindex,
            Parent = parent,
        })
    end
end

-- Simplified tag system placeholder (disabled by default in N3 mogg hub)
local TagSystem = {
    _running = false,
    OnUsersUpdated = function() end,
    RemoveListener = function() end,
}

local function stopTagSystem() end

local Library = {
    Version       = "1.0",
    ChatFree      = true,
    Themes        = THEMES,
    Icons         = ICONS,
    DefaultLogo   = DEFAULT_LOGO,
    Flags         = {},
    State         = {},
    _stateListeners = {},
    ConfigFolder  = "N3MoggHub/configs",
    _windows      = {},
    _windowObjects= {},
    _currentTheme = "Dark",
    TagSystem     = TagSystem,
}
local Window = {}; Window.__index = Window
local Tab    = {};    Tab.__index = Tab
local SubTab = {}; SubTab.__index = SubTab

function Library:SetState(key, val)
    local k = tostring(key)
    Library.State[k] = val
    if Library._stateListeners[k] then
        for _, fn in ipairs(Library._stateListeners[k]) do pcall(fn, val) end
    end
    return val
end

function Library:GetState(key, default)
    local v = Library.State[tostring(key)]
    if v == nil then return default end
    return v
end

function Library:BindState(key, fn)
    local k = tostring(key)
    if not Library._stateListeners[k] then Library._stateListeners[k] = {} end
    table.insert(Library._stateListeners[k], fn)
    if Library.State[k] ~= nil then pcall(fn, Library.State[k]) end
    return fn
end

function Library:Get(flag, default)
    local f = tostring(flag)
    local entry = Library.Flags[f]
    if entry and entry.api and entry.api.Get then
        local v = entry.api.Get()
        if v ~= nil then return v end
    end
    local s = Library.State[f]
    if s ~= nil then return s end
    return default
end

function Library:Set(flag, value)
    local f = tostring(flag)
    local entry = Library.Flags[f]
    if entry and entry.api and entry.api.Set then
        entry.api.Set(entry.api, value)
        return true
    end
    Library:SetState(f, value)
    return true
end

local function trackConn(window, conn)
    if window and window._connections and conn then
        table.insert(window._connections, conn)
    end
    return conn
end

local function registerFlag(flag, kind, api)
    if flag ~= nil and api then
        local f = tostring(flag)
        Library.Flags[f] = { kind = kind, api = api }
        if Library.State[f] ~= nil and api.Set then
            pcall(function() api:Set(Library.State[f]) end)
        end
    end
    return api
end

local THEME_PROPS = { "BackgroundColor3", "TextColor3", "PlaceholderColor3", "ScrollBarImageColor3", "Color", "ImageColor3" }

function Library:SetTheme(theme)
    local themeName = nil
    if type(theme) == "string" then
        themeName = theme
        theme = THEMES[theme]
        if not theme then warn(("[N3 mogg hub] unknown theme %q"):format(themeName)); return false end
    elseif type(theme) ~= "table" then
        warn("[N3 mogg hub] SetTheme expects a built-in theme name or theme table"); return false
    end
    for key in pairs(C) do
        local value = theme[key]
        if value ~= nil and typeof(value) ~= "Color3" then
            warn(("[N3 mogg hub] theme key %s must be a Color3"):format(key)); return false
        end
    end
    for key in pairs(C) do
        local value = theme[key]
        if value ~= nil then C[key] = value end
    end
    Library._currentTheme = themeName or "Custom"
    rebuildReverse()
    for _, gui in ipairs(Library._windows) do
        if gui and gui.Parent then
            for _, inst in ipairs(gui:GetDescendants()) do
                if inst:IsA("UIGradient") then
                    refreshEdgeGradient(inst)
                    refreshVerticalFade(inst)
                end
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
function Library:GetIcons() return ICONS end
function Library:GetIcon(name) return ICONS[string.lower(tostring(name or ""))] end

function Library:GetFlag(flag, default)
    local entry = Library.Flags[tostring(flag)]
    if not entry or not entry.api or type(entry.api.Get) ~= "function" then return default end
    local ok, value = pcall(entry.api.Get, entry.api)
    if ok and value ~= nil then return value end
    return default
end

function Library:SetFlag(flag, value)
    local entry = Library.Flags[tostring(flag)]
    if not entry or not entry.api or type(entry.api.Set) ~= "function" then return false end
    pcall(entry.api.Set, entry.api, value)
    return true
end

function Library:GetConfig()
    local data = {}
    for flag, entry in pairs(Library.Flags) do
        local api = entry.api
        if api then
            local ok, value
            if entry.kind == "color" and type(api.GetHex) == "function" then
                ok, value = pcall(api.GetHex, api)
            elseif type(api.Get) == "function" then
                ok, value = pcall(api.Get, api)
            end
            if ok and value ~= nil then
                if entry.kind == "keybind" then
                    data[flag] = (typeof(value) == "EnumItem") and value.Name or false
                else
                    data[flag] = value
                end
            end
        end
    end
    return data
end

function Library:LoadConfigData(data)
    if type(data) ~= "table" then return false end
    Library._autoSaveDisabled = true
    for flag, value in pairs(data) do
        local entry = Library.Flags[tostring(flag)]
        if entry and entry.api and type(entry.api.Set) == "function" then
            if entry.kind == "keybind" then
                local key = nil
                if type(value) == "string" then
                    pcall(function() key = Enum.KeyCode[value] end)
                end
                pcall(entry.api.Set, entry.api, key)
            else
                pcall(entry.api.Set, entry.api, value)
            end
        end
    end
    task.delay(0.2, function() Library._autoSaveDisabled = false end)
    return true
end

local function hasFileApi()
    return type(writefile) == "function" and type(readfile) == "function"
end
local function ensureConfigFolder()
    if type(makefolder) ~= "function" or type(isfolder) ~= "function" then return end
    local parts = string.split(Library.ConfigFolder, "/")
    local path = ""
    for _, part in ipairs(parts) do
        if part ~= "" then
            path = (path == "") and part or (path .. "/" .. part)
            if not isfolder(path) then pcall(makefolder, path) end
        end
    end
end
local function configPath(name)
    name = tostring(name or "default"):gsub("[^%w%-_ ]", "")
    if name == "" then name = "default" end
    return Library.ConfigFolder .. "/" .. name .. ".json"
end

local autoSaveThread = nil
function Library:QueueAutoSave()
    if Library._autoSaveDisabled then return end
    if not hasFileApi() then return end
    local cfgName = Library._currentConfigName or "autoload"
    if autoSaveThread then
        pcall(task.cancel, autoSaveThread)
        autoSaveThread = nil
    end
    autoSaveThread = task.delay(0.6, function()
        autoSaveThread = nil
        pcall(function() Library:SaveConfig(cfgName) end)
    end)
end

function Library:SaveConfig(name)
    if not hasFileApi() then return false end
    ensureConfigFolder()
    local ok, encoded = pcall(function()
        return HttpService:JSONEncode(Library:GetConfig())
    end)
    if not ok then return false end
    local wrote = pcall(writefile, configPath(name), encoded)
    return wrote
end

function Library:LoadConfig(name)
    if not hasFileApi() then return false end
    local path = configPath(name)
    if type(isfile) == "function" and not isfile(path) then return false end
    local ok, raw = pcall(readfile, path)
    if not ok or not raw then return false end
    local decoded, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not decoded then return false end
    return Library:LoadConfigData(data)
end

function Library:ListConfigs()
    local out = {}
    if type(listfiles) ~= "function" then return out end
    ensureConfigFolder()
    local ok, files = pcall(listfiles, Library.ConfigFolder)
    if not ok or type(files) ~= "table" then return out end
    for _, file in ipairs(files) do
        local name = string.match(tostring(file), "([^/\\]+)%.json$")
        if name then table.insert(out, name) end
    end
    return out
end

function Library:DeleteConfig(name)
    if type(delfile) ~= "function" then return false end
    local path = configPath(name)
    if type(isfile) == "function" and not isfile(path) then return false end
    return (pcall(delfile, path))
end

function Library:Notify(opts)
    for index = #Library._windowObjects, 1, -1 do
        local window = Library._windowObjects[index]
        if window and window.ScreenGui and window.ScreenGui.Parent then
            return window:Notify(opts)
        end
    end
    return nil
end
function Library:Notification(opts) return self:Notify(opts) end
function Library:IsAdmin() return false end
function Library:AdminDisconnect() return false, "not supported" end
function Library:JoinPlayer() return false, "not supported" end

function Library:DestroyAll()
    local objects = table.clone(Library._windowObjects or {})
    for _, window in ipairs(objects) do
        if window and type(window.Destroy) == "function" then
            pcall(function() window:Destroy() end)
        end
    end
    local windows = table.clone(Library._windows)
    for _, screenGui in ipairs(windows) do
        if screenGui and screenGui.Parent then pcall(function() screenGui:Destroy() end) end
    end
    table.clear(Library._windows)
    table.clear(Library._windowObjects or {})
    table.clear(Library.Flags)
    stopTagSystem()
end

-- Returns an accent color setter used by the Settings tab
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
                if inst:IsA("UIGradient") then
                    refreshEdgeGradient(inst)
                    refreshVerticalFade(inst)
                end
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

-- ════════════════════════════════════════════════════════════════════════════
-- CREATE WINDOW
-- ════════════════════════════════════════════════════════════════════════════
function Library:CreateWindow(opts)
    opts = opts or {}

    local logoAsset      = normalizeAssetId(opts.Logo or DEFAULT_LOGO)
    local logoZoom       = math.clamp(tonumber(opts.LogoZoom) or 1, 1, 6)
    local windowSize     = opts.Size or UDim2.fromOffset(700, 490)
    local windowPosition = opts.Position or UDim2.fromScale(0.5, 0.5)
    local guiName        = opts.GuiName or "N3MoggHub"

    local function detectMobile()
        local platform = nil
        pcall(function() platform = UserInputService:GetPlatform() end)
        if platform == Enum.Platform.IOS or platform == Enum.Platform.Android then return true end
        return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    end
    local isMobile = (opts.Mobile == true) or (opts.Mobile ~= false and detectMobile())

    local HOTBAR_HEIGHT  = 36
    local HOTBAR_GAP     = 8

    local targetParent
    if typeof(opts.Parent) == "Instance" then
        targetParent = opts.Parent
    else
        pcall(function() targetParent = (gethui and gethui()) or game:GetService("CoreGui") end)
        if not targetParent then targetParent = Players.LocalPlayer:WaitForChild("PlayerGui") end
    end

    local function removeExistingGui(parent)
        if opts.ReplaceExisting == false or not parent then return end
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("ScreenGui") and child.Name == guiName then child:Destroy() end
        end
    end
    removeExistingGui(targetParent)

    local screenGui = make("ScreenGui", {
        Name = guiName, ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = opts.DisplayOrder or 10,
    })
    local parented = pcall(function() screenGui.Parent = targetParent end)
    if not parented then
        targetParent = Players.LocalPlayer:WaitForChild("PlayerGui")
        removeExistingGui(targetParent)
        screenGui.Parent = targetParent
    end
    table.insert(Library._windows, screenGui)

    local containerW = windowSize.X.Offset
    local containerH = windowSize.Y.Offset + HOTBAR_GAP + HOTBAR_HEIGHT

    local container = make("Frame", {
        Name = "N3MoggContainer",
        Size = UDim2.fromOffset(containerW, containerH),
        Position = windowPosition,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = screenGui,
    })
    local containerScale = make("UIScale", { Scale = 1, Parent = container })

    local loadingEnabled  = opts.LoadingAnimation ~= false
    local loadingDuration = math.clamp(tonumber(opts.LoadingDuration) or 1.2, 0.4, 8)
    local loadingText     = tostring(opts.LoadingText or opts.Name or "N3 mogg hub")
    local loadingSub      = tostring(opts.LoadingSubtitle or "HUB")
    local loadingFooter   = tostring(opts.LoadingFooter or "N3 mogg hub")

    local loadingComplete = not loadingEnabled
    local loadingLayer

    if loadingEnabled then
        loadingLayer = make("CanvasGroup", {
            Name = "StartupLoader", Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.35,
            GroupTransparency = 0, ZIndex = 500, Parent = screenGui,
        })
        local mainWrap = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(820, 140),
            Position = UDim2.new(0.5, 0, 0.5, -20), BackgroundTransparency = 1, ZIndex = 510, Parent = loadingLayer,
        })
        make("TextLabel", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = loadingText,
            Font = Enum.Font.GothamBlack, TextScaled = true, TextColor3 = C.White,
            TextStrokeColor3 = Color3.fromRGB(0, 0, 0), TextStrokeTransparency = 0.3,
            ZIndex = 510, Parent = mainWrap,
        })
        make("TextLabel", {
            Size = UDim2.fromOffset(400, 22), Position = UDim2.new(0.5, 0, 0.5, 82), AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1, Text = loadingSub, Font = Enum.Font.GothamBold, TextSize = 16,
            TextColor3 = C.Accent, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), TextStrokeTransparency = 0.5,
            ZIndex = 510, Parent = loadingLayer,
        })
        task.spawn(function()
            task.wait(loadingDuration)
            if loadingLayer.Parent then
                TweenService:Create(loadingLayer, TweenInfo.new(0.32, Enum.EasingStyle.Quart), { GroupTransparency = 1 }):Play()
                task.wait(0.35)
                if loadingLayer.Parent then loadingLayer:Destroy() end
                loadingComplete = true
            end
        end)
    end

    local main = make("Frame", {
        Name = "Main", Size = windowSize,
        Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = C.WindowBg, ClipsDescendants = true,
        Visible = not loadingEnabled, ZIndex = 2, Parent = container,
    })
    corner(main, 12); stroke(main, C.Border)

    local mainGlowStroke = make("UIStroke", {
        Color = C.Accent, Thickness = 1.6,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Transparency = 0, Parent = main,
    })
    local mainGlowGradient = make("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, C.Accent),
            ColorSequenceKeypoint.new(0.42, C.Accent),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.58, C.Accent),
            ColorSequenceKeypoint.new(1.00, C.Accent),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 1.0),
            NumberSequenceKeypoint.new(0.36, 1.0),
            NumberSequenceKeypoint.new(0.50, 0.0),
            NumberSequenceKeypoint.new(0.64, 1.0),
            NumberSequenceKeypoint.new(1.00, 1.0),
        }),
        Parent = mainGlowStroke,
    })
    mainGlowGradient:SetAttribute("ThemeGradient_Edge", "Accent")
    local glowT = 0
    RunService.RenderStepped:Connect(function(dt)
        if not main or not main.Parent then return end
        glowT = (glowT + dt * 0.35) % 1
        mainGlowGradient.Offset = Vector2.new(glowT * 2 - 1, 0)
    end)

    local hotbar = make("Frame", {
        Name = "TabHotbar",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, windowSize.Y.Offset + HOTBAR_GAP),
        Size = UDim2.fromOffset(0, HOTBAR_HEIGHT),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = C.HotbarBg, ClipsDescendants = false,
        Visible = not loadingEnabled, ZIndex = 3, Parent = container,
    })
    corner(hotbar, 11)
    local hotbarStroke = make("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255), Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = hotbar,
    })
    hotbarStroke:SetAttribute("Theme_Color", nil)
    edgeAccentGradient(hotbarStroke, "Accent", "HotbarBorder", 0.15)
    pad(hotbar, 5, 5, 10, 10)

    local hotbarInner = make("Frame", {
        Name = "HotbarInner", Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1, ZIndex = 4, Parent = hotbar,
    })
    make("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4), Parent = hotbarInner,
    })

    local minimized = false
    local noDrag = {}
    table.insert(noDrag, hotbar)

    local controls = make("Frame", {
        Name = "CornerControls", AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -6, 0, 8), Size = UDim2.fromOffset(36, 16),
        BackgroundTransparency = 1, ZIndex = 10, Parent = main,
    })
    local closeBtn = make("TextButton", {
        Text = "", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(14, 14), BackgroundColor3 = Color3.fromRGB(190, 60, 60),
        ZIndex = 12, Parent = controls,
    })
    circle(closeBtn)
    local minimizeBtn = make("TextButton", {
        Text = "", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.fromOffset(14, 14), BackgroundColor3 = Color3.fromRGB(255, 195, 0),
        ZIndex = 12, Parent = controls,
    })
    circle(minimizeBtn)
    table.insert(noDrag, closeBtn); table.insert(noDrag, minimizeBtn)

    local sidebar = make("Frame", { Size = UDim2.new(0, 190, 1, 0), BackgroundTransparency = 1, Parent = main })
    local brand = make("Frame", { Name = "Brand", Position = UDim2.fromOffset(12, 12), Size = UDim2.new(1, -24, 0, 64), BackgroundColor3 = C.White, Parent = sidebar })
    corner(brand, 10); stroke(brand, C.Border)
    brand:SetAttribute("Theme_BackgroundColor3", nil)
    local brandGrad = make("UIGradient", { Rotation = 90, Parent = brand })
    brandGrad:SetAttribute("ThemeGradient_Top", "CardBg")
    brandGrad:SetAttribute("ThemeGradient_Bottom", "Accent")
    brandGrad:SetAttribute("ThemeGradient_Strength", 0.5)
    refreshVerticalFade(brandGrad)
    local logoHolder = make("Frame", { Position = UDim2.fromOffset(9, 9), Size = UDim2.fromOffset(46, 46), BackgroundTransparency = 1, ClipsDescendants = true, Parent = brand })
    make("ImageLabel", { Image = logoAsset, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(logoZoom, logoZoom), ScaleType = Enum.ScaleType.Fit, Parent = logoHolder })
    make("TextLabel", { Text = opts.Name or "N3 mogg hub", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(64, 16), Size = UDim2.new(1, -72, 0, 17), Parent = brand })
    make("TextLabel", { Text = opts.BrandSubtitle or ("v" .. Library.Version), Font = Enum.Font.GothamMedium, TextSize = 9, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(64, 35), Size = UDim2.new(1, -72, 0, 13), Parent = brand })

    local lp = Players.LocalPlayer
    local pcard = make("Frame", { Name = "PlayerCard", Position = UDim2.fromOffset(12, 88), Size = UDim2.new(1, -24, 0, 52), BackgroundColor3 = C.CardBg, Parent = sidebar })
    corner(pcard, 10); stroke(pcard, C.Border)
    local avH = make("Frame", { Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(36, 36), BackgroundColor3 = C.Element, Parent = pcard })
    corner(avH, 8)
    make("ImageLabel", { Image = "rbxthumb://type=AvatarHeadShot&id=" .. lp.UserId .. "&w=150&h=150", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop, Parent = avH })
    local avRing = stroke(avH, C.Accent); avRing.Transparency = 0.4
    make("TextLabel", { Text = lp.DisplayName, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(52, 10), Size = UDim2.new(1, -60, 0, 15), Parent = pcard })
    make("TextLabel", { Text = "@" .. lp.Name, Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(52, 28), Size = UDim2.new(1, -60, 0, 13), Parent = pcard })

    local watermarkHolder = make("Frame", { Name = "Watermark", BackgroundTransparency = 1, ClipsDescendants = true, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 24), Size = UDim2.fromOffset(156, 156), ZIndex = 0, Parent = sidebar })
    make("ImageLabel", { Name = "WatermarkImage", Image = logoAsset, BackgroundTransparency = 1, ImageTransparency = 0.85, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(logoZoom, logoZoom), ScaleType = Enum.ScaleType.Fit, ZIndex = 3, Parent = watermarkHolder })

    local statusDot = make("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 16, 1, -19), Size = UDim2.fromOffset(6, 6), BackgroundColor3 = NOTIFICATION_STYLES.success.Color, Parent = sidebar })
    circle(statusDot)
    make("TextLabel", { Text = opts.StatusText or "N3 mogg hub ready", Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.new(0, 28, 1, -27), Size = UDim2.new(1, -40, 0, 16), Parent = sidebar })

    local divLine = make("Frame", { Position = UDim2.fromOffset(190, 0), Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = C.Accent, Parent = main })
    make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.5), NumberSequenceKeypoint.new(1, 1) }), Parent = divLine })
    local content = make("Frame", { Position = UDim2.fromOffset(191, 0), Size = UDim2.new(1, -191, 1, 0), BackgroundTransparency = 1, Parent = main })

    local dragConn = makeDraggable(container, noDrag)

    local notificationHolder = make("Frame", {
        Name = "Notifications", AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, 16), Size = UDim2.new(0, 300, 1, -32),
        BackgroundTransparency = 1, ZIndex = 200, Parent = screenGui,
    })
    make("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = notificationHolder })

    local windowRef = setmetatable({
        ScreenGui = screenGui, Main = main, Container = container,
        _hotbar = hotbar, _hotbarInner = hotbarInner, _content = content,
        _notificationHolder = notificationHolder, _notificationOrder = 0,
        _connections = {}, _noDrag = noDrag, _tabs = {}, _activeTab = nil,
        _containerScale = containerScale, _uiVisible = true,
        _destroyed = false,
    }, Window)

    if dragConn then table.insert(windowRef._connections, dragConn) end

    table.insert(Library._windowObjects, windowRef)

    closeBtn.MouseButton1Click:Connect(function() windowRef:Destroy() end)
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = true
        main.Visible = false
        hotbar.Visible = false
    end)

    task.defer(function()
        while not loadingComplete do RunService.Heartbeat:Wait() end
        if screenGui.Parent then
            main.Visible = true
            hotbar.Visible = true
        end
    end)

    return windowRef
end

-- ════════════════════════════════════════════════════════════════════════════
-- WINDOW METHODS
-- ════════════════════════════════════════════════════════════════════════════
function Window:SetState(key, val) return Library:SetState(key, val) end
function Window:GetState(key, default) return Library:GetState(key, default) end
function Window:BindState(key, fn) return Library:BindState(key, fn) end
function Window:Get(flag, default) return Library:Get(flag, default) end
function Window:Set(flag, value) return Library:Set(flag, value) end
function Window:SetVisible(v) self.ScreenGui.Enabled = v == true end
function Window:Toggle() self.ScreenGui.Enabled = not self.ScreenGui.Enabled; return self.ScreenGui.Enabled end
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
    local slot = make("Frame", { Name = "NotificationSlot", Size = UDim2.new(1, 0, 0, 62), BackgroundTransparency = 1, LayoutOrder = self._notificationOrder, ZIndex = 200, Parent = holder })
    local card = make("CanvasGroup", { Name = style.Name .. "Notification", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 12, 0, 0), Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.CardBg, GroupTransparency = 1, ClipsDescendants = true, ZIndex = 201, Parent = slot })
    corner(card, 6); stroke(card, C.Border)
    local accentBar = make("Frame", { Position = UDim2.fromOffset(0, 10), Size = UDim2.fromOffset(3, 42), BackgroundColor3 = style.Color, ZIndex = 202, Parent = card })
    corner(accentBar, 2)
    make("TextLabel", { Text = title, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = style.Color, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -46, 0, 16), ZIndex = 202, Parent = card })
    make("TextLabel", { Text = body, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 27), Size = UDim2.new(1, -26, 0, 26), ZIndex = 202, Parent = card })
    local xb = make("TextButton", { Text = "×", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = C.TextDim, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -7, 0, 5), Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, ZIndex = 204, Parent = card })
    local closed = false; local handle = {}
    local function close(reason)
        if closed then return end; closed = true
        TweenService:Create(card, NOTIFICATION_TWEEN, { Position = UDim2.new(1, 12, 0, 0), GroupTransparency = 1 }):Play()
        task.delay(0.2, function() if slot and slot.Parent then slot:Destroy() end end)
        fire(opts.Callback or opts.OnClose, reason or "closed")
    end
    function handle:Close() close("manual") end
    function handle:IsOpen() return not closed end
    xb.MouseButton1Click:Connect(function() close("manual") end)
    TweenService:Create(card, NOTIFICATION_TWEEN, { Position = UDim2.new(1, 0, 0, 0), GroupTransparency = 0 }):Play()
    if dur > 0 then task.delay(dur, function() close("timeout") end) end
    return handle
end

-- ════════════════════════════════════════════════════════════════════════════
-- TAB SYSTEM
-- ════════════════════════════════════════════════════════════════════════════
function Window:_selectTab(tab)
    if self._activeTab == tab then return end
    local prev = self._activeTab; self._activeTab = tab
    if prev then
        prev._page.Visible = false
        tween(prev._hBtn, { BackgroundColor3 = C.HotbarBg })
        tween(prev._hLabel, { TextColor3 = C.TextGray })
        if prev._hIconElement then
            if prev._hIconElement:IsA("ImageLabel") then tween(prev._hIconElement, { ImageColor3 = C.TextGray })
            elseif prev._hIconElement:IsA("TextLabel") then tween(prev._hIconElement, { TextColor3 = C.TextGray }) end
        end
    end
    tab._page.Visible = true
    tween(tab._hBtn, { BackgroundColor3 = C.HotbarActive })
    tween(tab._hLabel, { TextColor3 = C.White })
    if tab._hIconElement then
        if tab._hIconElement:IsA("ImageLabel") then tween(tab._hIconElement, { ImageColor3 = C.White })
        elseif tab._hIconElement:IsA("TextLabel") then tween(tab._hIconElement, { TextColor3 = C.White }) end
    end
end

function Window:AddTab(opts)
    if type(opts) == "string" then opts = { Name = opts } end
    opts = opts or {}
    local name = opts.Name or "Tab"
    local iconInput = opts.Icon
    local win = self

    local iconType, iconValue = resolveIcon(iconInput)
    if not iconType then
        local autoKey = string.lower(name)
        if ICONS[autoKey] then iconType = "image"; iconValue = ICONS[autoKey]
        else iconType = "text"; iconValue = string.upper(string.sub(name, 1, 1)) end
    end

    local hBtn = make("TextButton", {
        Text = "", AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = C.HotbarBg,
        ZIndex = 5, Parent = self._hotbarInner,
    })
    hBtn.LayoutOrder = #self._hotbarInner:GetChildren()
    corner(hBtn, 7); pad(hBtn, 0, 0, 12, 12)
    table.insert(win._noDrag, hBtn)

    local hRow = make("Frame", { BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), ZIndex = 5, Parent = hBtn })
    make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = hRow })

    local iconBadge = make("Frame", { Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, LayoutOrder = 1, ZIndex = 6, Parent = hRow })
    local hIconElement = createIconElement(iconBadge, iconType, iconValue, 18, 7)

    local hLabel = make("TextLabel", {
        Text = name, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = C.TextGray, BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0), LayoutOrder = 2, ZIndex = 6, Parent = hRow,
    })

    local page = make("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Parent = self._content })
    local header = make("Frame", { Size = UDim2.new(1, 0, 0, 88), BackgroundTransparency = 1, Parent = page })

    local headerBadge = make("Frame", { Size = UDim2.fromOffset(32, 32), Position = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, Parent = header })
    local headerIconElement = createIconElement(headerBadge, iconType, iconValue, 26, 3)
    if headerIconElement:IsA("ImageLabel") then headerIconElement.ImageColor3 = C.White
    elseif headerIconElement:IsA("TextLabel") then headerIconElement.TextColor3 = C.White end

    make("TextLabel", { Text = name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(54, 17), Size = UDim2.new(1, -70, 0, 14), Parent = header })
    make("TextLabel", { Text = opts.Subtitle or "", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(54, 33), Size = UDim2.new(1, -70, 0, 12), Parent = header })

    local pillBar = make("Frame", { Position = UDim2.fromOffset(16, 54), Size = UDim2.new(1, -32, 0, 24), BackgroundTransparency = 1, ClipsDescendants = true, Parent = header })
    local pillScroll = make("ScrollingFrame", { Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.X, AutomaticCanvasSize = Enum.AutomaticSize.X, CanvasSize = UDim2.new(), ClipsDescendants = true, Parent = pillBar })
    table.insert(win._noDrag, pillScroll)
    local pillRow = make("Frame", { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1, Parent = pillScroll })
    make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = pillRow })
    make("Frame", { Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = C.Border, Parent = header })
    local pagesHolder = make("Frame", { Position = UDim2.fromOffset(0, 88), Size = UDim2.new(1, 0, 1, -88), BackgroundTransparency = 1, Parent = page })

    local tab = setmetatable({
        _window = win,
        _hBtn = hBtn, _hLabel = hLabel, _hIconElement = hIconElement,
        _page = page, _pillBar = pillBar, _pillScroll = pillScroll, _pillRow = pillRow,
        _pagesHolder = pagesHolder,
        _subTabs = {}, _activeSub = nil,
    }, Tab)

    hBtn.MouseButton1Click:Connect(function() win:_selectTab(tab) end)
    hBtn.MouseEnter:Connect(function()
        if win._activeTab ~= tab then tween(hBtn, { BackgroundColor3 = C.HotbarHover }) end
    end)
    hBtn.MouseLeave:Connect(function()
        tween(hBtn, { BackgroundColor3 = win._activeTab == tab and C.HotbarActive or C.HotbarBg })
    end)

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
    local pill = make("TextButton", { Text = name, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.TextGray, BackgroundColor3 = C.WindowBg, Size = UDim2.new(0, 0, 0, 24), AutomaticSize = Enum.AutomaticSize.X, Parent = self._pillRow })
    autoOrder(pill); corner(pill, 6); pad(pill, 0, 0, 12, 12)
    table.insert(tab._window._noDrag, pill)
    local page = make("ScrollingFrame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 2, ScrollBarImageColor3 = C.Border, Parent = self._pagesHolder })
    pad(page, 12, 16, 16, 16)
    table.insert(tab._window._noDrag, page)
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
    circle(pill)
    stroke(pill, C.Accent)
    local knob = make("Frame", { Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = C.KnobOff, Parent = pill })
    circle(knob)
    local function render(a)
        local kp = value and UDim2.new(0, 18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        paint(pill, "BackgroundColor3", value and "Accent" or "Badge", not a)
        paint(knob, "BackgroundColor3", value and "KnobAccent" or "KnobOff", not a)
        if a then tween(knob, { Position = kp }) else knob.Position = kp end
    end
    local function set(v) v = v == true; if v == value then return end; value = v; render(true); fire(opts.Callback, value); Library:QueueAutoSave() end
    pill.MouseButton1Click:Connect(function() set(not value) end); render(false)
    return registerFlag(opts.Flag, "toggle", { Set = function(_, v) set(v) end, Get = function() return value end })
end

function SubTab:AddButton(opts)
    opts = opts or {}
    local primary = opts.Primary == true or opts.Style == "primary"
    local btn = make("TextButton", { Text = opts.Name or "Button", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = primary and C.AccentText or C.TextGray, Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = primary and C.Accent or C.Element, Parent = self._card })
    autoOrder(btn); corner(btn, 6)
    if primary then btn.Font = Enum.Font.GothamBold end
    btn.MouseEnter:Connect(function() if primary then tween(btn, { BackgroundTransparency = 0.14 }) else tween(btn, { BackgroundColor3 = C.ElementHover }) end end)
    btn.MouseLeave:Connect(function() if primary then tween(btn, { BackgroundTransparency = 0 }) else tween(btn, { BackgroundColor3 = C.Element }) end end)
    btn.MouseButton1Click:Connect(function() fire(opts.Callback) end)
    return btn
end

function SubTab:AddLabel(opts)
    if type(opts) == "string" then opts = { Text = opts } end; opts = opts or {}
    local lbl = make("TextLabel", { Text = tostring(opts.Text or "Label"), Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), Parent = self._card })
    autoOrder(lbl)
    return { Set = function(_, t) lbl.Text = tostring(t) end, Get = function() return lbl.Text end, Instance = lbl }
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
        if fc then fire(opts.Callback, value); Library:QueueAutoSave() end
    end
    local function fromX(x) return mn + (mx - mn) * math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1) end
    local dragging = false
    hit.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; apply(fromX(i.Position.X), true, true) end end)
    trackConn(self._window, UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then apply(fromX(i.Position.X), true, true) end end))
    trackConn(self._window, UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end))
    apply(value, false, false)
    return registerFlag(opts.Flag, "slider", { Set = function(_, v) apply(v, true, true) end, Get = function() return value end })
end

function SubTab:AddDropdown(opts)
    opts = opts or {}
    local options = opts.Options or {}; local value = opts.Default or options[1] or ""
    local IH = 22; local IP = 2; local LW = 160
    local row = newRow(self._card, 30); rowLabels(row, opts.Name or "Dropdown", opts.Description, 130)
    local btn = make("TextButton", { Text = "", Size = UDim2.fromOffset(120, 22), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = C.Element, Parent = row })
    corner(btn, 6)
    local vl = make("TextLabel", { Text = tostring(value), Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -26, 1, 0), Parent = btn })
    sortIcon(btn)
    local win = self._window
    local list = make("Frame", { Visible = false, Active = true, Size = UDim2.new(0, LW, 0, 0), BackgroundColor3 = C.Element, ClipsDescendants = true, ZIndex = 100, Parent = win.ScreenGui })
    corner(list, 6); stroke(list); table.insert(win._noDrag, list)
    local sf = make("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = C.Border, ZIndex = 101, Parent = list })
    pad(sf, 4, 4, 4, 4)
    make("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, IP), Parent = sf })
    local open = false; local cg = 0; local oc = {}; local ob = {}
    local function repo()
        local inset = GuiService:GetGuiInset(); local p, s = btn.AbsolutePosition, btn.AbsoluteSize
        list.Position = UDim2.fromOffset(p.X + inset.X + s.X - LW, p.Y + inset.Y + s.Y + 4)
    end
    local function calcH()
        local vc = math.min(math.max(#options, 1), 5)
        return vc * IH + math.max(vc - 1, 0) * IP + 8
    end
    local function closeDD()
        if not open then return end; open = false; cg = cg + 1
        for _, c in ipairs(oc) do c:Disconnect() end; table.clear(oc)
        tween(list, { Size = UDim2.new(0, LW, 0, 0) })
        local g = cg; task.delay(0.16, function() if g == cg and not open then list.Visible = false end end)
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
            ob2.MouseButton1Click:Connect(function() value = o; vl.Text = os; closeDD(); fire(opts.Callback, o); Library:QueueAutoSave() end)
            table.insert(ob, ob2)
        end
    end
    rebuild()
    local function setOpen(o)
        if open == o then return end
        if o then
            open = true; cg = cg + 1; repo(); list.Visible = true; tween(list, { Size = UDim2.new(0, LW, 0, calcH()) })
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
        Set = function(_, o) value = o; vl.Text = tostring(o); fire(opts.Callback, o); Library:QueueAutoSave() end,
        Get = function() return value end,
        SetOptions = function(_, no)
            options = no or {}; local se = false
            for _, o in ipairs(options) do if o == value then se = true; break end end
            if not se and options[1] then value = options[1]; vl.Text = tostring(value) end
            rebuild(); if open then tween(list, { Size = UDim2.new(0, LW, 0, calcH()) }) end
        end,
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
    trackConn(self._window, pressConn)
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
    corner(panel, 6); stroke(panel); table.insert(win._noDrag, panel)
    local inner = make("Frame", { Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(PW, 168), BackgroundTransparency = 1, ZIndex = 101, Parent = panel })
    pad(inner, 10, 10, 10, 10)
    local svBox = make("Frame", { Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, 0, 0, 110), BackgroundColor3 = Color3.fromHSV(h, 1, 1), ZIndex = 101, Parent = inner })
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
        if fc then fire(opts.Callback, value); Library:QueueAutoSave() end
    end
    local svDragging = false
    local function svFrom(px, py)
        local p, sz = svBox.AbsolutePosition, svBox.AbsoluteSize
        s = math.clamp((px - p.X) / math.max(sz.X, 1), 0, 1)
        v = 1 - math.clamp((py - p.Y) / math.max(sz.Y, 1), 0, 1)
    end
    svHit.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then svDragging = true; svFrom(i.Position.X, i.Position.Y); recompute(false) end end)
    trackConn(win, UserInputService.InputChanged:Connect(function(i)
        if svDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then svFrom(i.Position.X, i.Position.Y); recompute(false) end
    end))
    trackConn(win, UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then svDragging = false end end))
    hexBox.FocusLost:Connect(function()
        local c = hexToColor(hexBox.Text)
        if c then value = c; h, s, v = c:ToHSV(); recompute(true) else hexBox.Text = colorToHex(value) end
    end)
    local open = false; local cg = 0; local oc = {}
    local function repo()
        local inset = GuiService:GetGuiInset(); local p, sz = swatch.AbsolutePosition, swatch.AbsoluteSize
        panel.Position = UDim2.fromOffset(p.X + inset.X + sz.X - PW, p.Y + inset.Y + sz.Y + 4)
    end
    local function closePanel()
        if not open then return end; open = false; cg = cg + 1
        for _, c in ipairs(oc) do c:Disconnect() end; table.clear(oc)
        tween(panel, { Size = UDim2.fromOffset(PW, 0) })
        local g = cg; task.delay(0.16, function() if g == cg and not open then panel.Visible = false end end)
    end
    local function setOpen(o)
        if open == o then return end
        if o then
            open = true; cg = cg + 1; repo(); panel.Visible = true; tween(panel, { Size = UDim2.fromOffset(PW, 168) })
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
        Set = function(_, c)
            c = (typeof(c) == "Color3" and c) or hexToColor(c)
            if not c then return end
            value = c; h, s, v = c:ToHSV(); recompute(true)
        end,
        Get = function() return value end,
        GetHex = function() return colorToHex(value) end,
    })
end

function SubTab:AddInput(opts)
    opts = opts or {}
    local row = newRow(self._card, 30); rowLabels(row, opts.Name or "Input", opts.Description, 120)
    local holder = make("Frame", { Size = UDim2.fromOffset(110, 22), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = C.Element, Parent = row })
    corner(holder, 6)
    local box = make("TextBox", { Text = opts.Default or "", PlaceholderText = opts.Placeholder or "...", PlaceholderColor3 = C.Placeholder, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, ClearTextOnFocus = false, ClipsDescendants = true, Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -30, 1, 0), Parent = holder })
    inputIcon(holder)
    box.FocusLost:Connect(function(ep) fire(opts.Callback, box.Text, ep); Library:QueueAutoSave() end)
    return registerFlag(opts.Flag, "input", { Set = function(_, t) box.Text = tostring(t) end, Get = function() return box.Text end })
end

function Library:AddSubTabPlaceholder(subTab, text)
    if not subTab or not subTab._card then return end
    local lbl = make("TextLabel", {
        Text = tostring(text or "soon..."),
        Font = Enum.Font.GothamBold, TextSize = 20,
        TextColor3 = C.TextDim, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 60),
        Parent = subTab._card,
    })
    autoOrder(lbl)
    return lbl
end

return Library
