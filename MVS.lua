local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()

local Window = Library:CreateWindow({
	Title = "SKEET.WIN",
	Center = true,
	AutoShow = true,
})

local Tabs = {
	Main = Window:AddTab("Main"),
	Settings = Window:AddTab("settings"),
}

local Boxes = {
	Aim = Tabs.Main:AddLeftGroupbox("Aim"),
	Visual = Tabs.Main:AddRightGroupbox("Visual"),
	Menu   = Tabs.Settings:AddLeftGroupbox("menu"),
}

local Tabboxes = {
}

local plrs = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local shootRemote = rs.Remotes.Shoot
local SLon = false

local function isTeammate(model)
    local highlight = model:FindFirstChild("Highlight")
    return highlight and highlight.FillColor == Color3.fromRGB(30, 214, 134)
end

local function isRagdoll(model)
    return not model:FindFirstChild("Animate")
end

local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()
local camera = workspace.CurrentCamera

local r15BodyParts = {
    "Head",
    "UpperTorso",
    "LowerTorso",
    "LeftUpperArm",
    "LeftLowerArm",
    "LeftHand",
    "RightUpperArm",
    "RightLowerArm",
    "RightHand",
    "LeftUpperLeg",
    "LeftLowerLeg",
    "LeftFoot",
    "RightUpperLeg",
    "RightLowerLeg",
    "RightFoot"
}

local function isCharacterOnScreen(playerCharacter)
    local playerHead = playerCharacter:WaitForChild("Head")
    local screenPos, isOnScreen = camera:WorldToViewportPoint(playerHead.Position)
    return isOnScreen
end

local function getClosestPlayerToMouse()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, otherPlayer in plrs:GetPlayers() do
        local char = otherPlayer.Character
        if (not char) or otherPlayer == plr or isTeammate(char) or isRagdoll(char) or (not workspace:FindFirstChild(otherPlayer.Name)) or (not isCharacterOnScreen(char)) then
            continue
        end
        if char:FindFirstChild("HumanoidRootPart") then
            local playerPosition = char.HumanoidRootPart.Position
            local mousePosition = mouse.Hit.Position
            local distance = (mousePosition - playerPosition).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = otherPlayer
            end
        end
    end
    return closestPlayer
end

