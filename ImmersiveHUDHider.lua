ImmersiveHUDHider = ImmersiveHUDHider or {}
ImmersiveHUDHider.name = "ImmersiveHUDHider"
ImmersiveHUDHider.version = 1.12

-- AUI Unit frames ID list
local AUIUnitFramesToHide = {}

local function hideAUIUnitFrames()
    local gCurrentTemplateData = AUI.UnitFrames.GetActiveTemplates()
    for _, templateData in pairs(gCurrentTemplateData) do
        for frameType, data in pairs(templateData.frameData) do
            control = data.control
            for _, templateData in pairs(gCurrentTemplateData) do
                for frameType, data in pairs(templateData.frameData) do
                    control = data.control

                    -- Hides them, they just show back up after change
                    local timelastrun = 0
                    control:SetHandler(
                        "OnUpdate", function(self, timerun)
                            if (timerun - timelastrun) >= 0 then
                                timelastrun = timerun
                                for k, v in pairs(AUIUnitFramesToHide) do
                                    AUI.UnitFrames.HideFrame(v)
                                end
                            end
                        end
                    )

                    break
                end
            end
            break
        end
    end
end

-- Default values for settings menu
ImmersiveHUDHider.defaultSettingsMenu = {
    hideInteractableGlow = true, hideTargetGlow = true, hideQuestBestowerIndicator = true, hideGroupIndicators = true, hideFollowIndicator = true,
    hideAllianceIndicators = true, hideResurrectIndicator = true, hideAllHealthBars = true, hideAllNamePlates = true, hideChatBubbles = true,
    hideActionBar = true, hideAttributeBar = true, hideBuffs = true, hideScrollingCombatText = true, hideLootLog = true, hideCompass = true,
    hideMap = true, hideQuestTracker = true, hideGroupUnitFrames = true, hideBossBar = true, hideTargetInfo = true
}

-- Keep track of default options for in-game HUD settings.
-- Returns previous vanilla settings back to these on disable
ImmersiveHUDHider.default = {
    isInterfaceEventHandler = 0, ImmersiveHUDHider_isUIHidden = false,
    defaultInteractableGlow = GetSetting(SETTING_TYPE_IN_WORLD, IN_WORLD_UI_SETTING_INTERACTABLE_GLOW_ENABLED),
    defaultTargetGlow = GetSetting(SETTING_TYPE_IN_WORLD, IN_WORLD_UI_SETTING_TARGET_GLOW_ENABLED),
    defaultQuestBestowerIndicator = GetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_QUEST_BESTOWER_INDICATORS),
    defaultGroupIndicators = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_INDICATORS),
    defaultFollowIndicator = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_FOLLOWER_INDICATORS),
    defaultAllianceIndicators = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALLIANCE_INDICATORS),
    defaultResurrectIndicator = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_RESURRECT_INDICATORS),
    defaultAllHealthBars = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALL_HEALTHBARS),
    defaultAllNamePlates = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALL_NAMEPLATES),
    defaultChatBubbles = GetSetting(SETTING_TYPE_CHAT_BUBBLE, CHAT_BUBBLE_SETTING_ENABLED),
    defaultChatBubbleSpeed = GetSetting(SETTING_TYPE_CHAT_BUBBLE, CHAT_BUBBLE_SETTING_SPEED_MODIFIER),
    defaultActionBar = GetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_ACTION_BAR),
    defaultAttributeBar = GetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_RESOURCE_BARS),
    defaultBuffs = GetSetting(SETTING_TYPE_BUFFS, BUFFS_SETTING_ALL_ENABLED),
    defaultScrollingCombatText = GetSetting(SETTING_TYPE_COMBAT, COMBAT_SETTING_SCROLLING_COMBAT_TEXT_ENABLED),
    defaultLootLog = GetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_LOOT_HISTORY)
}

