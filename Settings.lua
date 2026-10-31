-- Options page: Esc > Options > AddOns > RpBuffBeg. Built at login, once the saved variables exist.
local _, ns = ...

function ns.BuildSettings()
    local category, layout = Settings.RegisterVerticalLayoutCategory("RpBuffBeg")
    ns.settingsCategory = category

    local function Header(text)
        layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(text))
    end

    local function Button(name, text, onClick, tooltip)
        layout:AddInitializer(CreateSettingsButtonInitializer(name, text, onClick, tooltip, false))
    end

    Header("Your character")
    -- Per character: each of your characters can have a voice of their own.
    local persona = Settings.RegisterAddOnSetting(category, "RPBUFFBEG_PERSONA", "persona", RpBuffBegCharDB,
        Settings.VarType.String, "Personality", ns.DEFAULT_PERSONA)
    local function Options()
        local container = Settings.CreateControlTextContainer()
        for _, p in ipairs(ns.PERSONAS) do container:Add(p.key, p.label, p.desc) end
        return container:GetData()
    end
    Settings.CreateDropdown(category, persona, Options,
        "How this character asks for buffs and says thank you. Each character has their own.")
    local accent = Settings.RegisterAddOnSetting(category, "RPBUFFBEG_ACCENT", "accent", RpBuffBegCharDB,
        Settings.VarType.String, "Accent", ns.DEFAULT_ACCENT)
    accent:SetValueChangedCallback(function() ns.AccentNote() end)
    Settings.CreateDropdown(category, accent, function()
        local container = Settings.CreateControlTextContainer()
        for _, a in ipairs(ns.ACCENTS) do container:Add(a.key, a.label, a.desc) end
        return container:GetData()
    end, "The accent this character's lines are said in. Each character has their own; a change is heard after a /reload.")
    Button("Sample lines", "Preview", function() ns.Preview() end,
        "Prints a few lines in this personality and accent to your chat. Only you see them.")

    Header("Chat")
    local channel = Settings.RegisterAddOnSetting(category, "RPBUFFBEG_CHANNEL", "channel", RpBuffBegDB,
        Settings.VarType.String, "Speak in", "SAY")
    Settings.CreateDropdown(category, channel, function()
        local container = Settings.CreateControlTextContainer()
        container:Add("SAY", "/say", "Everyone nearby hears you ask and thank.")
        container:Add("WHISPER", "Whisper", "Only your target hears you.")
        return container:GetData()
    end, "Where your asks and thank-yous go. Shared by all your characters.")

    Header("Button")
    local locked = Settings.RegisterAddOnSetting(category, "RPBUFFBEG_LOCKED", "locked", RpBuffBegDB,
        Settings.VarType.Boolean, "Lock position", true)
    Settings.CreateCheckbox(category, locked, "Shift-drag always moves the button.")
    -- No inline binding rows or search tags: they taint the options search in Forever.
    Button("Key bindings", "Key Bindings",
        function() Settings.OpenToCategory(Settings.KEYBINDINGS_CATEGORY_ID, "RpBuffBeg") end,
        "Bind the ask and thank keys in the RpBuffBeg section of the Key Bindings page.")

    Settings.RegisterAddOnCategory(category)
end
