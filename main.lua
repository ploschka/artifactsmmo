API_URL = 'http://api.artifactsmmo.com'
API_SECRET = require('secret')

---@param seconds number
local function sleep(seconds)
    if seconds == 0 then
        return
    end

    local file = assert(io.popen('sleep ' .. seconds))
    file:close()
end

---@param t string
---@return number timestamp
local function parse_time(t)
    local p = '(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+).%d+Z'
    local year, month, day, hour, minute, second = t:match(p)
    local offset = os.time()-os.time(os.date('!*t'))
    return os.time({year=year, month=month, day=day, hour=hour, min=minute, sec=second}) + offset
end

function New_char(name, func)
    return {
        name = name,
        expiration = nil,
        co = coroutine.create(func)
    }
end

local g = require('api.general')

local curr_time
local wait_seconds = 0
local queue = require('chars')
local goloop

repeat
    goloop = false
    print('Sleep ' .. wait_seconds .. ' seconds')
    sleep(wait_seconds)
    wait_seconds = 0
    local t = g.check_status()
    print("Server response status", t.status)
    if t.status ~= 200 then
        error('Server time error')
    end
    curr_time = t.body.data.server_time
    for i = 1, #queue do
        goloop = goloop or queue[i]
        if not queue[i] then
            goto continue
        end
        if (queue[i].expiration or '') < curr_time then
            local temp
            _, temp, queue[i].expiration = assert(coroutine.resume(queue[i].co, queue[i].name))
            if not temp then
                queue[i] = nil
                goto continue
            end
            if temp < wait_seconds or wait_seconds == 0 then
                wait_seconds = temp
            end
        end
        ::continue::
    end
until not goloop

