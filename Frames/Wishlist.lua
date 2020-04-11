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

local tabItems = {"Dungeons", "Raids"}

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

    local tab = AceGUI:Create("TabGroup")
    tab:SetLayout("Flow")
    tab:SetTabs({{text=tabItems[1], value=tabItems[1]}, 
                    {text=tabItems[2], value=tabItems[2]}})
    tab:SetCallback("OnGroupSelected", SelectGroup)
    tab:SelectTab(tabItems[1])

    parent:AddChild(tab)
    parent:SetUserData("tabMenu", tab)
end