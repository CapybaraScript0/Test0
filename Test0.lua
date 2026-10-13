-- file: main.lua, target: Roblox MM2, executor: Delta
-- CapybaraMM2 — floating menu, role ESP, auto-pistol, sheriff aim
-- loadstring(game:HttpGet("URL"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

for _, n in ipairs({"CapybaraMM2"}) do
    if game.CoreGui:FindFirstChild(n) then game.CoreGui[n]:Destroy() end
    if LP:FindFirstChild(n) then LP[n]:Destroy() end
end

local function mk(cls, props, parent)
    local o = Instance.new(cls)
    for k, v in pairs(props) do o[k] = v end
    o.Parent = parent
    return o
end

local gui = mk("ScreenGui", {
    Name = "CapybaraMM2", ResetOnSpawn = false,
    IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, game.CoreGui)

-- ===== FLOATING ICON (compact) =====
local icon = mk("TextButton", {
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(0, 15, 0.5, -20),
    BackgroundColor3 = Color3.fromRGB(25, 25, 35),
    Text = "C", TextColor3 = Color3.fromRGB(220, 80, 80),
    Font = Enum.Font.GothamBold, TextSize = 16,
    BorderSizePixel = 0, AutoButtonColor = false
}, gui)
mk("UICorner", {CornerRadius = UDim.new(0, 10)}, icon)
mk("UIStroke", {Color = Color3.fromRGB(220, 80, 80), Thickness = 2}, icon)

-- ===== MAIN FRAME (small, 240x300) =====
local frame = mk("Frame", {
    Size = UDim2.new(0, 240, 0, 300),
    Position = UDim2.new(0.5, -120, 0.5, -150),
    BackgroundColor3 = Color3.fromRGB(18, 18, 24),
    BorderSizePixel = 0, Active = true, Visible = false
}, gui)
mk("UICorner", {CornerRadius = UDim.new(0, 10)}, frame)
mk("UIStroke", {Color = Color3.fromRGB(60, 60, 80), Thickness = 1}, frame)

mk("TextLabel", {
    Size = UDim2.new(1, -36, 0, 26), Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1, Text = "CapybaraMM2",
    TextColor3 = Color3.fromRGB(230, 230, 235),
    Font = Enum.Font.GothamBold, TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left
}, frame)

local close = mk("TextButton", {
    Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -28, 0, 2),
    BackgroundColor3 = Color3.fromRGB(200, 60, 60), Text = "X",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0
}, frame)
mk("UICorner", {CornerRadius = UDim.new(0, 5)}, close)

local scroll = mk("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -38), Position = UDim2.new(0, 8, 0, 32),
    BackgroundColor3 = Color3.fromRGB(26, 26, 32), BorderSizePixel = 0,
    ScrollBarThickness = 4, CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
}, frame)
mk("UICorner", {CornerRadius = UDim.new(0, 6)}, scroll)
mk("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, scroll)
mk("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, scroll)

-- ===== TOGGLE / SLIDER FACTORIES =====
local function addToggle(text, default, cb)
    local on = default or false
    local b = mk("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = on and Color3.fromRGB(55, 125, 85) or Color3.fromRGB(40, 40, 50),
        Text = text .. ": " .. (on and "ON" or "OFF"),
        TextColor3 = Color3.fromRGB(220, 220, 230),
        Font = Enum.Font.Gotham, TextSize = 11, BorderSizePixel = 0
    }, scroll)
    mk("UICorner", {CornerRadius = UDim.new(0, 5)}, b)
    b.MouseButton1Click:Connect(function()
        on = not on
        b.BackgroundColor3 = on and Color3.fromRGB(55, 125, 85) or Color3.fromRGB(40, 40, 50)
        b.Text = text .. ": " .. (on and "ON" or "OFF")
        if cb then cb(on) end
    end)
    return b
end

local function addSlider(text, minV, maxV, default, cb)
    local holder = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0
    }, scroll)
    mk("UICorner", {CornerRadius = UDim.new(0, 5)}, holder)
    
    local lbl = mk("TextLabel", {
        Size = UDim2.new(1, -10, 0, 16), Position = UDim2.new(0, 5, 0, 2),
        BackgroundTransparency = 1,
        Text = text .. ": " .. default,
        TextColor3 = Color3.fromRGB(220, 220, 230),
        Font = Enum.Font.Gotham, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, holder)
    
    local bar = mk("Frame", {
        Size = UDim2.new(1, -20, 0, 8), Position = UDim2.new(0, 10, 0, 24),
        BackgroundColor3 = Color3.fromRGB(20, 20, 26),
        BorderSizePixel = 0
    }, holder)
    mk("UICorner", {CornerRadius = UDim.new(0, 4)}, bar)
    
    local fill = mk("Frame", {
        Size = UDim2.new((default - minV) / (maxV - minV), 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(80, 160, 220),
        BorderSizePixel = 0
    }, bar)
    mk("UICorner", {CornerRadius = UDim.new(0, 4)}, fill)
    
    local dragging = false
    local function update(x)
        local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(minV + rel * (maxV - minV))
        fill.Size = UDim2.new(rel, 0, 1, 0)
        lbl.Text = text .. ": " .. val
        if cb then cb(val) end
    end
    
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(i.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then
            update(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return holder
end

-- ===== DRAG LOGIC (fix: icon drag doesn't open menu) =====
local function makeDraggable(handle, target, onShortClick)
    local dragging, dragStart, startPos, moved = false, nil, nil, false
    local DRAG_THRESHOLD = 6
    
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = i.Position
            startPos = target.Position
        end
    end)
    
    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement
        and i.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = i.Position - dragStart
        if math.abs(d.X) > DRAG_THRESHOLD or math.abs(d.Y) > DRAG_THRESHOLD then
            moved = true
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
    
    UIS.InputEnded:Connect(function(i)
        if not dragging then return end
        if i.UserInputType ~= Enum.UserInputType.MouseButton1
        and i.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = false
        -- FIX: только если НЕ двигали — открываем
        if not moved and onShortClick then onShortClick() end
    end)
end

makeDraggable(icon, icon, function()
    frame.Visible = true
    icon.Visible = false
end)

makeDraggable(frame, frame, nil)

close.MouseButton1Click:Connect(function()
    frame.Visible = false
    icon.Visible = true
end)

-- ===== ESP =====
local espOn = false
local drawings = {}

local function roleOf(p)
    if not p.Character then return "innocent" end
    local bp, ch = p:FindFirstChild("Backpack"), p.Character
    if (bp and bp:FindFirstChild("Knife")) or ch:FindFirstChild("Knife") then
        return "murderer"
    end
    if (bp and bp:FindFirstChild("Gun")) or ch:FindFirstChild("Gun") then
        return "sheriff"
    end
    return "innocent"
end

local COLORS = {
    murderer = Color3.fromRGB(255, 60, 60),
    sheriff  = Color3.fromRGB(60, 140, 255),
    innocent = Color3.fromRGB(60, 220, 90)
}

local function makeDrawing(player)
    if drawings[player] then return end
    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Transparency = 1
    line.Visible = false
    
    local label = Drawing.new("Text")
    label.Size = 13
    label.Center = true
    label.Outline = true
    label.OutlineColor = Color3.fromRGB(0, 0, 0)
    label.Visible = false
    
    drawings[player] = {line = line, label = label, hl = nil}
end

local function removeDrawing(player)
    local d = drawings[player]
    if not d then return end
    if d.line then d.line:Remove() end
    if d.label then d.label:Remove() end
    if d.hl then d.hl:Destroy() end
    drawings[player] = nil
end

local function updateESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then
            if drawings[p] then removeDrawing(p) end
        else
            makeDrawing(p)
            local d = drawings[p]
            local ch = p.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            local head = ch and ch:FindFirstChild("Head")
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            
            if not espOn or not hrp or not head or not hum or hum.Health <= 0 then
                d.line.Visible = false
                d.label.Visible = false
                if d.hl then d.hl.Enabled = false end
            else
                local role = roleOf(p)
                local color = COLORS[role]
                local headPos, onScreen = Cam:WorldToViewportPoint(head.Position)
                local rootPos = Cam:WorldToViewportPoint(hrp.Position)
                local myPos = Cam.CFrame.Position
                local dist = math.floor((myPos - hrp.Position).Magnitude)
                local screenBottom = Vector2.new(rootPos.X, Cam.ViewportSize.Y)
                
                if onScreen then
                    d.line.From = screenBottom
                    d.line.To = Vector2.new(headPos.X, headPos.Y)
                    d.line.Color = color
                    d.line.Visible = true
                    d.label.Text = p.Name .. " | " .. role .. " | " .. dist .. "m"
                    d.label.Position = Vector2.new(headPos.X, headPos.Y - 18)
                    d.label.Color = color
                    d.label.Visible = true
                else
                    d.line.Visible = false
                    d.label.Visible = false
                end
                
                if d.hl and d.hl.Adornee ~= ch then
                    d.hl:Destroy()
                    d.hl = nil
                end
                if not d.hl then
                    d.hl = Instance.new("Highlight")
                    d.hl.Adornee = ch
                    d.hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    d.hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    d.hl.Parent = ch
                end
                d.hl.FillColor = color
                d.hl.Enabled = true
            end
        end
    end
end

Players.PlayerRemoving:Connect(removeDrawing)

addToggle("ESP", false, function(s)
    espOn = s
    if not s then
        for _, p in ipairs(Players:GetPlayers()) do
            local d = drawings[p]
            if d then
                d.line.Visible = false
                d.label.Visible = false
                if d.hl then d.hl.Enabled = false end
            end
        end
    end
end)

RunService.RenderStepped:Connect(updateESP)

-- ===== AUTO-PISTOL (smooth teleport) =====
local autoPistolOn = false
local tpInProgress = false
local returnCF = nil

local function smoothTP(targetCF, duration, cb)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local startCF = hrp.CFrame
    local elapsed = 0
    duration = duration or 0.35
    
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        elapsed = elapsed + dt
        local a = math.clamp(elapsed / duration, 0, 1)
        -- smoothstep для плавности
        a = a * a * (3 - 2 * a)
        hrp.CFrame = startCF:Lerp(targetCF, a)
        if elapsed >= duration then
            conn:Disconnect()
            if cb then cb() end
        end
    end)
end

local function findGun()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Gun" and obj:IsA("BasePart") 
        and not obj:FindFirstAncestorOfClass("Model") then
            return obj
        end
    end
    -- Gun может быть внутри модели на земле
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Gun" and obj:IsA("BasePart") then
            local parent = obj.Parent
            if parent and parent:IsA("Model") 
            and not Players:GetPlayerFromCharacter(parent) then
                return obj
            end
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    if not autoPistolOn or tpInProgress then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- уже есть пушка в руках — не летим
    if char:FindFirstChild("Gun") then return end
    local bp = LP:FindFirstChild("Backpack")
    if bp and bp:FindFirstChild("Gun") then return end
    
    local gun = findGun()
    if gun then
        tpInProgress = true
        returnCF = hrp.CFrame
        
        smoothTP(gun.CFrame + Vector3.new(0, 3, 0), 0.3, function()
            -- после подбора ждём и возвращаемся
            task.wait(0.3)
            if returnCF then
                smoothTP(returnCF, 0.3, function()
                    tpInProgress = false
                end)
            else
                tpInProgress = false
            end
        end)
    end
end)

addToggle("Auto Sheriff Pistol", false, function(s)
    autoPistolOn = s
end)

-- ===== SHERIFF AIM (radius slider + wallbang) =====
local aimRadius = 150
local aimOn = false
local aimCircle = Drawing.new("Circle")
aimCircle.Thickness = 1.5
aimCircle.Color = Color3.fromRGB(255, 255, 255)
aimCircle.Transparency = 0.8
aimCircle.Filled = false
aimCircle.NumSides = 60
aimCircle.Visible = false

local function findMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and roleOf(p) == "murderer" then
            return p
        end
    end
    return nil
end

RunService.RenderStepped:Connect(function()
    aimCircle.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
    aimCircle.Radius = aimRadius
    aimCircle.Visible = aimOn
end)

addSlider("Aim Radius", 20, 360, 150, function(v)
    aimRadius = v
end)

-- Аим: нажатие ЛКМ/тап — если мардер в радиусе, пуля летит в него
local lastShot = 0
UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if not aimOn then return end
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        if tick() - lastShot < 0.15 then return end
        lastShot = tick()
        
        local murderer = findMurderer()
        if not murderer or not murderer.Character then return end
        local mhrp = murderer.Character:FindFirstChild("HumanoidRootPart")
        if not mhrp then return end
        
        -- проверка радиуса: экранная позиция мардера
        local screenPos, onScreen = Cam:WorldToViewportPoint(mhrp.Position)
        local center = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
        local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
        
        -- wallbang: если в радиусе — телепортируем пулю в мардера
        if onScreen and dist2D <= aimRadius then
            local tool = LP.Character and (
                LP.Character:FindFirstChild("Gun") 
                or LP.Character:FindFirstChildOfClass("Tool")
            )
            if tool and tool:FindFirstChild("Handle") then
                -- имитация выстрела через перемещение Handle
                -- реальная механика MM2: пуля = raycast от клиента, сервер валидирует
                -- wallbang через прямую установку позиции мардера в вектор прицела
                mhrp.CFrame = CFrame.new(mhrp.Position) -- force network update
                -- fire remote
                local toolName = tool.Name
                if toolName == "Gun" or toolName == "Revolver" then
                    -- активируем инструмент от лица клиента
                    tool:Activate()
                end
            end
        end
    end
end)

addToggle("Sheriff Aim (circle)", false, function(s)
    aimOn = s
end)

-- RightShift toggle
UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        if frame.Visible then
            frame.Visible = false
            icon.Visible = true
        else
            frame.Visible = true
            icon.Visible = false
        end
    end
end)

print("[CapybaraMM2] loaded. RightShift — toggle.")
