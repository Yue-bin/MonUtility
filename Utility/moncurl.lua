-- moncurl.lua
-- 不是我这里面没有什么核心的curl功能的
-- 主要是那个luacurl他少点东西，我给他配点周边）
-- 注意配合monlog食用(请配置全局的Monlog)
-- 注意一个moncrul对应一个new出来的curl，不要多次init

moncurl = {}

--给luacurl用的默认写回调
moncurl.Response_Data = ""
function moncurl.Default_Write_Callback(userparam, buffer)
    moncurl.Response_Data = moncurl.Response_Data .. buffer
    return #buffer
end

--给luacurl用的默认头回调
moncurl.Header_Data = ""
function moncurl.Default_Header_Callback(userparam, buffer)
    moncurl.Header_Data = moncurl.Header_Data .. buffer
    return #buffer
end

local luacurl = require("luacurl")
function moncurl.init()
    moncurl.Response_Data = ""
    moncurl.Header_Data = ""
    local curl = luacurl.new()
    curl:setopt(luacurl.OPT_WRITEFUNCTION, moncurl.Default_Write_Callback)
    curl:setopt(luacurl.OPT_HEADERFUNCTION, moncurl.Default_Header_Callback)
    return curl
end

function moncurl.Get_Status_Code()
    local status_str = string.match(moncurl.Header_Data, "HTTP/[^%s]+ (%d+)")
    local status_code = tonumber(status_str)
    return status_code
end

function moncurl.Check_Status_Code(status_code, eventstr)
    if status_code ~= 200 then
        Monlog.log(eventstr .. " failed with status code " .. status_code, Monlog.ERROR)
        if moncurl.Response_Data ~= "" then
            Monlog.log(eventstr .. " failed with response data " .. moncurl.Response_Data, Monlog.ERROR)
        end
        return false
    elseif status_code == nil then
        Monlog.log(eventstr .. " failed with nil status code", Monlog.ERROR)
        if moncurl.Response_Data ~= "" then
            Monlog.log(eventstr .. " failed with response data " .. moncurl.Response_Data, Monlog.ERROR)
        end
        return false
    else
        Monlog.log(eventstr .. " success with status code " .. status_code, Monlog.DEBUG)
        return true
    end
end

--只能存单个cookie
function moncurl.Get_Cookie()
    local cookie_str = string.match(moncurl.Header_Data, "Set%-Cookie: (.-)\r\n")
    return cookie_str
end

function moncurl.Save_Cookie_2File(ip, cookiestr, filename)
    local file = io.open(filename, "w")
    local key = string.match(cookiestr, "(.-)=")
    local value = string.match(cookiestr, "=(.-);")
    if file == nil then
        Monlog.log("Failed to open file " .. filename, Monlog.ERROR)
        return
    end
    --我承认我急了，这里是超级硬编码
    file:write(ip .. "\tFALSE\t\\\tFALSE\t0\t" .. key .. "\t" .. value)
    file:close()
end

function moncurl.Check_Response_Json_Data(eventstr)
    if moncurl.Response_Data == nil or moncurl.Response_Data == "" then
        Monlog.log(eventstr .. " failed with empty response data", Monlog.ERROR)
        return false
    elseif not (string.sub(moncurl.Response_Data, 1, 1) == "{") then
        Monlog.log(eventstr .. " failed with non-json response data ", Monlog.ERROR)
        Monlog.log(eventstr .. " failed with head char " .. string.sub(moncurl.Response_Data, 1, 1), Monlog.DEBUG)
        return false
    else
        Monlog.log(eventstr .. " success with response data " .. moncurl.Response_Data, Monlog.DEBUG)
        return true
    end
end

return moncurl
