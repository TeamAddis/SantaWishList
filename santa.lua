local addonName, addonTable = ...

local SWL = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0")
addonTable.addon = SWL

local AceGUI = LibStub("AceGUI-3.0")
addonTable.gui = AceGUI

local defaults = {
    profile = {
        minimap = {
            hide = false,
        },
    },
}

--- Init of Addon
--
-- 
function SWL:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("Santa_DB", defaults)
    
    SWL:setupMiniMapIcon()
end

--- Setup the minimap icon
--
-- Setup the minimap icon. It is shown by defult.
function SWL:setupMiniMapIcon()
    SWL:RegisterMinimapIcon()
end
--- Enable Addon
--
--
function SWL:OnEnable()
    -- Called when the addon is enabled
end

--- Disable Addon
--
--
function SWL:OnDisable()
    -- Called when the addon is disabled
end