mouse.Button1Down:Connect(function()
    if plr.Character:FindFirstChildOfClass("Tool") then
        local closestPlayer = getClosestPlayerToMouse()
		if SLon then
			if closestPlayer then
				shootRemote:FireServer(Vector3.new(1,1,1), Vector3.new(1,1,1), closestPlayer.Character[r15BodyParts[math.random(1,#r15BodyParts)]], Vector3.new(1,1,1))
			end
		end
    end
end)

Boxes.Aim:AddToggle("Aim", {
	Text = "Silent Aim",
	Default = false,
})

Toggles.Aim:OnChanged(function(v)
	SLon = v
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer -- Reference to the local player
local OTESP = false -- Set this to true or false to enable/disable the ESP
local OTUFesp = Color3.new(0, 0, 0)
local OTUOesp = Color3.new(0, 0, 0)
local OTUOTesp = 0
local OTUFTesp = 0.5

local function applyHighlight(player)
    -- Skip the local player
    if player == LocalPlayer then
        return
    end

    local function onCharacterAdded(character)
        -- Check if OTESP is true before applying the highlight
        if not OTESP then
            return
        end

        -- Create a new Highlight instance and set properties
        local highlight = Instance.new("Highlight", character)

        highlight.Archivable = true
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Ensures highlight is always visible
        highlight.Enabled = true
        highlight.FillColor = OTUFesp
        highlight.OutlineColor = OTUFesp
        highlight.FillTransparency = OTUFTesp
        highlight.OutlineTransparency = OTUOTesp

        -- Continuously check OTESP state and remove highlight if disabled
        coroutine.wrap(function()
            while OTESP and character.Parent do
                task.wait(1)
            end
			if not OTESP and highlight and highlight.Parent then
				highlight:Destroy()
			end			
        end)()
    end

    -- If the player's character already exists, apply the highlight
    if player.Character then
        onCharacterAdded(player.Character)
    end

    -- Connect to CharacterAdded to ensure highlight is added when character respawns
    player.CharacterAdded:Connect(onCharacterAdded)
end

local function updateHighlights()
    if OTESP then
        -- Apply highlights to all current players except the local player
        for _, player in pairs(Players:GetPlayers()) do
            applyHighlight(player)
        end
    else
        -- Remove highlights by destroying existing Highlight instances
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                for _, child in pairs(player.Character:GetChildren()) do
                    if child:IsA("Highlight") then
                        child:Destroy()
                    end
                end
            end
        end
    end
end

-- Toggle OTESP and update highlights
local function toggleOTESP()
    OTESP = not OTESP
    updateHighlights()
end

-- Loop to continuously check every 3 seconds and update highlights
coroutine.wrap(function()
    while true do
        updateHighlights()
        task.wait(3)
    end
end)()

Boxes.Visual:AddButton({
    Text = 'Reload Esp (DEBUG)',
    Func = function()
        ToggleOTESP()
    end,
    DoubleClick = false,
    Tooltip = 'Just to fix some issues'
})

Boxes.Visual:AddToggle("Outline", {
	Text = "Outline",
	Default = false,
})

Toggles.Outline:OnChanged(function(v)
	toggleOTESP()
	OTESP = v
end)

Boxes.Visual:AddLabel('Fill Color'):AddColorPicker('FillUniversal', {
    Default = Color3.new(0, 0, 0), -- Bright green
    Title = 'Fill Color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

    Callback = function(Value)
        OTUFesp = Value
    end
})

Boxes.Visual:AddLabel('Outline Color'):AddColorPicker('OutlineUniversal', {
    Default = Color3.new(0, 0, 0), -- Bright green
    Title = 'Outline Color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

    Callback = function(Value)
        OTUFesp = Value
    end
})

Boxes.Visual:AddSlider('FillTransparency', {
    Text = 'Fill Transparency',
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 0.1,
    Compact = false,

    Callback = function(Value)
        OTUFTesp = Value
    end
})

Boxes.Visual:AddSlider('OutlineTransparency', {
    Text = 'Outline Transparency',
    Default = 0.1,
    Min = 0,
    Max = 1,
    Rounding = 0.1,
    Compact = false,

    Callback = function(Value)
        OTUOTesp = Value
    end
})

--- Box Esp

-- Settings
local Settings = {
    Box_Color = Color3.fromRGB(255, 0, 0),
    Box_Thickness = 2,
    Team_Check = false,
    Team_Color = false,
    Autothickness = true,
    Box_Visibility = true -- New setting to toggle box visibility
}

-- Locals
local Space = game:GetService("Workspace")
local Player = game:GetService("Players").LocalPlayer
local Camera = Space.CurrentCamera

-- Locals
local function NewLine(color, thickness)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

local function Vis(lib, state)
    for i, v in pairs(lib) do
        v.Visible = state
    end
end

local function Colorize(lib, color)
    for i, v in pairs(lib) do
        v.Color = color
    end
end

local Black = Color3.fromRGB(0, 0, 0)

local function UpdateBoxColor(Library)
    for _, box in pairs(Library) do
        box.Color = Settings.Box_Color
    end
end

-- Main Draw Function
local function Main(plr)
    repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil
    local R15
    if plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
        R15 = true
    else 
        R15 = false
    end
    local Library = {
        TL1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        TL2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),

        TR1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        TR2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),

        BL1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        BL2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),

        BR1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        BR2 = NewLine(Settings.Box_Color, Settings.Box_Thickness)
    }

    -- Update the box color whenever it changes
    UpdateBoxColor(Library)

    local oripart = Instance.new("Part")
    oripart.Parent = Space
    oripart.Transparency = 1
    oripart.CanCollide = false
    oripart.Size = Vector3.new(1, 1, 1)
    oripart.Position = Vector3.new(0, 0, 0)

    -- Updater Loop
    local function Updater()
        local c 
        c = game:GetService("RunService").RenderStepped:Connect(function()

			UpdateBoxColor(Library) -- to update everytime i was blind la

            if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
                local Hum = plr.Character
                local HumPos, vis = Camera:WorldToViewportPoint(Hum.HumanoidRootPart.Position)
                if vis then
                    oripart.Size = Vector3.new(Hum.HumanoidRootPart.Size.X, Hum.HumanoidRootPart.Size.Y*1.5, Hum.HumanoidRootPart.Size.Z)
                    oripart.CFrame = CFrame.new(Hum.HumanoidRootPart.CFrame.Position, Camera.CFrame.Position)
                    local SizeX = oripart.Size.X
                    local SizeY = oripart.Size.Y
                    local TL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, SizeY, 0)).p)
                    local TR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, SizeY, 0)).p)
                    local BL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, -SizeY, 0)).p)
                    local BR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, -SizeY, 0)).p)

                    if Settings.Team_Check then
                        if plr.TeamColor == Player.TeamColor then
                            Colorize(Library, Color3.fromRGB(0, 255, 0))
                        else 
                            Colorize(Library, Color3.fromRGB(255, 0, 0))
                        end
                    end

                    if Settings.Team_Color then
                        Colorize(Library, plr.TeamColor.Color)
                    end

                    local ratio = (Camera.CFrame.p - Hum.HumanoidRootPart.Position).magnitude
                    local offset = math.clamp(1/ratio*750, 2, 300)

                    Library.TL1.From = Vector2.new(TL.X, TL.Y)
                    Library.TL1.To = Vector2.new(TL.X + offset, TL.Y)
                    Library.TL2.From = Vector2.new(TL.X, TL.Y)
                    Library.TL2.To = Vector2.new(TL.X, TL.Y + offset)

                    Library.TR1.From = Vector2.new(TR.X, TR.Y)
                    Library.TR1.To = Vector2.new(TR.X - offset, TR.Y)
                    Library.TR2.From = Vector2.new(TR.X, TR.Y)
                    Library.TR2.To = Vector2.new(TR.X, TR.Y + offset)

                    Library.BL1.From = Vector2.new(BL.X, BL.Y)
                    Library.BL1.To = Vector2.new(BL.X + offset, BL.Y)
                    Library.BL2.From = Vector2.new(BL.X, BL.Y)
                    Library.BL2.To = Vector2.new(BL.X, BL.Y - offset)

                    Library.BR1.From = Vector2.new(BR.X, BR.Y)
                    Library.BR1.To = Vector2.new(BR.X - offset, BR.Y)
                    Library.BR2.From = Vector2.new(BR.X, BR.Y)
                    Library.BR2.To = Vector2.new(BR.X, BR.Y - offset)

                    -- Only show boxes if Box_Visibility is set to true
                    if Settings.Box_Visibility then
                        Vis(Library, true)
                    else
                        Vis(Library, false)
                    end

                    if Settings.Autothickness then
                        local distance = (Player.Character.HumanoidRootPart.Position - oripart.Position).magnitude
                        local value = math.clamp(1/distance*100, 1, 4) --0.1 is min thickness, 6 is max
                        for u, x in pairs(Library) do
                            x.Thickness = value
                        end
                    else 
                        for u, x in pairs(Library) do
                            x.Thickness = Settings.Box_Thickness
                        end
                    end
                else 
                    Vis(Library, false)
                end
            else 
                Vis(Library, false)
                if game:GetService("Players"):FindFirstChild(plr.Name) == nil then
                    for i, v in pairs(Library) do
                        v:Remove()
                        oripart:Destroy()
                    end
                    c:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

