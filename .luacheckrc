std = "lua51"
max_line_length = false
self = false

globals = {
    "RpBuffBegDB",
    "RpBuffBegCharDB",
    "SLASH_RPBUFFBEG1",
    "SLASH_RPBUFFBEG2",
    "SlashCmdList",
    "BINDING_HEADER_RPBUFFBEG",
    "_G",
}

read_globals = {
    -- Lua / WoW utility
    "format", "strtrim", "wipe", "floor",
    -- Frames & UI
    "CreateFrame", "UIParent", "TargetFrame", "EzBlessingsButton", "GameTooltip", "DEFAULT_CHAT_FRAME",
    "RAID_CLASS_COLORS", "NORMAL_FONT_COLOR",
    -- Settings panel
    "Settings", "CreateSettingsListSectionHeaderInitializer", "CreateSettingsButtonInitializer",
    -- Namespaced APIs
    "C_Spell", "C_UnitAuras", "C_Timer", "C_ChatInfo", "C_Secrets", "issecretvalue",
    "ChatFrameUtil", "ChatFrame_AddMessageEventFilter",
    -- Global APIs
    "GetBuildInfo", "GetSpellInfo", "GetTime", "UnitBuff", "UnitClass", "UnitName", "UnitLevel", "UnitIsUnit", "UnitExists", "UnitIsPlayer",
    "UnitIsFriend", "UnitIsDeadOrGhost", "IsInGroup", "SendChatMessage", "GetCVarBool", "IsShiftKeyDown", "InCombatLockdown",
    -- Other addons' saved variables
    "CampfireTalesForeverChar",
}
