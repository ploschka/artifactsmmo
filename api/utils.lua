local cache = {}

local function create_request(url, method)
    local http_request = require('http.request')
    local req = http_request.new_from_uri(url)
    req.headers:upsert(':method', method, false)

    return req
end

local function set_headers(headers, secret)
    headers:upsert('accept', 'application/json', false)
    headers:upsert('content-type', 'application/json', false)

    if secret then
        headers:upsert('authorization', 'Bearer '..secret, true)
    end
    -- headers:delete('expect')
end

local function api_request(path, method, body)
    local req
    if cache[path .. method] then
        req = cache[path .. method]
    else
        req = create_request(API_URL .. path, method)
        set_headers(req.headers, API_SECRET)
        cache[path .. method] = req
    end

    if body and req.body ~= body then
        req:set_body(body)
    end

    local headers, stream = assert(req:go())
    local response_body = assert(stream:get_body_as_string())

    local status = tonumber(headers:get(':status'))
    return {
        status = status,
        body = require('dkjson').decode(response_body)
    }
end

local function url_request(url, method, body)
    local req
    if cache[url .. method] then
        req = cache[url .. method]
    else
        req = create_request(url, method)
        req.headers:upsert('accept', 'application/json', false)

    end

    if body and req.body ~= body then
        req:set_body(body)
    end

    local headers, stream = assert(req:go())
    local response_body = assert(stream:get_body_as_string())

    local status = tonumber(headers:get(':status'))
    return {
        status = status,
        body = require('dkjson').decode(response_body)
    }
end

return {
    create_request = create_request,
    url_request = url_request,
    set_headers = set_headers,
    api_request = api_request,
}

