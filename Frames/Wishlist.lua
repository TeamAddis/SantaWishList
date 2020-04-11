--------------------------------------------------------------------------------
-- Filename: Wishlist.lua
-- Author: Andrew Addis
-- Description: This lua file handles the setup of the addon wish list Frame
--              It creates all needed containers to display information to the 
--              user. Getters and Setters shall be used to update information 
--              in the frames. The Wish List frame is a child frame and will be
--              added to a parent frame to be displayed. 
--------------------------------------------------------------------------------
local addonName, addonTable = ...

local SWL = addonTable.addon
local AceGUI = addonTable.gui
local player = SWL.player

local tabItems = {"Dungeons", "Raids"}
SWL.slots = {"HeadSlot", "NeckSlot","ShoulderSlot","BackSlot","ChestSlot","WristSlot",
                "HandsSlot","WaistSlot","LegsSlot","FeetSlot", "Finger0Slot","Finger1Slot",
                "Trinket0Slot","Trinket1Slot", "MainHandSlot","SecondaryHandSlot"}
local inventorySlots = {}
local slotContainer, selectContainer

--------------------------------------------------------------------------------
-- name: HideInventorySlots
-- args:    slotID : The id of the slot we don't want to hide if any.
-- returns: none
-- description: Hides all the inventory slots' frames.
--------------------------------------------------------------------------------
local function HideInventorySlots(slotId)
    for i = 1, #inventorySlots do
        invSlot = inventorySlots[i]
        if slotId ~= invSlot:GetUserData("slotid") then
            inventorySlots[i].frame:Hide()
            print "Hiding inventory slot"
        end
    end
end

--------------------------------------------------------------------------------
-- name: ShowInventorySlots
-- args:    
-- returns: none
-- description: Shows all the inventory slots' frames.
--------------------------------------------------------------------------------
local function ShowInventorySlots()
    for i = 1, #inventorySlots do
        inventorySlots[i].frame:Show()
        print "showing inventory slot"
    end
end

--------------------------------------------------------------------------------
-- name: ShowItemList
-- args:    slotId: the slot id we want to shot items for.
-- returns: none
-- description: Handle the on click event for an inventory slot
--------------------------------------------------------------------------------
local function ShowItemList(slotId)
    HideInventorySlots(slotId)

    selectContainer:ReleaseChildren()

    -- local scrollContainer = AceGUI:Create("ScrollFrame")
    -- selectFrame:AddChild(scrollContainer)

    local button = AceGUI:Create("Button")
    button:SetText("Select")
    button:SetWidth(200)
    --button:SetCallback("OnClick", ShowInventorySlots)
    selectContainer:AddChild(button)

    -- local deselectIcon = AceGUI:Create("InteractiveLabel")
    -- deselectIcon:SetImage("Interface\\Buttons\\UI-GroupLoot-Pass-Up.blp")
    -- --deselectIcon:SetCallback("OnClick", selectItemLabelOnClick)
    -- deselectIcon:SetFullWidth(true)
    -- deselectIcon:SetImageSize(30,30)
    -- deselectIcon:SetFont(GameFontNormalSmall:GetFont(), 14, nil)
    -- scrollContainer:AddChild(deselectIcon)
end

--------------------------------------------------------------------------------
-- name: inventoryIconOnClick
-- args:    widget : the inventory slot that was clicked
-- returns: none
-- description: Handle the on click event for an inventory slot
--------------------------------------------------------------------------------
function inventoryIconOnClick(widget)
    local slotId = widget:GetUserData("slotid")
    ShowItemList(slotId)
end

--------------------------------------------------------------------------------
-- name: CreateIventorySlot
-- args:    container : The parent frame. 
--          textureName : the name of the texture to display
--          slotId : the inventory slot id
-- returns: none
-- description: Create the inventory slot and add it to the parent container frame.
--------------------------------------------------------------------------------
local function CreateIventorySlot(container, textureName, slotId)
    local inventoryGroup = AceGUI:Create("SimpleGroup")
    inventoryGroup:SetHeight(45)
    inventoryGroup:SetUserData("slotid", slotId)
    
    local icon = AceGUI:Create("Icon")
    icon:SetUserData("slotid", slotId)
    icon:SetImage(textureName)
    icon:SetImageSize(40, 40)
    icon:SetWidth(40)
    icon:SetHeight(45)
    icon:SetPoint("TOPLEFT", container.frame, "TOPLEFT")
    icon:SetCallback("OnClick", inventoryIconOnClick)
    inventoryGroup:AddChild(icon)

    local nameLabel = AceGUI:Create("Label")
    nameLabel:SetHeight(20)
    nameLabel:SetPoint("TOPLEFT", icon.frame, "TOPRIGHT", 0, -5)
    inventoryGroup:AddChild(nameLabel)

    local typeLabel = AceGUI:Create("Label")
    typeLabel:SetHeight(20)
    typeLabel:SetPoint("TOPLEFT", nameLabel.frame, "TOPRIGHT", 0, -5)
    inventoryGroup:AddChild(typeLabel)

    container:AddChild(inventoryGroup)
    table.insert(inventorySlots, inventoryGroup)
