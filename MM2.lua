-- N3 mogg hub — MM2 script
-- Tabs: MM2, Others, Settings (with keybind)

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
    BrandSubtitle = "MM2",
    StatusText = "N3 mogg hub ready",
    LoadingAnimation = true,
    LoadingText = "N3 mogg hub",
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
local function GetRootCFrame()
    local hrp = GetHRP(); return hrp and hrp.CFrame
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
local function GetRole(plr)
    plr = plr or LocalPlayer
    local char = plr.Character
    if not char then return "Unknown" end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return "Dead" end
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("knife") then return "Murderer" end
            if n:find("gun") then return "Sheriff" end
        end
    end
    local bp = plr:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("knife") then return "Murderer?" end
            if t:IsA("Tool") and t.Name:lower():find("gun") then return "Sheriff?" end
        end
    end
    return "Innocent"
end
local function RoleColor(role)
    if role == "Murderer" then return Color3.fromRGB(220, 50, 50)
    elseif role == "Sheriff" then return Color3.fromRGB(50, 120, 255)
    elseif role:find("Sheriff") then return Color3.fromRGB(80, 140, 255)
    elseif role:find("Murderer") then return Color3.fromRGB(255, 80, 80)
    elseif role == "Dead" then return Color3.fromRGB(120, 120, 120)
    else return Color3.fromRGB(80, 220, 120) end
end
local function FormatMoney(v) return tostring(math.floor(tonumber(v) or 0)) end

-- ════════════════════════════════════════════════════════════════════════════
-- TAB: MM2
-- ════════════════════════════════════════════════════════════════════════════
local MM2Tab = Window:AddTab({ Name = "MM2", Subtitle = "Murder Mystery 2" })

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

-- ── TELEPORT ──
local TpSub = MM2Tab:AddSubTab("Teleport")
TpSub:AddSection("Players")
local selectedPlayer = nil
local playerDropdown

local function GetPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    table.sort(names)
    if #names == 0 then names = { "(no other players)" } end
    return names
end
local function ResolvePlayer(name)
    if not name then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name == name then return p end
    end
    return nil
end

playerDropdown = TpSub:AddDropdown({ Name = "Player", Options = GetPlayerNames(), Flag = "tp_player",
    Callback = function(v) selectedPlayer = v end })
TpSub:AddButton({ Name = "Refresh Players", Callback = function() playerDropdown:SetOptions(GetPlayerNames()) end })
TpSub:AddButton({ Name = "Teleport To Player", Primary = true, Callback = function()
    local target = ResolvePlayer(selectedPlayer)
    local myHRP = GetHRP()
    local tHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if myHRP and tHRP then
        myHRP.CFrame = tHRP.CFrame * CFrame.new(0, 0, 3)
        Notify("Teleport", "Teleported to " .. target.Name, "Success")
    else
        Notify("Teleport", "Target unavailable", "Error")
    end
end })

TpSub:AddSection("Waypoints")
local waypoints = {}
local pendingName = "Spot 1"
local selectedWaypoint = nil
local waypointDropdown

local function WaypointNames()
    local names = {}
    for name in pairs(waypoints) do table.insert(names, name) end
    table.sort(names)
    if #names == 0 then names = { "(none)" } end
    return names
end

TpSub:AddInput({ Name = "Waypoint Name", Placeholder = "Spot 1", Default = "Spot 1", Flag = "wp_name",
    Callback = function(text) pendingName = (text ~= "" and text) or "Spot 1" end })
TpSub:AddButton({ Name = "Save Current Position", Primary = true, Callback = function()
    local cf = GetRootCFrame()
    if not cf then Notify("Waypoints", "No character", "Error"); return end
    waypoints[pendingName] = cf
    if waypointDropdown then waypointDropdown:SetOptions(WaypointNames()) end
    Notify("Waypoints", "Saved '" .. pendingName .. "'", "Success")
end })
waypointDropdown = TpSub:AddDropdown({ Name = "Saved Waypoints", Options = WaypointNames(), Flag = "wp_selected",
    Callback = function(v) selectedWaypoint = v end })