-- Return values to previous
function ImmersiveHUDHider.setSettingsFromFile()
    SetSetting(SETTING_TYPE_IN_WORLD, IN_WORLD_UI_SETTING_INTERACTABLE_GLOW_ENABLED, ImmersiveHUDHider.savedVariables.defaultInteractableGlow)
    SetSetting(SETTING_TYPE_IN_WORLD, IN_WORLD_UI_SETTING_TARGET_GLOW_ENABLED, ImmersiveHUDHider.savedVariables.defaultTargetGlow)
    SetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_QUEST_BESTOWER_INDICATORS, ImmersiveHUDHider.savedVariables.defaultQuestBestowerIndicator)
    SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_INDICATORS, ImmersiveHUDHider.savedVariables.defaultGroupIndicators)
    SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_FOLLOWER_INDICATORS, ImmersiveHUDHider.savedVariables.defaultFollowIndicator)
    SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALLIANCE_INDICATORS, ImmersiveHUDHider.savedVariables.defaultAllianceIndicators)
    SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_RESURRECT_INDICATORS, ImmersiveHUDHider.savedVariables.defaultResurrectIndicator)
    SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALL_HEALTHBARS, ImmersiveHUDHider.savedVariables.defaultAllHealthBars)
    SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALL_NAMEPLATES, ImmersiveHUDHider.savedVariables.defaultAllNamePlates)
    SetSetting(SETTING_TYPE_CHAT_BUBBLE, CHAT_BUBBLE_SETTING_ENABLED, ImmersiveHUDHider.savedVariables.defaultChatBubbles)
    SetSetting(SETTING_TYPE_CHAT_BUBBLE, CHAT_BUBBLE_SETTING_SPEED_MODIFIER, ImmersiveHUDHider.savedVariables.defaultChatBubbleSpeed)
    SetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_ACTION_BAR, ImmersiveHUDHider.savedVariables.defaultActionBar)
    SetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_RESOURCE_BARS, ImmersiveHUDHider.savedVariables.defaultAttributeBar)
    SetSetting(SETTING_TYPE_BUFFS, BUFFS_SETTING_ALL_ENABLED, ImmersiveHUDHider.savedVariables.defaultBuffs)
    SetSetting(SETTING_TYPE_COMBAT, COMBAT_SETTING_SCROLLING_COMBAT_TEXT_ENABLED, ImmersiveHUDHider.savedVariables.defaultScrollingCombatText)
    SetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_LOOT_HISTORY, ImmersiveHUDHider.savedVariables.defaultLootLog)
end

-- Save default values to file
function ImmersiveHUDHider.saveSettingsToFile()
    if ImmersiveHUDHider.savedVariables.ImmersiveHUDHider_isUIHidden == false then
        ImmersiveHUDHider.savedVariables.defaultInteractableGlow = GetSetting(SETTING_TYPE_IN_WORLD, IN_WORLD_UI_SETTING_INTERACTABLE_GLOW_ENABLED)
        ImmersiveHUDHider.savedVariables.defaultTargetGlow = GetSetting(SETTING_TYPE_IN_WORLD, IN_WORLD_UI_SETTING_TARGET_GLOW_ENABLED)
        ImmersiveHUDHider.savedVariables.defaultQuestBestowerIndicator = GetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_QUEST_BESTOWER_INDICATORS)
        ImmersiveHUDHider.savedVariables.defaultGroupIndicators = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_INDICATORS)
        ImmersiveHUDHider.savedVariables.defaultFollowIndicator = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_FOLLOWER_INDICATORS)
        ImmersiveHUDHider.savedVariables.defaultAllianceIndicators = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALLIANCE_INDICATORS)
        ImmersiveHUDHider.savedVariables.defaultResurrectIndicator = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_RESURRECT_INDICATORS)
        ImmersiveHUDHider.savedVariables.defaultAllHealthBars = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALL_HEALTHBARS)
        ImmersiveHUDHider.savedVariables.defaultAllNamePlates = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALL_NAMEPLATES)
        ImmersiveHUDHider.savedVariables.defaultChatBubbles = GetSetting(SETTING_TYPE_CHAT_BUBBLE, CHAT_BUBBLE_SETTING_ENABLED)
        ImmersiveHUDHider.savedVariables.defaultChatBubbleSpeed = GetSetting(SETTING_TYPE_CHAT_BUBBLE, CHAT_BUBBLE_SETTING_SPEED_MODIFIER)
        ImmersiveHUDHider.savedVariables.defaultActionBar = GetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_ACTION_BAR)
        ImmersiveHUDHider.savedVariables.defaultAttributeBar = GetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_RESOURCE_BARS)
        ImmersiveHUDHider.savedVariables.defaultBuffs = GetSetting(SETTING_TYPE_BUFFS, BUFFS_SETTING_ALL_ENABLED)
        ImmersiveHUDHider.savedVariables.defaultScrollingCombatText = GetSetting(SETTING_TYPE_COMBAT, COMBAT_SETTING_SCROLLING_COMBAT_TEXT_ENABLED)
        ImmersiveHUDHider.savedVariables.defaultLootLog = GetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_LOOT_HISTORY)
    end

    ImmersiveHUDHider.savedVariables.hideActionBar = ImmersiveHUDHider.savedVariables.hideActionBar
    ImmersiveHUDHider.savedVariables.hideAllHealthBars = ImmersiveHUDHider.savedVariables.hideAllHealthBars
    ImmersiveHUDHider.savedVariables.hideActionBar = ImmersiveHUDHider.savedVariables.hideActionBar
    ImmersiveHUDHider.savedVariables.hideAllHealthBars = ImmersiveHUDHider.savedVariables.hideAllHealthBars
    ImmersiveHUDHider.savedVariables.hideAllianceIndicators = ImmersiveHUDHider.savedVariables.hideAllianceIndicators
    ImmersiveHUDHider.savedVariables.hideAllNamePlates = ImmersiveHUDHider.savedVariables.hideAllNamePlates
    ImmersiveHUDHider.savedVariables.hideAttributeBar = ImmersiveHUDHider.savedVariables.hideAttributeBar
    ImmersiveHUDHider.savedVariables.hideBossBar = ImmersiveHUDHider.savedVariables.hideBossBar
    ImmersiveHUDHider.savedVariables.hideBuffs = ImmersiveHUDHider.savedVariables.hideBuffs
    ImmersiveHUDHider.savedVariables.hideChatBubbles = ImmersiveHUDHider.savedVariables.hideChatBubbles
    ImmersiveHUDHider.savedVariables.hideCompass = ImmersiveHUDHider.savedVariables.hideCompass
    ImmersiveHUDHider.savedVariables.hideFollowIndicator = ImmersiveHUDHider.savedVariables.hideFollowIndicator
    ImmersiveHUDHider.savedVariables.hideGroupIndicators = ImmersiveHUDHider.savedVariables.hideGroupIndicators
    ImmersiveHUDHider.savedVariables.hideGroupUnitFrames = ImmersiveHUDHider.savedVariables.hideGroupUnitFrames
    ImmersiveHUDHider.savedVariables.hideInteractableGlow = ImmersiveHUDHider.savedVariables.hideInteractableGlow
    ImmersiveHUDHider.savedVariables.hideLootLog = ImmersiveHUDHider.savedVariables.hideLootLog
    ImmersiveHUDHider.savedVariables.hideMap = ImmersiveHUDHider.savedVariables.hideMap
    ImmersiveHUDHider.savedVariables.hideQuestBestowerIndicator = ImmersiveHUDHider.savedVariables.hideQuestBestowerIndicator
    ImmersiveHUDHider.savedVariables.hideQuestTracker = ImmersiveHUDHider.savedVariables.hideQuestTracker
    ImmersiveHUDHider.savedVariables.hideResurrectIndicator = ImmersiveHUDHider.savedVariables.hideResurrectIndicator
    ImmersiveHUDHider.savedVariables.hideScrollingCombatText = ImmersiveHUDHider.savedVariables.hideScrollingCombatText
    ImmersiveHUDHider.savedVariables.hideTargetGlow = ImmersiveHUDHider.savedVariables.hideTargetGlow
    ImmersiveHUDHider.savedVariables.hideTargetInfo = ImmersiveHUDHider.savedVariables.hideTargetInfo