-- Draw Boxes
for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= Player.Name then
        coroutine.wrap(Main)(v)
    end
end

game:GetService("Players").PlayerAdded:Connect(function(newplr)
    coroutine.wrap(Main)(newplr)
end)


Boxes.Visual:AddToggle("Box", {
	Text = "Corner Box",
	Default = false,
})

Toggles.Box:OnChanged(function(v)
	Settings.Box_Visibility = v
end)

Boxes.Visual:AddToggle("BoxTeamCheck", {
	Text = "Team Check",
	Default = false,
})

Toggles.BoxTeamCheck:OnChanged(function(v)
	Settings.Team_Check = v
end)

Boxes.Visual:AddLabel('Corner Box Color'):AddColorPicker('CornerBoxColor', {
    Default = Color3.new(0, 0, 0), -- Bright green
    Title = 'Change the corner color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

    Callback = function(Value)
        Settings.Box_Color = Value
    end
})

Boxes.Menu:AddLabel("hide keybind"):AddKeyPicker("Hide", { Default = "KeypadOne", NoUI = true }); Library.ToggleKeybind = Options.Hide
Boxes.Menu:AddLabel("unload keybind"):AddKeyPicker("Unload", { Default = "Delete", NoUI = true })
Boxes.Menu:AddButton("unload", function() Library:Unload() end)

Library.Colors = {
	MainColor       = Color3.fromHex("1e1e1e"),
	AccentColor     = Color3.fromHex("db4467"),
	OutlineColor    = Color3.fromHex("141414"),
	BackgroundColor = Color3.fromHex("232323")
}

for property, color in Library.Colors do
	Library[property] = color
end

Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor) Library:UpdateColorsUsingRegistry()