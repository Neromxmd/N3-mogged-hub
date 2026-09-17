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
    local parts