end

function ImmersiveHUDHider.interfaceEventHandlerToggle()
    if ImmersiveHUDHider.savedVariables.isInterfaceEventHandler == 1 then
        EVENT_MANAGER:UnregisterForEvent(ImmersiveHUDHider.name, EVENT_INTERFACE_SETTING_CHANGED)
    else
        EVENT_MANAGER:RegisterForEvent(ImmersiveHUDHider.name, EVENT_INTERFACE_SETTING_CHANGED, ImmersiveHUDHider.saveSettingsToFile)
    end
end

function hideInteractableGlow(boolean)
    if (ImmersiveHUDHider.savedVariables.hideInteractableGlow) then
        if (boolean) then
            SetSetting(SETTING_TYPE_IN_WORLD, IN_WORLD_UI_SETTING_INTERACTABLE_GLOW_ENABLED, "false", DO_NOT_SAVE_TO_PERSISTED_DATA)
        else
            SetSetting(
                SETTING_TYPE_IN_WORLD, IN_WORLD_UI_SETTING_INTERACTABLE_GLOW_ENABLED, ImmersiveHUDHider.savedVariables.defaultInteractableGlow,
                DO_NOT_SAVE_TO_PERSISTED_DATA
            )
        end
    end
end

function hideTargetGlow(boolean)
    if (ImmersiveHUDHider.savedVariables.hideTargetGlow) then
        if (boolean) then
            SetSetting(SETTING_TYPE_IN_WORLD, IN_WORLD_UI_SETTING_TARGET_GLOW_ENABLED, "false", DO_NOT_SAVE_TO_PERSISTED_DATA)
        else
            SetSetting(
                SETTING_TYPE_IN_WORLD, IN_WORLD_UI_SETTING_TARGET_GLOW_ENABLED, ImmersiveHUDHider.savedVariables.defaultTargetGlow,
                DO_NOT_SAVE_TO_PERSISTED_DATA
            )
        end
    end
end

function hideQuestBestowerIdicator(boolean)
    if (ImmersiveHUDHider.savedVariables.hideQuestBestowerIndicator) then
        if (boolean) then
            SetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_QUEST_BESTOWER_INDICATORS, "false", DO_NOT_SAVE_TO_PERSISTED_DATA)
        else
            SetSetting(
                SETTING_TYPE_UI, UI_SETTING_SHOW_QUEST_BESTOWER_INDICATORS, ImmersiveHUDHider.savedVariables.defaultQuestBestowerIndicator,
                DO_NOT_SAVE_TO_PERSISTED_DATA
            )
        end
    end
end

