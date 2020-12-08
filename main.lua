local GreenCandle = RegisterMod("GreenCandle", 1)

GreenCandle.COLLECTIBLE_GREEN_CANDLE = Isaac.GetItemIdByName("Green Candle")
local game = Game()
local DURATION = 100

function GreenCandle:onUpdate()
    --Run initialisation
    if game:GetFrameCount() == 1 then
        GreenCandle.HasGreenCandle = false
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, GreenCandle.COLLECTIBLE_GREEN_CANDLE, Vector(320, 300), Vector(0, 0), nil)
    end

    -- Green Candle functionality
    for playerNum = 1, game:GetNumPlayers() do
        local player = game:GetPlayer(playerNum)
        if player:HasCollectible(GreenCandle.COLLECTIBLE_GREEN_CANDLE) then
            -- initial pickup
            if not GreenCandle.HasGreenCandle then
               player:AddSoulHearts(4)
               GreenCandle.HasGreenCandle = true 
            end

            for i, entity in pairs(Isaac.GetRoomEntities()) do
                if entity:IsVulnerableEnemy() and math.random(500) <= player.Luck + 1 then
                    entity:AddPoison(EntityRef(player), DURATION, player.Damage)
                end
            end
        end
    end
end

GreenCandle:AddCallback(ModCallbacks.MC_POST_UPDATE, GreenCandle.onUpdate)