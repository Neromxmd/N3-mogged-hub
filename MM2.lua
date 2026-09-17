-- N3 mogg hub — MM2 script
-- Tabs: MM2, Others, Settings, Secret

local Library = _G.N3MoggLibrary
if not Library then error("[N3 mogg hub] Library not loaded", 0) end

local Players            = game:GetService("Players")
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

local SECRET_KEY = "mogged"
local secretUnlocked = false

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

local function GetHumanoid()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function Notify(title, content, kind, dur)
    Window:Notify({ Title = title, Content = content, Type = kind or "Info", Duration = dur or 2.5 })
end
local function GetCoins()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    local c = ls and (ls:FindFirstChild("Coins") or ls:FindFirstChild("Coin"))
    if c and typeof(c.Value) == "number" then return c.Value end
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
    return "Innocent"
end

-- ═══════════ TAB: MM2 (пустая заготовка, сюда вернём функции позже) ═══════════
local MM2Tab = Window:AddTab({ Name = "MM2", Subtitle = "Murder Mystery 2", Icon = "combat" })
local PlayerSub = MM2Tab:AddSubTab("Player")
PlayerSub:AddSection("Speed")
local wsEnabled, wsValue = false, 16
PlayerSub:AddToggle({ Name = "WalkSpeed", Default = false, Flag = "ws_enabled",
    Callback = function(v) wsEnabled = v; local h = GetHumanoid(); if h then h.WalkSpeed = v and wsValue or 16 end end })
PlayerSub:AddSlider({ Name = "WalkSpeed Value", Min = 16, Max = 500, Default = 16, Flag = "ws_value",
    Callback = function(v) wsValue = v; if wsEnabled then local h = GetHumanoid(); if h then h.WalkSpeed = v end end end })
track(RunService.RenderStepped:Connect(function()
    if HUB.dead or not wsEnabled then return end
    local h = GetHumanoid()
    if h and h.WalkSpeed ~= wsValue then h.WalkSpeed = wsValue end
end))

-- ═══════════ TAB: OTHERS ═══════════
local OthersTab = Window:AddTab({ Name = "Others", Subtitle = "More games soon", Icon = "grid" })
local OthersSub = OthersTab:AddSubTab("Coming Soon")
OthersSub:AddParagraph({ Title = "soon...", Text = "More games later." })

-- ═══════════ TAB: SECRET ═══════════
local SecretTab = Window:AddTab({ Name = "Secret", Subtitle = "Locked area", Icon = "lock" })
local UnlockSub = SecretTab:AddSubTab("Unlock")

UnlockSub:AddSection("Secret Key")
local keyInput = UnlockSub:AddInput({
    Name = "Enter Key",
    Placeholder = "type key here...",
    Default = "",
    Flag = "secret_key_input",
    Callback = function() end,
})

UnlockSub:AddButton({
    Name = "Unlock", Primary = true,
    Callback = function()
        if secretUnlocked then
            Notify("Secret", "Already unlocked!", "Info")
            return
        end
        local entered = ""
        pcall(function() entered = tostring(keyInput:Get() or "") end)
        entered = entered:lower():gsub("%s", "")
        if entered == SECRET_KEY then
            secretUnlocked = true
            Notify("Secret", "Access granted!", "Success", 4)
            task.spawn(function()
                task.wait(0.3)
                buildSecretFeatures()
            end)
        else
            Notify("Secret", "Invalid key.", "Error", 3)
        end
    end,
})

UnlockSub:AddParagraph({ Title = "Hint", Text = "Enter the secret key to unlock hidden features." })

local SecretFeatures = SecretTab:AddSubTab("Features")
SecretFeatures:AddParagraph({ Title = "🔒 Locked", Text = "Enter the correct key in the Unlock tab." })

-- ── Скрытые функции ──
local secretBuilt = false
local secretEsp = { enabled = false, textList = {} }
local aimbot = { enabled = false, radius = 120, targetPart = "Head" }

local hasDrawing = (typeof(Drawing) == "table") or (Drawing ~= nil and pcall(function() return Drawing.new end))

local function newSecretText()
    if not hasDrawing then return nil end
    local ok, d = pcall(function() return Drawing.new("Text") end)
    if not ok or not d then return nil end
    d.Size = 14; d.Center = true; d.Outline = true
    d.Color = Color3.fromRGB(255, 50, 50); d.Font = 2; d.Visible = false
    table.insert(HUB.drawings, d)
    return d
end

function buildSecretFeatures()
    if secretBuilt then return end
    secretBuilt = true

    -- ESP
    SecretFeatures:AddSection("Secret ESP")
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then secretEsp.textList[p] = newSecretText() end
    end
    track(Players.PlayerAdded:Connect(function(p)
        if p ~= LocalPlayer then secretEsp.textList[p] = newSecretText() end
    end))
    track(RunService.RenderStepped:Connect(function()
        if HUB.dead then return end
        for p, t in pairs(secretEsp.textList) do
            if t then
                local char = p.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if secretEsp.enabled and hrp and hum and hum.Health > 0 then
                    local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                    if vis then
                        t.Position = Vector2.new(pos.X, pos.Y - 20)
                        t.Text = p.Name
                        t.Visible = true
                    else t.Visible = false end
                else t.Visible = false end
            end
        end
    end))
    SecretFeatures:AddToggle({
        Name = "Secret ESP", Default = false, Flag = "secret_esp",
        Description = "Simple red name ESP",
        Callback = function(v) secretEsp.enabled = v end,
    })

    -- Aimbot
    SecretFeatures:AddSection("Secret Aimbot")
    track(RunService.RenderStepped:Connect(function()
        if HUB.dead or not aimbot.enabled then return end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
        local closest, dist = nil, aimbot.radius
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local part = player.Character:FindFirstChild(aimbot.targetPart)
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
    end))
    SecretFeatures:AddToggle({
        Name = "Secret Aimbot", Default = false, Flag = "secret_aimbot",
        Description = "Hold right mouse to aim",
        Callback = function(v) aimbot.enabled = v end,
    })
    SecretFeatures:AddSlider({
        Name = "Aimbot Radius", Min = 30, Max = 500, Default = 120, Suffix = "px", Flag = "secret_aim_radius",
        Callback = function(v) aimbot.radius = v end,
    })
    SecretFeatures:AddDropdown({
        Name = "Target Part", Options = { "Head", "HumanoidRootPart", "UpperTorso" },
        Default = "Head", Flag = "secret_aim_part",
        Callback = function(v) aimbot.targetPart = v end,
    })

    Notify("Secret", "Unlocked: ESP & Aimbot!", "Success", 4)
end

-- ═══════════ TAB: SETTINGS ═══════════
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
    Description = "Show/hide hub",
    OnPress = function() Window:ToggleUI() end,
})
SettingsSub:AddSection("Server")
SettingsSub:AddButton({
    Name = "Rejoin to Server", Primary = true,
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end,
})

Notify("N3 mogg hub", "Loaded — Coins: " .. GetCoins() .. " | Role: " .. GetRole(), "Success", 3)
