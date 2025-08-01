--I am aware that it is unorganize as hell, and doesn't scale well.
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
local Remotes              = ReplicatedStorage:WaitForChild("Remotes", 4)
local LocalPlayer          = Players.LocalPlayer
local PlayerGui            = LocalPlayer:WaitForChild("PlayerGui", 4)
local BlindGuisTable       = { ScreenFog = true, DarknessGui = true, VolleyballScreenGui = true, FlashBangEffect = true }
local LocalPlayerWhiteList = { LocalPlayer.UserId }
local gearTable            = {
    ["Diamond Blade Sword"] = { ["name"] = "Diamond Blade Sword", ["id"] = 173755801 },
    ["HadesStaff"] = { ["name"] = "HadesStaff", ["id"] = 69210321 },
    ["Charming Blade"] = { ["name"] = "Charming Blade", ["id"] = 106064277 },
    ["CloverHammer"] = { ["name"] = "CloverHammer", ["id"] = 108153884 },
    ["2018BloxyAward"] = { ["name"] = "2018BloxyAward", ["id"] = 1469987740 },
    ["SpaceSword"] = { ["name"] = "SpaceSword", ["id"] = 170903610 },
    ["Balligator"] = { ["name"] = "Balligator", ["id"] = 292969458 },
    ["KorbloxSwordAndShield"] = { ["name"] = "KorbloxSwordAndShield", ["id"] = 68539623 },
    ["StepGun"] = { ["name"] = "StepGun", ["id"] = 34898883 },
    ["SuperFlyGoldBoombox"] = { ["name"] = "SuperFlyGoldBoombox", ["id"] = 212641536 },
    ["RocketJumper"] = { ["name"] = "RocketJumper", ["id"] = 169602103 },
    ["SorcusSword"] = { ["name"] = "SorcusSword", ["id"] = 53623322 },
    ["StaffOfPitFire"] = { ["name"] = "StaffOfPitFire", ["id"] = 49491808 }
}
local adminCommands        = {}
local LoopkillList         = {}
local LoopGodList          = {}
local whitelist            = {}
local FFkillList           = {}
local saveList             = {}
local ExplodeList          = {}
local loopkillRejoinProof  = {}
local baseProtectionList   = {}
local killAuraList         = {}
local killnewplayers       = false
local autocrash            = false
local LegacyKillMethod     = true  --this makes the script more stable and reduces crashes
local creator              = false --this gives avatar
local publicMode           = false --this makes that everyone can use your commands
local Rocketconnection     = nil
local PlatformConnection   = nil
local NaN                  = 0 / 0
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

local function Notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 6,
    })
end

Notify("Catalog Heaven Admin Script; verison july 31 2025", "Loading script..." .. "\nPrefix is" .. " {" .. prefix .. "}")


local function number(str)
    if str == nil then
        return 0 / 0
    elseif str == "inf" then
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

local function insertToList(list, v)
    local index = table.find(list, v)
    if index then return end
    table.insert(list, v)
end

local function RemoveFromList(List, Thing)
    local index = table.find(List, Thing)
    if not index then return end
    table.remove(List, index)
end


