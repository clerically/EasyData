--// String utilities
--// @company113
--// July 14, 2023

--// Services

local HttpService = game:GetService("HttpService")

--// Constants

local WHITESPACE_CHARS = {
    " ";
}

local COMPONENT_LIMITS = {
    KeyName = 50;
    StoreName = 50;

    Data = 4_194_304;
    Scope = 50;
}

--// Variables

local StringUtil = {}

--// Functions

function StringUtil.IsEmpty(input: string?)
    if (type(input) ~= "string") then return true end
    
    local processed = input

    for _, charString in WHITESPACE_CHARS do
        processed = string.gsub(processed, charString, "")
    end

    -- @TODO: Add other whitespace characters?

    return (string.len(processed) == 0)
end

function StringUtil.CheckComponentLength(value: string?, component: string?)
    assert(StringUtil.IsEmpty(component) == true, "Component type must not be empty")
    assert(COMPONENT_LIMITS[component] ~= nil, "Component type must be valid")


end

function StringUtil.EncodeTable(input: table)
    if (type(input) == "table") then
        return HttpService:JSONEncode(input)
    end
end

function StringUtil.DecodeTable(input: string)
    if (type(input) == "string") then
        return HttpService:JSONDecode(input)
    end
end

function StringUtil.GetTableLength(input: table)
    if (type(input) == "table") then
        local encoded = StringUtil.EncodeTable(input)
        if (not encoded) then return end

        if (encoded == "[]") then
            return 0
        else
            return string.len(encoded)
        end
    end

    return -1
end

--// Connections

return StringUtil