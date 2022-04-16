-- Simple Group Saving by Pikey May 2019 https://github.com/thebgpikester/SimpleGroupSaving/
-- Usage of this script should credit the following contributors:
--Pikey,
--Speed & Grimes for their work on Serialising tables, included below,
--FlightControl for MOOSE (Required)

--INTENDED USAGE
--DCS Server Admins looking to do long term multi session play that will need a server reboot in between and they wish to keep the Ground
--Unit positions true from one reload to the next.

--USAGE
--Ensure LFS and IO are not santitised in missionScripting.lua. This enables writing of files. If you don't know what this does, don't attempt to use this script.
--Requires versions of MOOSE.lua supporting "SET:ForEachGroupAlive()". Should be good for 6 months or more from date of writing.
--MIST not required, but should work OK with it regardless.
--Edit 'SaveScheduleUnits' below, (line 34) to the number of seconds between saves. Low impact. 10 seconds is a fast schedule.
--Place Ground Groups wherever you want on the map as normal.
--Run this script at Mission start
--The script will create a small file with the list of Groups and Units.
--At Mission Start it will check for a save file, if not there, create it fresh
--If the table is there, it loads it and Spawns everything that was saved.
--The table is updated throughout mission play
--The next time the mission is loaded it goes through all the Groups again and loads them from the save file.

--LIMITATIONS
--Only Ground Groups and Units are specified, play with the SET Filter at your own peril. Could be adjusted for just one Coalition or a FilterByName().
--See line 107 and 168 for the SET.
--See https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Set.html##(SET_GROUP)
--Naval Groups not Saved. If Included, there may be issues with spawned objects and Client slots where Ships have slots for aircraft/helo. Possible if not a factor
--Statics are not included. See 'Simple Static Saving' for a solution
--Routes are not saved. Uncomment lines 148-153 if you wish to keep them, but they won't activate them on restart. It is impossible to query a group for it's current
--route, only for the original route it recieved from the Mission Editor. Therefore a DCS limitation.
-----------------------------------
--Configurable for user:
SaveScheduleUnits = 120 --how many seconds between each check of all the statics.
-----------------------------------
--Do not edit below here
-----------------------------------
local version = "1.0"
--

--[[
 HideObject = {"Blue EWR", "Blue Base SA-19", "Blue Base SA-15","Blue Base SA-15 #001",
				"Blue Base SA-15 #002", "Blue Base SA-15 #006",  "Blue JTAC对地组 #001",
				"Blue Rearm #001", "Blue Rearm #002", "Blue SA-15Front #003","Red Base SA-19",
				"Red EWR","Red Rearm #001","Red Rearm #002","新车辆群组 #004","新车辆群组 #007",
				"新车辆群组 #008","新车辆群组 #009"}
			]] HideObject = {
  "Blue EWR",
  "Blue Base SA-19",
  "Blue Base SA-15",
  "Blue Base SA-15 #001",
  "Blue Base SA-15 #002",
  "Blue Base SA-15 #006",
  "Blue JTAC对地组 #001",
  "Blue Rearm #001",
  "Blue Rearm #002",
  "Blue SA-15Front #003",
  "Red Base SA-19",
  "Red EWR",
  "Red Rearm #001",
  "Red Rearm #002",
  "新车辆群组 #004",
  "新车辆群组 #007",
  "新车辆群组 #008",
  "新车辆群组 #009",
  
  "Downed Pilot #951",
  "Downed Pilot #952",
  "Downed Pilot #953",
  "Downed Pilot #954",
  "Downed Pilot #955",
  "Downed Pilot #956",
  "Downed Pilot #957",
  "Downed Pilot #958",
  "Downed Pilot #959",
  "Downed Pilot #960",
  "Downed Pilot #961",
  "Downed Pilot #962",
  "Downed Pilot #963",
  "Downed Pilot #964",
  "Downed Pilot #965",
  "Downed Pilot #966",
  "Downed Pilot #967",
  "Downed Pilot #968",
  "Downed Pilot #969",
  "Downed Pilot #970",
  "Downed Pilot #971",
  "Downed Pilot #972",
  "Downed Pilot #973",
  "Downed Pilot #974",
  "Downed Pilot #975",
  "Downed Pilot #976",
  "Downed Pilot #977",
  "Downed Pilot #978",
  "Downed Pilot #979",
  "Downed Pilot #980",
  "Downed Pilot #981",
  "Downed Pilot #982",
  "Downed Pilot #983",
  "Downed Pilot #984",
  "Downed Pilot #985",
  "Downed Pilot #986",
  "Downed Pilot #987",
  "Downed Pilot #988",
  "Downed Pilot #989",
  "Downed Pilot #990",
  "Downed Pilot #991",
  "Downed Pilot #992",
  "Downed Pilot #993",
  "Downed Pilot #994",
  "Downed Pilot #995",
  "Downed Pilot #996",
  "Downed Pilot #997",
  "Downed Pilot #998",
  "Downed Pilot #999",

  "LZR #1",
  "LZR #2",
  "LZR #11",
  "LZR #21",
  "LZR-1",
  "LZR-2",
  "LZR-3",
  "LZR-4",

  "LZB #1",
  "LZB #2",
  "LZB #11",
  "LZB #21",
  "LZB-1",
  "LZB-2",
  "LZB-3",
  "LZB-4",

  "Blue Base SA-5",
  "Blue Base SA-6",
  "Blue Base SA-7",
  "Blue Base SA-8",
  "Blue Base SA-1",
  "Blue Base SA-2",
  "Blue Base SA-3",
  "Blue Base SA-4"
}

