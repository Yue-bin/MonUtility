function Sleep(n)
    os.execute("sleep " .. tonumber(n))
end

--小小的日志功能
monlog = {

    --@region private
    --日志路径,默认为当前目录下的log.log,可自行修改
    logpath = "./log.log",
    --日志读取器和日志添加器,默认为nil
    logreader = nil,
    logadder = nil,
    --@endregion

    --@region public
    --使用日志路径初始化,返回是否成功
    init = function(path)
        monlog.logpath = path or monlog.logpath
        monlog.logadder = io.open(monlog.logpath, "a")
        monlog.logreader = io.open(monlog.logpath, "r")
        if monlog.logadder == nil or monlog.logreader == nil then
            return false
        end
        return true
    end,

    --记录到日志中
    log = function(msg)
        monlog.logadder:write(os.date("%Y.%m.%d-%H:%M:%S  ") .. msg .. "\n")
    end,

    --时间字符串转时间戳
    timestr2Stamp = function(timestr)
        --%Y.%m.%d-%H:%M:%S
        local _, _, y, m, d, _hour, _min, _sec = string.find(timestr, "(%d+).(%d+).(%d+)-(%d+):(%d+):(%d+)")
        local timestamp = os.time({ year = y, month = m, day = d, hour = _hour, min = _min, sec = _sec })
        return timestamp
    end,

    --获取一个日志迭代器
    getlogiterator = function()
        return monlog.logreader:lines()
    end,

    --接受一行日志,返回日志中的时间字符串
    getlogdate = function(logstr)
        --每行日志的格式为"%Y.%m.%d-%H:%M:%S  msg"
        return string.sub(logstr, 1, (string.find(logstr, "  ") - 1))
    end,

    --计算日志距现在时间
    log2now = function(logstr)
        local logtime = monlog.timestr2Stamp(monlog.getlogdate(logstr))
        return os.difftime(os.time(), logtime)
    end,

    --关闭日志
    close = function()
        monlog.logadder:close()
        monlog.logreader:close()
    end
    --@endregion
}

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
