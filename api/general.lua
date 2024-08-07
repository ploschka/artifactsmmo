local utils = require('api.utils')

local function check_status()
    return utils.api_request('', 'GET', nil)
end

local function server_time()
    return utils.url_request(SERVER_URL .. '/api/server-time', 'GET', nil)
end

return {
    check_status = check_status,
    server_time = server_time,
}