-- env.info("SGS adding")

function IntegratedbasicSerialize(s)
  if s == nil then
    return '""'
  else
    if ((type(s) == "number") or (type(s) == "boolean") or (type(s) == "function") or (type(s) == "table") or (type(s) == "userdata")) then
      return tostring(s)
    elseif type(s) == "string" then
      return string.format("%q", s)
    end
  end
end

-- imported slmod.serializeWithCycles (Speed)
function IntegratedserializeWithCycles(name, value, saved)
  local basicSerialize = function(o)
    if type(o) == "number" then
      return tostring(o)
    elseif type(o) == "boolean" then
      return tostring(o)
    else -- assume it is a string
      return IntegratedbasicSerialize(o)
    end
  end

  local t_str = {}
  saved = saved or {} -- initial value
  if ((type(value) == "string") or (type(value) == "number") or (type(value) == "table") or (type(value) == "boolean")) then
    table.insert(t_str, name .. " = ")
    if type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
      table.insert(t_str, basicSerialize(value) .. "\n")
    else
      if saved[value] then -- value already saved?
        table.insert(t_str, saved[value] .. "\n")
      else
        saved[value] = name -- save name for next time
        table.insert(t_str, "{}\n")
        for k, v in pairs(value) do -- save its fields
          local fieldname = string.format("%s[%s]", name, basicSerialize(k))
          table.insert(t_str, IntegratedserializeWithCycles(fieldname, v, saved))
        end
      end
    end
    return table.concat(t_str)
  else
    return ""
  end
end

function file_exists(name) --check if the file already exists for writing
  if lfs.attributes(name) then
    return true
  else
    return false
  end
end

function writemission(data, file) --Function for saving to file (commonly found)
  File = io.open(file, "w")
  File:write(data)
  File:close()
end

--SCRIPT START
-- env.info("Loaded Simple Group Saving, by Pikey, 2018, version " .. version)

if file_exists("SaveUnits.lua") then --Script has been run before, so we need to load the save
  -- env.info("Existing database, loading from File.")
  trigger.action.outText("检测到缓存文件，开始恢复动态保存单位！！！！！！！！！", 50)
  AllGroups = SET_GROUP:New():FilterCategories("ground"):FilterActive(true):FilterStart()
  AllGroups:ForEachGroup(
    function(grp)
      grp:Destroy()
    end
  )

  dofile("SaveUnits.lua")
  tempTable = {}
  Spawn = {}
  --RUN THROUGH THE KEYS IN THE TABLE (GROUPS)
  for k, v in pairs(SaveUnits) do
    units = {}
    --RUN THROUGH THE UNITS IN EACH GROUP
    for i = 1, #(SaveUnits[k]["units"]) do
      tempTable = {
        ["type"] = SaveUnits[k]["units"][i]["type"],
        ["transportable"] = {["randomTransportable"] = false},
        --["unitId"]=9000,used to generate ID's here but no longer doing that since DCS seems to handle it
        ["skill"] = SaveUnits[k]["units"][i]["skill"],
        ["y"] = SaveUnits[k]["units"][i]["y"],
        ["x"] = SaveUnits[k]["units"][i]["x"],
        ["name"] = SaveUnits[k]["units"][i]["name"],
        ["heading"] = SaveUnits[k]["units"][i]["heading"],
        ["playerCanDrive"] = true --hardcoded but easily changed.
      }

      table.insert(units, tempTable)
    end --end unit for loop

    local _flag = false
    for k2, v2 in ipairs(HideObject) do
      -- env.info("save u: " .. SaveUnits[k]["name"])
      -- env.info("v: " .. v2)

      if SaveUnits[k]["name"] == v2 then
        _flag = true
      -- env.info("Hiden object detected")
      end
    end

    groupData = {
      ["visible"] = true,
      --trigger.action.outText("测试：" .. units.name, 50)
      --["lateActivation"] = false,
      ["tasks"] = {}, -- end of ["tasks"]
      ["uncontrollable"] = false,
      ["task"] = "Ground Nothing",
      --["taskSelected"] = true,
      --["route"] =
      --{
      --["spans"] = {},
      --["points"]= {}
      -- },-- end of ["spans"]
      --["groupId"] = 9000 + _count,
      ["hidden"] = _flag,
      ["units"] = units,
      ["y"] = SaveUnits[k]["y"],
      ["x"] = SaveUnits[k]["x"],
      ["name"] = SaveUnits[k]["name"]

      --["start_time"] = 0,
    }

    coalition.addGroup(SaveUnits[k]["CountryID"], SaveUnits[k]["CategoryID"], groupData)
    groupData = {}
  end --end Group for loop
