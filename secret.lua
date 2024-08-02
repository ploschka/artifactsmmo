local secret = os.getenv('API_SECRET')
if not secret or secret == "" then
    error("API_SECRET environment variable not set")
end

return secret

