-- KeySystem.lua
-- N3TrueAdam Key System | HWID + Expiry + Discord logs

local KeySystem = {}

-- ============ НАСТРОЙКИ ============
local KEYS_URL = "https://raw.githubusercontent.com/Neromxmd/N3-mogged-hub/main/keys.json"
local WEBHOOK_URL = "" -- ВСТАВЬ СЮДА DISCORD WEBHOOK (или оставь пустым)
local HWID_FILE = "N3_hwid.txt"
local KEY_FILE = "N3_key.txt"
-- ==================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- ---------- HWID ----------
local function getHWID()
    -- 1. Пытаемся получить настоящий HWID через executor
    local ok, hwid = pcall(function()
        if gethwid then return gethwid() end
        if syn and syn.get_hwid then return syn.get_hwid() end
        if KRNL_LOADED and getgenv then return getgenv().KRNL_HWID end
        if fluxus and fluxus.getHWID then return fluxus.getHWID() end
        return nil
    end)
    if ok and hwid and hwid ~= "" then
        return tostring(hwid)
    end

    -- 2. Fallback: генерируем псевдо-HWID и сохраняем локально
    local saved = nil
    pcall(function()
        if isfile and isfile(HWID_FILE) then
            saved = readfile(HWID_FILE)
        end
    end)
    if saved and saved ~= "" then return saved end

    local generated = tostring(localPlayer.UserId) .. "-" .. tostring(math.random(100000, 999999))
    pcall(function()
        if writefile then writefile(HWID_FILE, generated) end
    end)
    return generated
end

-- ---------- Загрузка базы ключей ----------
local function fetchKeys()
    local url = KEYS_URL .. "?t=" .. tick()
    local ok, response = pcall(function() return game:HttpGet(url) end)
    if not ok or not response or response == "" then return nil end
    local ok2, data = pcall(function() return HttpService:JSONDecode(response) end)
    if not ok2 then return nil end
    return data
end

-- ---------- Discord лог ----------
local function logToDiscord(key, status, reason)
    if not WEBHOOK_URL or WEBHOOK_URL == "" then return end
    local embed = {
        title = "N3TrueAdam | Key Log",
        color = (status == "SUCCESS") and 65280 or 16711680,
        fields = {
            { name = "Игрок",  value = localPlayer.Name .. " (`" .. localPlayer.UserId .. "`)", inline = true },
            { name = "Ключ",   value = (key ~= "" and key) or "—", inline = true },
            { name = "Статус", value = status, inline = true },
            { name = "Причина",value = reason or "—", inline = false },
            { name = "HWID",   value = getHWID(), inline = false },
        },
        timestamp = DateTime.now():ToIsoDate(),
    }
    local payload = { content = "", embeds = { embed } }
    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(payload))
    end)
end

-- ---------- Проверка ключа ----------
local function validateKey(inputKey)
    if inputKey == "" then return false, "Ключ не введён" end

    local keys = fetchKeys()
    if not keys then return false, "Не удалось загрузить базу ключей" end

    local entry = keys[inputKey]
    if not entry then return false, "Ключ не найден" end
    if entry.active == false then return false, "Ключ отключён" end

    -- Проверка срока
    if entry.expires and entry.expires ~= "" then
        local ok, expDate = pcall(function() return DateTime.fromIsoDate(entry.expires) end)
        if ok and expDate and DateTime.now().UnixTimestamp > expDate.UnixTimestamp then
            return false, "Срок действия ключа истёк"
        end
    end

    -- Проверка HWID
    local myHWID = getHWID()
    if entry.hwid and entry.hwid ~= "" then
        if tostring(entry.hwid) ~= tostring(myHWID) then
            return false, "Ключ привязан к другому устройству"
        end
    end

    return true, "OK"
end

-- ---------- Публичный метод ----------
function KeySystem.check(Rayfield)
    -- Автовход, если ключ сохранён
    local savedKey = nil
    pcall(function()
        if isfile and isfile(KEY_FILE) then savedKey = readfile(KEY_FILE) end
    end)

    if savedKey and savedKey ~= "" then
        local ok, reason = validateKey(savedKey)
        if ok then
            Rayfield:Notify({ Title = "N3TrueAdam", Content = "Ключ действителен. Загрузка..." })
            logToDiscord(savedKey, "SUCCESS", "авто-вход")
            task.wait(0.5)
            return true
        else
            pcall(function() if delfile then delfile(KEY_FILE) end end)
        end
    end

    -- Иначе — окно ввода
    local inputKey = ""
    local passed = false

    local keyWindow = Rayfield:CreateWindow({
        Name = "N3TrueAdam | Key System",
        LoadingTitle = "Проверка ключа...",
        LoadingSubtitle = "by N3TrueAdam",
        ConfigurationSaving = { Enabled = false },
        KeySystem = false
    })

    local tab = keyWindow:CreateTab("Ключ", 4483362458)

    tab:CreateInput({
        Name = "Введите ключ",
        PlaceholderText = "Вставьте ключ сюда...",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text) inputKey = Text end,
    })

    tab:CreateButton({
        Name = "Проверить",
        Callback = function()
            local ok, reason = validateKey(inputKey)
            if ok then
                passed = true
                logToDiscord(inputKey, "SUCCESS", "ручной ввод")
                pcall(function() if writefile then writefile(KEY_FILE, inputKey) end end)
                Rayfield:Notify({ Title = "Успех", Content = "Ключ верный!" })
                task.wait(0.7)
                keyWindow:Destroy()
            else
                logToDiscord(inputKey, "FAIL", reason)
                Rayfield:Notify({ Title = "Ошибка", Content = reason })
            end
        end,
    })

    while not passed do task.wait(0.1) end
    return true
end

return KeySystem
