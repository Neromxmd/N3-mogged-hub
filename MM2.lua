-- N3 mogg hub — MM2 script
-- Tabs: MM2 (Player, Visual, Gameplay, System), Others (Aim, ESP), Settings

local Library = _G.N3MoggLibrary
if not Library then
    error("[N3 mogg hub] Library not loaded", 0)
end

local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local Workspace          = game:GetService("Workspace")
local Lighting           = game:GetService("Lighting")
local TeleportService    = game:GetService("TeleportService")
local VirtualUser        = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera

local HUB = { conns = {}, drawings = {}, highlights = {}, dead = false }
local function track(c) table.insert(HUB.conns, c); return c end
local function trackDrawing(d) if d then table.insert(HUB.drawings, d) end; return d end

local Window = Library:CreateWindow({
    Name = "N3 mogg hub",
    Logo = "rbxassetid://134591276795300",
    BrandSubtitle = "MM2",
    StatusText = "N3 mogg hub is ready",
    LoadingAnimation = true,
    LoadingText = "N3 mogg hub",
    LoadingSubtitle = "HUB",
    LoadingFooter = "N3 mogg hub",
    LoadingDuration = 1.5,
})

-- ════════════════════════════════════════════════════════════════════════════
-- HELPERS
-- ════════════════════════════════════════════════════════════════════════════
local function GetCharacter() return LocalPlayer.Character end
local function GetHumanoid()
    local c = GetCharacter(); if not c then return nil end
    return c:FindFirstChildOfClass("Humanoid")
end
local function GetHRP()
    local c = GetCharacter(); return c and c:FindFirstChild("HumanoidRootPart")
end
local function Notify(title, content, kind, dur)
    Window:Notify({ Title = title, Content = content, Type = kind or "Info", Duration = dur or 2.5 })
end
local function GetCoins()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    local c = ls and (ls:FindFirstChild("Coins") or ls:FindFirstChild("Coin"))
    if c and typeof(c.Value) == "number" then return c.Value end
    local df = LocalPlayer:FindFirstChild("DataFolder")
    local c2 = df and df:FindFirstChild("Coins")
    if c2 then return tonumber(c2.Value) or 0 end
    return 0
end
local function GetLevel()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    local l = ls and ls:FindFirstChild("Level")
    if l then return tonumber(l.Value) or 0 end
    return 0
end

-- ════════════════════════════════════════════════════════════════════════════
-- ROLE TRACKER (мгновенный, читает атрибуты Role)
-- ════════════════════════════════════════════════════════════════════════════
local roleMemory = {}

local ROLE_ATTR_NAMES = { "Role", "role", "ROLE", "Team", "team" }
local ROLE_VALUES = {
    ["murderer"] = "Murderer",
    ["sheriff"]  = "Sheriff",
    ["hero"]     = "Hero",
    ["innocent"] = "Innocent",
}

local function ReadRoleAttr(inst)
    if not inst then return nil end
    for _, attrName in ipairs(ROLE_ATTR_NAMES) do
        local ok, val = pcall(function() return inst:GetAttribute(attrName) end)
        if ok and type(val) == "string" then
            local norm = ROLE_VALUES[val:lower()]
            if norm then return norm end
        end
    end
    for _, childName in ipairs({ "Role", "Team", "role" }) do
        local child = inst:FindFirstChild(childName)
        if child and (child:IsA("StringValue") or child:IsA("ValueBase")) then
            local ok, val = pcall(function() return tostring(child.Value) end)
            if ok then
                local norm = ROLE_VALUES[val:lower()]
                if norm then return norm end
            end
        end
    end
    return nil
end

local function isToolRole(t)
    if not t or not t:IsA("Tool") then return nil end
    local n = t.Name:lower()
    if n:find("knife") then return "Murderer" end
    if n:find("gun") or n:find("revolver") or n:find("pistol") then return "Sheriff" end
    return nil
end

local function GetRole(plr)
    if plr == nil then plr = LocalPlayer end

    local r = ReadRoleAttr(plr)
    if r then roleMemory[plr] = r; return r end

    local char = plr.Character
    if char then
        r = ReadRoleAttr(char)
        if r then roleMemory[plr] = r; return r end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then
            roleMemory[plr] = "Dead"
            return "Dead"
        end

        for _, t in ipairs(char:GetChildren()) do
            r = isToolRole(t)
            if r then roleMemory[plr] = r; return r end
        end
    end

    local bp = plr:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            r = isToolRole(t)
            if r then roleMemory[plr] = r; return r end
        end
    end

    if roleMemory[plr] then return roleMemory[plr] end
    return "Unknown"
end

local function hookCharacterAdded(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.1)
        roleMemory[p] = nil
    end)
end
for _, p in ipairs(Players:GetPlayers()) do hookCharacterAdded(p) end
Players.PlayerAdded:Connect(hookCharacterAdded)

local function RoleColor(role)
    if role == "Murderer" then return Color3.fromRGB(255, 60, 60)
    elseif role == "Sheriff" then return Color3.fromRGB(60, 130, 255)
    elseif role == "Hero" then return Color3.fromRGB(60, 255, 255)
    elseif role == "Innocent" then return Color3.fromRGB(80, 220, 120)
    elseif role == "Dead" then return Color3.fromRGB(120, 120, 120)
    else return Color3.fromRGB(180, 180, 180) end
