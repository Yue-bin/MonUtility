-- monlog.lua
--小小的日志功能

monlog = {}

--@region private

--日志路径,默认为当前目录下的log.log,可自行修改
local logpath = "./log.log"

--日志读取器和日志添加器,默认为nil
local logreader = nil
local logadder = nil
--@endregion


--@region public

--使用日志路径初始化,返回是否成功
function monlog.init(path)
    monlog.logpath = path or monlog.logpath
    monlog.logadder = io.open(monlog.logpath, "a")
    monlog.logreader = io.open(monlog.logpath, "r")
    if monlog.logadder == nil or monlog.logreader == nil then
        return false
    end
    return true
end

--记录到日志中
function monlog.log(msg)
    monlog.logadder:write(os.date("%Y.%m.%d-%H:%M:%S  ") .. msg .. "\n")
end

--时间字符串转时间戳
function monlog.timestr2Stamp(timestr)
    --%Y.%m.%d-%H:%M:%S
    local _, _, y, m, d, _hour, _min, _sec = string.find(timestr, "(%d+).(%d+).(%d+)-(%d+):(%d+):(%d+)")
    local timestamp = os.time({ year = y, month = m, day = d, hour = _hour, min = _min, sec = _sec })
    return timestamp
end

--获取一个日志迭代器
function monlog.getlogiterator()
    return monlog.logreader:lines()
end

--接受一行日志,返回日志中的时间字符串
function monlog.getlogdate(logstr)
    --每行日志的格式为"%Y.%m.%d-%H:%M:%S  msg"
    return string.sub(logstr, 1, (string.find(logstr, "  ") - 1))
end

--计算日志距现在时间
function monlog.log2now(logstr)
    local logtime = monlog.timestr2Stamp(monlog.getlogdate(logstr))
    return os.difftime(os.time(), logtime)
end

--获取日志中距今超过给定秒数的行数
function monlog.getlogover(sec)
    local count = 0
    for line in monlog.getlogiterator() do
        if monlog.log2now(line) > sec then
            count = count + 1
        end
    end
    return count
end

--删除日志前n行
function monlog.dellog(n)
    n = n or 0
    monlog.logreader:seek("set", 0)
    local tmpline = ""
    repeat
        tmpline = monlog.logreader:read()
        n = n - 1
    until n == 0 or tmpline == nil
    --其实这里不用判空lua他自己会停下来的，但是我素质比较高（
    local content = monlog.logreader:read("*a")
    monlog.close()
    local tmpadder = io.open(monlog.logpath, "w")
    if tmpadder == nil then
        return false
    end
    tmpadder:write(content)
    tmpadder:close()
    monlog.init(monlog.logpath)
    return true
end

--关闭日志
function monlog.close()
    monlog.logadder:close()
    monlog.logreader:close()
end

--@endregion

return monlog
