--------------------------------------------------------------------------------
-- Filename: Player.lua
-- Author: Andrew Addis
-- Description: This lua file handles loading all information related to the 
--              current player. 
--              + Character Name
--              + Class
--              + Class specializations
--              
--------------------------------------------------------------------------------
local addonName, addonTable = ...

local SWL = addonTable.addon

local player = {}
SWL.player = player
player.specializations = {}

--------------------------------------------------------------------------------
-- name: LoadSpecDetails
-- args: none
-- returns: none
-- description: Load all the needed specialization information for this character.
--------------------------------------------------------------------------------
local function LoadSpecDetails()
    local specNames = {}
    local specIds = {}
    for i = 1, GetNumSpecializations() do
        local id, specName = GetSpecializationInfo(i)
        specNames[i] = specName
        specIds[i] = id
    end
    player.specializations.names = specNames
    player.specializations.ids = specIds
end

--------------------------------------------------------------------------------
-- name: LoadPlayerDetails
-- args: none 
-- returns: none
-- description: Load all needed player details.
--------------------------------------------------------------------------------
function SWL:LoadPlayerDetails()
    LoadSpecDetails()
end