local function FindPlayers(Me, input)
    local foundTargets = {}
    if not input then
        print("No player input")
        return
    end
    local target = input:lower()
    local allplayers = Players:GetPlayers()
    if not target then return end
    if target == "all" then
        foundTargets = allplayers
    elseif target == "me" then
        table.insert(foundTargets, Me)
    elseif target == "hackers" then
        for i = 1, #allplayers do
            local plr = allplayers[i]
            local backpack = plr and plr:FindFirstChild("Backpack")
            local char = plr.Character
            if backpack and char and (backpack:FindFirstChild("Diamond Blade Sword") or backpack:FindFirstChild("RocketJumper") or char:FindFirstChild("RocketJumper") or char:FindFirstChild("Diamond Blade Sword")) then
                table.insert(foundTargets, plr)
            end
        end
    elseif target == "blacks" or target == "colored" then
        for i = 1, #allplayers do
            pcall(function()
                local plr = allplayers[i]
                local char = plr.Character
                if not char then return end
                local head = char:FindFirstChild("Head")
                if head then
                    local headColor = head.Color
                    local r = headColor.R * 255
                    local g = headColor.G * 255
                    local b = headColor.B * 255
                    if not (r > 200 and g > 80 and b > 10) then --Targets darker skin tone including brown and black.
                        table.insert(foundTargets, plr)
                    end
                end
            end)
        end
    elseif target == "bacons" then
        for i = 1, #allplayers do
            local plr = allplayers[i]
            local char = plr.Character
            if char then
                local condiction = char:FindFirstChild("Pal Hair")
                if condiction then
                    table.insert(foundTargets, plr)
                end
            end
        end
    elseif target == "nonhackers" then
        for i = 1, #allplayers do
            local plr = allplayers[i]
            local backpack = plr and plr:FindFirstChild("Backpack")
            local char = plr.Character
            if backpack and char and not (backpack:FindFirstChild("Diamond Blade Sword") or backpack:FindFirstChild("RocketJumper") or char:FindFirstChild("RocketJumper") or char:FindFirstChild("Diamond Blade Sword")) then
                table.insert(foundTargets, plr)
            end
        end
    elseif target == "ff" then
        for i = 1, #allplayers do
            local plr = allplayers[i]
            local char = plr.Character
            if char then
                local condiction = char:FindFirstChild("ForceField")
                if condiction then
                    table.insert(foundTargets, plr)
                end
            end
        end
    elseif target == "others" then
        for i = 1, #allplayers do
            local plr = allplayers[i]
            if plr ~= Me then
                table.insert(foundTargets, plr)
            end
        end
    else
        for i = 1, #allplayers do
            local plr = allplayers[i]
            if (string.sub(plr.Name:lower(), 1, #target) == target or string.sub(plr.DisplayName:lower(), 1, #target) == target) then
                table.insert(foundTargets, plr)
            end
        end
    end

    task.spawn(function()
        if #foundTargets == 0 then return end
        local namelist = {}
        for i = 1, #foundTargets do
            local plr = foundTargets[i]
            table.insert(namelist, plr.Name)
        end
        local AllName = table.concat(namelist, ", ")
        print(Me.Name .. " called " .. AllName .. " with the input " .. input)
    end)

    return foundTargets
end

local function removeFirstElement(tbl)
    local tableToReturn = {}
    for i = 1, #tbl do
        if i ~= 1 then
            table.insert(tableToReturn, tbl[i])
        end
    end
    return tableToReturn
end

adminCommands.parse = function(UserID, text)
    local Player = Players:GetPlayerByUserId(UserID)
    local lowerstring = text:lower()
    if lowerstring:sub(1, 1) ~= prefix then return end
    local splitString = string.sub(lowerstring, 2):split(" ")
    local command = splitString[1]
    if adminCommands[command] then
        local payload = { ["player"] = Player, ["data"] = removeFirstElement(splitString) }
        adminCommands[command](payload)
    end
end

local function ToggleAsset(id)
    ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("ToggleAsset"):InvokeServer(id)
end

local function RetoggleGear(id)
    ToggleAsset(id)
    ToggleAsset(id)
end

local function GetCharacterAndBackpack()
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack", 1)
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
    if not (myTorso or myTorso.Anchored) then return end

    local sword = storage:FindFirstChild("KorbloxSwordAndShield") or character:FindFirstChild("KorbloxSwordAndShield")
    if not sword then return end
    task.spawn(function() cleanball() end)
    local cloneList = FFkillList
    for i = 1, #cloneList do
        local Player = cloneList[i]

        local char = Player.Character

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
                local target = FFkillList[i].Character
                if not target then return end
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
            args[1] = CFrame.new(NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN)
        end
        return shothook(self, unpack(args))
    end)
end)

if not success then
    print(err)
end

local function infhp(table)
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