end
local function FormatMoney(v) return tostring(math.floor(tonumber(v) or 0)) end

-- ════════════════════════════════════════════════════════════════════════════
-- TAB: MM2
-- ════════════════════════════════════════════════════════════════════════════
local MM2Tab = Window:AddTab({ Name = "MM2", Subtitle = "Murder Mystery 2", Icon = "combat" })

-- ── PLAYER ──
local PlayerSub = MM2Tab:AddSubTab("Player")
PlayerSub:AddSection("Speed & Jump")
local wsEnabled, wsValue = false, 16
local jpEnabled, jpValue = false, 50
local infJump = false
local defaultGravity = Workspace.Gravity

PlayerSub:AddToggle({ Name = "WalkSpeed", Default = false, Flag = "ws_enabled",
    Callback = function(v) wsEnabled = v; local h = GetHumanoid(); if h then h.WalkSpeed = v and wsValue or 16 end end })
PlayerSub:AddSlider({ Name = "WalkSpeed Value", Min = 16, Max = 500, Default = 16, Flag = "ws_value",
    Callback = function(v) wsValue = v; if wsEnabled then local h = GetHumanoid(); if h then h.WalkSpeed = v end end end })
PlayerSub:AddToggle({ Name = "JumpPower", Default = false, Flag = "jp_enabled",
    Callback = function(v) jpEnabled = v; local h = GetHumanoid(); if h then h.UseJumpPower = true; h.JumpPower = v and jpValue or 50 end end })
PlayerSub:AddSlider({ Name = "JumpPower Value", Min = 50, Max = 400, Default = 50, Flag = "jp_value",
    Callback = function(v) jpValue = v; if jpEnabled then local h = GetHumanoid(); if h then h.UseJumpPower = true; h.JumpPower = v end end end })
PlayerSub:AddToggle({ Name = "Infinite Jump", Default = false, Flag = "inf_jump",
    Callback = function(v) infJump = v end })

PlayerSub:AddSection("Gravity")
local gravityEnabled, gravityValue = false, defaultGravity
PlayerSub:AddToggle({ Name = "Custom Gravity", Default = false, Flag = "grav_enabled",
    Callback = function(v) gravityEnabled = v; Workspace.Gravity = v and gravityValue or defaultGravity end })
PlayerSub:AddSlider({ Name = "Gravity Value", Min = 0, Max = 400, Default = math.floor(defaultGravity), Flag = "grav_value",
    Callback = function(v) gravityValue = v; if gravityEnabled then Workspace.Gravity = v end end })

track(RunService.RenderStepped:Connect(function()
    if HUB.dead then return end
    local h = GetHumanoid()
    if not h then
        if gravityEnabled and Workspace.Gravity ~= gravityValue then Workspace.Gravity = gravityValue end
        return
    end
    if wsEnabled and h.WalkSpeed ~= wsValue then h.WalkSpeed = wsValue end
    if jpEnabled then
        if not h.UseJumpPower then h.UseJumpPower = true end
        if h.JumpPower ~= jpValue then h.JumpPower = jpValue end
    end
    if gravityEnabled and Workspace.Gravity ~= gravityValue then Workspace.Gravity = gravityValue end
end))

