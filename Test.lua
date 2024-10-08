--[[
Time1 = os.time()
Timetable1 = os.date("*t", Time1)
Date1 = os.date("%Y.%m.%d-%H:%M:%S  ", Time1)
print(Date1)
--PrintTable(Timetable1)
print(Time1)
print(Timestr2Stamp(Date1))

Sleep(5)
Time2 = os.time()
Timetable2 = os.date("*t", Time2)
Date2 = os.date("%Y.%m.%d-%H:%M:%S  ", Time2)
print(Date2)
print(os.difftime(os.time(Timetable2), os.time(Timetable1)))

local monlog = require("Utility/monlog")
dofile("MonUtility.lua")
print(monlog.init("./log.log"))
monlog.log("test")
monlog.log("test2")
monlog.log("test3")
monlog.LOG_LEVEL = monlog.FATAL
monlog.log("test4", 0)
monlog.log("test5", 1)
monlog.log("test6", 2)
monlog.log("test7", 3)
monlog.log("test8", 4)
monlog.log("test10", 2)
print(monlog.getlogover(5))
monlog.log("001test001", monlog.INFO)
--monlog.dellog(2)
monlog.close()

while true do
    local str = io.read()
    print(Trim_Space_HeadEnd(str))
end
]]
dofile("MonUtility.lua")
local fakejson_str = "1111iloveu"
local json_str = require("lunajson").encode({
    name = "John",
    age = 30,
    city = "New York"
})

print(PrintTable(TryDecodeJson(json_str)))
print(TryDecodeJson(fakejson_str))
print(TryDecodeJson(""))
print(TryDecodeJson(nil))
