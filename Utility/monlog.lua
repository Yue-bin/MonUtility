--monlog.lua
--小小的日志功能
monlog = {}


--@region global
--debug选项，默认关，影响到debug日志是否输出
IS_DEBUG = false

--@endregion


--@region private

--日志路径,默认为当前目录下的log.log,可自行修改
local logpath = "./log.log"

--日志读取器和日志添加器,默认为nil
local logreader = nil
local logadder = nil

--mua的不加锁不行了
local filelock = false

--日志队列，用于删除日志时暂存
local queue = {}

--日志级别
local loglevel = {
    [0] = "DEBUG",
    [1] = "INFO",
    [2] = "WARN",
    [3] = "ERROR",
    [4] = "FATAL"
}
local loglevelmax = 4
local loglevelmin = 0

--@endregion


--@region public
--使用日志路径初始化,返回是否成功
function monlog.init(path)
    logpath = path or logpath
    logadder = io.open(logpath, "a")
    logreader = io.open(logpath, "r")
    if logadder == nil or logreader == nil then
        return false
    end
    filelock = false
    return true
end

--loglevels
monlog.DEBUG = 0
monlog.INFO = 1
monlog.WARN = 2
monlog.ERROR = 3
monlog.FATAL = 4

--记录到日志(流)中,若有level则记录level
-- loglevel
-- 0:DEBUG
-- 1:INFO
-- 2:WARN
-- 3:ERROR
-- 4:FATAL
function monlog.log(msg, level)
    if level ~= nil then
        assert((level >= loglevelmin and level <= loglevelmax), "level is valid")
        if level == 0 and IS_DEBUG == false then
            return false
        end
    end
    if logadder == nil then
        return false
    end
    if filelock == true then
        table.insert(queue, msg)
        return false
    end
    logadder:write(os.date("%Y.%m.%d-%H:%M:%S  "))
    if level ~= nil then
        logadder:write("[" .. loglevel[level] .. "]")
    else
        logadder:write("[INFO]")
    end
    logadder:write(msg .. "\n")
    return true
end

--刷新日志流
function monlog.flush()
    if logadder == nil then
        return false
    end
    logadder:flush()
    return true
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
    if logreader == nil then
        return nil
    end
    return logreader:lines()
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
    if logreader == nil then
        return false
    end
    n = n or 0
    if n <= 0 then
        return false
    end
    filelock = true
    logreader:seek("set", 0)
    local tmpline = ""
    repeat
        tmpline = logreader:read()
        n = n - 1
    until n == 0 or tmpline == nil
    --其实这里不用判空lua他自己会停下来的，但是我素质比较高（
    local content = logreader:read("*a")
    monlog.close()
    local tmpadder = io.open(logpath, "w")
    if tmpadder == nil then
        return false
    end
    tmpadder:write(content)
    tmpadder:close()
    monlog.init(logpath)
    --处理队列
    for _, v in ipairs(queue) do
        monlog.log(v)
    end
    return true
end

--关闭日志
function monlog.close()
    if logadder ~= nil then
        logadder:close()
    end
    if logreader ~= nil then
        logreader:close()
    end
end

--@endregion

return monlog
