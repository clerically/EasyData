--// Evaluation output
--// @company113
--// July 15, 2023

--// Constants

local TYPE_FUNCTIONS = {
    ["warn"] = warn;
    ["print"] = print;
    ["error"] = error;
}

--// Connections

return function(evaluation: boolean, output: string, type: string) : boolean
    if (evaluation == nil) then return end
    if (not type or not output) then return end
    
    local doFunc = TYPE_FUNCTIONS[type]
    if (doFunc == nil) then return end

    if (evaluation) then
        doFunc(`[EasyData]: {output}`)
        return true
    end

    return false
end