function hideGroupIndicators(boolean)
    if (ImmersiveHUDHider.savedVariables.hideGroupIndicators) then
        if (boolean) then
            SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_INDICATORS, "false", DO_NOT_SAVE_TO_PERSISTED_DATA)
        else
            SetSetting(
                SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_INDICATORS, ImmersiveHUDHider.savedVariables.defaultGroupIndicators,
                DO_NOT_SAVE_TO_PERSISTED_DATA
            )
        end

    end
end

function hideFollowIndicator(boolean)
    if (ImmersiveHUDHider.savedVariables.hideFollowIndicator) then
        if (boolean) then
            SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_FOLLOWER_INDICATORS, "false", DO_NOT_SAVE_TO_PERSISTED_DATA)
        else
            SetSetting(
                SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_FOLLOWER_INDICATORS, ImmersiveHUDHider.savedVariables.defaultFollowIndicator,
                DO_NOT_SAVE_TO_PERSISTED_DATA
            )
        end
    end
end

function hideAllianceIndicators(boolean)
    if (ImmersiveHUDHider.savedVariables.hideAllianceIndicators) then
        if (boolean) then
            SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALLIANCE_INDICATORS, NAMEPLATE_CHOICE_NEVER, DO_NOT_SAVE_TO_PERSISTED_DATA)
        else
            SetSetting(
                SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALLIANCE_INDICATORS, ImmersiveHUDHider.savedVariables.defaultAllianceIndicators,
                DO_NOT_SAVE_TO_PERSISTED_DATA
            )
        end
    end
end

function hideResurrectIndicator(boolean)
    if (ImmersiveHUDHider.savedVariables.hideResurrectIndicator) then
        if (boolean) then
            SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_RESURRECT_INDICATORS, "false", DO_NOT_SAVE_TO_PERSISTED_DATA)
        else
            SetSetting(
                SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_RESURRECT_INDICATORS, ImmersiveHUDHider.savedVariables.defaultResurrectIndicator,
                DO_NOT_SAVE_TO_PERSISTED_DATA
            )
        end
    end
end

function hideAllNamePlates(boolean)
    if (ImmersiveHUDHider.savedVariables.hideAllNamePlates) then
        if (boolean) then
            SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALL_NAMEPLATES, "false", DO_NOT_SAVE_TO_PERSISTED_DATA)
        else
            SetSetting(
                SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALL_NAMEPLATES, ImmersiveHUDHider.savedVariables.defaultAllNamePlates,
                DO_NOT_SAVE_TO_PERSISTED_DATA
            )
        end
    end
end

function hideChatBubbles(boolean)
    if (ImmersiveHUDHider.savedVariables.hideChatBubbles) then
        if (boolean) then
            SetSetting(SETTING_TYPE_CHAT_BUBBLE, CHAT_BUBBLE_SETTING_ENABLED, "false", DO_NOT_SAVE_TO_PERSISTED_DATA)
            SetSetting(SETTING_TYPE_CHAT_BUBBLE, CHAT_BUBBLE_SETTING_SPEED_MODIFIER, "0.80000001")
        else
            SetSetting(
                SETTING_TYPE_CHAT_BUBBLE, CHAT_BUBBLE_SETTING_ENABLED, ImmersiveHUDHider.savedVariables.defaultChatBubbles,
                DO_NOT_SAVE_TO_PERSISTED_DATA
            )
            SetSetting(SETTING_TYPE_CHAT_BUBBLE, CHAT_BUBBLE_SETTING_SPEED_MODIFIER, ImmersiveHUDHider.savedVariables.defaultChatBubbleSpeed)
        end

    end
end

function hideActionBar(boolean)
    if (ImmersiveHUDHider.savedVariables.hideActionBar) then
        if (boolean) then
            SetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_ACTION_BAR, "false", DO_NOT_SAVE_TO_PERSISTED_DATA)
        else
            SetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_ACTION_BAR, ImmersiveHUDHider.savedVariables.defaultActionBar, DO_NOT_SAVE_TO_PERSISTED_DATA)
        end
    end
end

function hideBuffs(boolean)
    if (ImmersiveHUDHider.savedVariables.hideBuffs == true) then
        if (boolean) then
            -- Vanilla
            SetSetting(SETTING_TYPE_BUFFS, BUFFS_SETTING_ALL_ENABLED, "false", DO_NOT_SAVE_TO_PERSISTED_DATA)

            -- AUI
            if (AUI) then
                if (AUI.Buffs.IsEnabled()) then
                    
                    -- unitTag = AUI_TARGET_UNIT_TAG
                    -- effectType = BUFF_EFFECT_TYPE_DEBUFF
                    local _unitTag = "player"
                    local _effectType = BUFF_EFFECT_TYPE_BUFF
                    local activeBuffs = {}
                    if not activeBuffs[_unitTag] then
                        activeBuffs[_unitTag] = {}
                    end
                    
                    if not activeBuffs[_unitTag][_effectType] then
                        activeBuffs[_unitTag][_effectType] = {}
                    end	

                    for unitTag, unitData in pairs(activeBuffs) do
                        for effectType, buffControls in pairs(unitData) do	
                            for _, control in pairs(buffControls) do
                                RemoveBuff(control.buffData.AbilityId	, unitTag, effectType, false)
                                control:SetHidden(true)
                            end
                        end
                    end

                end
            end
        else
            SetSetting(SETTING_TYPE_BUFFS, BUFFS_SETTING_ALL_ENABLED, ImmersiveHUDHider.savedVariables.defaultBuffs, DO_NOT_SAVE_TO_PERSISTED_DATA)
        end
    end
