if game.PlaceId ~= 26838733 then return end
if AmeChan then return end
pcall(function() getgenv().AmeChan = true end)
local prefix               = "!"
local Players              = game:GetService("Players")
local RunService           = game:GetService("RunService")
local Workspace            = game:GetService("Workspace")
local StarterGui           = game:GetService("StarterGui")
local TextChatService      = game:GetService("TextChatService")
local ReplicatedStorage    = game:GetService("ReplicatedStorage")
local VirtualUser          = game:GetService("VirtualUser")
local LocalPlayer          = Players.LocalPlayer
local PlayerGui            = LocalPlayer:WaitForChild("PlayerGui", 5)
local BlindGuisTable       = { ScreenFog = true, DarknessGui = true, VolleyballScreenGui = true, FlashBangEffect = true }
local LocalPlayerWhiteList = { LocalPlayer.UserId }
local LoopkillList         = {}
local LoopGodList          = {}
local whitelist            = {}
local FFkillList           = {}
local saveList             = {}
local RocketList           = {}
local loopkillRejoinProof  = {}
local baseProtect          = {}
local killAuraList         = {}
local LegacyKillMethod     = true  --this makes the script more stable and reduces crashes
local creator              = true  --this gives cool avatar
local publicMode           = false --this makes that everyone can use your commands
local chatCooldown         = false
local nan                  = 0 / 0
local anchorWhenRespawn    = false
local ImportantPlayerParts = {
    Head = true,
    Torso = true,
    ["Left Arm"] = true,
    ["Right Arm"] = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true,
    UpperTorso = true,
    LowerTorso = true,
    LeftUpperArm = true,
    LeftLowerArm = true,
    LeftHand = true,
    RightUpperArm = true,
    RightLowerArm = true,
    RightHand = true,
    LeftUpperLeg = true,
    LeftLowerLeg = true,
    LeftFoot = true,
    RightUpperLeg = true,
    RightLowerLeg = true,
    RightFoot = true,
    HumanoidRootPart = true,
    Humanoid = true,
    Health = true,
    ForceField = true
}
StarterGui:SetCore("SendNotification", {
    Title = "Catalog Heaven Admin Script",
    Text = "Loading script...",
    Duration = 5,
})

local function num(str)
    if str == "inf" then
        return math.huge
    elseif tonumber(str) then
        return tonumber(str)
    else
        return 0 / 0
    end
end

local function isAlive(humanoid)
    return (humanoid and (humanoid.Health > 0 or humanoid.Health ~= humanoid.Health)) or false
end

