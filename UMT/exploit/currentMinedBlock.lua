local plr = game.Players.LocalPlayer.Name

-- game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(-1853.72, 4.88, -194.68)

local plrPosition = game.Workspace[plr].HumanoidRootPart.Position
local targetPosition = game.Workspace:WaitForChild("HoverSelectionBox2", 10).Position

local targetX = targetPosition.X + 2
local targetY = targetPosition.Y - 2
local targetZ = targetPosition.Z + 2

print("Player Position:", plrPosition)
print("Target Block Position:", targetPosition)
print("")
print("")
print("")
print("New X ", targetX)
print("New Y ", targetY)
print("New Z ", targetZ)
print("")


----------------------------------------------------------------------------------



-- local Toggle = AutoFarmTab:CreateToggle({
--     Name = "Toggle Example",
--     CurrentValue = false,
--     Flag = "Toggle1",
--     Callback = function(Value)
--         runningHoverCheck = Value

--         task.spawn(function()
--             while runningHoverCheck do
--                 local plr = game.Players.LocalPlayer.Name
--                 local plrPosition = game.Workspace[plr].HumanoidRootPart.Position

--                 local hoverBox = game.Workspace:FindFirstChild("HoverSelectionBox2")
--                 if hoverBox then
--                     local targetPos = hoverBox.Position
--                     print("Player Position:", plrPosition)
--                     print("x:", targetPos.X)
--                     print("y:", targetPos.Y)
--                     print("z:", targetPos.Z)
--                     print("\n\n\n\n")
--                 end

--                 wait(0.2) -- petite pause pour éviter le spam
--             end
--         end)
--     end,
-- })