end

function hideScrollingCombatText(boolean)
    if (ImmersiveHUDHider.savedVariables.hideScrollingCombatText == true) then
        if (boolean) then
            SetSetting(SETTING_TYPE_COMBAT, COMBAT_SETTING_SCROLLING_COMBAT_TEXT_ENABLED, "false", DO_NOT_SAVE_TO_PERSISTED_DATA)
        else
            SetSetting(
                SETTING_TYPE_COMBAT, COMBAT_SETTING_SCROLLING_COMBAT_TEXT_ENABLED, ImmersiveHUDHider.savedVariables.defaultScrollingCombatText,
                DO_NOT_SAVE_TO_PERSISTED_DATA
            )
        end
    end
end

function hideLootLog(boolean)
    if (ImmersiveHUDHider.savedVariables.hideLootLog == true) then
        if (boolean) then
            SetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_LOOT_HISTORY, "false", DO_NOT_SAVE_TO_PERSISTED_DATA)
        else
            SetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_LOOT_HISTORY, ImmersiveHUDHider.savedVariables.defaultLootLog, DO_NOT_SAVE_TO_PERSISTED_DATA)
        end
    end
end

function hideCompass(boolean)
    if (ImmersiveHUDHider.savedVariables.hideCompass) then
        if (boolean == true) then
            ZO_Compass:SetHidden(true)
            ZO_Compass:SetAlpha(0)
            ZO_CompassFrameCenter:SetHidden(true)
            ZO_CompassFrameLeft:SetHidden(true)
            ZO_CompassFrameRight:SetHidden(true)

            -- Hide compass after it has been updated
            -- Prevents ghosting after opening menu
            local timelastrun = 0
            ZO_CompassFrame:SetHandler(
                "OnUpdate", function(self, timerun)
                    if (timerun - timelastrun) >= 0 then
                        timelastrun = timerun
                        ZO_Compass:SetHidden(true)
                    end
                end
            )
        else
            ZO_Compass:SetHidden(false)
            ZO_Compass:SetAlpha(100)
            ZO_CompassFrameCenter:SetHidden(false)
            ZO_CompassFrameLeft:SetHidden(false)
            ZO_CompassFrameRight:SetHidden(false)

            -- Hide compass after it has been updated
            -- Prevents ghosting after opening menu
            local timelastrun = 0
            ZO_CompassFrame:SetHandler(
                "OnUpdate", function(self, timerun)
                    if (timerun - timelastrun) >= 0 then
                        timelastrun = timerun
                        ZO_Compass:SetHidden(false)
                    end
                end
            )
        end
    end
end

function hideMinimap(boolean)
    if (ImmersiveHUDHider.savedVariables.hideMap) then
        if (boolean == true) then
            if (AUI) then

                if (AUI.Minimap.IsEnabled()) then
                    AUI.Minimap.Hide()
                    AUI.Settings.Minimap.hidden = true
                end
            end
            if (FyrMM) then
                FyrMM.Visible = false
                FyrMM.AutoHidden = true
            end
            ZO_WorldMap:SetAlpha(0)
        else
            if (AUI) then
                if (AUI.Minimap.IsEnabled()) then
                    AUI.Minimap.Show()
                    AUI.Settings.Minimap.hidden = false
                end
            end
            if (FyrMM) then
                FyrMM.Visible = true
                FyrMM.AutoHidden = false
            end
            ZO_WorldMap:SetAlpha(100)
        end
    end
end

function hideQuestTracker(boolean)
    if (ImmersiveHUDHider.savedVariables.hideQuestTracker) then
        -- AUI
        if (AUI_Questtracker) then
            if (boolean) then
                AUI_Questtracker:SetAlpha(0)
            else
                AUI_Questtracker:SetAlpha(100)
            end
        end

        -- Ravlox' Quest Tracker
        if (QUESTTRACKER) then
            if (boolean) then
                QUESTTRACKER.svCurrent.mainWindow.hideQuestWindow = true
                QUESTTRACKER.WINDOW_FRAGMENT:SetHiddenForReason("QuestTracker_UserSetting_Hidden", true)
            else
                QUESTTRACKER.svCurrent.mainWindow.hideQuestWindow = false
                QUESTTRACKER.WINDOW_FRAGMENT:SetHiddenForReason("QuestTracker_UserSetting_Hidden", false)
            end
        end
    end
