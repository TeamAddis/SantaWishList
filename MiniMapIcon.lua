local addonName, addonTable = ...

local SWL = addonTable.addon
local AceGUI = addonTable.gui

local isRegistered = false
local santaLDB = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
    type = "launcher",
    text = addonName,
    icon = "Interface\\Icons\\Achievement_ChallengeMode_Silver",
    OnTooltipShow = function(tooltip)
      tooltip:AddLine(addonName)
    --   tooltip:AddLine(("%s%s: %s%s|r"):format(SWL.colorHighlight, L["Click"], SWL.colorNormal, L["Show the GUI"]))
    end})

  local minimapIcon = LibStub("LibDBIcon-1.0")
  
  function santaLDB:OnClick(button, down)
    SWL:ToggleFrame()
  end
  
 function SWL:RegisterMinimapIcon()
    minimapIcon:Register(addonName, santaLDB, SWL.db.profile.minimap)
    isRegistered = true
  end
--[[ 
  function BestInSlot:MiniMapButtonVisible(bool)
    if bool then
      if not isRegistered then
        self:RegisterMinimapIcon()
      end
      minimapIcon:Show("BestInSlotRedux")
    else
      if not isRegistered then return end
      minimapIcon:Hide("BestInSlotRedux")
    end
  end
  
  function BestInSlot:MiniMapButtonHideShow()
    BestInSlot.db.char.options.minimapButton = not BestInSlot.db.char.options.minimapButton
    BestInSlot:MiniMapButtonVisible(BestInSlot.db.char.options.minimapButton)
  end ]]