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

function TrimTrailingNewlines(str)
    -- 使用gsub移除末尾的换行符
    return str:gsub("%s*$", ""):gsub("\r?\n$", "")
end

function TrimAfterLastBracket(str)
    -- 查找最后一个 '}' 的位置
    local lastBracketPos = str:reverse():find("}", 1, true)

    -- 如果找到了 '}', 则从字符串中删除它之后的所有字符
    if lastBracketPos then
        lastBracketPos = #str + 1 - lastBracketPos
        -- 我们需要保留 '}'，所以这里使用 sub(1, lastBracketPos + 1)
        return str:sub(1, lastBracketPos + 1)
    else
        -- 如果没有找到 '}', 返回原字符串
        return str
    end
end

--给lunajson写的尝试解码
--不知道为什么他没有try而且decode失败了就直接报错了
--可能因为写lua写的）
function TryDecodeJson(json_str)
    local json = require("lunajson")
    local success, result = pcall(json.decode, json_str)
    if success then
        return result
    else
        return nil
    end
end

function SafeRequire(name)
    local status, content = pcall(require, name)
    if not status then
        monlog("failed to require " .. name .. "...", monlog.ERROR)
        monlog("errmsg: " .. content, monlog.DEBUG)
        return nil
    else
        return content
    end
end
