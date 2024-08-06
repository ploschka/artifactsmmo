API_URL = 'https://api.artifactsmmo.com'
API_SECRET = require('secret')

local mc = require('api.my_characters')
local c = require('api.characters')

local r = c.create('Kukuruz', c.skins.men1)
print(r.status)


