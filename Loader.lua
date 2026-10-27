local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- ===== SETTING =====
local Games = {
    [7633926880] = "https://raw.githubusercontent.com/bimzmods/Main-TheClown/refs/heads/main/Games/Bloxstrike_BZ.lua",
    [9876543210] = "https://example.com/game2.lua",
}
local HWIDs = {}   
local DELAY = 3

local FOLDER    = "BZ Menu"
local CACHE     = FOLDER .. "/cache"
local LOGO_URL  = "https://raw.githubusercontent.com/bimzmods/Ui-BZ/main/Asset/Logo.png"
local LOGO_PATH = CACHE .. "/Logo.png"
-- ===================

local GREEN = Color3.fromRGB(46, 204, 113)
local RED   = Color3.fromRGB(255, 85, 85)

local function getLogo()
    local ok, result = pcall(function()
        if not isfolder(FOLDER) then makefolder(FOLDER) end
        if not isfolder(CACHE) then makefolder(CACHE) end
        if not isfile(LOGO_PATH) then
            writefile(LOGO_PATH, game:HttpGet(LOGO_URL))
        end
        return getcustomasset(LOGO_PATH)
    end)
    return ok and result or ""
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ClownLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
local okParent = pcall(function() gui.Parent = gethui() end)
if not okParent or not gui.Parent then
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(440, 200)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 24)

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.fromOffset(100, 100)
logo.AnchorPoint = Vector2.new(0, 0.5)
logo.Position = UDim2.new(0, 20, 0.5, 0)
logo.BackgroundTransparency = 1
logo.Image = getLogo()
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -146, 1, 0)
content.Position = UDim2.fromOffset(130, 0)
content.BackgroundTransparency = 1
content.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.fromOffset(0, 20)
title.BackgroundTransparency = 1
title.Text = "The Clown Studio"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = content

-- Step (spinner -> centang)
local function makeStep(text, y)
    local icon = Instance.new("Frame")
    icon.Size = UDim2.fromOffset(22, 22)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.Position = UDim2.new(0, 0, 0, y + 14)
    icon.BackgroundTransparency = 1
    icon.Parent = content
    Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 3
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Parent = icon

    local grad = Instance.new("UIGradient")
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.75, 1),
        NumberSequenceKeypoint.new(1, 1),
    })
    grad.Parent = stroke

    local mark = Instance.new("TextLabel")
    mark.Size = UDim2.fromScale(1, 1)
    mark.BackgroundTransparency = 1
    mark.Font = Enum.Font.GothamBold
    mark.TextSize = 16
    mark.Visible = false
    mark.Parent = icon

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -34, 0, 28)
    label.Position = UDim2.fromOffset(34, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 225)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = content

    local conn = RunService.RenderStepped:Connect(function(dt)
        grad.Rotation = (grad.Rotation + 360 * dt) % 360
    end)

    local step = {}
    local function finish(color, symbol)
        conn:Disconnect()
        grad:Destroy()
        stroke.Color = color
        mark.Text = symbol
        mark.TextColor3 = color
        mark.Visible = true
    end
    function step.done() finish(GREEN, "✓") end
    function step.fail(msg)
        finish(RED, "✗")
        label.Text = msg
        label.TextColor3 = RED
    end
    return step
end

-- Alur loading
task.spawn(function()
    local s1 = makeStep("Checking ID Game...", 70)
    task.wait(DELAY)
    local link = Games[game.PlaceId]
    if not link then
        s1.fail("Game belum didukung")
        task.wait(2)
        gui:Destroy()
        return
    end
    s1.done()

    local s2 = makeStep("Checking HWID...", 106)
    task.wait(DELAY)
    local hwid
    pcall(function()
        hwid = (gethwid and gethwid())
            or game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if #HWIDs > 0 and not table.find(HWIDs, hwid) then
        s2.fail("HWID tidak terdaftar")
        task.wait(2)
        gui:Destroy()
        return
    end
    s2.done()

    local s3 = makeStep("Loading Script...", 142)
    task.wait(DELAY)
    s3.done()
    task.wait(0.5)
    gui:Destroy()

    local ok, err = pcall(function()
        loadstring(game:HttpGet(link))()
    end)
    if not ok then
        warn("Gagal load script: " .. tostring(err))
    end
end)
