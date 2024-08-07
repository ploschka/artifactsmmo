API_URL = 'http://api.artifactsmmo.com'
SERVER_URL = 'http://artifactsmmo.com'
API_SECRET = require('secret')

local function sleep(seconds)
    if seconds == 0 then
        return
    end

    local file = assert(io.popen('sleep ' .. seconds))
    file:close()
end

function New_char(name, func)
    return {
        name = name,
        expiration = nil,
        co = coroutine.create(func)
    }
end

local mc = require('api.my_characters')
local g = require('api.general')

local ku = New_char('Kukuruz', function(name)
    for i = 1, 111 do
        print(i)
        local r = mc.gathering(name)
        print(r.status)
        if r.status ~= 200 then
            error "Error"
        end
        coroutine.yield(r.body.data.cooldown.remaining_seconds, r.body.data.cooldown.expiration)
    end
    return false
end)

local ka = New_char('Kapusta', function(name)
    for i = 1, 99 do
        print(i)
        local r = mc.gathering(name)
        print(r.status)
        if r.status ~= 200 then
            error "Error"
        end
        coroutine.yield(r.body.data.cooldown.remaining_seconds, r.body.data.cooldown.expiration)
    end
    return false
end)

local curr_time
local wait_seconds = 0
local queue = {}

table.insert(queue, ku)
table.insert(queue, ka)

while wait_seconds do
    sleep(wait_seconds)
    local t = g.server_time()
    if t.status ~= 200 then
        error('Server time error')
    end
    curr_time = t.body.time
    for i = 1, #queue do
        if (queue[i].expiration or '') < curr_time then
            local temp
            _, temp, queue[i].expiration = assert(coroutine.resume(queue[i].co, queue[i].name))
            if not temp then
                table.remove(queue, i)
                goto continue
            end
            if temp < wait_seconds then
                wait_seconds = temp
            end
        end
        ::continue::
    end
end

