CNTH = {}
CNTH.name = '[CaptainNavigationTerminalHotkeys]'
CNTH.Log = function (message)
  print(CNTH.name .. " " .. message)
end
CNTH.Path = table.pack(...)[1]
CNTH.Debug = false
local hello = "Starting up!"



if CLIENT then

  if CNTH.cl == nil then
    CNTH.cl = {}
  else
    return
  end

  CNTH.Log("[Client] "..hello)
  CNTH.Angle = 2
  -- LuaUserData.RegisterType("Barotrauma.GameMain")
  -- local GameMain = LuaUserData.CreateStatic("Barotrauma.GameMain")
  local Steering = Descriptors["Barotrauma.Items.Components.Steering"]
  LuaUserData.MakeFieldAccessible(Steering, "maintainPosTickBox")
  local Sonar = Descriptors["Barotrauma.Items.Components.Sonar"]
  LuaUserData.MakeFieldAccessible(Sonar, "useDirectionalPing")
  LuaUserData.MakeFieldAccessible(Sonar, "directionalModeSwitch")
  LuaUserData.MakeFieldAccessible(Sonar, "pingDirection")
  LuaUserData.MakeMethodAccessible(Sonar, "SetPingDirection")


  -- catch faulty user inputted key configs
  local function tryKey()
    if PlayerInput.KeyHit(Keys[CNTH.Config.logKey]) then
      -- GameMain.Client.ShowLogButton.OnClicked.Invoke()
    end
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

             if not Game.RoundStarted then return end
             if Character.Controlled == nil then return end
             local struct = Character.Controlled.SelectedConstruction
             if struct == nil then return end
             local steerGui = struct.GetComponentString("Steering")
             if steerGui == nil then return end
             local sonarGui = struct.GetComponentString("Sonar")
             if sonarGui == nil then return end
             if not Character.DisableControls and GUI.GUI.KeyboardDispatcher.Subscriber == nil then
               if PlayerInput.KeyHit(Keys.F) then
                 sonarGui.SonarModeSwitch.Selected = not sonarGui.SonarModeSwitch.Selected
                 if sonarGui.SonarModeSwitch.Selected then
                   sonarGui.CurrentMode = sonarGui.Mode.Active
                 else
                   sonarGui.CurrentMode = sonarGui.Mode.Passive
                 end
               elseif PlayerInput.KeyHit(Keys.G) then
                 sonarGui.useDirectionalPing = not sonarGui.useDirectionalPing;
                 sonarGui.directionalModeSwitch.Selected = not sonarGui.directionalModeSwitch.Selected
               elseif PlayerInput.KeyHit(Keys.X) then
                 steerGui.AutoPilot = not steerGui.AutoPilot
               elseif PlayerInput.KeyDown(Keys.Q) then
                 rotatePing(sonarGui, math.rad(-CNTH.Angle))
               elseif PlayerInput.KeyDown(Keys.E) then
                 rotatePing(sonarGui, math.rad(CNTH.Angle))
               end
             end
  end)

end