track(UserInputService.JumpRequest:Connect(function()
    if HUB.dead or not infJump then return end
    local h = GetHumanoid()
    if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

PlayerSub:AddSection("Fly & Noclip")
local flying, flySpeed = false, 50
local flyConn
local function startFly()
    local h = GetHumanoid(); if not h then return end
    h.PlatformStand = true
    if flyConn then flyConn:Disconnect() end
    flyConn = RunService.RenderStepped:Connect(function()
        if HUB.dead or not flying then return end
        local hh = GetHumanoid(); local root = GetHRP()
        if not hh or not root then return end
        hh.PlatformStand = true
        local dir = Vector3.zero
        local cf = Camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
        if dir.Magnitude > 0 then dir = dir.Unit * flySpeed else dir = Vector3.zero end
        root.AssemblyLinearVelocity = dir
        root.AssemblyAngularVelocity = Vector3.zero
    end)
end
local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    local h = GetHumanoid()
    if h then h.PlatformStand = false end
    local root = GetHRP()
    if root then root.AssemblyLinearVelocity = Vector3.zero end
end
PlayerSub:AddToggle({ Name = "Fly", Default = false, Flag = "fly_enabled",
    Callback = function(v) flying = v; if v then startFly() else stopFly() end end })
PlayerSub:AddSlider({ Name = "Fly Speed", Min = 10, Max = 500, Default = 50, Flag = "fly_speed",
    Callback = function(v) flySpeed = v end })

local noclip = false
local noclipConn
PlayerSub:AddToggle({ Name = "Noclip", Default = false, Flag = "noclip_enabled",
    Callback = function(v)
        noclip = v
        if v then
            if noclipConn then noclipConn:Disconnect() end
            noclipConn = RunService.Stepped:Connect(function()
                if HUB.dead or not noclip then return end
                local c = GetCharacter(); if not c then return end
                for _, part in ipairs(c:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        end
    end })

PlayerSub:AddSection("Character")
PlayerSub:AddButton({ Name = "Respawn", Primary = true, Callback = function()
    local h = GetHumanoid(); if h then h.Health = 0 end
end })
PlayerSub:AddButton({ Name = "Reset Stats", Callback = function()
    local h = GetHumanoid()
    if h then h.WalkSpeed = 16; h.JumpPower = 50; h.UseJumpPower = true end
    Workspace.Gravity = defaultGravity
end })

local antiAFK = true
PlayerSub:AddToggle({ Name = "Anti-AFK", Default = true, Flag = "anti_afk",
    Callback = function(v) antiAFK = v end })
if not _G.N3MoggAntiAFK then
    _G.N3MoggAntiAFK = true
    LocalPlayer.Idled:Connect(function()
        if not antiAFK then return end
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end)
end

-- ════════════════════════════════════════════════════════════════════════════
-- VISUAL
-- ════════════════════════════════════════════════════════════════════════════
local VisualSub = MM2Tab:AddSubTab("Visual")
local hasDrawing = (typeof(Drawing) == "table") or (Drawing ~= nil and pcall(function() return Drawing.new end))

local esp = {
    enabled      = true,
    players      = true,
    box          = false,
    boxStyle     = "Corner",
    boxThickness = 1,
    name         = true,
    distance     = false,
    health       = false,
    chams        = true,
    tracer       = false,
    roleESP      = true,
    coinESP      = false,
    maxDistance  = 1000,
    textSize     = 14,
    coinColor    = Color3.fromRGB(255, 220, 60),
}
local playerObjects = {}

local function getEspParent()
    local ok, parent = pcall(function() return (gethui and gethui()) or game:GetService("CoreGui") end)
    if ok and parent then return parent end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local function newDrawing(class, props)
    if not hasDrawing then return nil end
    local ok, d = pcall(function() return Drawing.new(class) end)
    if not ok or not d then return nil end
    for k, v in pairs(props or {}) do pcall(function() d[k] = v end) end
    return trackDrawing(d)
end

local function MakeBox()
    local box = {}
    if hasDrawing then
        box.frame   = newDrawing("Square", { Thickness = 1, Filled = false, Visible = false })
        box.outline = newDrawing("Square", { Thickness = 2, Filled = false, Color = Color3.new(0, 0, 0), Visible = false })
        box.corners = {}
        for i = 1, 8 do
            box.corners[i] = newDrawing("Line", { Thickness = 1, Visible = false, Color = Color3.new(1, 1, 1) })
        end
    end
    box.highlight = Instance.new("Highlight")
    box.highlight.FillTransparency = 0.5
    box.highlight.OutlineTransparency = 0.2
    box.highlight.Enabled = false
    box.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    pcall(function() box.highlight.Parent = getEspParent() end)
    table.insert(HUB.highlights, box.highlight)
    box.name = newDrawing("Text", { Color = Color3.fromRGB(255, 255, 255), Size = 14, Outline = true, Centre = true, Visible = false })
    box.dist = newDrawing("Text", { Color = Color3.fromRGB(255, 255, 255), Size = 11, Outline = true, Centre = true, Visible = false })
    box.hpText = newDrawing("Text", { Color = Color3.fromRGB(255, 255, 255), Size = 11, Outline = true, Centre = false, Visible = false })
    if hasDrawing then
        box.tracer = newDrawing("Line", { Thickness = 1.2, Visible = false })
        box.hpOutline = newDrawing("Line", { Thickness = 3, Visible = false, Color = Color3.new(0, 0, 0) })
        box.hp = newDrawing("Line", { Thickness = 2, Visible = false })
    end
    return box
end

local function AddPlayerESP(p)
    if p == LocalPlayer or playerObjects[p] then return end
    playerObjects[p] = MakeBox()
end

local function RemovePlayerESP(p)
    local obj = playerObjects[p]
    if not obj then return end
    for _, d in ipairs({ obj.frame, obj.outline, obj.name, obj.dist, obj.tracer, obj.hpText, obj.hp, obj.hpOutline }) do
        if d then pcall(function() d:Remove() end) end
    end
    if obj.corners then for _, l in ipairs(obj.corners) do if l then pcall(function() l:Remove() end) end end end
    if obj.highlight then pcall(function() obj.highlight:Destroy() end) end
    playerObjects[p] = nil
end

for _, p in ipairs(Players:GetPlayers()) do AddPlayerESP(p) end
track(Players.PlayerAdded:Connect(AddPlayerESP))
track(Players.PlayerRemoving:Connect(RemovePlayerESP))

VisualSub:AddSection("ESP")
VisualSub:AddToggle({ Name = "Master Enable", Default = true, Flag = "esp_enabled", Callback = function(v) esp.enabled = v end })
VisualSub:AddToggle({ Name = "Players", Default = true, Flag = "esp_players", Callback = function(v) esp.players = v end })
VisualSub:AddToggle({ Name = "Role ESP (color by role)", Default = true, Flag = "esp_role", Callback = function(v) esp.roleESP = v end })
VisualSub:AddToggle({ Name = "Name", Default = true, Flag = "esp_name", Callback = function(v) esp.name = v end })
VisualSub:AddToggle({ Name = "Chams (Highlight)", Default = true, Flag = "esp_chams", Callback = function(v) esp.chams = v end })
VisualSub:AddToggle({ Name = "Coin ESP", Default = false, Flag = "esp_coin", Callback = function(v) esp.coinESP = v end })

VisualSub:AddSection("Boxes")
VisualSub:AddToggle({ Name = "2D Box", Default = false, Flag = "esp_box", Callback = function(v) esp.box = v end })
VisualSub:AddDropdown({ Name = "Box Style", Options = { "Full", "Corner" }, Default = "Corner", Flag = "esp_boxstyle",
    Callback = function(v) esp.boxStyle = v end })
VisualSub:AddSlider({ Name = "Box Thickness", Min = 1, Max = 5, Default = 1, Flag = "esp_boxthick",
    Callback = function(v) esp.boxThickness = v end })
VisualSub:AddToggle({ Name = "Health Bar", Default = false, Flag = "esp_health", Callback = function(v) esp.health = v end })
VisualSub:AddToggle({ Name = "Tracers", Default = false, Flag = "esp_tracers", Callback = function(v) esp.tracer = v end })
VisualSub:AddToggle({ Name = "Distance", Default = false, Flag = "esp_distance", Callback = function(v) esp.distance = v end })
VisualSub:AddSlider({ Name = "Text Size", Min = 10, Max = 20, Default = 14, Flag = "esp_textsize",
    Callback = function(v) esp.textSize = v end })
VisualSub:AddSlider({ Name = "Max Distance", Min = 0, Max = 5000, Default = 1000, Suffix = "m", Flag = "esp_maxdist",
    Callback = function(v) esp.maxDistance = v end })

local function getBox2D(char)
    if not char then return nil end
    local head = char:FindFirstChild("Head")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local topPos = head and head.Position or (hrp.Position + Vector3.new(0, 1.5, 0))
    local bottomPos = hrp.Position - Vector3.new(0, 3, 0)

    local topScreen, topOn = Camera:WorldToViewportPoint(topPos)
    local botScreen, botOn = Camera:WorldToViewportPoint(bottomPos)
    if not topOn or not botOn or topScreen.Z <= 0 then return nil end

    local h = math.abs(botScreen.Y - topScreen.Y)
    if h < 8 then h = 8 end
    local w = h * 0.5
    local cx = topScreen.X
    return cx - w / 2, topScreen.Y - 8, cx + w / 2, botScreen.Y
end

local roleCache = {}
local roleCacheTime = 0
local ROLE_CACHE_TTL = 0.05

local function refreshRoleCache()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            roleCache[p] = GetRole(p)
        end
    end
    roleCacheTime = tick()
end

track(RunService.RenderStepped:Connect(function()
    if HUB.dead then return end
    if tick() - roleCacheTime > ROLE_CACHE_TTL then
        refreshRoleCache()
    end
    local hrp = GetHRP()
    local myPos = hrp and hrp.Position or Vector3.zero

    for p, obj in pairs(playerObjects) do
        local visible = esp.enabled and esp.players
        local char = p.Character
        local hrp2 = char and char:FindFirstChild("HumanoidRootPart")
        local hum2 = char and char:FindFirstChild("Humanoid")
        if visible and hrp2 and hum2 and hum2.Health > 0 then
            local dist = (hrp2.Position - myPos).Magnitude
            local roleName = roleCache[p] or GetRole(p)
            local color = esp.roleESP and RoleColor(roleName) or Color3.fromRGB(255, 255, 255)

            if esp.maxDistance > 0 and dist > esp.maxDistance then
                if obj.frame then obj.frame.Visible = false end
                if obj.outline then obj.outline.Visible = false end
                if obj.corners then for _, l in ipairs(obj.corners) do if l then l.Visible = false end end end
                if obj.name then obj.name.Visible = false end
                if obj.dist then obj.dist.Visible = false end
                if obj.tracer then obj.tracer.Visible = false end
                if obj.hp then obj.hp.Visible = false end
                if obj.hpOutline then obj.hpOutline.Visible = false end
                if obj.hpText then obj.hpText.Visible = false end
                if obj.highlight then obj.highlight.Enabled = false end
            else
                if obj.highlight then
                    if obj.highlight.Adornee ~= char then pcall(function() obj.highlight.Adornee = char end) end
                    obj.highlight.FillColor = color
                    obj.highlight.OutlineColor = color
                    obj.highlight.Enabled = (esp.chams or esp.roleESP)
                end

                if esp.name and obj.name then
                    local headPart = char:FindFirstChild("Head")
                    local headPos = (headPart and headPart.Position or hrp2.Position) + Vector3.new(0, 1.2, 0)
                    local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                    if onScreen and screenPos.Z > 0 then
                        obj.name.Visible = true
                        obj.name.Text = p.Name
                        obj.name.Color = color
                        obj.name.Size = esp.textSize
                        obj.name.Position = Vector2.new(screenPos.X, screenPos.Y)
                    else
                        obj.name.Visible = false
                    end
                else
                    if obj.name then obj.name.Visible = false end
                end

                local leftX, topY, rightX, bottomY = getBox2D(char)
                if leftX then
                    local w = rightX - leftX
                    local h = bottomY - topY
                    local cx = (leftX + rightX) / 2
                    local cornerLen = math.clamp(w * 0.28, 4, 18)

                    if esp.box and hasDrawing then
                        if esp.boxStyle == "Corner" then
                            if obj.frame then obj.frame.Visible = false end
                            if obj.outline then obj.outline.Visible = false end
                            if obj.corners then
                                local pts = {
                                    {Vector2.new(leftX, topY), Vector2.new(leftX + cornerLen, topY)},
                                    {Vector2.new(leftX, topY), Vector2.new(leftX, topY + cornerLen)},
                                    {Vector2.new(rightX, topY), Vector2.new(rightX - cornerLen, topY)},
                                    {Vector2.new(rightX, topY), Vector2.new(rightX, topY + cornerLen)},
                                    {Vector2.new(leftX, bottomY), Vector2.new(leftX + cornerLen, bottomY)},
                                    {Vector2.new(leftX, bottomY), Vector2.new(leftX, bottomY - cornerLen)},
                                    {Vector2.new(rightX, bottomY), Vector2.new(rightX - cornerLen, bottomY)},
                                    {Vector2.new(rightX, bottomY), Vector2.new(rightX, bottomY - cornerLen)},
                                }
                                for i, l in ipairs(obj.corners) do
                                    if l then
                                        l.Visible = true; l.Color = color; l.Thickness = esp.boxThickness
                                        l.From = pts[i][1]; l.To = pts[i][2]
                                    end
                                end
                            end
                        else
                            if obj.corners then for _, l in ipairs(obj.corners) do if l then l.Visible = false end end end
                            if obj.outline then
                                obj.outline.Visible = true
                                obj.outline.Size = Vector2.new(w + 2, h + 2)
                                obj.outline.Position = Vector2.new(leftX - 1, topY - 1)
                            end
                            if obj.frame then
                                obj.frame.Visible = true; obj.frame.Color = color; obj.frame.Thickness = esp.boxThickness
                                obj.frame.Size = Vector2.new(w, h); obj.frame.Position = Vector2.new(leftX, topY)
                            end
                        end
                    else
                        if obj.frame then obj.frame.Visible = false end
                        if obj.outline then obj.outline.Visible = false end
                        if obj.corners then for _, l in ipairs(obj.corners) do if l then l.Visible = false end end end
                    end

                    if esp.distance and obj.dist then
                        obj.dist.Visible = true
                        obj.dist.Text = string.format("%.0fm", dist / 3)
                        obj.dist.Size = math.max(9, esp.textSize - 2)
                        obj.dist.Position = Vector2.new(cx, bottomY + 4)
                    else
                        if obj.dist then obj.dist.Visible = false end
                    end

                    if esp.tracer and obj.tracer then
                        obj.tracer.Visible = true; obj.tracer.Color = color
                        local vs = Camera.ViewportSize
                        obj.tracer.From = Vector2.new(vs.X / 2, vs.Y - 4)
                        obj.tracer.To = Vector2.new(cx, bottomY)
                    else
                        if obj.tracer then obj.tracer.Visible = false end
                    end

                    local humHealth = hum2.Health
                    local humMax = hum2.MaxHealth
                    local healthFrac = math.clamp(humHealth / math.max(humMax, 1), 0, 1)
                    if esp.health and hasDrawing then
                        local barX = leftX - 5
                        if obj.hpOutline then obj.hpOutline.Visible = true; obj.hpOutline.From = Vector2.new(barX, topY - 1); obj.hpOutline.To = Vector2.new(barX, bottomY + 1) end
                        if obj.hp then
                            local col = Color3.fromRGB(math.floor(255 * (1 - healthFrac)), math.floor(255 * healthFrac), 0)
                            obj.hp.Visible = true; obj.hp.Color = col
                            obj.hp.From = Vector2.new(barX, bottomY); obj.hp.To = Vector2.new(barX, bottomY - h * healthFrac)
                        end
                        if obj.hpText then
                            obj.hpText.Visible = true; obj.hpText.Text = tostring(math.floor(humHealth))
                            obj.hpText.Position = Vector2.new(barX - 16, (topY + bottomY) / 2 - 6)
                        end
                    else
                        if obj.hpOutline then obj.hpOutline.Visible = false end
                        if obj.hp then obj.hp.Visible = false end
                        if obj.hpText then obj.hpText.Visible = false end
                    end
                else
                    if obj.frame then obj.frame.Visible = false end
                    if obj.outline then obj.outline.Visible = false end
                    if obj.corners then for _, l in ipairs(obj.corners) do if l then l.Visible = false end end end
                    if obj.dist then obj.dist.Visible = false end
                    if obj.tracer then obj.tracer.Visible = false end
                end
            end
        else
            if obj.frame then obj.frame.Visible = false end
            if obj.outline then obj.outline.Visible = false end
            if obj.corners then for _, l in ipairs(obj.corners) do if l then l.Visible = false end end end
            if obj.name then obj.name.Visible = false end
            if obj.dist then obj.dist.Visible = false end
            if obj.tracer then obj.tracer.Visible = false end
            if obj.hp then obj.hp.Visible = false end
            if obj.hpOutline then obj.hpOutline.Visible = false end
            if obj.hpText then obj.hpText.Visible = false end
            if obj.highlight then obj.highlight.Enabled = false end
        end
    end
end))

local coinHighlights = {}
task.spawn(function()
    while not HUB.dead do
        if esp.coinESP and esp.enabled then
            pcall(function()
                local found = {}
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v.Name == "Coin" and v:IsA("BasePart") and v.Transparency < 1 then
                        found[v] = true
                        if not coinHighlights[v] then
                            local hl = Instance.new("Highlight")
                            hl.FillColor = esp.coinColor; hl.FillTransparency = 0.6
                            hl.OutlineColor = esp.coinColor
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            pcall(function() hl.Parent = v end)
                            table.insert(HUB.highlights, hl)
                            coinHighlights[v] = hl
                        end
                    end
                end
                for part, hl in pairs(coinHighlights) do
                    if not found[part] then pcall(function() hl:Destroy() end); coinHighlights[part] = nil end
                end
            end)
        elseif next(coinHighlights) then
            for p, hl in pairs(coinHighlights) do pcall(function() hl:Destroy() end); coinHighlights[p] = nil end
        end
        task.wait(1)
    end
end)

VisualSub:AddSection("World")
local fullbright = false
local savedLighting = { Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient }
VisualSub:AddToggle({ Name = "Fullbright", Default = false, Flag = "fullbright",
    Callback = function(v)
        fullbright = v
        if v then
            Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 1e9
            Lighting.GlobalShadows = false; Lighting.Ambient = Color3.fromRGB(180, 180, 180)
        else
            Lighting.Brightness = savedLighting.Brightness; Lighting.ClockTime = savedLighting.ClockTime
            Lighting.FogEnd = savedLighting.FogEnd; Lighting.GlobalShadows = savedLighting.GlobalShadows
            Lighting.Ambient = savedLighting.Ambient
        end
    end })
local defaultFOV = Camera.FieldOfView
VisualSub:AddSlider({ Name = "Field of View", Min = 30, Max = 120, Default = math.floor(defaultFOV), Suffix = "°", Flag = "fov",
    Callback = function(v) Camera.FieldOfView = v end })

-- ════════════════════════════════════════════════════════════════════════════
-- GAMEPLAY
-- ════════════════════════════════════════════════════════════════════════════
local GameplaySub = MM2Tab:AddSubTab("Gameplay")
GameplaySub:AddSection("Auto Farm Coins")
local autoCollect = false
local autoCollectSpeed = 0.8

GameplaySub:AddToggle({ Name = "Auto Collect Coins", Default = false, Flag = "auto_collect",
    Callback = function(v) autoCollect = v; Notify("Gameplay", v and "Auto Coins ON" or "Auto Coins OFF", v and "Success" or "Error") end })
GameplaySub:AddSlider({ Name = "Collect Interval", Min = 0.2, Max = 3, Default = 0.8, Suffix = "s", Flag = "auto_collect_speed",
    Callback = function(v) autoCollectSpeed = v end })

task.spawn(function()
    local function getNearestCoin()
        local hrp = GetHRP(); if not hrp then return nil end
        local best, bestDist = nil, math.huge
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency < 1 and v.Parent and (v.Name == "Coin" or v.Name:lower():find("coin")) then
                local ok, d = pcall(function() return (v.Position - hrp.Position).Magnitude end)
                if ok and d < bestDist and d <= 250 then best = v; bestDist = d end
            end
        end
        return best
    end
    while not HUB.dead do
        if autoCollect then
            pcall(function()
                local coin = getNearestCoin()
                local hrp = GetHRP()
                if coin and hrp then
                    local dist = (coin.Position - hrp.Position).Magnitude
                    if dist < 10 then
                        if firetouchinterest then pcall(function() firetouchinterest(hrp, coin, 0); firetouchinterest(hrp, coin, 1) end) end
                        pcall(function() hrp.CFrame = CFrame.new(coin.Position + Vector3.new(0, 1.5, 0)) end)
                        task.wait(0.15)
                    else
                        local TweenService = game:GetService("TweenService")
                        local tw = TweenService:Create(hrp, TweenInfo.new(math.clamp(dist / 100, 0.22, 0.9), Enum.EasingStyle.Linear), { CFrame = CFrame.new(coin.Position + Vector3.new(0, 2.5, 0)) })
                        tw:Play(); tw.Completed:Wait()
                    end
                end
            end)
        end
        task.wait(autoCollect and autoCollectSpeed or 0.5)
    end
end)

GameplaySub:AddSection("Hitbox Expander")
local hitboxEnabled, hitboxSize = false, 4
local hitboxConn
local originalSizes = {}
local function applyHitbox(enable)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:IsA("BasePart") then
                if enable then
                    if not originalSizes[hrp] then originalSizes[hrp] = hrp.Size end
                    pcall(function()
                        hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        hrp.Transparency = 0.6; hrp.CanCollide = false; hrp.Massless = true
                    end)
                else
                    local orig = originalSizes[hrp]
                    if orig then pcall(function() hrp.Size = orig; hrp.Transparency = 1 end) end
                    originalSizes[hrp] = nil
                end
            end
        end
    end
end
local function startHitboxLoop()
    if hitboxConn then hitboxConn:Disconnect() end
    hitboxConn = RunService.Heartbeat:Connect(function()
        if HUB.dead or not hitboxEnabled then return end
        applyHitbox(true)
    end)
    table.insert(HUB.conns, hitboxConn)
end
local function stopHitboxLoop()
    if hitboxConn then hitboxConn:Disconnect(); hitboxConn = nil end
    for part, orig in pairs(originalSizes) do
        if part and part.Parent then pcall(function() part.Size = orig; part.Transparency = 1 end) end
    end
    table.clear(originalSizes)
end
GameplaySub:AddToggle({ Name = "Expand Hitbox", Default = false, Flag = "rage_hitbox",
    Callback = function(v) hitboxEnabled = v; if v then startHitboxLoop() else stopHitboxLoop() end end })
GameplaySub:AddSlider({ Name = "Hitbox Size", Min = 2, Max = 12, Default = 4, Flag = "rage_hitboxsize",
    Callback = function(v) hitboxSize = v; if hitboxEnabled then applyHitbox(true) end end })

-- ════════════════════════════════════════════════════════════════════════════
-- SYSTEM
-- ════════════════════════════════════════════════════════════════════════════
local SysSub = MM2Tab:AddSubTab("System")
SysSub:AddSection("Balance")
local moneyLabel = SysSub:AddParagraph({ Title = "Balance", Text = ("Coins: %s\nLevel: %d\nRole: %s"):format(FormatMoney(GetCoins()), GetLevel(), GetRole()) })
task.spawn(function()
    while not HUB.dead do
        pcall(function() moneyLabel:Set(("Coins: %s\nLevel: %d\nRole: %s"):format(FormatMoney(GetCoins()), GetLevel(), GetRole())) end)
        task.wait(2)
    end
end)
SysSub:AddSection("Server")
SysSub:AddButton({ Name = "Rejoin Server", Primary = true, Callback = function()
    Notify("Server", "Rejoining...", "Info")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end })
SysSub:AddButton({ Name = "Server Hop", Callback = function()
    Notify("Server", "Finding a new server...", "Info")
    task.spawn(function()
        local ok, err = pcall(function()
            local HttpService = game:GetService("HttpService")
            local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)
            local raw
            local ok2, res = pcall(function() return game:HttpGet(url) end)
            if ok2 and type(res) == "string" and #res > 10 then raw = res
            elseif typeof(request) == "function" then
                local r = request({Url = url, Method = "GET"})
                if r and r.Body and r.StatusCode == 200 then raw = r.Body else error("request failed") end
            else error("no http method") end
            local data = HttpService:JSONDecode(raw)
            for _, s in ipairs(data.data or {}) do
                if type(s.playing) == "number" and s.playing < s.maxPlayers and s.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer); return
                end
            end
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
        if not ok then Notify("Server", "Hop failed: " .. tostring(err), "Error", 4) end
    end)
end })

-- ════════════════════════════════════════════════════════════════════════════
-- TAB: OTHERS
-- ════════════════════════════════════════════════════════════════════════════
local OthersTab = Window:AddTab({ Name = "Others", Subtitle = "Extra functions", Icon = "grid" })

-- ── Others → Aim ──
local OthersAim = OthersTab:AddSubTab("Aim")

local aimCfg = {
    enabled    = false,
    fov        = 120,
    targetPart = "Head",
    key        = Enum.UserInputType.MouseButton2,
    teamCheck  = false,
}
local aimFovCircle = nil

if hasDrawing then
    local ok, c = pcall(function() return Drawing.new("Circle") end)
    if ok and c then
        c.Thickness = 1.5
        c.NumSides = 64
        c.Radius = aimCfg.fov
        c.Filled = false
        c.Visible = false
        c.Color = Color3.fromRGB(255, 255, 255)
        c.Transparency = 0.6
        aimFovCircle = trackDrawing(c)
    end
end

OthersAim:AddSection("Aim Assist")
OthersAim:AddToggle({
    Name = "Aim Assist", Default = false, Flag = "others_aim_enabled",
    Description = "Наводит камеру на ближайшего игрока при зажатой клавише",
    Callback = function(v) aimCfg.enabled = v end,
})
OthersAim:AddSlider({
    Name = "FOV Radius", Min = 30, Max = 500, Default = 120, Suffix = "px", Flag = "others_aim_fov",
    Callback = function(v) aimCfg.fov = v; if aimFovCircle then aimFovCircle.Radius = v end end,
})
OthersAim:AddDropdown({
    Name = "Target Part", Options = { "Head", "HumanoidRootPart", "UpperTorso" },
    Default = "Head", Flag = "others_aim_part",
    Callback = function(v) aimCfg.targetPart = v end,
})
OthersAim:AddDropdown({
    Name = "Aim Key", Options = { "Right Mouse", "Left Mouse", "E", "Q", "Shift" },
    Default = "Right Mouse", Flag = "others_aim_key",
    Callback = function(v)
        if v == "Right Mouse" then aimCfg.key = Enum.UserInputType.MouseButton2
        elseif v == "Left Mouse" then aimCfg.key = Enum.UserInputType.MouseButton1
        elseif v == "E" then aimCfg.key = Enum.KeyCode.E
        elseif v == "Q" then aimCfg.key = Enum.KeyCode.Q
        elseif v == "Shift" then aimCfg.key = Enum.KeyCode.LeftShift
        end
    end,
})
OthersAim:AddToggle({
    Name = "Team Check", Default = false, Flag = "others_aim_teamcheck",
    Description = "Игнорировать игроков из своей команды",
    Callback = function(v) aimCfg.teamCheck = v end,
})

local function isAimKeyDown(key)
    if typeof(key) == "EnumItem" then
        if key.EnumType == Enum.UserInputType then
            return UserInputService:IsMouseButtonPressed(key)
        elseif key.EnumType == Enum.KeyCode then
            return UserInputService:IsKeyDown(key)
        end
    end
    return false
end

track(RunService.RenderStepped:Connect(function()
    if HUB.dead then return end
    if aimFovCircle then
        aimFovCircle.Visible = aimCfg.enabled
        aimFovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
    if not aimCfg.enabled then return end
    if not isAimKeyDown(aimCfg.key) then return end

    local closest, bestDist = nil, aimCfg.fov
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if aimCfg.teamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
                -- skip
            else
                local part = plr.Character:FindFirstChild(aimCfg.targetPart)
                    or plr.Character:FindFirstChild("Head")
                    or plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if part and hum and hum.Health > 0 then
                    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen and pos.Z > 0 then
                        local screenPos = Vector2.new(pos.X, pos.Y)
                        local mousePos = UserInputService:GetMouseLocation()
                        local d = (screenPos - mousePos).Magnitude
                        if d < bestDist then
                            bestDist = d
                            closest = part
                        end
                    end
                end
            end
        end
    end

    if closest then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
    end
end))

-- ── Others → ESP ──
local OthersESP = OthersTab:AddSubTab("ESP")

local simpleEspCfg = {
    enabled  = false,
    color    = Color3.fromRGB(255, 255, 255),
    textSize = 14,
}
local simpleEspList = {}

local function makeSimpleEspText()
    if not hasDrawing then return nil end
    local ok, d = pcall(function() return Drawing.new("Text") end)
    if not ok or not d then return nil end
    d.Size = simpleEspCfg.textSize
    d.Center = true
    d.Outline = true
    d.Font = 2
    d.Color = simpleEspCfg.color
    d.Visible = false
    return trackDrawing(d)
end

local function addSimpleEsp(p)
    if p == LocalPlayer or simpleEspList[p] then return end
    simpleEspList[p] = makeSimpleEspText()
end
local function removeSimpleEsp(p)
    if simpleEspList[p] then
        pcall(function() simpleEspList[p]:Remove() end)
        simpleEspList[p] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do addSimpleEsp(p) end
track(Players.PlayerAdded:Connect(addSimpleEsp))
track(Players.PlayerRemoving:Connect(removeSimpleEsp))

track(RunService.RenderStepped:Connect(function()
    if HUB.dead then return end
    for p, d in pairs(simpleEspList) do
        if d then
            local char = p.Character
            local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if simpleEspCfg.enabled and head and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.2, 0))
                if onScreen and pos.Z > 0 then
                    d.Text = p.Name
                    d.Position = Vector2.new(pos.X, pos.Y)
                    d.Visible = true
                else
                    d.Visible = false
                end
            else
                d.Visible = false
            end
        end
    end
end))

OthersESP:AddSection("Simple ESP")
OthersESP:AddToggle({
    Name = "Simple ESP", Default = false, Flag = "others_esp_enabled",
    Description = "Простой ESP — ник над головой",
    Callback = function(v) simpleEspCfg.enabled = v end,
})
OthersESP:AddColorPicker({
    Name = "ESP Color", Default = Color3.fromRGB(255, 255, 255), Flag = "others_esp_color",
    Callback = function(c)
        simpleEspCfg.color = c
        for _, d in pairs(simpleEspList) do
            if d then pcall(function() d.Color = c end) end
        end
    end,
})
OthersESP:AddSlider({
    Name = "Text Size", Min = 10, Max = 24, Default = 14, Flag = "others_esp_textsize",
    Callback = function(v)
        simpleEspCfg.textSize = v
        for _, d in pairs(simpleEspList) do
            if d then pcall(function() d.Size = v end) end
        end
    end,
})

-- ════════════════════════════════════════════════════════════════════════════
-- TAB: SETTINGS
-- ════════════════════════════════════════════════════════════════════════════
local SettingsTab = Window:AddTab({ Name = "Settings", Subtitle = "Themes & server", Icon = "settings" })
local SettingsSub = SettingsTab:AddSubTab("Themes")

SettingsSub:AddSection("Theme")
SettingsSub:AddDropdown({
    Name = "Theme", Options = { "Dark", "Light", "OLED" }, Default = "Dark", Flag = "ui_theme",
    Callback = function(v) pcall(function() Library:SetTheme(v) end) end,
})

SettingsSub:AddSection("Hub Keybind")
SettingsSub:AddKeybind({
    Name = "Toggle Hub Key", Default = Enum.KeyCode.RightShift, Flag = "hub_toggle_key",
    Description = "Press to show/hide the hub",
    OnPress = function() Window:ToggleUI() end,
})

SettingsSub:AddSection("Server")
SettingsSub:AddButton({
    Name = "Rejoin to Server", Primary = true,
    Callback = function()
        Notify("Server", "Rejoining...", "Info")
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end,
})

-- ════════════════════════════════════════════════════════════════════════════
-- BOOT
-- ════════════════════════════════════════════════════════════════════════════
Notify("N3 mogg hub", "Loaded — Coins: " .. tostring(GetCoins()) .. " | Role: " .. GetRole(), "Success", 3)
