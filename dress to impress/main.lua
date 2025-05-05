local plr = game.Players.LocalPlayer.Name
local money1 = game.Workspace.CollectibleMoney.DressingRoom:GetChildren()
local money2 = game.Workspace.CollectibleMoney.Lobby:GetChildren()
local money3 = game.Workspace.CollectibleMoney.Obby:GetChildren()
local money4 = game.Workspace.CollectibleMoney.VIP:GetChildren()


local UserInputService = game:GetService("UserInputService")

local chosenKey = Enum.KeyCode.P

local activeOuPas = false

local function toggleKeybind()
    activeOuPas = not activeOuPas
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == chosenKey and not gameProcessed then
        toggleKeybind()
        if activeOuPas then
            collectMoney()
        end
    end
end)

local funciton collectMoney()
    if not activeOuPas then return end
    for _,v in pairs(money1) do
        game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(v.Position)
        wait(0.2)
    end
    
    for _,v in pairs(money2) do
        game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(v.Position)
        wait(0.2)
    end

    for _,v in pairs(money3) do
        game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(v.Position)
        wait(0.2)
    end

    for _,v in pairs(money4) do
        game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(v.Position)
        wait(0.2)
    end
end