local function Explode(List)
    if #List == 0 then return end
    local RocketRemoteEvent = GetRocketRemote()
    if not RocketRemoteEvent then return end
    for i = 1, #List do
        task.spawn(function()
            local plr = List[i]
            if not plr then return end
            local TargetCharacter = plr.Character
            if not TargetCharacter then return end
            local head = TargetCharacter:FindFirstChild("Head")
            if not head then return end
            local humanoid = TargetCharacter:FindFirstChildOfClass("Humanoid")
            if not isAlive(humanoid) then return end
            local StartingPosition = head.Position
            RocketRemoteEvent:FireServer(StartingPosition - Vector3.new(0, 1, 0), StartingPosition)
        end)
    end
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

local function TouchInterestPlatformKill(plr) --old unstable pltaform kill
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

local function kill(table)
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
                        insertToList(FFkillList, target)
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

local function isGearExist(gearName)
    local char, backpack = GetCharacterAndBackpack()
    if not char and backpack then return nil end
    return (backpack:FindFirstChild(gearName) ~= nil or char:FindFirstChild(gearName) ~= nil)
end



adminCommands["loopexplode"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    if player and target then
        local findtargets = FindPlayers(player, target[1])
        if findtargets == nil then return end
        for i, v in pairs(findtargets) do
            insertToList(ExplodeList, v)
        end
    end
end


adminCommands["god"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    if player and target then
        local findtargets = FindPlayers(player, target[1])
        if findtargets then
            infhp(findtargets)
        end
    end
end


adminCommands["loopgod"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    if player and target then
        local findtargets = FindPlayers(player, target[1])
        if findtargets == nil then return end
        for _, v in pairs(findtargets) do
            insertToList(LoopGodList, v)
        end
    end
end


adminCommands["unloopkill"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    if player and target then
        local findtargets = FindPlayers(player, target[1])
        if findtargets == nil then return end
        for i, v in pairs(findtargets) do
            RemoveFromList(LoopkillList, v)
            RemoveFromList(loopkillRejoinProof, v.UserId)
        end
    end
end

local function checkPermisson(v)
    return (whitelist[v] or table.find(LocalPlayerWhiteList, v))
end

adminCommands["whitelist"] = function(payload)
    local player = payload["player"]
    local target = payload["data"][1]
    local targets = FindPlayers(player, target[1])
    if targets then
        for i = 1, #targets do
            task.spawn(function()
                local plr = targets[i]
                if checkPermisson(plr) then return end
                whitelist[plr.UserId] = true
            end)
        end
    end
end

adminCommands["unwhitelist"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    if player and target then
        local targets = FindPlayers(player, target[1])
        if targets then
            for i = 1, #targets do
                task.spawn(function()
                    local plr = targets[i]
                    if not checkPermisson(plr) then return end
                    if plr.UserId ~= LocalPlayer.UserId then
                        whitelist[plr.UserId] = false
                    end
                end)
            end
        end
    end
end

local function sendKillDiamondRemoteToHumanoid(remote, Humanoid, damage)
    if Humanoid then
        remote:InvokeServer(7, Humanoid, damage)
    end
end

local function sendDiamondRemoteToPlayersTable(remote, targets, damage)
    for i = 1, #targets do
        task.spawn(function()
            local player = targets[i]
            if not player then return end
            local character = player.Character
            if not (player and remote and character) then return end
            local Humanoid = character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                remote:InvokeServer(7, Humanoid, damage)
            end
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



local function baseprotection(myPlayer)
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
    insertToList(baseProtectionList, playerName)
    task.wait()
    while checkTrueIfInList(baseProtectionList, playerName, myPlayer) do
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
local function nanHealth(table)
    local remote = GetDiamondRemote()
    if remote then
        sendDiamondRemoteToPlayersTable(remote, table, NaN)
    end
end


local function MainLoop()
    pcall(function()
        task.spawn(function()
            if #LoopkillList == 0 then return end
            kill(LoopkillList)
        end)
        task.spawn(function()
            if #LoopGodList == 0 then return end
            infhp(LoopGodList)
        end)
        task.spawn(function()
            if #saveList == 0 then return end
            nanHealth(saveList)
        end)
        task.spawn(function()
            if #FFkillList == 0 then return end
            LegacykorbloxNew()
        end)
        task.spawn(function()
            if #ExplodeList == 0 then return end
            Explode(ExplodeList)
        end)
    end)
end

task.spawn(function()
    while true do
        task.wait()
        task.spawn(function()
            MainLoop()
        end)
    end
end)

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

task.spawn(function()
    for _, v in pairs(PlayerGui:GetChildren()) do
        if BlindGuisTable[v.Name] then
            v:Destroy()
        end
    end
end)


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
        local backpack = LocalPlayer:WaitForChild("Backpack", 2)
        if not backpack then return end
        local boombox = backpack:WaitForChild("SuperFlyGoldBoombox", 2)
        if not boombox then return Notify("Missing gear", "boombox needed") end
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

adminCommands["play"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    if player and target then
        playMusic(target)
    end
end

local function playRandomMusic()
    local randomNum = math.random(1, CountMap(MusicList))
    SoundIDtoPlay = findValueOfIndex(randomNum, MusicList)
    playMusic(SoundIDtoPlay)
    print("playing " .. SoundIDtoPlay)
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


local function crashfunction() --thanks for leaking inter crash, now my script is finished!
    local Character = LocalPlayer.Character
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    if not (Character and Backpack) then return end
    local AligatorGear = Backpack:FindFirstChild("Balligator") or Character:FindFirstChild("Balligator")
    local Intergalatic = Backpack:FindFirstChild("SpaceSword") or Backpack:FindFirstChild("SpaceSword")
    if not (AligatorGear and Intergalatic) then return end
    if AligatorGear.Parent == Backpack then
        AligatorGear.Parent = Character
    end
    if Intergalatic.Parent == Backpack then
        Intergalatic.Parent = Character
    end
    AligatorGear:WaitForChild("Remote", 5):WaitForChild("Spawn", 5):InvokeServer()
    local aligator = Character:FindFirstChildOfClass("Model")
    aligator:PivotTo(CFrame.new(Vector3.new(8610111412132831051081081215851, 8610111412132831051081081215851,
        8610111412132831051081081215851)))
    Intergalatic:WaitForChild("ControlFunction", 5):InvokeServer("KeyDown", "q")
end



local bindable = Instance.new("BindableFunction")
function bindable.OnInvoke(response)
    if response == "Get gears and crash" then
        ToggleAsset(292969458)
        ToggleAsset(170903610)
        task.wait(0.1)
        crashfunction()
    end
    if response == "get required gear" then
        ToggleAsset(53623322)
    end
    if response == "get blind staff" then
        ToggleAsset(69210321)
    end
    if response == "get pink" then
        ToggleAsset(106064277) --cupid blade
        task.wait(0.1)
        ColorAllParts("Charming Blade")
    end
    if response == "get green" then
        ToggleAsset(108153884) --lucky hammer
        task.wait(0.1)

        ColorAllParts("CloverHammer")
    end
    if response == "get gold" then
        ToggleAsset(1469987740) -- bloxxy 1018
        task.wait(0.1)
        ColorAllParts("2018BloxyAward")
    end
    if gearTable[response] then
        ToggleAsset(gearTable[response]["id"])
    end
end

local function requestGear(gearCallback)
    StarterGui:SetCore("SendNotification", {
        Title = "Missing Gears",
        Text = "get required gear and try again.",
        Duration = 10,
        Callback = bindable,
        Button1 = gearCallback,
        Button2 = "Nevermind"
    })
end

local function equiptoolandColor(tool)
    local char, backpack = GetCharacterAndBackpack()
    local foundTool = char:FindFirstChild(tool) or backpack:FindFirstChild(tool)
    if foundTool then
        ColorAllParts(tool)
        return
    end
    if tool == "Charming Blade" then
        requestGear("get pink")
    elseif tool == "CloverHammer" then
        requestGear("get green")
    elseif tool == "2018BloxyAward" then
        requestGear("get gold")
    end
end

local function getEveryoneButLocalPlayer(List)
    local NotLocalPlayers =  {}
    for i = 1, #List do
        local player = List[i]
        if player ~= LocalPlayer then
            table.insert(NotLocalPlayers,player)
        end

    end
    return NotLocalPlayers
end
local function BlindStableVerison(List)
    if #List == 0 then return end
    local mychar = LocalPlayer.Character
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    local Humanoid = mychar:FindFirstChildOfClass("Humanoid")
    local myTorso = mychar:FindFirstChild("Torso") or mychar:FindFirstChild("UpperTorso")
    if not (mychar and Backpack and Humanoid and myTorso) then return end
    local tool = mychar:FindFirstChild("HadesStaff") or Backpack:FindFirstChild("HadesStaff")
    if not tool then
        requestGear("get blind staff")
        return
    end
    if tool.Parent == Backpack then
        Humanoid:EquipTool(tool)
    end
    kill(getEveryoneButLocalPlayer(List))
    task.wait(0.3)
    tool:Activate()
    for i = 1, #List do
        task.spawn(function()
            local player = List[i]
            local char = player.Character
            if not char then return end
            local targetHumanoid = char:FindFirstChildOfClass("Humanoid")
            if not targetHumanoid then return end
            local head = char:FindFirstChild("Head")
            if not head then return end
            if targetHumanoid.Health == 0 then
            head.Anchored = true
            head.CFrame = myTorso.CFrame * CFrame.new(0, -5, 0)
            head.Size = Vector3.new(100, 5, 50)
            head.CanCollide = false
            head.CanQuery = false
            head.Transparency = 1
            end
        end)
    end
    task.wait(0.1)
    if tool.Parent == mychar then
        tool.Parent = Backpack
    end
end

local function equipHadesStaffAndActivateAndBlind(List)
    if #List == 0 then return end
    local mychar = LocalPlayer.Character
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    local Humanoid = mychar:FindFirstChildOfClass("Humanoid")
    if not (mychar and Backpack and Humanoid) then return end
    local tool = mychar:FindFirstChild("HadesStaff") or Backpack:FindFirstChild("HadesStaff")
    if not tool then
        requestGear("get blind staff")
        return
    end
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

adminCommands["blind"] = function(payload)
    local player = payload["player"]
    local data = payload["data"]
    Notify("Blind is expermential", "please open your base ForceField work")
    if player and data then
        local findplayers = FindPlayers(player, data[1])
        if findplayers then
            BlindStableVerison(findplayers)
        end
    end
end

local function CrashCommand()
    local Character = LocalPlayer.Character
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    if not (Character and Backpack) then return end
    local AligatorGear = Backpack:FindFirstChild("Balligator") or Character:FindFirstChild("Balligator")
    local Intergalatic = Backpack:FindFirstChild("SpaceSword") or Backpack:FindFirstChild("SpaceSword")
    if (AligatorGear and Intergalatic) then
        crashfunction()
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Missing Gears",
            Text = "Intergalactic Sword, From the Vault: Alligator Plushie",
            Duration = 10,
            Callback = bindable,
            Button1 = "Get gears and crash",
            Button2 = "Nevermind"
        })
    end
end
adminCommands["unloopexplode"] = function(payload)
    local player = payload["player"]
    local target = payload["data"][1]
    if player and target then
        local findtargets = FindPlayers(target)
        if findtargets == nil then return end
        for i, v in pairs(findtargets) do
            RemoveFromList(ExplodeList, v)
        end
    end
end
adminCommands["explode"] = function(payload)
    local player = payload["player"]
    local target = payload["data"][1]

    if player and target then
        local findtargets = FindPlayers(target)
        if findtargets == nil then return end
        Explode(findtargets)
    end
end

adminCommands["crash"] = function(payload)
    CrashCommand()
end

local function equipSorcusAndActivate()
    local char, backpack = GetCharacterAndBackpack()
    local sword = equiptool("SorcusSword")
    if not sword then
        StarterGui:SetCore("SendNotification", {
            Title = "Missing Gears",
            Text = "get required gear and try again.",
            Duration = 10,
            Callback = bindable,
            Button1 = "get required gear",
            Button2 = "Nevermind"
        })
        return
    end
    if sword.Parent == char then
        sword:WaitForChild("Input", 5):FireServer("Key", true, { Name = "x" })
    end
    sword.Parent = backpack
    task.wait(0.6)
    RetoggleGear(gearTable["SorcusSword"]["id"])
end

local function walkspeed(list, spd)
    local targetSpeed = number(spd)
    local DiamondRemote = GetDiamondRemote()
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
            sendKillDiamondRemoteToHumanoid(DiamondRemote, humanoid, domath)
            print("dealing " .. domath .. "damage to " .. plr.Name)
        end)
    end
    task.wait(0.3)
    equipSorcusAndActivate()
end


local function checkAndGetGear(gearName)
    pcall(function()
        task.spawn(function()
            if not isGearExist(gearName) then
                requestGear(gearTable[gearName]["name"])
            end
        end)
    end)
end


adminCommands["speed"] = function(payload)
    local player = payload["player"]
    local data = payload["data"]
    checkAndGetGear(gearTable["Diamond Blade Sword"]["name"])
    if player and data then
        local findplayers = FindPlayers(player, data[1])
        if findplayers then
            walkspeed(findplayers, data[2])
        end
    end
end

adminCommands["killaura"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    checkAndGetGear(gearTable["Diamond Blade Sword"]["name"])

    if player and target then
        local findtargets = FindPlayers(player, target[1])
        if findtargets == nil then return end
        killaura(findtargets)
    end
end

adminCommands["unkillaura"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    checkAndGetGear(gearTable["Diamond Blade Sword"]["name"])

    if player and target then
        local findtargets = FindPlayers(player, target[1])
        if findtargets == nil then return end
        for _, v in pairs(findtargets) do
            RemoveFromList(killAuraList, v.Name)
        end
    end
end


adminCommands["nan"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    checkAndGetGear(gearTable["Diamond Blade Sword"]["name"])

    if player and target then
        local findtargets = FindPlayers(player, target[1])
        if findtargets == nil then return end
        nanHealth(findtargets)
    end
end

adminCommands["save"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    checkAndGetGear(gearTable["Diamond Blade Sword"]["name"])

    if player and target then
        local findtargets = FindPlayers(player, target[1])
        if findtargets == nil then return end
        for i, v in pairs(findtargets) do
            insertToList(saveList, v)
        end
    end
end

adminCommands["unsave"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    checkAndGetGear(gearTable["Diamond Blade Sword"]["name"])

    if player and target then
        local findtargets = FindPlayers(player, target[1])
        if findtargets == nil then return end
        for i, v in pairs(findtargets) do
            RemoveFromList(saveList, v)
        end
    end
end

adminCommands["bp"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    checkAndGetGear(gearTable["Diamond Blade Sword"]["name"])

    if player and target then
        local findtargets = FindPlayers(player, target[1])
        if findtargets == nil then return end
        baseprotection(findtargets)
    end
end

adminCommands["unbp"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    checkAndGetGear(gearTable["Diamond Blade Sword"]["name"])

    if player and target then
        local findtargets = FindPlayers(player, target[1])
        if findtargets == nil then return end
        for _, v in pairs(findtargets) do
            RemoveFromList(baseProtectionList, v.Name)
        end
    end
end

adminCommands["kill"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    checkAndGetGear(gearTable["Diamond Blade Sword"]["name"])

    if player and target then
        local findtargets = FindPlayers(player, target[1])
        if findtargets == nil then return end
        kill(findtargets)
    end
end
local function dealDamage(table, dmg)
    local DamageToDeal = number(dmg)
    checkAndGetGear(gearTable["Diamond Blade Sword"]["name"])

    local remote = GetDiamondRemote()
    if remote then
        sendDiamondRemoteToPlayersTable(remote, table, DamageToDeal)
    end
end

adminCommands["damage"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    checkAndGetGear(gearTable["Diamond Blade Sword"]["name"])

    if player and target then
        local findtargets = FindPlayers(player, target[1])
        if findtargets == nil then return end
        dealDamage(findtargets, target[2])
    end
end

local function AnchorPlayer()
    ToggleAsset(49491808)
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
        ToggleAsset(49491808)
    end
end

adminCommands["toggleanchor"] = function(payload)
    if anchorWhenRespawn == false then
        AnchorPlayer()
        anchorWhenRespawn = true
    else
        anchorWhenRespawn = false
    end
end

adminCommands["togglecrash"] = function(payload)
    if autocrash then
        autocrash = false
    else
        autocrash = true
        CrashCommand()
        task.wait(0.1)
        while autocrash do
            task.wait()
            pcall(function()
                crashfunction()
            end)
        end
    end
end

adminCommands["togglekillmethod"] = function()
    LegacyKillMethod = not LegacyKillMethod
end

adminCommands["debug"] = function(payload)
    local messages = payload["data"]
    if messages then
        for i, v in pairs(messages) do
            print(i .. ", " .. v)
        end
    end
end

adminCommands["toggleantiplatform"] = function()
    Notify("expermential", "may not work")
    if PlatformConnection then
        PlatformConnection:Disconnect()
        PlatformConnection = nil
    else
        PlatformConnection = RunService.Heartbeat:Connect(function()
            for _, v in pairs(Players:GetPlayers()) do
                task.spawn(function()
                    if v ~= LocalPlayer then
                        pcall(function()
                            local char = v.Character
                            if not char then return end
                            local root = char:FindFirstChild("HumanoidRootPart")
                            if not root then return end
                            root.Size = Vector3.new(100, 100, 100)
                            root.CanCollide = false
                        end)
                    end
                end)
            end
        end)
    end
end

adminCommands["loopkill"] = function(payload)
    local player = payload["player"]
    local target = payload["data"]
    checkAndGetGear(gearTable["Diamond Blade Sword"]["name"])
    if player and target then
        local findtargets = FindPlayers(player, target[1])
        if findtargets == nil then return end
        for _, v in pairs(findtargets) do
            task.spawn(function()
                insertToList(LoopkillList, v)
            end)
        end
    end
end

local destroyList = { ["Rocket"] = true, ["Explosion"] = true }


adminCommands["togglehiderockets"] = function()
    if not Rocketconnection then
        Rocketconnection = Workspace.ChildAdded:Connect(function(v)
            if destroyList[v.Name] then
                task.wait()
                v:Remove()
            end
        end)
    else
        Rocketconnection:Disconnect()
        Rocketconnection = nil
    end
end


adminCommands["pink"] = function()
    equiptoolandColor("Charming Blade")
end
adminCommands["green"] = function()
    equiptoolandColor("CloverHammer")
end
adminCommands["gold"] = function()
    equiptoolandColor("2018BloxyAward")
end

adminCommands["cmds"] = function()
    Notify("Check console", "/console in chat")
    for i, _ in adminCommands do
        print(i)
    end
end

local function processCommands(UserID, str) --parse
    local uncleanedstring = str
    local Chatter = Players:GetPlayerByUserId(UserID)
    local lowerstring = uncleanedstring:lower()
    if lowerstring:sub(1, 1) ~= prefix then return end
    local split = string.sub(lowerstring, 2):split(" ")
    local command = split[1]
    if command == "speed" then
        local targets = FindPlayers(Chatter, split[2])
        local speed = number(split[3])
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
    elseif command == "changekillmethod" then
        LegacyKillMethod = not LegacyKillMethod
    elseif command == "unkillaura" then
        local targets = FindPlayers(Chatter, split[2])
        if not targets then return end
        for i, v in targets do
            RemoveFromList(killAuraList, v.Name)
        end
    elseif command == "antiplatform" then --may not work very expermential
        if split[2] == "false" then
            if not PlatformConnection then return end
            PlatformConnection:Disconnect()
            PlatformConnection = nil
        else
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
        end
    elseif command == "debug" then
        for i, v in pairs(split) do
            print(i .. ", " .. v)
        end
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
        Explode(targets)
    elseif command == "autocrash" then
        local bool = split[2]
        if bool == "false" then
            autocrash = false
        else
            autocrash = true
            CrashCommand()
            task.wait(0.1)
            while autocrash do
                task.wait()
                pcall(function()
                    crashfunction()
                end)
            end
        end
    elseif command == "crash" then
        CrashCommand()
    elseif command == "autokill" then
        local bool = split[2]
        if bool == "false" then
            killnewplayers = false
        else
            killnewplayers = true
        end
    elseif command == "autoanchor" then
        local bool = split[2]
        if bool == "false" then
            anchorWhenRespawn = false
        else
            anchorWhenRespawn = true
            AnchorPlayer()
        end
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
                baseprotection(plr)
            end)
        end
    elseif command == "unbp" then
        local targets = FindPlayers(Chatter, split[2])
        if not targets then return end
        for i, v in targets do
            RemoveFromList(baseProtectionList, v.Name)
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
            forLoopForList(targets, insertToList, ExplodeList)
        end
    elseif command == "unloopexplode" then
        local targets = FindPlayers(Chatter, split[2])
        if targets then
            forLoopForList(targets, RemoveFromList, ExplodeList)
        end
    elseif command == "god" then
        local targets = FindPlayers(Chatter, split[2])
        if targets then
            infhp(targets)
        end
    elseif command == "cmds" then
        print([[ crash, loopkill target, unloopkill target,
        ]])
        Notify("type /console in chat", "to view some commands")
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
        local damage = number(split[3])
        if targets then
            dealDamage(targets, damage)
        end
    end
end

TextChatService.MessageReceived:Connect(function(messageInstance)
    local UserId = messageInstance.TextSource.UserId
    if not ((UserId and checkPermisson(UserId)) or publicMode) then return end
    local msg = messageInstance.Text
    if UserId and msg then
        --processCommands(UserId, msg) --Old verison if you wanna use
        adminCommands.parse(UserId, msg)
    end
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
    RemoveFromList(baseProtectionList, v.Name)
    RemoveFromList(killAuraList, v.Name)
    RemoveFromList(FFkillList, v)
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
    if killnewplayers then
        insertToList(LoopkillList, v)
        insertToList(loopkillRejoinProof, v.UserId)
    end
end

for _, v in pairs(Players:GetPlayers()) do
    PlayerJoinedSetUp(v)
end

Players.PlayerAdded:Connect(function(v)
    PlayerJoinedSetUp(v)
end)

task.spawn(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false) end) --disable red blood mark when dies

task.spawn(function()                                                                   --anti afk script
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
        Remotes.BecomeAvatar:FireServer("1967676620") --for the cool avatar!
    end
    task.wait(1)
    --ballingator and intergalatic
    ToggleAsset(gearTable["Balligator"]["id"])
    ToggleAsset(gearTable["SpaceSword"]["id"])

    --gears that kill
    ToggleAsset(gearTable["StepGun"]["id"])               --Positronic-Platform-Producer
    ToggleAsset(gearTable["KorbloxSwordAndShield"]["id"]) --Korblox-Sword-and-Shield
    ToggleAsset(gearTable["Diamond Blade Sword"]["id"])   --Diamond-Blade-Sword
    ToggleAsset(gearTable["RocketJumper"]["id"])          -- Seranoks-Rocket-Jumper
    --else
    --[[
    ToggleAsset(69210321)   --Hades-Staff-of-Darkness-A-Gamestop-Exclusive
    ToggleAsset(106064277)  --cupid blade
    ToggleAsset(108153884)  --lucky hammer
    ToggleAsset(1469987740) -- bloxxy 1018
    ToggleAsset(53623322)   -- sorcus sword
    ToggleAsset(212641536)  -- boombox

    ]] --
end


Notify("Script Loaded!", "I'm so silly :3")

Notify("How to use", "Type " .. prefix .. "cmds to for a list of commands")
