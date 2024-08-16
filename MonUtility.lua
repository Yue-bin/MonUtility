--require("Utility/monlog")
--require("Utility/moncurl")

function Sleep(n)
    os.execute("sleep " .. tonumber(n))
end

ThisTableKey = ""
function PrintTable(table, level, key)
    ThisTableKey = key or ""
    level = level or 1
    local indent = ""
    for i = 1, level do
        indent = indent .. "  "
    end

    if ThisTableKey ~= "" then
        print(indent .. ThisTableKey .. " " .. "=" .. " " .. "{")
    else
        print(indent .. "{")
    end

    ThisTableKey = ""
    for k, v in pairs(table) do
        if type(v) == "table" then
            ThisTableKey = k
            PrintTable(v, level + 1)
        else
            local content = string.format("%s%s = %s", indent .. "  ", tostring(k), tostring(v))
            print(content)
        end
    end
    print(indent .. "}")
end

function Trim_Space_HeadEnd(str)
    local trimmed_str = str:gsub("^%s*(.-)%s*$", "%1")
    return trimmed_str
end
