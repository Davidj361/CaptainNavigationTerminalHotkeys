-- Taken from https://github.com/Mannatwo/Neurotrauma/blob/5a4b8c47de50a78996ccc483f99fd3db1769f951/Neurotrauma/Lua/Scripts/Client/configgui.lua#L1

-- I'm sorry for the eyes of anyone looking at the GUI code.

local MultiLineTextBox = dofile(CNTH.Path .. "/Lua/MultiLineTextBox.lua")

Game.AddCommand("cnth", "Opens Captain Navigation Terminal Hotkeys's config",
                function ()
                  CNTH.ToggleGUI()
end)

local function CommaStringToTable(str)
    local tbl = {}

    for word in string.gmatch(str, '([^,]+)') do
        table.insert(tbl, word)
    end

    return tbl
end
local function ClearElements(guicomponent, removeItself)
    local toRemove = {}

    for value in guicomponent.GetAllChildren() do
        table.insert(toRemove, value)
    end

    for index, value in pairs(toRemove) do
        value.RemoveChild(value)
    end

    if guicomponent.Parent and removeItself then
        guicomponent.Parent.RemoveChild(guicomponent)
    end
end
local function GetAmountOfPrefab(prefabs)
    local amount = 0
    for key, value in prefabs do
        amount = amount + 1
    end

    return amount
end


Hook.Add("stop", "CNTH.CleanupGUI", function ()
    if selectedGUIText then
        selectedGUIText.Parent.RemoveChild(selectedGUIText)
    end

    if CNTH.GUIFrame then
        ClearElements(CNTH.GUIFrame, true)
    end
end)

CNTH.ShowGUI = function ()
    local frame = GUI.Frame(GUI.RectTransform(Vector2(0.3, 0.6), GUI.Screen.Selected.Frame.RectTransform, GUI.Anchor.Center))

    CNTH.GUIFrame = frame

    frame.CanBeFocused = true

    local config = GUI.ListBox(GUI.RectTransform(Vector2(1, 1), frame.RectTransform, GUI.Anchor.BottomCenter))

    local closebtn = GUI.Button(GUI.RectTransform(Vector2(0.1, 0.3), frame.RectTransform, GUI.Anchor.TopRight), "X", GUI.Alignment.Center, "GUIButtonSmall")
    closebtn.OnClicked = function ()
        CNTH.ToggleGUI()
    end

    GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.1), config.Content.RectTransform), "Captain Navigation Terminal Hotkeys Config", nil, nil, GUI.Alignment.Center)

    GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.1), config.Content.RectTransform), "Use proper capitals for the hotkeys and press Enter", nil, nil, GUI.Alignment.Center)

    local savebtn = GUI.Button(GUI.RectTransform(Vector2(1, 0.2), config.Content.RectTransform), "Save Config", GUI.Alignment.Center, "GUIButtonSmall")
    savebtn.OnClicked = function ()
        File.Write(CNTH.Path .. "/config.json", json.serialize(CNTH.Config))
    end

    local toggleHotkeys = GUI.TickBox(GUI.RectTransform(Vector2(1, 0.2), config.Content.RectTransform), "Enable Hotkeys?")
    toggleHotkeys.Selected = CNTH.Config.toggleHotkeys
    toggleHotkeys.OnSelected = function ()
      CNTH.Config.toggleHotkeys = toggleHotkeys.State == 3
    end

    GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.05), config.Content.RectTransform), "Toggle Sonar Hotkey",
                  nil, nil, GUI.Alignment.Center, true)
    local toggleSonar = GUI.TextBox(GUI.RectTransform(Vector2(1, 0.1), config.Content.RectTransform))
    toggleSonar.Text = CNTH.Config.toggleSonar
    toggleSonar.OnEnterPressed = function ()
      CNTH.Config.toggleSonar = toggleSonar.Text
    end

    GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.05), config.Content.RectTransform), "Sonar Direction Hotkey",
                  nil, nil, GUI.Alignment.Center, true)
    local sonarDirection = GUI.TextBox(GUI.RectTransform(Vector2(1, 0.1), config.Content.RectTransform))
    sonarDirection.Text = CNTH.Config.sonarDirection
    sonarDirection.OnEnterPressed = function ()
      CNTH.Config.sonarDirection = sonarDirection.Text
    end

    GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.05), config.Content.RectTransform), "AutoPilot Hotkey",
                  nil, nil, GUI.Alignment.Center, true)
    local autoPilot = GUI.TextBox(GUI.RectTransform(Vector2(1, 0.1), config.Content.RectTransform))
    autoPilot.Text = CNTH.Config.autoPilot
    autoPilot.OnEnterPressed = function ()
      CNTH.Config.autoPilot = autoPilot.Text
    end

    GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.05), config.Content.RectTransform), "Sonar Direction Left Hotkey",
                  nil, nil, GUI.Alignment.Center, true)
    local sonarDirLeft = GUI.TextBox(GUI.RectTransform(Vector2(1, 0.1), config.Content.RectTransform))
    sonarDirLeft.Text = CNTH.Config.sonarDirLeft
    sonarDirLeft.OnEnterPressed = function ()
      CNTH.Config.sonarDirLeft = sonarDirLeft.Text
    end

    GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.05), config.Content.RectTransform), "Sonar Direction Right Hotkey",
                  nil, nil, GUI.Alignment.Center, true)
    local sonarDirRight = GUI.TextBox(GUI.RectTransform(Vector2(1, 0.1), config.Content.RectTransform))
    sonarDirRight.Text = CNTH.Config.sonarDirRight
    sonarDirRight.OnEnterPressed = function ()
      CNTH.Config.sonarDirRight = sonarDirRight.Text
    end



--[[

-- Multilines

    GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.05), config.Content.RectTransform), "Client High Priority Items", nil, nil, GUI.Alignment.Center, true)

    local clientHighPriorityItems = MultiLineTextBox(config.Content.RectTransform, "", 0.2)

    clientHighPriorityItems.Text = table.concat(NT.Config.clientItemHighPriority, ",")

    clientHighPriorityItems.OnTextChangedDelegate = function (textBox)
        NT.Config.clientItemHighPriority = CommaStringToTable(textBox.Text)
    end

-- Tickboxes

    local hideInGameWires = GUI.TickBox(GUI.RectTransform(Vector2(1, 0.2), config.Content.RectTransform), "Hide In Game Wires")

    hideInGameWires.Selected = NT.Config.hideInGameWires

    hideInGameWires.OnSelected = function ()
        NT.Config.hideInGameWires = hideInGameWires.State == 3
    end

    ]]
end


CNTH.HideGUI = function()
    if CNTH.GUIFrame then
        ClearElements(CNTH.GUIFrame, true)
    end
end

CNTH.GUIOpen = false
CNTH.ToggleGUI = function ()
    CNTH.GUIOpen = not CNTH.GUIOpen

    if CNTH.GUIOpen then
        CNTH.ShowGUI()
    else
        CNTH.HideGUI()
    end
end