TpSub:AddButton({ Name = "Teleport To Waypoint", Primary = true, Callback = function()
    local cf = waypoints[selectedWaypoint]
    local hrp = GetHRP()
    if cf and hrp then
        hrp.CFrame = cf
        Notify("Waypoints", "Teleported to '" .. tostring(selectedWaypoint) .. "'", "Success")
    else
        Notify("Waypoints", "Waypoint unavailable", "Error")
    end
end })

TpSub:AddSection("MM2 Spots")
local spots = {
    ["Lobby"] = CFrame.new(-109.56, 137.91, -11.67),
    ["Hotel"] = CFrame.new(76, 131, 28),
    ["Mansion"] = CFrame.new(-97, 131, 56),
    ["Bank"] = CFrame.new(-7, 131, -11),
    ["Factory"] = CFrame.new(-33, 131, -102),
    ["Hospital"] = CFrame.new(44, 131, -82),
    ["House 2"] = CFrame.new(19, 131, -42),
    ["Workplace"] = CFrame.new(-42, 131, 56),
}
local spotNames = {}
for n in pairs(spots) do table.insert(spotNames, n) end
table.sort(spotNames)
local selectedSpot = spotNames[1]
TpSub:AddDropdown({ Name = "Location", Options = spotNames, Default = selectedSpot, Flag = "tp_spot",
    Callback = function(v) selectedSpot = v end })
TpSub:AddButton({ Name = "Teleport To Location", Primary = true, Callback = function()
    local cf = spots[selectedSpot]
    local hrp = GetHRP()
    if cf and hrp then hrp.CFrame = cf; Notify("Teleport", "To " .. selectedSpot, "Success")
    else Notify("Teleport", "Unavailable", "Error") end
end })

-- ── VISUAL ──
local VisualSub = MM2Tab:AddSubTab("Visual")
local hasDrawing = (typeof(Drawing) == "table") or (Drawing ~= nil and pcall(function() return Drawing.new end))