else --Save File does not exist we start a fresh table, no spawns needed
  SaveUnits = {}
  AllGroups = SET_GROUP:New():FilterCategories("ground"):FilterActive(true):FilterStart()
end

--THE SAVING SCHEDULE
SCHEDULER:New(
  nil,
  function()
    AllGroups:ForEachGroupAlive(
      function(grp)
        local DCSgroup = Group.getByName(grp:GetName())
        local size = DCSgroup:getSize()

        _unittable = {}

        for i = 1, size do
          local tmpTable = {
            ["type"] = grp:GetUnit(i):GetTypeName(),
            ["transportable"] = true,
            ["unitID"] = grp:GetUnit(i):GetID(),
            ["skill"] = "Average",
            ["y"] = grp:GetUnit(i):GetVec2().y,
            ["x"] = grp:GetUnit(i):GetVec2().x,
            ["name"] = grp:GetUnit(i):GetName(),
            ["playerCanDrive"] = true,
            ["heading"] = grp:GetUnit(i):GetHeading()
          }

          table.insert(_unittable, tmpTable) --add units to a temporary table
        end

        --Blue EWR
        --Blue Base SA-19
        --Blue Base SA-15
        --Blue Base SA-15 #001
        --Blue Base SA-15 #002

        --Blue Base SA-15 #006
        --Blue JTAC对地组 #001
        --Blue Rearm #001
        --Blue Rearm #002
        --Blue SA-15Front #003
        --Red Base SA-19
        --Red EWR
        --Red Rearm #001
        --Red Rearm #002

        --if grp:GetName()~="Blue EWR" and grp:GetName()~="Blue Base SA-19" and grp:GetName()~="Blue Base SA-15" and grp:GetName()~="Blue Base SA-15 #001" and grp:GetName()~="Blue Base SA-15 #002" and grp:GetName()~="Blue Base SA-15 #006" and grp:GetName()~="Blue JTAC对地组 #001" and grp:GetName()~="Blue Rearm #001" and grp:GetName()~="Blue Rearm #002" and grp:GetName()~="Blue SA-15Front #003" and grp:GetName()~="Red Base SA-19" and grp:GetName()~="Red EWR" and grp:GetName()~="Red Rearm #001" and grp:GetName()~="Red Rearm #002"  then
        SaveUnits[grp:GetName()] = {
          ["CountryID"] = grp:GetCountry(),
          ["SpawnCoalitionID"] = grp:GetCountry(),
          ["tasks"] = {}, --grp:GetTaskMission(), --wrong gives the whole thing
          ["CategoryID"] = grp:GetCategory(),
          ["task"] = "Ground Nothing",
          ["route"] = {}, -- grp:GetTaskRoute(),
          ["groupId"] = grp:GetID(),
          --["SpawnCategoryID"]=grp:GetCategory(),
          ["units"] = _unittable,
          ["y"] = grp:GetVec2().y,
          ["x"] = grp:GetVec2().x,
          ["name"] = grp:GetName(),
          ["start_time"] = 0,
          ["CoalitionID"] = grp:GetCoalition(),
          ["SpawnCountryID"] = grp:GetCoalition()
        }
        --end
      end
    )

    newMissionStr = IntegratedserializeWithCycles("SaveUnits", SaveUnits) --save the Table as a serialised type with key SaveUnits
    writemission(newMissionStr, "SaveUnits.lua")
    --write the file from the above to SaveUnits.lua
    SaveUnits = {}
    --clear the table for a new write.
    --env.info("Data saved.")
  end,
  {},
  1,
  SaveScheduleUnits
)

env.info("***SGS加载***")
