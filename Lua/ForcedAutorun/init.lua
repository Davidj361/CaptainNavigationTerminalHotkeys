CNTH = {}
CNTH.name = '[CaptainNavigationTerminalHotkeys]'
CNTH.Log = function (message)
  print(CNTH.name .. " " .. message)
end
CNTH.Path = table.pack(...)[1]
CNTH.Debug = false
local hello = "Starting up!"


-- config loading
if CNTH.config == nil then
  if not File.Exists(CNTH.Path .. "/config.json") then

    -- create default config if there is no config file
    CNTH.Config = dofile(CNTH.Path .. "/Lua/defaultConfig.lua")
    File.Write(CNTH.Path .. "/config.json", json.serialize(CNTH.Config))

  else

    -- load existing config
    CNTH.Config = json.parse(File.Read(CNTH.Path .. "/config.json"))

    -- add missing entries
    local defaultConfig = dofile(CNTH.Path .. "/Lua/defaultConfig.lua")
    for key, value in pairs(defaultConfig) do
      if CNTH.Config[key] == nil then
        CNTH.Config[key] = value
      end
    end
  end
end


if CLIENT then

  if CNTH.cl == nil then
    CNTH.cl = {}
  else
    return
  end

  CNTH.Log("[Client] "..hello)
  CNTH.Angle = 2 -- Degrees of turning directional sonar
  local Sonar = Descriptors["Barotrauma.Items.Components.Sonar"]
  LuaUserData.MakeFieldAccessible(Sonar, "useDirectionalPing")
  LuaUserData.MakeFieldAccessible(Sonar, "directionalModeSwitch")
  LuaUserData.MakeFieldAccessible(Sonar, "pingDirection")
  LuaUserData.MakeMethodAccessible(Sonar, "SetPingDirection")


  -- catch faulty user inputted key configs
  local function tryKey(key, f)
    -- PlayerInput.KeyHit(Keys[CNTH.Config.yourHotkey])
    a,b = pcall(function()
        return PlayerInput[f](Keys[key])
    end)
    return b
  end

  -- Utilizes rotation matrix to rotate the unit vector
  local function rotatePing(sonarGui, a)
    if PlayerInput.KeyDown(InputType.Run) then a = a*2 end
    local dir = sonarGui.pingDirection
    local v = Vector2(0,0)
    v.x = ( dir.x * math.cos(a) ) - ( dir.y * math.sin(a) )
    v.y = ( dir.x * math.sin(a) ) + ( dir.y * math.cos(a) )
    sonarGui.SetPingDirection( v )
  end

  Hook.Add("think", "CNTHhook",
           function()

             if not CNTH.Config.toggleHotkeys or Character.Controlled == nil then return end
             local struct = Character.Controlled.SelectedConstruction
             if struct == nil then return end
             local steerGui = struct.GetComponentString("Steering")
             if steerGui == nil then return end
             local sonarGui = struct.GetComponentString("Sonar")
             if sonarGui == nil then return end
             if not Character.DisableControls and GUI.GUI.KeyboardDispatcher.Subscriber == nil then
               if tryKey(CNTH.Config.toggleSonar, "KeyHit") then
                 sonarGui.SonarModeSwitch.Selected = not sonarGui.SonarModeSwitch.Selected
                 if sonarGui.SonarModeSwitch.Selected then
                   sonarGui.CurrentMode = sonarGui.Mode.Active
                 else
                   sonarGui.CurrentMode = sonarGui.Mode.Passive
                 end
               end
               if tryKey(CNTH.Config.sonarDirection, "KeyHit") then
                 sonarGui.useDirectionalPing = not sonarGui.useDirectionalPing;
                 sonarGui.directionalModeSwitch.Selected = not sonarGui.directionalModeSwitch.Selected
               end
               if tryKey(CNTH.Config.autoPilot, "KeyHit") then
                 steerGui.AutoPilot = not steerGui.AutoPilot
               end
               if tryKey(CNTH.Config.sonarDirLeft, "KeyDown") then
                 rotatePing(sonarGui, math.rad(-CNTH.Angle))
               end
               if tryKey(CNTH.Config.sonarDirRight, "KeyDown") then
                 rotatePing(sonarGui, math.rad(CNTH.Angle))
               end
             end
  end)

  -- Add a GUI for configuration
  dofile(CNTH.Path .. "/Lua/configGui.lua")

end
