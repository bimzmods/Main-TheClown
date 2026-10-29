local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Games = {
    [7633926880] = "https://raw.githubusercontent.com/bimzmods/Main-TheClown/refs/heads/main/Games/Bloxstrike_BZ.lua",
    [10624691669] = "https://raw.githubusercontent.com/bimzmods/Main-TheClown/refs/heads/main/Games/Monochrome_obf.lua",
    [2440500124] = "https://raw.githubusercontent.com/bimzmods/Main-TheClown/refs/heads/main/Games/Doors_BZ.lua",
}
local HWIDs = {}
local DELAY = 3

local FOLDER    = "BZ Menu"
local CACHE     = FOLDER .. "/cache"
local LOGO_URL  = "https://raw.githubusercontent.com/bimzmods/Ui-BZ/main/Asset/Logo.png"
local LOGO_PATH = CACHE .. "/Logo.png"

local GREEN  = Color3.fromRGB(52, 211, 120)
local RED    = Color3.fromRGB(255, 90, 100)
local ACCENT = Color3.fromRGB(150, 85, 255)
local ACCENT2 = Color3.fromRGB(222, 110, 255)

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

local function getHWID()
    local hwid
    pcall(function()
        hwid = (gethwid and gethwid())
            or game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if hwid then getgenv().BZ_HWID = hwid end
    return hwid
end

local function tw(obj, t, props, style, dir)
    local tween = TweenService:Create(obj, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local gui = Instance.new("ScreenGui")
gui.Name = "ClownLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
local okParent = pcall(function() gui.Parent = gethui() end)
if not okParent or not gui.Parent then
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

local dim = Instance.new("Frame")
dim.Size = UDim2.fromScale(1, 1)
dim.BackgroundColor3 = Color3.new(0, 0, 0)
dim.BackgroundTransparency = 1
dim.BorderSizePixel = 0
dim.Parent = gui

local main = Instance.new("CanvasGroup")
main.Size = UDim2.fromOffset(480, 250)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(17, 17, 21)
main.BorderSizePixel = 0
main.GroupTransparency = 1
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 22)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(52, 52, 64)
mainStroke.Thickness = 1
mainStroke.Parent = main

local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new(Color3.fromRGB(24, 22, 32), Color3.fromRGB(14, 14, 18))
bgGrad.Rotation = 90
bgGrad.Parent = main

local mainScale = Instance.new("UIScale")
mainScale.Scale = 0.88
mainScale.Parent = main

local glow = Instance.new("Frame")
glow.Size = UDim2.fromOffset(120, 120)
glow.AnchorPoint = Vector2.new(0.5, 0.5)
glow.Position = UDim2.new(0, 78, 0.5, -14)
glow.BackgroundColor3 = ACCENT
glow.BackgroundTransparency = 0.86
glow.BorderSizePixel = 0
glow.Parent = main
Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.fromOffset(96, 96)
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.Position = UDim2.new(0, 78, 0.5, -14)
logo.BackgroundTransparency = 1
logo.Image = getLogo()
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -164, 1, 0)
content.Position = UDim2.fromOffset(140, 0)
content.BackgroundTransparency = 1
content.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 28)
title.Position = UDim2.fromOffset(0, 22)
title.BackgroundTransparency = 1
title.Text = "The Clown Studio"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 21
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = content

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, -60, 0, 16)
sub.Position = UDim2.fromOffset(0, 50)
sub.BackgroundTransparency = 1
sub.Text = "Secure Loader  •  v1.0"
sub.TextColor3 = Color3.fromRGB(130, 130, 150)
sub.Font = Enum.Font.Gotham
sub.TextSize = 12
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Parent = content

local percent = Instance.new("TextLabel")
percent.Size = UDim2.fromOffset(56, 28)
percent.AnchorPoint = Vector2.new(1, 0)
percent.Position = UDim2.new(1, -22, 0, 22)
percent.BackgroundTransparency = 1
percent.Text = "0%"
percent.TextColor3 = ACCENT2
percent.Font = Enum.Font.GothamBold
percent.TextSize = 16
percent.TextXAlignment = Enum.TextXAlignment.Right
percent.Parent = main

local track = Instance.new("Frame")
track.Size = UDim2.new(1, -48, 0, 5)
track.Position = UDim2.new(0, 24, 1, -28)
track.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
track.BorderSizePixel = 0
track.Parent = main
Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