end

--------------------------------------------------------------------------------
-- name: CreateSelectContainer
-- args: container : The parent frame. 
-- returns: none
-- description: Create the container that will handle selecting gear for a selected
--              slot.
--------------------------------------------------------------------------------
local function CreateSelectContainer(container)
    selectContainer = AceGUI:Create("SimpleGroup")
    selectContainer:SetLayout("Flow")
    container:AddChild(selectContainer)
end

--------------------------------------------------------------------------------
-- name: CreateSlotContainer
-- args: container : The parent frame. 
-- returns: none
-- description: Create all the gear slots and add them to a new container. Then
--              add the new slot container to parent container frame.
--------------------------------------------------------------------------------
local function CreateSlotContainer(container)
    slotContainer = AceGUI:Create("SimpleGroup")
    slotContainer:SetFullWidth(true)
    slotContainer:SetHeight(0)
    slotContainer:SetLayout("Flow")
    for i = 1, #SWL.slots do
        local slotId, textureName = GetInventorySlotInfo(SWL.slots[i])
        CreateIventorySlot(slotContainer, textureName, slotId)
    end

    container:AddChild(slotContainer)
end

--------------------------------------------------------------------------------
-- name: AddDropDowns
-- args: container : The parent frame. 
-- returns: none
-- description: Create and add the drop down selections for difficulty and spec
--              the parent container.
--------------------------------------------------------------------------------
local function AddDropDowns(container)
    local difficultyDropDown = AceGUI:Create("Dropdown")
    local difficulties = {"Normal",
                            "Heroic",
                            "Mythic",
                        }
    difficultyDropDown:SetLabel("Difficulty")
    difficultyDropDown:SetList(difficulties)
    difficultyDropDown:SetValue(3)
    container:AddChild(difficultyDropDown)

    local specDropDown = AceGUI:Create("Dropdown")
    specDropDown:SetLabel("Specialization")
    local id, spec = GetSpecializationInfo(GetSpecialization())
    specDropDown:SetList(player.specializations.names)
    specDropDown:SetText(spec)
    container:AddChild(specDropDown)
end

--------------------------------------------------------------------------------
-- name: DrawDungeonTab
-- args: container : The parent frame. 
-- returns: none
-- description: Create the dungeons tab frame and add all the needed widgets to it.
--------------------------------------------------------------------------------
local function DrawDungeonTab(container)
    AddDropDowns(container)
    CreateSlotContainer(container)
    CreateSelectContainer(container)
end
  
--------------------------------------------------------------------------------
-- name: DrawRaidsTab
-- args: container : The parent frame. 
-- returns: none
-- description: Create the raids tab frame and add all the needed widgets to it.
--------------------------------------------------------------------------------
local function DrawRaidsTab(container)
    AddDropDowns(container)
end

--------------------------------------------------------------------------------
-- name: SelectGroup
-- args: container : The parent frame, 
--       event : tab selected event, 
--       group : the target tab
-- returns: none
-- description: Callback function for OnGroupSelected
--------------------------------------------------------------------------------
local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    if group == tabItems[1] then
       DrawDungeonTab(container)
    elseif group == tabItems[2] then
       DrawRaidsTab(container)
    end
end

--------------------------------------------------------------------------------
-- name: CreateWishlistFrame
-- args: parent : The parent frame.
-- returns: none
-- description: Create the Wish list frame and all its widgets. Then adds the 
--              frame to the parent frame as a child. Need to ensure parent frame
--              has the correct layout for the wishlist.
--------------------------------------------------------------------------------
function SWL:CreateWishlistFrame(parent)
    parent:SetLayout("Fill")

    SWL:LoadPlayerDetails()

    local tab = AceGUI:Create("TabGroup")
    tab:SetLayout("Flow")
    tab:SetTabs({{text=tabItems[1], value=tabItems[1]}, 
                    {text=tabItems[2], value=tabItems[2]}})
    tab:SetCallback("OnGroupSelected", SelectGroup)
    tab:SelectTab(tabItems[1])

    parent:AddChild(tab)
    parent:SetUserData("tabMenu", tab)
end