end

function hideTargetInfo(boolean)
    if (ImmersiveHUDHider.savedVariables.hideTargetInfo) then
        if (boolean == true) then
            -- Default target frame
            EVENT_MANAGER:RegisterForEvent(
                "toggleTargetInfo", EVENT_RETICLE_TARGET_CHANGED, function()
                    if ZO_TargetUnitFramereticleover then
                        ZO_TargetUnitFramereticleover:SetHidden(true)
                    end
                end
            )
            -- AUI target frame
            if (AUI) then
                if (AUI.UnitFrames.Target.IsEnabled()) then
                    table.insert(AUIUnitFramesToHide, 201)
                    table.insert(AUIUnitFramesToHide, 202)
                    table.insert(AUIUnitFramesToHide, 211)
                    table.insert(AUIUnitFramesToHide, 212)
                    hideAUIUnitFrames()
                end
            end
        else
            -- Reset main target hud
            EVENT_MANAGER:UnregisterForEvent(
                "toggleTargetInfo", EVENT_RETICLE_TARGET_CHANGED, function()
                    if ZO_TargetUnitFramereticleover then
                        ZO_TargetUnitFramereticleover:SetHidden(false)
                    end
                end
            )

            -- Reset AUI target hud
            if (AUI) then
                if (AUI.UnitFrames.Target.IsEnabled()) then
                    AUIUnitFramesToHide = {}
                    hideAUIUnitFrames()
                end
            end
        end
    end
end

function hideBossBar(boolean)
    if (ImmersiveHUDHider.savedVariables.hideBossBar) then
        if (boolean == true) then
            ZO_BossBar:SetAlpha(0)
        else
            ZO_BossBar:SetAlpha(100)
        end
    end
end

function hideAttributeBars(boolean)
    if (ImmersiveHUDHider.savedVariables.hideAttributeBar) then
        if (boolean == true) then
            -- Vanilla
            SetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_RESOURCE_BARS, "false", DO_NOT_SAVE_TO_PERSISTED_DATA)

            -- AUI
            if (AUI) then
                if (AUI.UnitFrames.Player.IsEnabled()) then
                    local gCurrentTemplateData = AUI.UnitFrames.GetActiveTemplates()
                    for _, templateData in pairs(gCurrentTemplateData) do
                        for frameType, data in pairs(templateData.frameData) do
                            control = data.control
                            for _, templateData in pairs(gCurrentTemplateData) do
                                for frameType, data in pairs(templateData.frameData) do
                                    control = data.control

                                    if (AUI.UnitFrames.IsPlayer(control.attributeId)) then
                                        table.insert(AUIUnitFramesToHide, 101)
                                        table.insert(AUIUnitFramesToHide, 102)
                                        table.insert(AUIUnitFramesToHide, 103)
                                        hideAUIUnitFrames()
                                    end

                                    break
                                end
                            end
                            break
                        end
                    end
                end
            end

        else
            -- Vanilla
            SetSetting(
                SETTING_TYPE_UI, UI_SETTING_SHOW_RESOURCE_BARS, ImmersiveHUDHider.savedVariables.defaultAttributeBar, DO_NOT_SAVE_TO_PERSISTED_DATA
            )

            -- AUI
            if (AUI) then
                if (AUI.UnitFrames.Player.IsEnabled()) then
                    AUIUnitFramesToHide = {}
                    hideAUIUnitFrames()
                end
            end
        end
    end
end

function hideFloatingMarkers(boolean)
    if (ImmersiveHUDHider.savedVariables.hideQuestBestowerIndicator) then
        if (boolean == true) then
            SetFloatingMarkerGlobalAlpha(0)
        else
            SetFloatingMarkerGlobalAlpha(100)
        end
    end
end

function hideGroupFrames(boolean)
    if (ImmersiveHUDHider.savedVariables.hideGroupUnitFrames) then
        if (boolean) then
            -- Vanilla
            ZO_UnitFramesGroups:SetHidden(true)

            -- AUI
            if (AUI) then
                if (AUI.UnitFrames.Group.IsEnabled()) then
                    local gCurrentTemplateData = AUI.UnitFrames.GetActiveTemplates()
                    for _, templateData in pairs(gCurrentTemplateData) do
                        for frameType, data in pairs(templateData.frameData) do
                            control = data.control
                            for _, templateData in pairs(gCurrentTemplateData) do
                                for frameType, data in pairs(templateData.frameData) do
                                    control = data.control

                                    if (AUI.UnitFrames.IsPlayer(control.attributeId)) then
                                        table.insert(AUIUnitFramesToHide, 301)
                                        table.insert(AUIUnitFramesToHide, 302)
                                        table.insert(AUIUnitFramesToHide, 303)
                                        hideAUIUnitFrames()
                                    end

                                    break
                                end
                            end
                            break
                        end
                    end
                end
            end
        else
            -- Vanilla
            ZO_UnitFramesGroups:SetHidden(false)

            -- AUI
            if (AUI) then
                if (AUI.UnitFrames.Group.IsEnabled()) then
                    ZO_UnitFramesGroups:SetHidden(true)
                    AUIUnitFramesToHide = {}
                    hideAUIUnitFrames()
                end
            end
        end
    end