local fill = Instance.new("Frame")
fill.Size = UDim2.fromScale(0, 1)
fill.BackgroundColor3 = Color3.new(1, 1, 1)
fill.BorderSizePixel = 0
fill.Parent = track
Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

local fillGrad = Instance.new("UIGradient")
fillGrad.Color = ColorSequence.new(ACCENT, ACCENT2)
fillGrad.Parent = fill

local function setProgress(p)
    tw(fill, 0.5, {Size = UDim2.fromScale(p, 1)})
    percent.Text = math.floor(p * 100) .. "%"
end

local floatConn = RunService.RenderStepped:Connect(function()
    local t = tick()
    local y = -14 + math.sin(t * 2) * 3
    logo.Position = UDim2.new(0, 78, 0.5, y)
    glow.Position = UDim2.new(0, 78, 0.5, y)
    glow.BackgroundTransparency = 0.86 + math.sin(t * 2.4) * 0.05
end)

local function popIn()
    tw(blur, 0.5, {Size = 14})
    tw(dim, 0.5, {BackgroundTransparency = 0.55})
    tw(mainScale, 0.55, {Scale = 1}, Enum.EasingStyle.Back)
    tw(main, 0.4, {GroupTransparency = 0}).Completed:Wait()
end

local function popOut()
    tw(blur, 0.4, {Size = 0})
    tw(dim, 0.4, {BackgroundTransparency = 1})
    tw(mainScale, 0.4, {Scale = 0.88}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    tw(main, 0.35, {GroupTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.In).Completed:Wait()
    floatConn:Disconnect()
    blur:Destroy()
    gui:Destroy()
end

local function makeStep(text, y)
    local row = Instance.new("CanvasGroup")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.Position = UDim2.fromOffset(28, y)
    row.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    row.BorderSizePixel = 0
    row.GroupTransparency = 1
    row.Parent = content
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)

    local icon = Instance.new("Frame")
    icon.Size = UDim2.fromOffset(18, 18)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.Position = UDim2.new(0, 12, 0.5, 0)
    icon.BackgroundTransparency = 1
    icon.Parent = row
    Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2.5
    stroke.Color = ACCENT2
    stroke.Parent = icon

    local grad = Instance.new("UIGradient")
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.7, 1),
        NumberSequenceKeypoint.new(1, 1),
    })
    grad.Parent = stroke

    local mark = Instance.new("TextLabel")
    mark.Size = UDim2.fromScale(1, 1)
    mark.BackgroundTransparency = 1
    mark.Font = Enum.Font.GothamBold
    mark.TextSize = 14
    mark.Text = ""
    mark.Parent = icon
    local markScale = Instance.new("UIScale")
    markScale.Scale = 0
    markScale.Parent = mark

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -46, 1, 0)
    label.Position = UDim2.fromOffset(40, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(205, 205, 218)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local conn = RunService.RenderStepped:Connect(function(dt)
        grad.Rotation = (grad.Rotation + 420 * dt) % 360
    end)

    tw(row, 0.45, {GroupTransparency = 0, Position = UDim2.fromOffset(0, y)})

    local step = {}
    local function finish(color, symbol)
        conn:Disconnect()
        grad:Destroy()
        tw(stroke, 0.3, {Color = color})
        mark.Text = symbol
        mark.TextColor3 = color
        tw(markScale, 0.4, {Scale = 1}, Enum.EasingStyle.Back)
    end
    function step.done()
        finish(GREEN, "✓")
    end
    function step.fail(msg)
        finish(RED, "✗")
        label.Text = msg
        tw(label, 0.3, {TextColor3 = RED})
    end
    return step
end

task.spawn(function()
    popIn()

    local s1 = makeStep("Checking ID Game...", 88)
    task.wait(DELAY)
    local link = Games[game.GameId]
    if not link then
        s1.fail("Game belum didukung")
        task.wait(2)
        popOut()
        return
    end
    s1.done()
    setProgress(0.33)
    task.wait(0.4)

    local s2 = makeStep("Checking HWID...", 128)
    task.wait(DELAY)
    local hwid = getHWID()
    s2.done()
    setProgress(0.66)
    task.wait(0.4)

    local s3 = makeStep("Loading Script...", 168)
    task.wait(DELAY)
    s3.done()
    setProgress(1)
    task.wait(0.8)
    popOut()

    local ok, err = pcall(function()
        loadstring(game:HttpGet(link))()
    end)
    if not ok then
        warn("Gagal load script: " .. tostring(err))
    end
end)
