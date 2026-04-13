--[[   ____    ______
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/

 [=====================================]
 [  Author: Munigan                    ]
 [  MuniganXCT Version 3.x.x           ]
 [  Customized for Munigan UI.         ]
 [====================================]]

local ADDON_NAME, addon = ...
local x = addon.engine

local LSM = LibStub("LibSharedMedia-3.0");
local type = type
local string_sub = string.sub

local function HookElvUIBlizzardFonts()
  if x.elvUIBlizzardFontsHooked then
    return
  end

  local elvui = _G.ElvUI and _G.ElvUI[1]
  if elvui and type(elvui.UpdateBlizzardFonts) == "function" then
    hooksecurefunc(elvui, "UpdateBlizzardFonts", function()
      x:UpdateBlizzardFCT()
    end)

    x.elvUIBlizzardFontsHooked = true
  end
end

-- Intercept Messages Sent by other Add-Ons that use CombatText_AddMessage
hooksecurefunc('CombatText_AddMessage', function(message, scrollFunction, r, g, b, displayType, isStaggered)
  local lastEntry = COMBAT_TEXT_TO_ANIMATE[ #COMBAT_TEXT_TO_ANIMATE ]
  CombatText_RemoveMessage(lastEntry)
  x:AddMessage("general", message, {r, g, b})
end)

-- Move the options up
local defaultFont, defaultSize = InterfaceOptionsCombatTextPanelTargetEffectsText:GetFont()

-- Show Combat Options Title
local fsTitle = InterfaceOptionsCombatTextPanel:CreateFontString(nil, "OVERLAY")
fsTitle:SetTextColor(1.00, 1.00, 1.00, 1.00)
fsTitle:SetFont(defaultFont, defaultSize)
fsTitle:SetText("|cff60A0FFPowered By |cffFF0000x|r|cff80F000CT|r+|r")
--fsTitle:SetPoint("TOPLEFT", 16, -90)
fsTitle:SetPoint("TOPLEFT", 180, -16)

-- Move the Effects and Floating Options
--[[InterfaceOptionsCombatTextPanelTargetEffects:ClearAllPoints()
InterfaceOptionsCombatTextPanelTargetEffects:SetPoint("TOPLEFT", 314, -132)
InterfaceOptionsCombatTextPanelEnableFCT:ClearAllPoints()
InterfaceOptionsCombatTextPanelEnableFCT:SetPoint("TOPLEFT", 18, -132)

InterfaceOptionsCombatTextPanelTargetDamage:ClearAllPoints()
InterfaceOptionsCombatTextPanelTargetDamage:SetPoint("TOPLEFT", 18, -355) ]]


-- Hide Blizzard Combat Text Toggles
InterfaceOptionsCombatTextPanelEnableFCT:Hide()
InterfaceOptionsCombatTextPanelTargetEffects:Hide()
InterfaceOptionsCombatTextPanelOtherTargetEffects:Hide()
InterfaceOptionsCombatTextPanelDodgeParryMiss:Hide()
InterfaceOptionsCombatTextPanelDamageReduction:Hide()
InterfaceOptionsCombatTextPanelRepChanges:Hide()
InterfaceOptionsCombatTextPanelReactiveAbilities:Hide()
InterfaceOptionsCombatTextPanelFriendlyHealerNames:Hide()
InterfaceOptionsCombatTextPanelCombatState:Hide()
InterfaceOptionsCombatTextPanelComboPoints:Hide()
InterfaceOptionsCombatTextPanelLowManaHealth:Hide()
InterfaceOptionsCombatTextPanelEnergyGains:Hide()
InterfaceOptionsCombatTextPanelPeriodicEnergyGains:Hide()
InterfaceOptionsCombatTextPanelHonorGains:Hide()
InterfaceOptionsCombatTextPanelAuras:Hide()

-- Direction does not work with MuniganXCT at all
InterfaceOptionsCombatTextPanelFCTDropDown:Hide()

-- FCT Options
InterfaceOptionsCombatTextPanelTargetDamage:Hide()
InterfaceOptionsCombatTextPanelPeriodicDamage:Hide()
InterfaceOptionsCombatTextPanelPetDamage:Hide()
InterfaceOptionsCombatTextPanelHealing:Hide()

function x:UpdateBlizzardFCT()
  HookElvUIBlizzardFonts()

  if self.db.profile.blizzardFCT.enabled then
    DAMAGE_TEXT_FONT = self.db.profile.blizzardFCT.fontName

    if CombatTextFont and CombatTextFont.SetFont then
      CombatTextFont:SetFont(
        self.db.profile.blizzardFCT.fontName,
        self.db.profile.blizzardFCT.fontSize,
        string_sub(self.db.profile.blizzardFCT.fontOutline, 2)
      )
    end
  end
end

-- Turn off Blizzard's Combat Text
CombatText:UnregisterAllEvents()
CombatText:SetScript("OnLoad", nil)
CombatText:SetScript("OnEvent", nil)
CombatText:SetScript("OnUpdate", nil)


-- Create a button to delete profiles
if not MuniganCombatTextConfigButton then
  CreateFrame("Button", "MuniganCombatTextConfigButton", InterfaceOptionsCombatTextPanel, "UIPanelButtonTemplate")
end

MuniganCombatTextConfigButton:ClearAllPoints()
MuniganCombatTextConfigButton:SetPoint("TOPRIGHT", -36, -80)
MuniganCombatTextConfigButton:SetSize(200, 30)
MuniganCombatTextConfigButton:SetText("|cffFFFFFFGo to the |r|cffFF8000Munigan|r |cffFFFFFFOptions Panel...|r")
MuniganCombatTextConfigButton:Show()
MuniganCombatTextConfigButton:SetScript("OnClick", function(self)
  InterfaceOptionsFrameOkay:Click()
  LibStub("AceConfigDialog-3.0"):Open(ADDON_NAME)
end)

-- Interface - Addons (Ace3 Blizzard Options)
x.blizzardOptions = {
  name = "|cffFFFF00Combat Text - |r|cff60A0FFPowered By MuniganXCT|r",
  handler = x,
  type = 'group',
  args = {
    showConfig = {
      order = 1,
      type = 'execute',
      name = "Show Config",
      func = function() InterfaceOptionsFrameOkay:Click(); LibStub("AceConfigDialog-3.0"):Open(ADDON_NAME); GameMenuButtonContinue:Click() end,
    },
  },
}
