local utils = require('api.utils')

local function check_status()
    return utils.api_request('', 'GET', nil)
end

return {
    check_status = check_status,
}