end

function hideNameplateHealthbars(boolean)
    if (ImmersiveHUDHider.savedVariables.hideNameplateHealthbars) then
        if (boolean) then
            SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALL_HEALTHBARS, "false", DO_NOT_SAVE_TO_PERSISTED_DATA)
        else
            SetSetting(
                SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_ALL_HEALTHBARS, ImmersiveHUDHider.savedVariables.defaultAllHealthBars,
                DO_NOT_SAVE_TO_PERSISTED_DATA
            )
        end
    end
end

function hideHUD(boolean)
    hideInteractableGlow(boolean)
    hideTargetGlow(boolean)
    hideQuestBestowerIdicator(boolean)
    hideGroupIndicators(boolean)
    hideFollowIndicator(boolean)
    hideAllianceIndicators(boolean)
    hideResurrectIndicator(boolean)
    hideAllNamePlates(boolean)
    hideChatBubbles(boolean)
    hideActionBar(boolean)
    hideBuffs(boolean)
    hideScrollingCombatText(boolean)
    hideLootLog(boolean)
    hideCompass(boolean)
    hideMinimap(boolean)
    hideQuestTracker(boolean)
    hideTargetInfo(boolean)
    hideBossBar(boolean)
    hideAttributeBars(boolean)
    hideFloatingMarkers(boolean)
    hideGroupFrames(boolean)
    hideNameplateHealthbars(boolean)
end

function ImmersiveHUDHider.ImmersiveHUDHiderToggler()
    if not ImmersiveHUDHider.savedVariables.ImmersiveHUDHider_isUIHidden then
        ImmersiveHUDHider.interfaceEventHandlerToggle()
        hideHUD(true)
        ImmersiveHUDHider.savedVariables.ImmersiveHUDHider_isUIHidden = true
    else
        ImmersiveHUDHider.interfaceEventHandlerToggle()
        ImmersiveHUDHider.setSettingsFromFile()
        hideHUD(false)
        ImmersiveHUDHider.savedVariables.ImmersiveHUDHider_isUIHidden = false
    end
end

function ImmersiveHUDHider:Initialize()
    ImmersiveHUDHider.savedVariables = ZO_SavedVars:NewAccountWide(
                                           "ImmersiveHUDHiderSavedVariables", ImmersiveHUDHider.version, nil, ImmersiveHUDHider.default
                                       )
    ImmersiveHUDHider.buildMenu()
    if ImmersiveHUDHider.savedVariables.ImmersiveHUDHider_isUIHidden == true then
        ImmersiveHUDHider.setSettingsFromFile()
        ImmersiveHUDHider.savedVariables.ImmersiveHUDHider_isUIHidden = false
    else
        ImmersiveHUDHider.saveSettingsToFile()
        ImmersiveHUDHider.savedVariables.ImmersiveHUDHider_isUIHidden = false
    end

    ImmersiveHUDHider.savedVariables.isInterfaceEventHandler = 0
    ImmersiveHUDHider.interfaceEventHandlerToggle()
    EVENT_MANAGER:UnregisterForEvent(ImmersiveHUDHider.name, EVENT_ADD_ON_LOADED)
end

function ImmersiveHUDHider.OnAddOnLoaded(event, addonName)
    if addonName == ImmersiveHUDHider.name then
        ImmersiveHUDHider:Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(ImmersiveHUDHider.name, EVENT_ADD_ON_LOADED, ImmersiveHUDHider.OnAddOnLoaded)

SLASH_COMMANDS["/immersivelyhideui"] = ImmersiveHUDHider.ImmersiveHUDHiderToggler

