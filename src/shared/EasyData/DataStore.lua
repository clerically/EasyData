--// DataStore handler
--// @company113
--// July 14, 2023

--// Services

local DataStoreService = game:GetService("DataStoreService")

--// Modules

local EvalOutput = require(script.Parent.EvalOutput)
local StringUtil = require(script.Parent.StringUtil)

--// Constants

--// Types

export type EasyDataStore = {
    GetData: (key: string) -> ({}?, {});
    SetData: (key: string, value: any) -> (boolean, string)
}

--// Variables

local DataStore = {}

--// Functions

function DataStore.Get(name: string, scope: string?) : EasyDataStore
    assert(type(name) == "string", "DataStore name must be a string")
    assert(StringUtil.IsEmpty(name) ~= true, "DataStore name must not be empty")

    local realDataStore = DataStoreService:GetDataStore(name, scope)
    local fakeDataStore: EasyDataStore = {}

    function fakeDataStore.GetData(key: string)
        assert(type(key) == "string", "Provided key must be a string")
        assert(StringUtil.IsEmpty(key) ~= true, "Provided key must not be empty")

        local getSuccess, returnData = pcall(function()
            return realDataStore:GetAsync(key)
        end)

        if (not EvalOutput(getSuccess == false, `Failed to retrieve data from {name} ({scope}) using key {key}\nError: {returnData}`, "warn")) then
            if (returnData == nil) then
                returnData = {}
            end
            
            return returnData
        end

        return nil
    end

    function fakeDataStore.SetData(key: string, value: any)
        assert(type(key) == "string", "Provided key must be a string")
        assert(StringUtil.IsEmpty(key) ~= true, "Provided key must not be empty")

        assert(type(value) ~= "userdata" and type(value) ~= "nil", "Provided value must not be userdata or nil")

        local setSuccess, errorMessage = pcall(function()
            realDataStore:SetAsync(key, value)
        end)

        EvalOutput(setSuccess == false, `Failed to set data from {name} ({scope}) using key {key}\nError: {errorMessage}`, "warn")
        return setSuccess, errorMessage
    end

    return fakeDataStore
end

--// Connections

return DataStore