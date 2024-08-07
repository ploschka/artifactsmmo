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
end

local function api_request(path, method, body)
    local req = create_request(API_URL .. path, method)
    set_headers(req.headers, API_SECRET)
    req:set_body(body)

    local headers, stream = assert(req:go())
    local response_body = assert(stream:get_body_as_string())
    return {
        status = tonumber(headers:get(':status')),
        body = require('dkjson').decode(response_body)
    }
end

local function url_request(url, method, body)
    local req = create_request(url, method)
    set_headers(req.headers, API_SECRET)
    req:set_body(body)

    local headers, stream = assert(req:go())
    local response_body = assert(stream:get_body_as_string())
    return {
        status = tonumber(headers:get(':status')),
        body = require('dkjson').decode(response_body)
    }
end

return {
    create_request = create_request,
    url_request = url_request,
    set_headers = set_headers,
    api_request = api_request,
}

