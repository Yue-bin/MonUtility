-- moncurl.lua
-- 不是我这里面没有什么核心的curl功能的
-- 主要是那个luacurl他少点东西，我给他配点周边）
-- 注意配合monlog食用(请配置全局的Monlog)
-- 注意一个moncrul对应一个new出来的curl，不要多次init

moncurl = {}

--给luacurl用的默认写回调
moncurl.Response_Data = ""
function moncurl.Get_Default_Write_Callback(_userparam)
    --清空Response_Data
    moncurl.Response_Data = ""
    local function Default_Write_Callback(userparam, buffer)
        moncurl.Response_Data = moncurl.Response_Data .. buffer
        return #buffer
    end
    return Default_Write_Callback
end

--给luacurl用的默认头回调
moncurl.Header_Data = ""
function moncurl.Get_Default_Header_Callback(_userparam)
    --清空Header_Data
    moncurl.Header_Data = ""
    local function Default_Header_Callback(userparam, buffer)
        moncurl.Header_Data = moncurl.Header_Data .. buffer
        return #buffer
    end
    return Default_Header_Callback
end

function moncurl.init(luacurl)
    local curl = luacurl.new()
    curl:setopt(luacurl.OPT_WRITEFUNCTION, moncurl.Get_Default_Write_Callback())
    curl:setopt(luacurl.OPT_HEADERFUNCTION, moncurl.Get_Default_Header_Callback())
    return curl
end

function moncurl.Get_Status_Code()
    local status_str = string.match(moncurl.Header_Data, "HTTP/%d%.%d (%d+)")
    local status_code = tonumber(status_str)
    return status_code
end

function moncurl.Check_Status_Code(status_code, eventstr)
    if status_code ~= 200 then
        Monlog.log(eventstr .. " failed with status code " .. status_code, Monlog.ERROR)
        return false
    elseif status_code == nil then
        Monlog.log(eventstr .. " failed with nil status code", Monlog.ERROR)
        return false
    else
        Monlog.log(eventstr .. "success with status code " .. status_code, Monlog.DEBUG)
        return true
    end
end

function moncurl.Check_Response_Json_Data(eventstr)
    if moncurl.Response_Data == nil or moncurl.Response_Data == "" or not (string.sub(moncurl.Response_Data, 1, 1) == "{" and string.sub(moncurl.Response_Data, -1) == "}") then
        Monlog.log(eventstr .. " failed with invalid json response data", Monlog.ERROR)
    else
        Monlog.log(eventstr .. " success with response data " .. moncurl.Response_Data, Monlog.DEBUG)
    end
end