local esp = {
    enabled = true, players = true, box = false, boxStyle = "Corner", boxThickness = 1,
    name = false, distance = false, health = false, chams = false, tracer = false,
    roleESP = true, coinESP = false, gunESP = false, maxDistance = 1000, textSize = 13,
    color = Color3.fromRGB(30, 90, 220), coinColor = Color3.fromRGB(255, 220, 60),
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
    box.highlight.FillTransparency = 0.6
    box.highlight.OutlineTransparency = 0.5
    box.highlight.Enabled = false
    box.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    pcall(function() box.highlight.Parent = getEspParent() end)
    table.insert(HUB.highlights, box.highlight)
    box.name = newDrawing("Text", { Color = Color3.fromRGB(255, 255, 255), Size = 13, Outline = true, Centre = true, Visible = false })
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
VisualSub:AddToggle({ Name = "Role ESP", Default = true, Flag = "esp_role", Callback = function(v) esp.roleESP = v end })
VisualSub:AddToggle({ Name = "Coin ESP", Default = false, Flag = "esp_coin", Callback = function(v) esp.coinESP = v end })
VisualSub:AddSection("Boxes")
VisualSub:AddToggle({ Name = "2D Box", Default = false, Flag = "esp_box", Callback = function(v) esp.box = v end })
VisualSub:AddDropdown({ Name = "Box Style", Options = { "Full", "Corner" }, Default = "Corner", Flag = "esp_boxstyle",
    Callback = function(v) esp.boxStyle = v end })
VisualSub:AddSlider({ Name = "Box Thickness", Min = 1, Max = 5, Default = 1, Flag = "esp_boxthick",
    Callback = function(v) esp.boxThickness = v end })
VisualSub:AddSection("Text")
VisualSub:AddToggle({ Name = "Name", Default = false, Flag = "esp_name", Callback = function(v) esp.name = v end })
VisualSub:AddToggle({ Name = "Distance", Default = false, Flag = "esp_distance", Callback = function(v) esp.distance = v end })
VisualSub:AddSlider({ Name = "Text Size", Min = 10, Max = 20, Default = 13, Flag = "esp_textsize",
    Callback = function(v) esp.textSize = v end })
VisualSub:AddSection("Extras")
VisualSub:AddToggle({ Name = "Chams (Highlight)", Default = false, Flag = "esp_chams", Callback = function(v) esp.chams = v end })
VisualSub:AddToggle({ Name = "Health Bar", Default = false, Flag = "esp_health", Callback = function(v) esp.health = v end })
VisualSub:AddToggle({ Name = "Tracers", Default = false, Flag = "esp_tracers", Callback = function(v) esp.tracer = v end })
VisualSub:AddSlider({ Name = "Max Distance", Min = 0, Max = 5000, Default = 1000, Suffix = "m", Flag = "esp_maxdist",
    Callback = function(v) esp.maxDistance = v end })

local function getBox2D(char)
    if not char then return nil end
    local ok, cf, size = pcall(function() return char:GetBoundingBox() end)
    if not ok or not cf or not size then return nil end
    if size.Magnitude < 1 then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        cf = hrp.CFrame; size = Vector3.new(3, 6, 2)
    end
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    local anyOn = false
    for x = -1, 1, 2 do for y = -1, 1, 2 do for z = -1, 1, 2 do
        local corner = (cf * CFrame.new(size.X / 2 * x, size.Y / 2 * y, size.Z / 2 * z)).Position
        local sp, on = Camera:WorldToViewportPoint(corner)
        if sp.Z > 0 then
            anyOn = anyOn or on
            minX = math.min(minX, sp.X); minY = math.min(minY, sp.Y)
            maxX = math.max(maxX, sp.X); maxY = math.max(maxY, sp.Y)
        end
    end end end
    if minX == math.huge or not anyOn then return nil end
    return minX, minY, maxX, maxY
end

track(RunService.RenderStepped:Connect(function()
    if HUB.dead then return end
    local hrp = GetHRP()
    local myPos = hrp and hrp.Position or Vector3.zero
    for p, obj in pairs(playerObjects) do
        local visible = esp.enabled and esp.players
        local char = p.Character
        local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
        local hrp2 = char and char:FindFirstChild("HumanoidRootPart")
        local hum2 = char and char:FindFirstChildOfClass("Humanoid")
        if visible and head and hrp2 then
            local dist = (hrp2.Position - myPos).Magnitude
            local color = (esp.roleESP and RoleColor(GetRole(p))) or esp.color
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
                if obj.highlight and obj.highlight.Adornee ~= char then pcall(function() obj.highlight.Adornee = char end) end
                local leftX, topY, rightX, bottomY = getBox2D(char)
                if leftX then
                    local w = rightX - leftX; local h = bottomY - topY
                    if h < 8 then local pad = (8 - h) / 2; topY = topY - pad; bottomY = bottomY + pad; h = 8 end
                    if w < 6 then local pad = (6 - w) / 2; leftX = leftX - pad; rightX = rightX + pad; w = 6 end
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
                    if esp.name and obj.name then
                        obj.name.Visible = true
                        obj.name.Text = p.DisplayName ~= p.Name and (p.DisplayName .. " (@" .. p.Name .. ")") or p.Name
                        obj.name.Color = color; obj.name.Size = esp.textSize
                        obj.name.Position = Vector2.new(cx, topY - 14)
                    else if obj.name then obj.name.Visible = false end end
                    if esp.distance and obj.dist then
                        obj.dist.Visible = true
                        obj.dist.Text = string.format("%.0fm", dist / 3)
                        obj.dist.Size = math.max(9, esp.textSize - 2)
                        obj.dist.Position = Vector2.new(cx, bottomY + 4)
                    else if obj.dist then obj.dist.Visible = false end end
                    if esp.tracer and obj.tracer then
                        obj.tracer.Visible = true; obj.tracer.Color = color
                        local vs = Camera.ViewportSize
                        obj.tracer.From = Vector2.new(vs.X / 2, vs.Y - 4)
                        obj.tracer.To = Vector2.new(cx, bottomY)
                    else if obj.tracer then obj.tracer.Visible = false end end
                    local humHealth = hum2 and hum2.Health or 100
                    local humMax = hum2 and hum2.MaxHealth or 100
                    local healthFrac = math.clamp(humHealth / math.max(humMax, 1), 0, 1)
                    if esp.health and hasDrawing and hum2 then
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
                    if obj.highlight then
                        if esp.chams then
                            obj.highlight.FillColor = color; obj.highlight.OutlineColor = color
                            obj.highlight.Enabled = true
                        else obj.highlight.Enabled = false end
                    end
                else
                    if obj.frame then obj.frame.Visible = false end
                    if obj.outline then obj.outline.Visible = false end
                    if obj.corners then for _, l in ipairs(obj.corners) do if l then l.Visible = false end end end
                    if obj.name then obj.name.Visible = false end
                    if obj.dist then obj.dist.Visible = false end
                    if obj.tracer then obj.tracer.Visible = false end
                    if obj.highlight then obj.highlight.Enabled = false end
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

-- ── GAMEPLAY ──
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

-- ── RAGE ──
local RageSub = MM2Tab:AddSubTab("Rage")
RageSub:AddSection("Murderer")
local murderKillAll = false
local murderKillDistance = 35
local murderKillDelay = 0.18

local function isMurderer()
    local char = GetCharacter(); if not char then return false end
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and t.Name:lower():find("knife") then return true end
    end
    return false
end
local function killPlayer(targetPlr)
    local char = targetPlr.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local myHRP = GetHRP(); local myChar = GetCharacter()
    if not hrp or not myHRP or not myChar then return end
    local knife = myChar:FindFirstChildOfClass("Tool")
    if not knife or not knife.Name:lower():find("knife") then
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then knife = bp:FindFirstChildOfClass("Tool") end
        if knife and knife.Name:lower():find("knife") then
            pcall(function() knife.Parent = myChar end); task.wait(0.15)
        else return end
    end
    local origSize = hrp.Size
    pcall(function() hrp.Size = Vector3.new(10, 10, 10); hrp.CanCollide = false; hrp.Transparency = 0.5 end)
    pcall(function()
        local handle = knife:FindFirstChild("Handle") or knife:FindFirstChild("Blade") or knife:FindFirstChildWhichIsA("BasePart")
        if handle then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and firetouchinterest then
                    firetouchinterest(handle, part, 0)
                    firetouchinterest(handle, part, 1)
                end
            end
            pcall(function() knife:Activate() end)
        end
    end)
    task.wait(0.05)
    pcall(function() hrp.Size = origSize; hrp.Transparency = 1 end)
end

RageSub:AddToggle({ Name = "Kill Aura (nearby)", Default = false, Flag = "mm2_killaura", Callback = function(v) murderKillAll = v end })
RageSub:AddSlider({ Name = "Aura Distance", Min = 5, Max = 80, Default = 35, Suffix = " studs", Flag = "mm2_killdist", Callback = function(v) murderKillDistance = v end })
RageSub:AddSlider({ Name = "Kill Delay", Min = 0.05, Max = 1, Default = 0.18, Suffix = "s", Flag = "mm2_killdelay", Callback = function(v) murderKillDelay = v end })
RageSub:AddButton({ Name = "Kill All (Murderer)", Primary = true, Callback = function()
    if not isMurderer() then Notify("Rage", "You are not Murderer!", "Error"); return end
    task.spawn(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if HUB.dead then break end
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character.Humanoid.Health > 0 then
                killPlayer(plr); task.wait(murderKillDelay)
            end
        end
        Notify("Rage", "Kill All done", "Success")
    end)
end })

task.spawn(function()
    while not HUB.dead do
        if murderKillAll and isMurderer() then
            local myPos = GetHRP() and GetHRP().Position or Vector3.zero
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 and (hrp.Position - myPos).Magnitude <= murderKillDistance then
                        killPlayer(plr); task.wait(murderKillDelay)
                    end
                end
            end
        end
        task.wait(0.12)
    end
end)

RageSub:AddSection("Sheriff")
RageSub:AddButton({ Name = "Grab Gun if Dropped", Callback = function()
    local gunDrop = nil
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v.Name:lower():find("gun") and v:IsA("Tool") then gunDrop = v; break end
    end
    if gunDrop then
        local hrp = GetHRP()
        if hrp then
            local pos = gunDrop:FindFirstChild("Handle") and gunDrop.Handle.Position or hrp.Position
            hrp.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
            Notify("Rage", "Teleported to gun", "Success")
        end
    else
        Notify("Rage", "No dropped gun found", "Error")
    end
end })

local sheriff = { silentEnabled = false, fov = 150, hitPart = "Head" }
local fovCircle = hasDrawing and newDrawing("Circle", { Thickness = 1.5, NumSides = 64, Radius = 150, Filled = false, Visible = false, Color = Color3.fromRGB(255, 255, 255) }) or nil

track(RunService.RenderStepped:Connect(function()
    if fovCircle then
        local on = sheriff.silentEnabled
        fovCircle.Visible = on
        if on then
            pcall(function()
                fovCircle.Radius = sheriff.fov
                fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            end)
        end
    end
    if sheriff.silentEnabled then
        local closest, dist = nil, 200
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local part = player.Character:FindFirstChild(sheriff.hitPart) or player.Character:FindFirstChild("Head")
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if part and hum and hum.Health > 0 then
                    local pos, visible = Camera:WorldToViewportPoint(part.Position)
                    if visible then
                        local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if mag < dist then dist = mag; closest = part end
                    end
                end
            end
        end
        if closest then Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position) end
    end
end))

RageSub:AddToggle({ Name = "Silent Aim", Default = false, Flag = "sheriff_silent", Callback = function(v) sheriff.silentEnabled = v end })
RageSub:AddSlider({ Name = "FOV Radius", Min = 10, Max = 600, Default = 150, Suffix = "px", Flag = "sheriff_fov", Callback = function(v) sheriff.fov = v end })
RageSub:AddDropdown({ Name = "Hit Part", Options = { "Head", "HumanoidRootPart", "UpperTorso" }, Default = "Head", Flag = "sheriff_hitpart", Callback = function(v) sheriff.hitPart = v end })

-- ── SYSTEM ──
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
local OthersTab = Window:AddTab({ Name = "Others", Subtitle = "More games" })
local OthersSub = OthersTab:AddSubTab("Coming Soon")
Library:AddSubTabPlaceholder(OthersSub, "soon...")

-- ════════════════════════════════════════════════════════════════════════════
-- TAB: SETTINGS (Themes + Keybind + Rejoin)
-- ════════════════════════════════════════════════════════════════════════════
local SettingsTab = Window:AddTab({ Name = "Settings", Subtitle = "Themes & server" })
local SettingsSub = SettingsTab:AddSubTab("Themes")

SettingsSub:AddSection("Theme")
SettingsSub:AddDropdown({ Name = "Theme", Options = { "Dark", "Light", "OLED" }, Default = "Dark", Flag = "ui_theme",
    Callback = function(v) pcall(function() Library:SetTheme(v) end) end })

SettingsSub:AddSection("Accent Color")
SettingsSub:AddColorPicker({ Name = "Accent", Default = Color3.fromRGB(168, 120, 245), Flag = "ui_accent",
    Callback = function(c) pcall(function() Library:SetAccent(c) end) end })

SettingsSub:AddSection("Hub Keybind")
SettingsSub:AddKeybind({
    Name = "Toggle Hub Key", Default = Enum.KeyCode.RightShift, Flag = "hub_toggle_key",
    Description = "Press to show/hide the hub",
    OnPress = function()
        if Window._minimized then
            Window:SetMinimized(false)
        else
            Window:SetMinimized(true)
        end
    end,
})

SettingsSub:AddSection("Server")
SettingsSub:AddButton({ Name = "Rejoin to Server", Primary = true, Callback = function()
    Notify("Server", "Rejoining...", "Info")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end })

-- ════════════════════════════════════════════════════════════════════════════
-- BOOT
-- ════════════════════════════════════════════════════════════════════════════
Notify("N3 mogg hub", "Loaded — Coins: " .. tostring(GetCoins()) .. " | Role: " .. GetRole(), "Success", 3)
