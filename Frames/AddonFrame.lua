--------------------------------------------------------------------------------
-- Filename: AddonFrame.lua
-- Author: Andrew Addis
-- Description: This lua file handles the setup of the addon main GUI Frame
--              It creates all needed containers to display information to the 
--              user. Getters and Setters shall be used to update information 
--              in the frames.
--------------------------------------------------------------------------------
local addonName, addonTable = ...

local SWL = addonTable.addon
local AceGUI = addonTable.gui

local frame

local menuItems = {"Wish List", "Options"}
local selectedMenuItem = menuItems[1]

--------------------------------------------------------------------------------
-- name: CreateMenuFrame
-- args: parent : The parent frame.
-- returns: none
-- description: 
--------------------------------------------------------------------------------
local function WishListSelected(parent)
    SWL:CreateWishlistFrame(parent)
end

--------------------------------------------------------------------------------
-- name: CreateMenuFrame
-- args: parent : The parent frame.
-- returns: none
-- description: Create the menu frame and all its widgets. Then adds the frame
--              to the parent frame as a child.
--------------------------------------------------------------------------------
local function CreateMenuFrame(parent)
    local menuFrame = AceGUI:Create("SimpleGroup")
    menuFrame:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", 10, -20)
    menuFrame:SetPoint("BOTTOMRIGHT", parent.frame, "BOTTOMLEFT", 160, 50)

    for i = 1, #menuItems do
        local lineSpace = 10
        local interactiveLabel = AceGUI:Create("InteractiveLabel")
        interactiveLabel:SetText(menuItems[i])
        interactiveLabel:SetWidth(140)
        interactiveLabel:SetFont(GameFontNormalSmall:GetFont(), 14, nil)
        interactiveLabel:SetUserData("name", menuItems[i])
        interactiveLabel:SetUserData("id", i)
        interactiveLabel:SetPoint("TOPLEFT", menuFrame.frame, "TOPLEFT", 10, -12*i)
        interactiveLabel:SetPoint("TOPRIGHT", menuFrame.frame, "TOPRIGHT", -10, -12*i)

        menuFrame:AddChild(interactiveLabel)
    end

    parent:AddChild(menuFrame)
    parent:SetUserData("menu", menuFrame)
end

--------------------------------------------------------------------------------
-- name: CreateFrame
-- args: none
-- returns: none
-- description: Create and initialize the main GUI frame and all 
--              subframes/containers.
--------------------------------------------------------------------------------
local function CreateFrame()
    -- Top level frame
    frame = AceGUI:Create("Frame")
    frame:SetTitle("Santa Wish List")
    frame:SetStatusText("Created by: Andrew Addis")
    frame:SetCallback("OnClose", HideFrame)
    frame:SetLayout("Flow")

    -- menu frame
    CreateMenuFrame(frame)


    -- content frame
    local contentContainer = AceGUI:Create("SimpleGroup")
    contentContainer:SetPoint("TOPRIGHT", frame.frame, "TOPRIGHT", -20, -20)
    contentContainer:SetPoint("BOTTOMLEFT", frame:GetUserData("menu").frame, "BOTTOMRIGHT", 5, 0)
    contentContainer:SetLayout("Fill")
    frame:AddChild(contentContainer)
    frame:SetUserData("content", contentContainer)

    -- Decide what to load in the content frame based on the selected menu item.
    local switch = function (choice)
        -- Cases
        local case = {
            [menuItems[1]] = function ( )
                SWL:CreateWishlistFrame(contentContainer)
            end,
            [menuItems[2]] = function ( )
                print "Options frame is not called"
            end,
        }

        if case[choice] then
            case[choice]()
        else
            print "error in executing switch choice"
        end
    end

    switch(selectedMenuItem)

    SWL.frame = frame
end

--------------------------------------------------------------------------------
-- name: Show Frame 
-- args: none
-- return: none
-- description: Show the GUI Frame
--------------------------------------------------------------------------------
local function ShowFrame()
    if not frame then
        CreateFrame()
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
    end
end

--------------------------------------------------------------------------------
-- Hide Frame
-- args: none
-- return: none
-- Hide the GUI Frame
--------------------------------------------------------------------------------
local function HideFrame()
    if frame then
        frame:Release()
        frame = nil
        SWL.frame = nil
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
    end
end

--------------------------------------------------------------------------------
-- Toggle Frame
-- args: none
-- return: none
-- Toggle between showing and hiding the GUI Frame
--------------------------------------------------------------------------------
function SWL:ToggleFrame()
    if not frame then
        ShowFrame()
    else
        HideFrame()
    end
end