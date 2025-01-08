-- jols1337 never knew :3





-- Fly Script yk AHAHAHA
local flySettings={fly=false,flyspeed=50}
local c local h local bv local bav local cam local flying local p=game.Players.LocalPlayer
local buttons={W=false,S=false,A=false,D=false,Moving=false}
local startFly=function()if not p.Character or not p.Character.Head or flying then return end c=p.Character h=c.Humanoid h.PlatformStand=true cam=workspace:WaitForChild('Camera') bv=Instance.new("BodyVelocity") bav=Instance.new("BodyAngularVelocity") bv.Velocity,bv.MaxForce,bv.P=Vector3.new(0,0,0),Vector3.new(10000,10000,10000),1000 bav.AngularVelocity,bav.MaxTorque,bav.P=Vector3.new(0,0,0),Vector3.new(10000,10000,10000),1000 bv.Parent=c.Head bav.Parent=c.Head flying=true h.Died:connect(function()flying=false end)end
local endFly=function()if not p.Character or not flying then return end h.PlatformStand=false bv:Destroy() bav:Destroy() flying=false end
game:GetService("UserInputService").InputBegan:connect(function(input,GPE)if GPE then return end for i,e in pairs(buttons)do if i~="Moving" and input.KeyCode==Enum.KeyCode[i]then buttons[i]=true buttons.Moving=true end end end)
game:GetService("UserInputService").InputEnded:connect(function(input,GPE)if GPE then return end local a=false for i,e in pairs(buttons)do if i~="Moving"then if input.KeyCode==Enum.KeyCode[i]then buttons[i]=false end if buttons[i]then a=true end end end buttons.Moving=a end)
local setVec=function(vec)return vec*(flySettings.flyspeed/vec.Magnitude)end
game:GetService("RunService").Heartbeat:connect(function(step)if flying and c and c.PrimaryPart then local p=c.PrimaryPart.Position local cf=cam.CFrame local ax,ay,az=cf:toEulerAnglesXYZ()c:SetPrimaryPartCFrame(CFrame.new(p.x,p.y,p.z)*CFrame.Angles(ax,ay,az))if buttons.Moving then local t=Vector3.new()if buttons.W then t=t+(setVec(cf.lookVector))end if buttons.S then t=t-(setVec(cf.lookVector))end if buttons.A then t=t-(setVec(cf.rightVector))end if buttons.D then t=t+(setVec(cf.rightVector))end c:TranslateBy(t*step)end end end)



local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'SKEET.WIN',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Aim'),
    Visual = Window:AddTab('Visual'),
    Changer = Window:AddTab('Changer'),
    Misc = Window:AddTab('Misc'),
    Settings = Window:AddTab("settings"),
}

local Boxes = {
	Aim = Tabs.Main:AddLeftGroupbox("Aim"),
    AA = Tabs.Main:AddRightGroupbox("Anti-Aim"),
	Visual = Tabs.Visual:AddLeftGroupbox("Visual"),
    AVisual = Tabs.Visual:AddRightGroupbox("Arm Visual"),
    GVisual = Tabs.Visual:AddRightGroupbox("Gun Visual"),
    Character = Tabs.Changer:AddLeftGroupbox("Character"),
    Announcer = Tabs.Changer:AddRightGroupbox("Announcer"),
    Melee = Tabs.Changer:AddLeftGroupbox("Melee"),
    Card = Tabs.Changer:AddRightGroupbox("Card"),
    Mods = Tabs.Misc:AddLeftGroupbox("Gun Mods"),
    PlayerMods = Tabs.Misc:AddRightGroupbox("Player Mods"),
    Menu   = Tabs.Settings:AddLeftGroupbox("menu"),
}