local function FindPlayers(Me, input)
    local Loosers = {}
    local target = input:lower()
    local allplayers = Players:GetPlayers()
    if not target then return end
    if target == "all" then
        Loosers = allplayers
    elseif target == "me" then
        table.insert(Loosers, Me)
    elseif target == "hackers" then
        for i = 1, #allplayers do
            local plr = allplayers[i]
            local backpack = plr and plr:FindFirstChild("Backpack")
            local char = plr.Character
            if backpack and char and (backpack:FindFirstChild("Diamond Blade Sword") or backpack:FindFirstChild("RocketJumper") or char:FindFirstChild("RocketJumper") or char:FindFirstChild("Diamond Blade Sword")) then
                table.insert(Loosers, plr)
            end
        end
    elseif target == "blacks" or target == "colored" then
        for i = 1, #allplayers do
            pcall(function()
                local plr = allplayers[i]
                local char = plr.Character
                local head = char:FindFirstChild("Head")
                if head then
                    local headColor = head.Color
                    local r = headColor.R * 255
                    local g = headColor.G * 255
                    local b = headColor.B * 255
                    if not (r > 200 and g > 80 and b > 10) then --Targets darker skin tone including brown and black.
                        table.insert(Loosers, plr)
                    end
                end
            end)
        end
    elseif target == "bacons" then
        for i = 1, #allplayers do
            local plr = allplayers[i]
            local char = plr.Character
            local condiction = char:FindFirstChild("Pal Hair")
            if condiction then
                table.insert(Loosers, plr)
            end
        end
    elseif target == "nonhackers" then
        for i = 1, #allplayers do
            local plr = allplayers[i]
            local backpack = plr and plr:FindFirstChild("Backpack")
            local char = plr.Character
            if backpack and char and not (backpack:FindFirstChild("Diamond Blade Sword") or backpack:FindFirstChild("RocketJumper") or char:FindFirstChild("RocketJumper") or char:FindFirstChild("Diamond Blade Sword")) then
                table.insert(Loosers, plr)
            end
        end
    elseif target == "ff" then
        for i = 1, #allplayers do
            local plr = allplayers[i]
            local char = plr.Character
            local condiction = char:FindFirstChild("ForceField")
            if condiction then
                table.insert(Loosers, plr)
            end
        end
    elseif target == "others" then
        for i = 1, #allplayers do
            local plr = allplayers[i]
            if plr ~= Me then
                table.insert(Loosers, plr)
            end
        end
    else
        for i = 1, #allplayers do
            local plr = allplayers[i]
            if (string.sub(plr.Name:lower(), 1, #target) == target or string.sub(plr.DisplayName:lower(), 1, #target) == target) then
                table.insert(Loosers, plr)
            end
        end
    end
    task.spawn(function()
        if #Loosers == 0 then return end
        local namelist = {}
        for i = 1, #Loosers do
            local plr = Loosers[i]
            table.insert(namelist, plr.Name)
        end
        local AllName = table.concat(namelist, ", ")
        print(Me.Name .. " called " .. AllName .. " with the input " .. input)
    end)

    return Loosers
end

local function ToggleAsset(id)
    ReplicatedStorage.Remotes.ToggleAsset:InvokeServer(id)
end

local function RetoggleGear(id)
    ReplicatedStorage.Remotes.ToggleAsset:InvokeServer(id)
    ReplicatedStorage.Remotes.ToggleAsset:InvokeServer(id)
end

function Chat(Message)
    if not chatCooldown then
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Message, "ALL")
    end
end

local function GetCharacterAndBackpack()
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack", 5)
    return Character, Backpack
end

local function cleanball()
    for _, part in pairs(Workspace:GetChildren()) do
        if part.Name == "Part" then
            local sound = part:FindFirstChild("HoHoHo")
            if sound then
                part:Destroy()
            end
        end
    end
end

local function RemoveFromList(List, Thing)
    local index = table.find(List, Thing)
    if not index then return end
    table.remove(List, index)
end


local function cleantouch(character)
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return end
    local handle = tool:FindFirstChild("Handle")
    if not handle then return end
    local touch = handle:FindFirstChild("TouchInterest")
    if not touch then return end
    touch:Destroy()
end

local function IsGodMode(Character)
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    return (Character:FindFirstChild("ForceField") or Humanoid.Health ~= Humanoid.Health or Humanoid.Health == math.huge or Character:FindFirstChild("DragonSword&Shield"))
end

local function isAnchored(Character)
    local theirTorso = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
    return (theirTorso and theirTorso.Anchored or Character:FindFirstChild("DrumKit") ~= nil)
end

local function LegacykorbloxNew()
    if #FFkillList == 0 then return end
    local storage = LocalPlayer:FindFirstChild("Backpack")
    local useSword = false
    local character = LocalPlayer.Character
    if not character then return end
    local Humanoid = character:FindFirstChild("Humanoid")
    if not Humanoid then return end
    local myTorso = character:FindFirstChild("Torso")
    if not myTorso then return end
    local sword = storage:FindFirstChild("KorbloxSwordAndShield") or character:FindFirstChild("KorbloxSwordAndShield")
    if not sword then return end
    task.spawn(function() cleanball() end)
    local cloneList = FFkillList
    for i = 1, #cloneList do
        local char = cloneList[i]

        if not char then
            RemoveFromList(FFkillList, char)
            continue
        end

        local targetTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        local targetHumanoid = char:FindFirstChild("Humanoid")

        if not (targetTorso and targetHumanoid) then
            RemoveFromList(FFkillList, char)
            continue
        end

        if not isAlive(targetHumanoid) then
            RemoveFromList(FFkillList, char)
            continue
        end

        if not isAnchored(char) then
            RemoveFromList(FFkillList, char)
            continue
        end

        if (character and Humanoid and myTorso and sword and char and targetTorso and targetHumanoid) then
            if not useSword then
                useSword = true
            end
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then
                    task.spawn(function() cleantouch(char) end)
                    task.spawn(function() v.Anchored = true end)
                    v.CFrame = myTorso.CFrame * CFrame.new(Vector3.new(1.5, 3.5, -1.8)) *
                        CFrame.Angles(math.rad(90), 0, 0)
                end
            end
        end
    end

    if useSword then
        if sword.Parent == storage then
            sword.Parent = character
        end
        if (Humanoid.Health > 0 or Humanoid.Health ~= Humanoid.Health) then
            sword:Activate()
        end
    end
end

local function TouchAndUnTouch(PartToTouch, MyTouchTransmitter)
    task.spawn(function()
        pcall(function()
            if not (PartToTouch and MyTouchTransmitter) then return end
            firetouchinterest(PartToTouch, MyTouchTransmitter, 0)
            task.wait()
            if not (PartToTouch and MyTouchTransmitter) then return end
            firetouchinterest(PartToTouch, MyTouchTransmitter, 1)
        end)
    end)
end

local korbloxEquipped = false

local function equipKorbloxAndKillOld() --old verison
    if not korbloxEquipped and #FFkillList == 0 then return end
    if korbloxEquipped and #FFkillList == 0 then
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local mychar = LocalPlayer.Character
        if not (backpack and mychar) then return end
        local korblox = mychar:FindFirstChild("KorbloxSwordAndShield")
        if korblox then
            korblox.Parent = backpack
            korbloxEquipped = false
        end
        return
    end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local mychar = LocalPlayer.Character
    if not (backpack and mychar) then return end
    local korblox = backpack:FindFirstChild("KorbloxSwordAndShield") or mychar:FindFirstChild("KorbloxSwordAndShield")
    if not korblox then return end
    local handle = korblox:FindFirstChild("Handle")
    if not handle then return end
    korblox.Parent = mychar
    korbloxEquipped = true
    task.spawn(function()
        for i = 1, #FFkillList do
            task.spawn(function()
                local target = FFkillList[i]
                local TheirHumanoid = target and target:FindFirstChildOfClass("Humanoid")
                if (TheirHumanoid.Health == 0 or target == nil) then
                    RemoveFromList(FFkillList, target)
                    return
                end
                for _, v in pairs(target:GetChildren()) do
                    if v:IsA("BasePart") and korblox.Parent == mychar and handle then
                        TouchAndUnTouch(v, handle)
                    end
                end
            end)
        end
    end)
end

local function GetDiamondRemote()
    local char, backpack = GetCharacterAndBackpack()
    if not (char and backpack) then return end
    local sword = backpack:FindFirstChild("Diamond Blade Sword") or char:FindFirstChild("Diamond Blade Sword")
    if not sword then return end
    local script = sword:FindFirstChildOfClass("Script")
    if not script then return end
    local remote = script:FindFirstChildOfClass("RemoteFunction")
    return remote
end

local success, err = pcall(function()
    local shothook; shothook = hookmetamethod(game, "__namecall", function(self, ...)
        local args = { ... }
        local method = getnamecallmethod()
        if tostring(self) == "Report" and method == "FireServer" then
            args[1] = CFrame.new(nan, nan, nan, nan, nan, nan, nan, nan, nan, nan, nan, nan)
        end
        return shothook(self, unpack(args))
    end)
end)

if not success then
    print(err)
end

local function infhp(table)
    if #table == 0 then return end
    local remote = GetDiamondRemote()
    for i = 1, #table do
        task.spawn(function()
            local target = table[i]
            local Character = target.Character
            if not (remote and Character) then return end
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if not Humanoid then return end
            remote:InvokeServer(7, Humanoid, -math.huge)
        end)
    end
end

local PlatformCooldown = false

local function sendKillDiamondRemoteToHumanoid(Humanoid, remote, damage)
    remote:InvokeServer(7, Humanoid, damage)
end

local function sendDiamondRemoteToPlayers(target, remote, damage)
    local Character = target and target.Character
    if not (target and remote and Character) then return end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    remote:InvokeServer(7, Humanoid, damage)
end

local function getPlatformShooter()
    local Character, Backpack = GetCharacterAndBackpack()
    if not (Character and Backpack) then return end
    local PlatformGun = Backpack:FindFirstChild("StepGun") or Character:FindFirstChild("StepGun")
    if not PlatformGun then return end
    local ShootEvent = PlatformGun:FindFirstChildOfClass("RemoteEvent")
    if not ShootEvent then return end
    return Character, Backpack, PlatformGun, ShootEvent
end

local function GetRocketRemote()
    local Character, backpack = GetCharacterAndBackpack()
    if not (Character and backpack) then return end
    local Rocket = backpack:FindFirstChild("RocketJumper") or Character:FindFirstChild("RocketJumper")
    if not Rocket then return end
    local RocketRemoteEvent = Rocket:FindFirstChildOfClass("RemoteEvent")
    return RocketRemoteEvent
end

local function fireRocket(List)
    if #List == 0 then return end
    local RocketRemoteEvent = GetRocketRemote()
    if not RocketRemoteEvent then return end
    for i = 1, #List do
        task.spawn(function()
            local plr = List[i]
            if not plr then return end
            local char = plr.Character
            if not char then return end
            local head = char:FindFirstChild("Head")
            if not head then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not isAlive(humanoid) then return end
            local StartingPosition = head.Position
            RocketRemoteEvent:FireServer(StartingPosition - Vector3.new(0, 1, 0), StartingPosition)
        end)
    end
end

local function insertToList(list, v)
    local index = table.find(list, v)
    if index then return end
    table.insert(list, v)
end

local function GetStickeyStep()
    local something
    local connection
    local attempts
    connection = Workspace.ChildAdded:Connect(function(thing)
        task.wait()
        if thing.Name == "StickyStep" then
            something = thing
            connection:Disconnect()
        end
    end)
    repeat
        task.wait(0.1)
    until something
    return something
end

local function GetHadesStaffSnowFlake()
    local something
    local connection
    local attempts = 0
    connection = Workspace.ChildAdded:Connect(function(thing)
        task.wait()
        if thing.Name == "Part" and thing:FindFirstChild("TouchInterest") and thing:FindFirstChild("Fire") and thing:FindFirstChild("BodyForce") then
            something = thing
            connection:Disconnect()
        end
    end)
    repeat
        task.wait(0.1)
    until something
    return something
end

PlatformCoolDown = false



local function TouchInterestPlatformKill(plr)
    local Char, Backpack, PlatformGun, ShootEvent = getPlatformShooter()
    if (not (Char and Backpack and PlatformGun and ShootEvent) or PlatformCooldown) then return end
    if PlatformGun.Parent == Backpack then
        PlatformGun.Parent = Char
    end
    local torso = Char:FindFirstChild("Torso") or Char:FindFirstChild("UpperTorso")
    local shootPosition = torso.Position + Vector3.new(0, 2, 0) + (torso.CFrame.LookVector * 4)
    ShootEvent:FireServer(shootPosition)
    task.wait()
    if PlatformGun.Parent == Char then
        PlatformGun.Parent = Backpack
    end
    local StickyStep = GetStickeyStep()
    if StickyStep then
        task.spawn(function()
            local char = plr.Character
            if not char then return end
            local head = char:FindFirstChild("Head")
            if not head then return end
            TouchAndUnTouch(head, StickyStep)
        end)
    end
    task.spawn(function()
        PlatformCoolDown = true
        task.wait(0.5)
        PlatformCoolDown = false
    end)
end

function LegacyPlatformKill(plr) --despite the legacy name, it is actually brand new
    local Char, Backpack, PlatformGun, ShootEvent = getPlatformShooter()
    if (not (Char and Backpack and PlatformGun and ShootEvent) or PlatformCooldown) then return end
    local myTorso = Char:FindFirstChild("UpperTorso") or Char:FindFirstChild("Torso")
    if not myTorso then return end
    local targetCharacter = plr.Character
    local targetTorso = targetCharacter:FindFirstChild("UpperTorso") or targetCharacter:FindFirstChild("Torso")
    if not targetTorso then return end
    local targetHead = targetCharacter:FindFirstChild("Head")
    if not targetHead then return end
    task.spawn(function()
        targetHead.CanCollide = false
        targetHead.Anchored = true
        targetHead.Size = Vector3.new(50, 50, 50)
        targetHead.Transparency = 1
        targetCharacter:PivotTo(myTorso.CFrame * CFrame.new(0, 4, 6))
    end)
    if PlatformGun.Parent == Backpack then
        PlatformGun.Parent = Char
    end
    ShootEvent:FireServer(targetTorso.Position)
    if PlatformGun.Parent == Char then
        PlatformGun.Parent = Backpack
    end
    task.spawn(function()
        PlatformCoolDown = true
        task.wait(0.5)
        PlatformCoolDown = false
    end)
end

local function kill(table)
    if #table == 0 then return end
    pcall(function()
        local remote = GetDiamondRemote()
        for i = 1, #table do
            task.spawn(function()
                local target = table[i]
                local Character = target and target.Character
                if not (target and remote and Character) then return end
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                if isAlive(Humanoid) then
                    remote:InvokeServer(7, Humanoid, math.huge)
                    if not IsGodMode(Character) or target == LocalPlayer then return end
                    if isAnchored(Character) then
                        insertToList(FFkillList, Character)
                    else
                        if LegacyKillMethod then
                            LegacyPlatformKill(target)
                        else
                            TouchInterestPlatformKill(target)
                        end
                    end
                end
            end)
        end
    end)
end

local function damage(dmg, targets)
    local _damage = num(dmg)
    local remote = GetDiamondRemote()
    if type(targets) == "table" then
        if #targets == 0 then return end
        for i = 1, #targets do
            task.spawn(function()
                sendDiamondRemoteToPlayers(targets[i], remote, _damage)
            end)
        end
    else
        sendDiamondRemoteToPlayers(targets, remote, _damage)
    end
end

local function nanHealth(table)
    if #table == 0 then return end
    local remote = GetDiamondRemote()
    for i = 1, #table do
        task.spawn(function()
            sendDiamondRemoteToPlayers(table[i], remote, nan)
        end)
    end
end

local function checkTrueIfInList(tbl, playerName, plr)
    return (table.find(tbl, playerName) ~= nil and plr ~= nil)
end

local function killaura(myPlayer)
    local size = Vector3.new(30, 30, 30)
    local playerName = myPlayer.Name
    local HitboxName = playerName .. "'s Aura"
    local Hitbox = Instance.new("Part")
    Hitbox.Parent = Workspace
    Hitbox.Size = size
    Hitbox.CanCollide = false
    Hitbox.Anchored = true
    Hitbox.CanQuery = false
    Hitbox.Name = HitboxName
    Hitbox.Transparency = 0.5
    insertToList(killAuraList, playerName)
    task.wait()
    while checkTrueIfInList(killAuraList, playerName, myPlayer) do
        task.wait()
        task.spawn(function()
            local MyChar = myPlayer.Character
            if not MyChar then return end
            local PartToCheck = MyChar:FindFirstChild("HumanoidRootPart") or MyChar:FindFirstChild("Torso") or
                MyChar:FindFirstChild("UpperTorso")
            if not PartToCheck then return end
            if Hitbox then
                Hitbox.CFrame = PartToCheck.CFrame
            end
            local tableTokill = {}
            local playersNearMe = Workspace:GetPartBoundsInBox(PartToCheck.CFrame, size)
            for _, v in pairs(playersNearMe) do
                local player = Players:GetPlayerFromCharacter(v.Parent)
                if player ~= myPlayer and not table.find(tableTokill, player) then
                    table.insert(tableTokill, player)
                end
            end
            kill(tableTokill)
        end)
    end
    task.wait()
    print("LoopAuraFinished!!!")
    local cleanUp = Workspace:FindFirstChild(HitboxName)
    if cleanUp then
        cleanUp:Destroy()
    end
end

local function baseProtectfun(myPlayer)
    local hitboxsize = Vector3.new(60, 60, 60)
    local playerName = myPlayer.Name
    local cloudname = playerName .. "'s Cloud"
    local Cloud = Workspace:FindFirstChild(cloudname)
    if not Cloud then return end
    local union = Cloud:FindFirstChild("Union")
    if not union then return end
    local cloneName = playerName .. "'s CloneUnion"
    local param = OverlapParams.new()
    param.FilterDescendantsInstances = { Cloud }
    param.FilterType = Enum.RaycastFilterType.Exclude
    local clone = union:Clone()
    clone.Parent = Workspace
    clone.CanCollide = false
    clone.Size = hitboxsize
    clone.CFrame = union.CFrame
    clone.CanQuery = false
    clone.Transparency = 0.5
    clone.Name = cloneName
    insertToList(baseProtect, playerName)
    task.wait()
    while checkTrueIfInList(baseProtect, playerName, myPlayer) do
        task.wait()
        task.spawn(function()
            local playersNearMe = Workspace:GetPartBoundsInBox(clone.CFrame, hitboxsize, param)
            local tableTokill = {}
            for i, v in pairs(playersNearMe) do
                local player = Players:GetPlayerFromCharacter(v.Parent)
                if player ~= myPlayer and not table.find(tableTokill, player) then
                    table.insert(tableTokill, player)
                end
            end
            kill(tableTokill)
        end)
    end
    task.wait()
    print("BpLoopFinished!!!")
    local cleanUp = Workspace:FindFirstChild(cloneName)
    if cleanUp then
        cleanUp:Destroy()
    end
end



local function MainLoop()
    pcall(function()
        task.spawn(function()
            kill(LoopkillList)
        end)
        task.spawn(function()
            infhp(LoopGodList)
        end)
        task.spawn(function()
            nanHealth(saveList)
        end)
        task.spawn(function()
            if LegacyKillMethod then
                LegacykorbloxNew()
            else
                equipKorbloxAndKillOld()
            end
        end)
        task.spawn(function()
            fireRocket(RocketList)
        end)
    end)
end

local ColorNameIdTable = { ["Diamond Blade Sword"] = 173755801 }


local function getGearFromCatalog(gearId, gearName) --unused
    local character, backpack = GetCharacterAndBackpack()
    local foundedgear = nil
    repeat
        task.wait(0.1)
        local gear = character:FindFirstChild(gearName) or backpack:FindFirstChild(gearName)
        if gear then
            foundedgear = gear
        else
            ReplicatedStorage.Remotes.ToggleAsset(gearId)
        end
    until gear or character == nil
    return foundedgear
end

local function equiptool(n)
    local mychar, backpack = GetCharacterAndBackpack()
    if not mychar then return end
    local humanoid = mychar:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local Tool = backpack:FindFirstChild(n) or mychar:FindFirstChild(n)
    if Tool then
        humanoid:EquipTool(Tool)
    end
    return Tool
end


local function ColorAllParts(t)
    local mychar = LocalPlayer.Character
    local Descendants = Workspace:GetDescendants()
    local tasks = 0
    if Descendants then
        local Tool = equiptool(t)
        if not Tool then return end
        task.wait(0.2)
        local handle = Tool:FindFirstChild("Handle")
        if not handle then return end
        Tool:Activate()
        task.wait(0.3)
        for i = 1, #Descendants do
            task.spawn(function()
                local v = Descendants[i]
                if Tool.Parent ~= mychar then return end
                if v:IsA("BasePart") and not ImportantPlayerParts[v.Name] and v.Name ~= "FF" then
                    TouchAndUnTouch(v, handle)
                    tasks = tasks + 1
                else
                    tasks = tasks + 1
                end
            end)
        end
    end
end

local function equiptoolandColor(tool)
    ColorAllParts(tool)
end

task.spawn(function()
    for _, v in pairs(PlayerGui:GetChildren()) do
        if BlindGuisTable[v.Name] then
            v:Destroy()
        end
    end
end)

local function equipSorcusAndActivate()
    local char, backpack = GetCharacterAndBackpack()
    local sword = equiptool("SorcusSword")
    if not sword then return end
    if sword.Parent == char then
        sword:WaitForChild("Input", 5):FireServer("Key", true, { Name = "x" })
    end
    sword.Parent = backpack
    task.wait(0.6)
    RetoggleGear(53623322)
end

local function walkspeed(list, spd)
    local targetSpeed = num(spd)
    local diamondRomote = GetDiamondRemote()
    for i = 1, #list do
        task.spawn(function()
            local plr = list[i]
            if not plr then return end
            local char = plr.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            if plr == LocalPlayer then
                humanoid.WalkSpeed = targetSpeed
                return
            end
            local max_health = humanoid.MaxHealth
            local theirspeed = humanoid.WalkSpeed
            local ratio = (targetSpeed / theirspeed - 0.3) / 0.7
            local healthRequired = ratio * max_health
            local domath
            if healthRequired > humanoid.Health then
                domath = -(healthRequired - humanoid.Health)
                print(healthRequired .. " - " .. humanoid.Health .. " = " .. domath)
            elseif healthRequired < humanoid.Health then
                domath = humanoid.Health - healthRequired
                print(humanoid.Health .. " -  " .. healthRequired .. " = " .. domath)
            end
            if domath > humanoid.Health then
                print(domath .. " will kill " .. plr.Name .. " with " .. humanoid.Health)
                return
            end
            sendKillDiamondRemoteToHumanoid(humanoid, diamondRomote, domath)
            print("dealing " .. domath .. "damage to " .. plr.Name)
        end)
    end
    task.wait(0.3)
    equipSorcusAndActivate()
end


local function equipHadesStaffAndActivateAndBlind(List)
    if #List == 0 then return end
    local mychar = LocalPlayer.Character
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    local Humanoid = mychar:FindFirstChildOfClass("Humanoid")
    if not (mychar and Backpack and Humanoid) then return end
    local tool = mychar:FindFirstChild("HadesStaff") or Backpack:FindFirstChild("HadesStaff")
    if not tool then return end
    if tool.Parent == Backpack then
        Humanoid:EquipTool(tool)
    end
    kill(List)
    task.wait(0.3)
    tool:Activate()
    local fak, snowflake = pcall(function()
        return GetHadesStaffSnowFlake()
    end)
    if snowflake then
        task.spawn(function()
            for i = 1, #List do
                task.spawn(function()
                    local v = List[i]
                    if not v or v == LocalPlayer then return end
                    local char = v.Character
                    if not char then return end
                    local head = char:FindFirstChild("Head")
                    if not head then return end
                    TouchAndUnTouch(head, snowflake)
                end)
            end
        end)
    end
    task.wait(0.1)
    if tool.Parent == mychar then
        tool.Parent = Backpack
    end
end

local function CountMap(map)
    local count = 0
    for k, v in pairs(map) do
        count = count + 1
    end
    return count
end

local function findValueOfIndex(index, table)
    local ans = nil
    local count = 0
    for k, v in pairs(table) do
        count = count + 1
        if count == index then
            ans = v
            break
        end
    end
    return ans
end

local MusicList = { ["Alkline Tears"] = 73718692864423 }


local function playMusic(songid)
    pcall(function()
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if not Character then return end
        local backpack = LocalPlayer:WaitForChild("Backpack", 5)
        if not backpack then return end
        local boombox = backpack:WaitForChild("SuperFlyGoldBoombox", 5)
        if not boombox then return end
        boombox.Parent = Character
        Character.SuperFlyGoldBoombox.Remote:FireServer("PlaySong", tonumber(songid))
        boombox.DescendantAdded:wait()
        task.wait()
        boombox.Parent = backpack
        local Sound = boombox:FindFirstChildWhichIsA("Sound", true)
        repeat task.wait() until not Sound.IsPlaying
        Sound:Play()
        Sound.TimePosition = Settings.Time
    end)
end

local function playRandomMusic()
    local randomNum = math.random(1, CountMap(MusicList))
    SoundIDtoPlay = findValueOfIndex(randomNum, MusicList)
    playMusic(SoundIDtoPlay)
    print("playing " .. SoundIDtoPlay)
end

task.spawn(function()
    while true do
        task.wait()
        MainLoop()
    end
end)

local function checkPermisson(v)
    return (whitelist[v] or table.find(LocalPlayerWhiteList, v))
end
local function forLoopForList(List, func, ListToPut)
    for i = 1, #List do
        task.spawn(function()
            local plr = List[i]
            func(ListToPut, plr)
        end)
    end
end

local function forLoopForListUserID(List, func, ListToPut)
    for i = 1, #List do
        task.spawn(function()
            local plr = List[i]
            func(ListToPut, plr.UserId)
        end)
    end
end

local function AnchorPlayer()
    ReplicatedStorage.Remotes.ToggleAsset:InvokeServer(49491808)
    local backpack = LocalPlayer:WaitForChild("Backpack", 2)
    local Character = LocalPlayer.Character
    local Humanoid = Character:WaitForChild("Humanoid", 2)
    local Tool = backpack:WaitForChild("StaffOfPitFire", 2)
    if Tool then
        Humanoid:EquipTool(Tool)
        task.wait()
        if Tool.Parent == Character then
            Tool:Activate()
        end
        ReplicatedStorage.Remotes.ToggleAsset:InvokeServer(49491808)
    end
end

local destroyList = { ["Rocket"] = true, ["Explosion"] = true }
local function processCommands(UserID, str)
    local Rocketconnection = nil
    local PlatformConnection = nil
    local AnchorConnection = nil
    local uncleanedstring = str
    local Chatter = Players:GetPlayerByUserId(UserID)
    local lowerstring = uncleanedstring:lower()
    if lowerstring:sub(1, 1) ~= prefix then return end
    local split = string.sub(lowerstring, 2):split(" ")
    local command = split[1]
    if command == "speed" then
        local targets = FindPlayers(Chatter, split[2])
        local speed = num(split[3])
        if not targets then return end
        walkspeed(targets, speed)
    elseif command == "killaura" then
        local targets = FindPlayers(Chatter, split[2])
        if not targets then return end
        for i = 1, #targets do
            task.spawn(function()
                local plr = targets[i]
                killaura(plr)
            end)
        end
    elseif command == "unkillaura" then
        local targets = FindPlayers(Chatter, split[2])
        if not targets then return end
        for i, v in targets do
            RemoveFromList(killAuraList, v.Name)
        end
    elseif command == "antiplatform" then --may not work very expermential
        if PlatformConnection then return end
        PlatformConnection = RunService.Heartbeat:Connect(function()
            for _, v in pairs(Players:GetPlayers()) do
                task.spawn(function()
                    if v ~= LocalPlayer then
                        pcall(function()
                            local char = v.Character
                            local root = char:FindFirstChild("HumanoidRootPart")
                            root.Size = Vector3.new(100, 100, 100)
                            root.CanCollide = false
                        end)
                    end
                end)
            end
        end)
    elseif command == "startanchor" then
        AnchorPlayer()
        anchorWhenRespawn = true
    elseif command == "stopanchor" then
        anchorWhenRespawn = false
    elseif command == "unantiplatform" then
        if not PlatformConnection then return end
        PlatformConnection:Disconnect()
        PlatformConnection = nil
    elseif command == "pink" then
        equiptoolandColor("Charming Blade")
    elseif command == "green" then
        equiptoolandColor("CloverHammer")
    elseif command == "gold" then
        equiptoolandColor("2018BloxyAward")
    elseif command == "kill" then
        local targets = FindPlayers(Chatter, split[2])
        if not targets then return end
        kill(targets)
    elseif command == "nan" then
        local targets = FindPlayers(Chatter, split[2])
        if not targets then return end
        nanHealth(targets)
    elseif command == "playmusic" or command == "play" then
        pcall(function()
            if split[2] then
                playMusic(split[2])
            else
                playRandomMusic()
            end
        end)
    elseif command == "explode" then
        local targets = FindPlayers(Chatter, split[2])
        if not targets then return end
        fireRocket(targets)
    elseif command == "loopkill" then
        local targets = FindPlayers(Chatter, split[2])
        if not targets then return end
        forLoopForList(targets, insertToList, LoopkillList)
        forLoopForListUserID(targets, insertToList, loopkillRejoinProof)
    elseif command == "unloopkill" then
        local targets = FindPlayers(Chatter, split[2])
        if not targets then return end
        forLoopForList(targets, RemoveFromList, LoopkillList)
        forLoopForListUserID(targets, RemoveFromList, loopkillRejoinProof)
    elseif command == "bp" then
        local targets = FindPlayers(Chatter, split[2])
        if not targets then return end
        for i = 1, #targets do
            local plr = targets[i]
            task.spawn(function()
                baseProtectfun(plr)
            end)
        end
    elseif command == "unbp" then
        local targets = FindPlayers(Chatter, split[2])
        if not targets then return end
        for i, v in targets do
            RemoveFromList(baseProtect, v.Name)
        end
    elseif command == "loopgod" then
        local targets = FindPlayers(Chatter, split[2])
        if targets then
            forLoopForList(targets, insertToList, LoopGodList)
        end
    elseif command == "unloopgod" then
        local targets = FindPlayers(Chatter, split[2])
        if targets then
            forLoopForList(targets, RemoveFromList, LoopGodList)
        end
    elseif command == "blind" then
        local targets = FindPlayers(Chatter, split[2])
        if targets then
            equipHadesStaffAndActivateAndBlind(targets)
        end
    elseif command == "save" then
        local targets = FindPlayers(Chatter, split[2])
        if targets then
            forLoopForList(targets, insertToList, saveList)
        end
    elseif command == "unsave" then
        local targets = FindPlayers(Chatter, split[2])
        if targets then
            forLoopForList(targets, RemoveFromList, saveList)
        end
    elseif command == "removerockets" then
        Rocketconnection = Workspace.ChildAdded:Connect(function(v)
            if destroyList[v.Name] then
                task.wait()
                v:Remove()
            end
        end)
    elseif command == "unremoverockets" then
        if Rocketconnection then
            Rocketconnection:Disconnect()
            Rocketconnection = nil
        end
    elseif command == "loopexplode" then
        local targets = FindPlayers(Chatter, split[2])
        if targets then
            forLoopForList(targets, insertToList, RocketList)
        end
    elseif command == "unloopexplode" then
        local targets = FindPlayers(Chatter, split[2])
        if targets then
            forLoopForList(targets, RemoveFromList, RocketList)
        end
    elseif command == "god" then
        local targets = FindPlayers(Chatter, split[2])
        if targets then
            infhp(targets)
        end
    elseif command == "cmds" then
        Chat("/w " .. Chatter.Name .. " commands: kill, damage, god, ")
    elseif command == "whitelist" then
        local targets = FindPlayers(Chatter, split[2])
        if targets then
            for i = 1, #targets do
                task.spawn(function()
                    local plr = targets[i]
                    if checkPermisson(plr) then return end
                    whitelist[plr.UserId] = true
                end)
            end
        end
    elseif command == "unwhitelist" then
        local targets = FindPlayers(Chatter, split[2])
        if targets then
            for i = 1, #targets do
                task.spawn(function()
                    local plr = targets[i]
                    if not checkPermisson(plr) then return end
                    if plr.UserId == LocalPlayer.UserId then
                        LocalPlayerWhiteList[plr.UserId] = false
                    elseif plr.UserId ~= LocalPlayer.UserId then
                        whitelist[plr.UserId] = false
                    end
                end)
            end
        end
    elseif command == "dmg" or command == "damage" then
        local targets = FindPlayers(Chatter, split[2])
        local dmgnum = num(split[3])
        if targets and dmgnum then
            damage(targets, dmgnum)
        end
    end
end

TextChatService.MessageReceived:Connect(function(messageInstance)
    local UserId = messageInstance.TextSource.UserId
    if not ((UserId and checkPermisson(UserId)) or publicMode) then return end
    local msg = messageInstance.Text
    processCommands(UserId, msg)
end)

local function CheckForBlackListKill(v)
    local ID = v.UserId
    if table.find(loopkillRejoinProof, ID) then
        insertToList(LoopkillList, v)
    end
end

local function RemoveMyBaseForceField(Player)
    local plrName = Player.Name
    local cloudname = plrName .. "'s Cloud"
    local cloud = Workspace:FindFirstChild(cloudname)
    if cloud then
        local myff = cloud:WaitForChild("ForceField", 1)
        if myff then
            myff:Destroy()
        end
    end
end

Players.PlayerRemoving:Connect(function(v)
    RemoveFromList(baseProtect, v.Name)
    RemoveFromList(killAuraList, v.Name)
end)


LocalPlayer.CharacterAdded:Connect(function(v)
    if anchorWhenRespawn then
        AnchorPlayer()
    end
end)

PlayerGui.ChildAdded:Connect(function(v)
    task.wait()
    if BlindGuisTable[v.Name] then
        v:Destroy()
    end
end)

local function PlayerJoinedSetUp(v)
    CheckForBlackListKill(v)
end

for _, v in pairs(Players:GetPlayers()) do
    PlayerJoinedSetUp(v)
end

Players.PlayerAdded:Connect(function(v)
    PlayerJoinedSetUp(v)
end)

task.spawn(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false) end)

task.spawn(function()
    pcall(function()
        task.wait(60)
        Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end)

print("finished connecting!")

if game.PlaceId == 26838733 then
    if creator then
        --ReplicatedStorage.Remotes.BecomeAvatar:FireServer("1967676620") --for the cool avatar!
    end
    task.wait(1)
    ToggleAsset(34898883)  --Positronic-Platform-Producer
    ToggleAsset(68539623)  --Korblox-Sword-and-Shield
    ToggleAsset(173755801) --Diamond-Blade-Sword
    ToggleAsset(169602103) -- Seranoks-Rocket-Jumper
    --[[
    ToggleAsset(69210321)   --Hades-Staff-of-Darkness-A-Gamestop-Exclusive
    ToggleAsset(106064277)  --cupid blade
    ToggleAsset(108153884)  --lucky hammer
    ToggleAsset(1469987740) -- bloxxy 1018
    ToggleAsset(53623322)   -- sorcus sword
    ToggleAsset(212641536)  -- boombox
    ]] --
end

StarterGui:SetCore("SendNotification", {
    Title = "Script Loaded!",
    Text = "I'm so silly :3",
    Duration = 5,
})
