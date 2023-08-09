--// EasyData Core API
--// @company113
--// July 14, 2023

--// Modules

local DataStore = require(script.DataStore)

local EvalOutput = require(script.EvalOutput)
local StringUtil = require(script.StringUtil)

--// Constants

local DS_NAME_PLAYER = "PlayerData"

local DS_SCOPE_DEFAULT = "Default"

local DS_PLAYER = DataStore.Get(DS_NAME_PLAYER, DS_SCOPE_DEFAULT)

--// Variables

local EasyData = {}

--// Functions

local function checkValidInstance(input: Instance?, check: string?)
    if (not input or not check) then return false end
    
    if (typeof(input) ~= "Instance") then return false end
    if (not input:IsA(check)) then return false end

    return true
end

function EasyData.LoadPlayerData(player: Player)
    -- Is player valid?

    local didOutput = EvalOutput(
        not checkValidInstance(player, "Player"),
        `GetPlayerData() requires a valid Player instance ({typeof(player)} was given)`,
        "warn"
    )

    if (didOutput) then return nil, nil end

    -- Get data

    local playerKey = "u" .. player.UserId

    local playerData = DS_PLAYER.GetData(playerKey)
    local playerDataMeta = {}

    playerDataMeta.DataSize = StringUtil.GetTableLength(playerData)

    if (playerDataMeta.DataSize == 0) then
        playerDataMeta._isNew = true
        playerDataMeta._creationTime = os.time()
    end

    playerDataMeta._loadedAt = os.time()

    return playerData, playerDataMeta
end

function EasyData.SavePlayerData(player: Player, newData: any)
    -- Inputs are valid?

    local playerOutput = EvalOutput(
        not checkValidInstance(player, "Player"),
        `SetPlayerData() requires a valid Player instance ({typeof(player)} was given)`,
        "warn"
    )

    if (playerOutput) then return false end

    local newDataOutput = EvalOutput(
        type(newData) == "userdata" or type(newData) == "nil",
        `SetPlayerData() cannot store data of this type ({typeof(newData)})`,
        "warn"
    )

    if (newDataOutput) then return false end

    -- Set data

    local playerKey = "u" .. player.UserId
    local saveSuccess, saveError = DS_PLAYER.SetData(playerKey, newData)

    return saveSuccess
end

--// Connections

return EasyData