local Tabboxes = {
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MeleesFolder = ReplicatedStorage:WaitForChild("Melees")
local ObtainablesFolder = ReplicatedStorage:WaitForChild("Obtainables")
local CharacterCaseFolder = ObtainablesFolder:WaitForChild("CharacterCase")
local NilFolder = CharacterCaseFolder:WaitForChild("nil")
local ItemDataFolder = ReplicatedStorage:WaitForChild("ItemData")
local ImagesFolder = ItemDataFolder:WaitForChild("Images")
local AnnouncersFolder = ImagesFolder:WaitForChild("Announcers")
local CardsFolder = ImagesFolder:WaitForChild("Cards")

local function getStringValueNames()
    local stringValueNames = {}
    for _, item in pairs(NilFolder:GetChildren()) do
        if item:IsA("StringValue") then
            table.insert(stringValueNames, item.Name)
        end
    end
    return stringValueNames
end

local function splitTable(tbl, chunkSize)
    local result = {}
    for i = 1, #tbl, chunkSize do
        local chunk = {}
        for j = i, math.min(i + chunkSize - 1, #tbl) do
            table.insert(chunk, tbl[j])
        end
        table.insert(result, chunk)
    end
    return result
end

local allStringValueNames = getStringValueNames()

local function createAddList(values, text, flag)
    Boxes.Character:AddDropdown('Character', {
        Values = values,
        Default = 1, -- number index of the value / string
        Multi = false, -- true / false, allows multiple choices to be selected
    
        Text = 'Change Character Skin',
        Tooltip = 'Ye not 100% working btw', -- Information shown when you hover over the dropdown
    
        Callback = function(v)
                local localPlayerName = game.Players.LocalPlayer.Name
                local skinName = v
    
                local dataPath = "Data"
                local skinData = game.Players:WaitForChild(localPlayerName):WaitForChild(dataPath):WaitForChild("Skin")
                if skinData and skinData:IsA("StringValue") then
                    skinData.Value = skinName
                    print("Updated StringValue in Data > Skin to", skinName)
                else
                    print("Data > Skin folder not found or is not a StringValue")
                end
        end
    })
end

local chunkedStringValues = splitTable(allStringValueNames, 15)

for i, chunk in ipairs(chunkedStringValues) do
    createAddList(chunk, "Skin " .. i, "Skin" .. i)
end

--- >>> ANNOUNCER <<< ---
local function getStringValueNames1()
    local stringValueNames = {}
    for _, item in pairs(AnnouncersFolder:GetChildren()) do
        if item:IsA("StringValue") then
            table.insert(stringValueNames, item.Name)
        end
    end
    return stringValueNames
end

local function splitTable1(tbl, chunkSize)
    local result = {}
    for i = 1, #tbl, chunkSize do
        local chunk = {}
        for j = i, math.min(i + chunkSize - 1, #tbl) do
            table.insert(chunk, tbl[j])
        end
        table.insert(result, chunk)
    end
    return result
end

local allStringValueNames = getStringValueNames1()

local function createAddList1(values, text, flag)
    Boxes.Announcer:AddDropdown('Announcer', {
        Values = values,
        Default = 1, -- number index of the value / string
        Multi = false, -- true / false, allows multiple choices to be selected
    
        Text = 'Announcer',
        Tooltip = 'Wow Works!', -- Information shown when you hover over the dropdown
    
        Callback = function(v)
                local localPlayerName = game.Players.LocalPlayer.Name
                local announcerName = v
    
                local dataPath = "Data"
                local announcerData = game.Players:WaitForChild(localPlayerName):WaitForChild(dataPath):WaitForChild("Announcer")
                if announcerData and announcerData:IsA("StringValue") then
                    announcerData.Value = announcerName
                    print("Updated StringValue in Data > Announcer to", announcerName)
                else
                    print("Data > Announcer folder not found or is not a StringValue")
                end
        end
    })
end

local chunkedStringValues = splitTable(allStringValueNames, 15)

for i, chunk in ipairs(chunkedStringValues) do
    createAddList1(chunk, "Announcer " .. i, "Announcer" .. i)
end


--- >>> MELEE <<< ---
local function getFolderNames2()
    local folderNames = {}
    for _, folder in pairs(MeleesFolder:GetChildren()) do
        if folder:IsA("Folder") then
            table.insert(folderNames, folder.Name)
        end
    end
    return folderNames
end

-- Function to split table into chunks
local function splitTable2(tbl, chunkSize)
    local result = {}
    for i = 1, #tbl, chunkSize do
        local chunk = {}
        for j = i, math.min(i + chunkSize - 1, #tbl) do
            table.insert(chunk, tbl[j])
        end
        table.insert(result, chunk)
    end
    return result
end

local allFolderNames = getFolderNames2()
local chunkedFolderNames = splitTable2(allFolderNames, 20)

-- Function to create AddList
local function createAddList2(values)
    Boxes.Melee:AddDropdown('Melee', {
        Values = values,
        Default = 1, -- number index of the value / string
        Multi = false, -- true / false, allows multiple choices to be selected
    
        Text = 'Melee Changer',
        Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown
    
        Callback = function(v)
                local localPlayerName = game.Players.LocalPlayer.Name
                local meleeFolderName = v
    
                -- Function to update folder name inside a specified path
                local function updateFolderName(path)
                    local folder = game.Players:WaitForChild(localPlayerName):WaitForChild(path)
                    local childFolder = folder:FindFirstChild("Melee")
                    if childFolder then
                        childFolder.Name = meleeFolderName
                        print("Updated folder name in", path, "to", meleeFolderName)
                    else
                        print("Melee folder not found in", path)
                    end
                end
    
                -- Update the StringValue in Workspace > LocalPlayer > Data > Melee
                local dataPath = "Data"
                local meleeData = game.Players:WaitForChild(localPlayerName):WaitForChild(dataPath):WaitForChild("Melee")
                if meleeData and meleeData:IsA("StringValue") then
                    meleeData.Value = meleeFolderName
                    print("Updated StringValue in Data > Melee to", meleeFolderName)
                else
                    print("Data > Melee folder not found or is not a StringValue")
                end
        end
    })
end

-- Create AddList for each chunk of folder names
for i, chunk in ipairs(chunkedFolderNames) do
    createAddList2(chunk)
end

--- >>> CARD <<< ---
local function getStringValueNames3()
    local stringValueNames = {}
    for _, item in pairs(CardsFolder:GetChildren()) do
        if item:IsA("StringValue") then
            table.insert(stringValueNames, item.Name)
        end
    end
    return stringValueNames
end

local function splitTable3(tbl, chunkSize)
    local result = {}
    for i = 1, #tbl, chunkSize do
        local chunk = {}
        for j = i, math.min(i + chunkSize - 1, #tbl) do
            table.insert(chunk, tbl[j])
        end
        table.insert(result, chunk)
    end
    return result
end

local allStringValueNames = getStringValueNames3()

local function createAddList3(values, text, flag)
    Boxes.Card:AddDropdown('Card', {
        Values = values,
        Default = 1, -- number index of the value / string
        Multi = false, -- true / false, allows multiple choices to be selected
    
        Text = 'Card Changer',
        Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown
    
        Callback = function(v)
                local localPlayerName = game.Players.LocalPlayer.Name
                local cardName = v
    
                local dataPath = "Data"
                local cardData = game.Players:WaitForChild(localPlayerName):WaitForChild(dataPath):WaitForChild("Card")
                if cardData and cardData:IsA("StringValue") then
                    cardData.Value = cardName
                    print("Updated StringValue in Data > Card to", cardName)
                else
                    print("Data > Card folder not found or is not a StringValue")
                end
        end
    })
end

local chunkedStringValues = splitTable3(allStringValueNames, 15)

for i, chunk in ipairs(chunkedStringValues) do
    createAddList3(chunk, "Card " .. i, "Card" .. i)
end

--- >>> > AIM TAB < <<< ---

local Silentaim = {
    fov = nil, -- Default FOV for legit mode
    active = false -- Flag to check if Silent Aim is active
}

local parts = {
    "RightUpperLeg",
    "LeftUpperLeg",
    "HeadHB",
    "HumanoidRootPart"
}

Boxes.Aim:AddToggle('SilentAim', {
    Text = 'Silent Aim',
    Default = false,
    Tooltip = 'It never goes off btw',

    Callback = function(v)
        Silentaim.active = v
        if Silentaim.active then
            print("Silent Aim Activated")
        else
            print("Silent Aim Deactivated")
        end
    end
})

Boxes.Aim:AddInput('SAFOV', {
    Default = '5',
    Numeric = true, -- true / false, only allows numbers
    Finished = true, -- true / false, only calls callback when you press enter

    Text = 'Silent Aim Fov',
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the textbox

    Placeholder = 'FOV: 1 - 20', -- placeholder text when the box is empty
    -- MaxLength is also an option which is the max length of the text

    Callback = function(v)
        Silentaim.fov = v
    end
})

Boxes.Aim:AddDropdown('HitBox', {
    Values = {
		"All",
		"HumanoidRootPart",
		"RightUpperLeg",
		"LeftUpperLeg"
	},
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'HitBox',
    Tooltip = 'Only Choose one!', -- Information shown when you hover over the dropdown

    Callback = function(v)
	    if v == "ALL" then
            parts = {"RightUpperLeg", "LeftUpperLeg", "HeadHB", "HumanoidRootPart"}
        elseif v == "Head" then
            parts = {"HeadHB"}
        elseif v == "HumanoidRootPart" then
            parts = {"HumanoidRootPart"}
        elseif v == "RightUpperLeg" then
            parts = {"RightUpperLeg"}
        elseif v == "LeftUpperLeg" then
            parts = {"LeftUpperLeg"}
        end
        warn("Selected Target: " .. v .. ", Parts: " .. table.concat(parts, ", "))
        
        if Silentaim.active then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character then
                    for _, partName in ipairs(parts) do
                        local part = v.Character:FindFirstChild(partName)
                        if part then
                            part.Transparency = 10
                        end
                    end
                end
            end
        end
    end
})

--- >>> Main Code for Silent Aim (Hitbox Expander) <<< ---
function getPlayersName()
    for i, v in pairs(game:GetChildren()) do
        if v.ClassName == "Players" then
            return v.Name
        end
    end
end

local players = getPlayersName()
local localPlayer = game[players].LocalPlayer

coroutine.resume(coroutine.create(function()
    while wait(1) do
        coroutine.resume(coroutine.create(function()
            if Silentaim.active then
                for _, v in pairs(game[players]:GetPlayers()) do
                    if v.Name ~= localPlayer.Name and v.Character then
                        for _, partName in ipairs(parts) do
                            local part = v.Character:FindFirstChild(partName)
                            if part then
                                part.Transparency = 10
                                part.CanCollide = false
                                part.Size = Vector3.new(Silentaim.fov, Silentaim.fov, Silentaim.fov)
                            end
                        end
                    end
                end
            end
        end))
    end
end))

--- >>> > Anti Aim < <<< ---
local spinSpeed = 10
local gyro

Boxes.AA:AddToggle('AntiAim', {
    Text = 'Anti-Aim',
    Default = false,
    Tooltip = '',

    Callback = function(value)
        local character = game.Players.LocalPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if value then
            -- game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.thirdperson.Value = true
    
            if humanoidRootPart then
                local spin = Instance.new("BodyAngularVelocity")
                spin.Name = "AntiAimSpin"
                spin.AngularVelocity = Vector3.new(0, spinSpeed, 0)
                spin.MaxTorque = Vector3.new(0, math.huge, 0)
                spin.P = 500000
                spin.Parent = humanoidRootPart
    
                gyro = Instance.new("BodyGyro")
                gyro.Name = "AntiAimGyro"
                gyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                gyro.CFrame = humanoidRootPart.CFrame
                gyro.P = 3000
                gyro.Parent = humanoidRootPart
            end
        else
            -- game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.thirdperson.Value = false
    
            if humanoidRootPart then
                local spin = humanoidRootPart:FindFirstChild("AntiAimSpin")
                if spin then
                    spin:Destroy()
                end
    
                if gyro then
                    gyro:Destroy()
                    gyro = nil
                end
            end
        end
    end
})

Boxes.AA:AddInput('AASPEED', {
    Default = '10',
    Numeric = true,
    Finished = false,
    Text = 'Power',
    Tooltip = '',
    Placeholder = '10 is lowest',
    Callback = function(value)
        spinSpeed = value

        local character = game.Players.LocalPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local spin = humanoidRootPart:FindFirstChild("AntiAimSpin")
            if spin then
                spin.AngularVelocity = Vector3.new(0, spinSpeed, 0)
            end
        end
    end
})

local ESPSolo = loadstring(game:HttpGet("https://raw.githubusercontent.com/V3xOwnYou/Universalv1/main/SoloEsp"))();
ESPSolo.Enabled = true;
ESPSolo.BoxType = "Corner Box Esp";

Boxes.Visual:AddToggle('CornerBox', {
    Text = 'Corner Box',
    Default = false,
    Tooltip = '',

    Callback = function(v)
        ESPSolo.ShowBox = v;
    end
})

Boxes.Visual:AddToggle('Name', {
    Text = 'Name',
    Default = false,
    Tooltip = '',

    Callback = function(v)
        ESPSolo.ShowName = v;
    end
})

Boxes.Visual:AddToggle('Health', {
    Text = 'Health',
    Default = false,
    Tooltip = '',

    Callback = function(v)
        ESPSolo.ShowHealth = v;
    end
})

Boxes.Visual:AddToggle('Tracer', {
    Text = 'Tracer',
    Default = false,
    Tooltip = '',

    Callback = function(v)
        ESPSolo.ShowTracer = v;
    end
})

Boxes.Visual:AddToggle('Distance', {
    Text = 'Distance',
    Default = false,
    Tooltip = '',

    Callback = function(v)
        ESPSolo.ShowDistance = v;
    end
})

--- >>> > Arm Visual < <<< ---

local function ak(al)
    return Vector3.new(al.R, al.G, al.B)
end

local am = "Plastic"
Boxes.AVisual:AddDropdown('ATYPE', {
    Values = { "Plastic", "ForceField", "Wood", "Grass" },
    Default = 1,
    Multi = false,
    Text = 'Arm Mode',
    Tooltip = 'This is a tooltip',

    Callback = function(an)
        am = an
    end
})

local ao = Color3.new(50, 50, 50)
Boxes.AVisual:AddLabel('Arm Color'):AddColorPicker('AColor', {
    Default = Color3.new(50, 50, 50),
    Title = 'Some color',
    Transparency = 0,

    Callback = function(ap)
        ao = ap
    end
})

local aq = false
Boxes.AVisual:AddToggle('AChams', {
    Text = 'Arm Chams',
    Default = false,
    Tooltip = '',

    Callback = function(L)
        aq = L
        if aq then
          spawn(function()
            while true do
              wait(.01)
              if not aq then
                break
              else
                local cameraArms = workspace.Camera:FindFirstChild("Arms")
                if cameraArms then
                  for ar, O in pairs(cameraArms:GetDescendants()) do
                    if O.Name == 'Right Arm' or O.Name == 'Left Arm' then
                      if O:IsA("BasePart") then
                        O.Material = Enum.Material[am]
                        O.Color = ao
                      end
                    elseif O:IsA("SpecialMesh") then
                      if O.TextureId == '' then
                        O.TextureId = 'rbxassetid://0'
                        O.VertexColor = ak(ao)
                      end
                    elseif O.Name == 'L' or O.Name == 'R' then
                      O:Destroy()
                    end
                  end
                end
              end
            end
          end)
        end
    end
})

--- >>> > Gun Visual < <<< ---

local at = "Plastic"
Boxes.GVisual:AddDropdown('GTYPE', {
    Values = { "Plastic", "ForceField", "Wood", "Grass" },
    Default = 1,
    Multi = false,
    Text = 'Gun Mode',
    Tooltip = 'This is a tooltip',

    Callback = function(an)
        at = an
    end
})

local au = Color3.new(50, 50, 50)
Boxes.GVisual:AddLabel('Gun Color'):AddColorPicker('GColor', {
    Default = Color3.new(50, 50, 50),
    Title = 'Some color',
    Transparency = 0,

    Callback = function(ap)
        au = ap
    end
})

local av = false;
Boxes.GVisual:AddToggle('GChams', {
    Text = 'Gun Chams',
    Default = false,
    Tooltip = '',

    Callback = function(L)
        av = L;
        if av
        then
          spawn(function()
            while true do wait(.01)
              if not av then
                break
              else
                if not workspace.Camera:FindFirstChild("Arms")
                then
                  wait()
                else
                  for ar, O in pairs(workspace.Camera.Arms:GetDescendants()) do
                    if O:IsA("MeshPart")
                    then
                      O.Material = Enum.Material[at]
                      O.Color = au
                    end
                  end
                end
              end
            end
          end)
        end
    end
})

local rainbowEnabled = false
local c = 1
function zigzag(X) 
  return math.acos(math.cos(X * math.pi)) / math.pi 
end

Boxes.GVisual:AddToggle('GRB', {
    Text = 'Rainbow Chams v1',
    Default = false,
    Tooltip = '',

    Callback = function(L)
        rainbowEnabled = state
    end
})

game:GetService("RunService").RenderStepped:Connect(function() 
    if game.Workspace.Camera:FindFirstChild('Arms') and rainbowEnabled then 
      for i, v in pairs(game.Workspace.Camera.Arms:GetDescendants()) do 
        if v.ClassName == 'MeshPart' then 
          v.Color = Color3.fromHSV(zigzag(c), 1, 1)
          c = c + .0001
        end 
      end 
    end 
end)

local rainbowEnabled = false
local c = 0
local hueIncrement = 0.1 

function updateColors()
    for i, v in pairs(game.Workspace.Camera.Arms:GetDescendants()) do
      if v.ClassName == 'MeshPart' then
        v.Color = Color3.fromHSV(c, 1, 1)
      end
    end
end

Boxes.GVisual:AddToggle('GRB', {
    Text = 'Rainbow Chams v2',
    Default = false,
    Tooltip = '',

    Callback = function(L)
        rainbowEnabled = state
    end
})

game:GetService("RunService").RenderStepped:Connect(function()
    if game.Workspace.Camera:FindFirstChild('Arms') and rainbowEnabled then
      c = c + hueIncrement
      if c >= 1 then
        c = c % 1 -- [0, 1] range
      end
      updateColors()
    end
end)

Boxes.Mods:AddToggle('Infv1', {
    Text = 'Infinite Ammo v1',
    Default = false,
    Tooltip = '',

    Callback = function(v)
        game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = v and "Infinite Ammo" or ""
    end
})

local SettingsInfinite = false
Boxes.Mods:AddToggle('infv2', {
    Text = 'Infinite ammo v2',
    Default = false,
    Tooltip = '',

    Callback = function(K)
        SettingsInfinite = K
        if SettingsInfinite then
            game:GetService("RunService").Stepped:connect(function()
                pcall(function()
                    if SettingsInfinite then
                        local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
                        playerGui.GUI.Client.Variables.ammocount.Value = 99
                        playerGui.GUI.Client.Variables.ammocount2.Value = 99
                    end
                end)
            end)
        end
    end
})

local originalValues = { -- saves/stores the original Values of the gun value :3
    FireRate = {},
    ReloadTime = {},
    EReloadTime = {},
    Auto = {},
    Spread = {},
    Recoil = {}
}

Boxes.Mods:AddToggle('FastReload', {
    Text = 'Fast Reload',
    Default = false,
    Tooltip = '',

    Callback = function(x)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
            if v:FindFirstChild("ReloadTime") then
                if x then
                    if not originalValues.ReloadTime[v] then
                        originalValues.ReloadTime[v] = v.ReloadTime.Value
                    end
                    v.ReloadTime.Value = 0.01
                else
                    if originalValues.ReloadTime[v] then
                        v.ReloadTime.Value = originalValues.ReloadTime[v]
                    else
                        v.ReloadTime.Value = 0.8 
                    end
                end
            end
            if v:FindFirstChild("EReloadTime") then
                if x then
                    if not originalValues.EReloadTime[v] then
                        originalValues.EReloadTime[v] = v.EReloadTime.Value
                    end
                    v.EReloadTime.Value = 0.01
                else
                    if originalValues.EReloadTime[v] then
                        v.EReloadTime.Value = originalValues.EReloadTime[v]
                    else
                        v.EReloadTime.Value = 0.8 
                    end
                end
            end
        end
    end
})

Boxes.Mods:AddToggle('Fastfirerate', {
    Text = 'Fast Fire Rate',
    Default = false,
    Tooltip = '',

    Callback = function(state)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "FireRate" or v.Name == "BFireRate" then
                if state then
                    if not originalValues.FireRate[v] then
                        originalValues.FireRate[v] = v.Value
                    end
                    v.Value = 0.02
                else
                    if originalValues.FireRate[v] then
                        v.Value = originalValues.FireRate[v]
                    else
                        v.Value = 0.8 
                    end
                end
            end
        end
    end
})

Boxes.Mods:AddToggle('AlwaysAuto', {
    Text = 'Always Auto',
    Default = false,
    Tooltip = '',

    Callback = function(state)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "Auto" or v.Name == "AutoFire" or v.Name == "Automatic" or v.Name == "AutoShoot" or v.Name == "AutoGun" then
                if state then
                    if not originalValues.Auto[v] then
                        originalValues.Auto[v] = v.Value
                    end
                    v.Value = true
                else
                    if originalValues.Auto[v] then
                        v.Value = originalValues.Auto[v]
                    else
                        v.Value = false 
                    end
                end
            end
        end
    end
})

Boxes.Mods:AddToggle('NoSpread', {
    Text = 'No Spread',
    Default = false,
    Tooltip = '',

    Callback = function(state)
        for _, v in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
            if v.Name == "MaxSpread" or v.Name == "Spread" or v.Name == "SpreadControl" then
                if state then
                    if not originalValues.Spread[v] then
                        originalValues.Spread[v] = v.Value
                    end
                    v.Value = 0
                else
                    if originalValues.Spread[v] then
                        v.Value = originalValues.Spread[v]
                    else
                        v.Value = 1 
                    end
                end
            end
        end
    end
})

Boxes.Mods:AddToggle('NoRecoil', {
    Text = 'No Recoil',
    Default = false,
    Tooltip = '',

    Callback = function(state)
        for _, v in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
            if v.Name == "RecoilControl" or v.Name == "Recoil" then
                if state then
                    if not originalValues.Recoil[v] then
                        originalValues.Recoil[v] = v.Value
                    end
                    v.Value = 0
                else
                    if originalValues.Recoil[v] then
                        v.Value = originalValues.Recoil[v]
                    else
                        v.Value = 1 
                    end
                end
            end
        end
    end
})

Boxes.PlayerMods:AddLabel('Fly'):AddKeyPicker('Fly', {
    Default = 'X',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Auto lockpick safes',
    NoUI = false,

    Callback = function(state)
        if state then
            startFly()
          else
            endFly()
          end
    end,
})

Boxes.PlayerMods:AddInput('FlySpeed', {
    Default = '3',
    Numeric = true,
    Finished = false,
    Text = 'Fly Speed',
    Tooltip = 'This is a tooltip',
    Placeholder = 'Idk Put any',
    Callback = function(s)
        flySettings.flyspeed = s
    end
})

local settings = {WalkSpeed = 16}
local isWalkSpeedEnabled = false

Boxes.PlayerMods:AddToggle('PWS', {
    Text = 'Change Walk Speed',
    Default = false,
    Tooltip = '',

    Callback = function(state)
        isWalkSpeedEnabled = state
    end
})

local walkMethods = {"Velocity", "Vector", "CFrame"}
local selectedWalkMethod = walkMethods[1]

Boxes.PlayerMods:AddDropdown('PWSM', {
    Values = { 'Velocity', 'Vector', 'CFrame' },
    Default = 1,
    Multi = false,
    Text = 'Walk Speed Mode',
    Tooltip = 'This is a tooltip',

    Callback = function(selected)
        selectedWalkMethod = selected
    end
})

Boxes.PlayerMods:AddInput('WalkSpeed', {
    Default = '16',
    Numeric = true,
    Finished = false,
    Text = 'Power',
    Tooltip = '',
    Placeholder = '16 is normal',
    Callback = function(value)
        settings.WalkSpeed = value
    end
})

local function wsm(player, deltaTime)
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if humanoid and rootPart then
        local VS = humanoid.MoveDirection * settings.WalkSpeed
        if selectedWalkMethod == "Velocity" then
            rootPart.Velocity = Vector3.new(VS.X, rootPart.Velocity.Y, VS.Z)
        elseif selectedWalkMethod == "Vector" then
            local scaleFactor = 0.0001
            rootPart.CFrame = rootPart.CFrame + (VS * deltaTime * scaleFactor)
        elseif selectedWalkMethod == "CFrame" then
            local scaleFactor = 0.0001
            rootPart.CFrame = rootPart.CFrame + (humanoid.MoveDirection * settings.WalkSpeed * deltaTime * scaleFactor)
        else
            humanoid.WalkSpeed = settings.WalkSpeed
        end
    end
end

game:GetService("RunService").Stepped:Connect(function(deltaTime)
    if isWalkSpeedEnabled then
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            wsm(player, deltaTime)
        end
    end
end)

local IJ = false
Boxes.PlayerMods:AddToggle('CJP', {
    Text = 'Change Jump Power',
    Default = false,
    Tooltip = '',

    Callback = function(state)
        IJ = state
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if IJ then
                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
            end
        end)
    end
})

local isJumpPowerEnabled = false
Boxes.PlayerMods:AddToggle('CJP', {
    Text = 'Custom Jump Power',
    Default = false,
    Tooltip = '',

    Callback = function(state)
        isJumpPowerEnabled = state
    end
})

local jumpMethods = {"Velocity", "Vector", "CFrame"}
local selectedJumpMethod = jumpMethods[1]

Boxes.PlayerMods:AddDropdown('CJPP', {
    Values = jumpMethods,
    Default = 1,
    Multi = false,
    Text = 'Jump Power Mode',
    Tooltip = 'This is a tooltip',

    Callback = function(selected)
        selectedJumpMethod = selected
    end
})

Boxes.PlayerMods:AddInput('Power', {
    Default = '30',
    Numeric = true,
    Finished = false,
    Text = 'Power',
    Tooltip = '',
    Placeholder = '30 is idk',
    Callback = function(value)
        local player = game:GetService("Players").LocalPlayer
        local humanoid = player.Character:WaitForChild("Humanoid")
        humanoid.UseJumpPower = true
        humanoid.Jumping:Connect(function(isActive)
            if isJumpPowerEnabled and isActive then
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    if selectedJumpMethod == "Velocity" then
                        rootPart.Velocity = rootPart.Velocity * Vector3.new(1, 0, 1) + Vector3.new(0, value, 0)
                    elseif selectedJumpMethod == "Vector" then
                        rootPart.Velocity = Vector3.new(0, value, 0)
                    elseif selectedJumpMethod == "CFrame" then
                        player.Character:SetPrimaryPartCFrame(player.Character:GetPrimaryPartCFrame() + Vector3.new(0, value, 0))
                    end
                end
            end
        end)
    end
})

local original_names = {
    GUIName = nil,
    GUIName2 = nil,
    KillFeed = {},
    WinnerName = nil,
    ScorecardName = nil
}

local hidename = false
local runLoop = false

local function names()
    local edited_name = "SKEET.WIN"
    local edited_killfeed = "ren is my master :3"

    local gui = LocalPlayer.PlayerGui
    gui.GUI_Scorecard.Scorecard.Scrolling.Visible = false
    gui.Menew_Main.Container.PlrName.Text = edited_name
    gui.Menew_Main.Container.PlrName2.Text = edited_name
    Workspace.KillFeed["1"].Killer.Value = edited_killfeed
    Workspace.KillFeed["2"].Killer.Value = edited_killfeed
    Workspace.KillFeed["3"].Killer.Value = edited_killfeed
    Workspace.KillFeed["4"].Killer.Value = edited_killfeed
    Workspace.KillFeed["5"].Killer.Value = edited_killfeed
    Workspace.KillFeed["6"].Killer.Value = edited_killfeed
    gui.GUI.Winner.Visible = false
    gui.GUI_Scorecard.Scorecard.PlayerCard.Username.Text = "SKEET.WIN"
end

local function restores_name()
    local gui = LocalPlayer.PlayerGui

    if original_names.GUIName then
        gui.Menew_Main.Container.PlrName.Text = original_names.GUIName
    end

    if original_names.GUIName2 then
        gui.Menew_Main.Container.PlrName2.Text = original_names.GUIName2
    end

    for i, v in pairs(original_names.KillFeed) do
        Workspace.KillFeed[tostring(i)].Killer.Value = v
    end

    if original_names.WinnerName ~= nil then
        gui.GUI.Winner.Visible = original_names.WinnerName
    end

    if original_names.ScorecardName then
        gui.GUI_Scorecard.Scorecard.PlayerCard.Username.Text = original_names.ScorecardName
    end
end

Boxes.PlayerMods:AddToggle('HName', {
    Text = 'Hide Name',
    Default = false,
    Tooltip = '',

    Callback = function(enabled)
        hidename = enabled
        runLoop = enabled
    
        if hidename then
            local gui = LocalPlayer.PlayerGui
            original_names.GUIName = gui.Menew_Main.Container.PlrName.Text
            original_names.GUIName2 = gui.Menew_Main.Container.PlrName2.Text
            original_names.WinnerName = gui.GUI.Winner.Visible
            original_names.ScorecardName = gui.GUI_Scorecard.Scorecard.PlayerCard.Username.Text
    
            for i = 1, 6 do
                original_names.KillFeed[i] = Workspace.KillFeed[tostring(i)].Killer.Value
            end
    
            --  loop
            spawn(function()
                while runLoop do
                    pcall(names)
                    wait(0.2)
                end
            end)
        else
            runLoop = false
            restores_name()
        end
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