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
]]

dofile("MonUtility.lua")
print(monlog.init("./log.log"))
monlog.log("test")
monlog.log("test2")
monlog.log("test3")
monlog.log("test4")
Sleep(5)
monlog.log("test5")
monlog.log("test6")
print(monlog.getlogover(5))
monlog.dellog(2)
monlog.close()