function ImmersiveHUDHider.buildMenu(addonName, version)
    local LAM = LibAddonMenu2

    local panelData = {
        type = "panel", name = "Customisable Immersive HUD Hider", displayName = "Customisable Immersive HUD Hider", author = "Alfthebigheaded",
        version = ImmersiveHUDHider.version, registerForRefresh = true, registerForDefaults = true
    }

    LAM:RegisterAddonPanel("Customisable Immersive HUD Hider", panelData)

    local optionsData = {
        {type = "header", name = "CIHUDH Header"}, {type = "description", name = "desc"}, {
            type = "checkbox", name = "Hide Interactable Glow", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideInteractableGlow
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideInteractableGlow = true
                else
                    ImmersiveHUDHider.savedVariables.hideInteractableGlow = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideInteractableGlow
        }, {
            type = "checkbox", name = "Hide Target Glow", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideTargetGlow
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideTargetGlow = true
                else
                    ImmersiveHUDHider.savedVariables.hideTargetGlow = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideTargetGlow
        }, {
            type = "checkbox", name = "Hide Quest Bestowers", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideQuestBestowerIndicator
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideQuestBestowerIndicator = true
                else
                    ImmersiveHUDHider.savedVariables.hideQuestBestowerIndicator = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideQuestBestowerIndicator
        }, {
            type = "checkbox", name = "Hide Group Indicators", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideGroupIndicators
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideGroupIndicators = true
                else
                    ImmersiveHUDHider.savedVariables.hideGroupIndicators = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideGroupIndicators
        }, {
            type = "checkbox", name = "Hide Follow Indicator", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideFollowIndicator
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideFollowIndicator = true
                else
                    ImmersiveHUDHider.savedVariables.hideFollowIndicator = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideFollowIndicator
        }, {
            type = "checkbox", name = "Hide Alliance Indicators", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideAllianceIndicators
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideAllianceIndicators = true
                else
                    ImmersiveHUDHider.savedVariables.hideAllianceIndicators = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideAllianceIndicators
        }, {
            type = "checkbox", name = "Hide Ressurrect Indicator", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideResurrectIndicator
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideResurrectIndicator = true
                else
                    ImmersiveHUDHider.savedVariables.hideResurrectIndicator = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideResurrectIndicator
        }, {
            type = "checkbox", name = "Hide Health Bars", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideAllHealthBars
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideAllHealthBars = true
                else
                    ImmersiveHUDHider.savedVariables.hideAllHealthBars = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideAllHealthBars
        }, {
            type = "checkbox", name = "Hide Name Plates", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideAllNamePlates
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideAllNamePlates = true
                else
                    ImmersiveHUDHider.savedVariables.hideAllNamePlates = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideAllNamePlates
        }, {
            type = "checkbox", name = "Hide Chat Bubbles", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideChatBubbles
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideChatBubbles = true
                else
                    ImmersiveHUDHider.savedVariables.hideChatBubbles = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideChatBubbles
        }, {
            type = "checkbox", name = "Hide Action Bar", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideActionBar
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideActionBar = true
                else
                    ImmersiveHUDHider.savedVariables.hideActionBar = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideActionBar
        }, {
            type = "checkbox", name = "Hide Attribute Bars", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideAttributeBar
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideAttributeBar = true
                else
                    ImmersiveHUDHider.savedVariables.hideAttributeBar = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideAttributeBar
        }, {
            type = "checkbox", name = "Hide Buffs", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideBuffs
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideBuffs = true
                else
                    ImmersiveHUDHider.savedVariables.hideBuffs = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideBuffs
        }, {
            type = "checkbox", name = "Hide Scrolling Combat Text", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideScrollingCombatText
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideScrollingCombatText = true
                else
                    ImmersiveHUDHider.savedVariables.hideScrollingCombatText = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideScrollingCombatText
        }, {
            type = "checkbox", name = "Hide Loot Log", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideLootLog
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideLootLog = true
                else
                    ImmersiveHUDHider.savedVariables.hideLootLog = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideLootLog
        }, {
            type = "checkbox", name = "Hide Compass", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideCompass
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideCompass = true
                else
                    ImmersiveHUDHider.savedVariables.hideCompass = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideCompass
        }, {
            type = "checkbox", name = "Hide Map", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideMap
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideMap = true
                else
                    ImmersiveHUDHider.savedVariables.hideMap = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideMap
        }, {
            type = "checkbox", name = "Hide Quest Tracker", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideQuestTracker
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideQuestTracker = true
                else
                    ImmersiveHUDHider.savedVariables.hideQuestTracker = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideQuestTracker
        }, {
            type = "checkbox", name = "Hide Boss Bar", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideBossBar
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideBossBar = true
                else
                    ImmersiveHUDHider.savedVariables.hideBossBar = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideBossBar
        }, {
            type = "checkbox", name = "Hide Group Unit Frames", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideGroupUnitFrames
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideGroupUnitFrames = true
                else
                    ImmersiveHUDHider.savedVariables.hideGroupUnitFrames = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideGroupUnitFrames
        }, {
            type = "checkbox", name = "Hide Target Info", tooltip = "Toggle", getFunc = function()
                return ImmersiveHUDHider.savedVariables.hideTargetInfo
            end, setFunc = function(newValue)
                if (newValue) then
                    ImmersiveHUDHider.savedVariables.hideTargetInfo = true
                else
                    ImmersiveHUDHider.savedVariables.hideTargetInfo = false
                end
            end, width = "full", default = ImmersiveHUDHider.defaultSettingsMenu.hideTargetInfo
        }, {
            type = "button", name = "Apply Settings", func = function()
                ReloadUI()
            end
        }

    }

    LAM:RegisterOptionControls("Customisable Immersive HUD Hider", optionsData)
end
