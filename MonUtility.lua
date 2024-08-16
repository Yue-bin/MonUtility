--require("Utility/monlog")

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

--给luacurl用的默认写回调
Response_Data = ""
function Get_Default_Write_Callback(userparam)
    --清空Response_Data
    Response_Data = ""
    local function Default_Write_Callback(userparam, buffer)
        Response_Data = Response_Data .. buffer
        return #buffer
    end
    return Default_Write_Callback
end
