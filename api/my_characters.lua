local function action_path(name, action)
    return '/my/' .. name .. '/action/' .. action
end

local function bank_action_path(name, action)
    return action_path(name, 'bank/' .. action)
end

local function ge_action_path(name, action)
    return action_path(name, 'ge/' .. action)
end

local function task_action_path(name, action)
    return action_path(name, 'task/' .. action)
end

local json = require('dkjson')
local utils = require('api.utils')

local slots = {
    weapon = 'weapon',
    shield = 'shield',
    helmet = 'helmet',
    body_armor = 'body_armor',
    leg_armor = 'leg_armor',
    boots = 'boots',
    ring1 = 'ring1',
    ring2 = 'ring2',
    amulet = 'amulet',
    artifact1 = 'artifact1',
    artifact2 = 'artifact2',
    artifact3 = 'artifact3',
    consumable1 = 'consumable1',
    consumable2 = 'consumable2',
}

local function move(name, x, y)
    local path = action_path(name, 'move')
    local body = json.encode {
        x = x,
        y = y
    }

    return utils.api_request(path, 'POST', body)
end

local function fight(name)
    local path = action_path(name, 'fight')

    return utils.api_request(path, 'POST', nil)
end

local function gathering(name)
    local path = action_path(name, 'gathering')

    return utils.api_request(path, 'POST', nil)
end

local function crafting(name, code, quantity)
    local path = action_path(name, 'crafting')
    local body = json.encode {
        code = code,
        quantity = quantity,
    }

    return utils.api_request(path, 'POST', body)
end

local function equip(name, code, slot)
    local path = action_path(name, 'equip')
    local body = json.encode {
        code = code,
        slot = slot,
    }

    return utils.api_request(path, 'POST', body)
end

local function unequip(name, slot)
    local path = action_path(name, 'unequip')
    local body = json.encode {
        slot = slot,
    }

    return utils.api_request(path, 'POST', body)
end

local function recycling(name, code, quantity)
    local path = action_path(name, 'recycling')
    local body = json.encode {
        code = code,
        quantity = quantity,
    }

    return utils.api_request(path, 'POST', body)
end

local function delete(name, code, quantity)
    local path = action_path(name, 'delete')
    local body = json.encode {
        code = code,
        quantity = quantity,
    }

    return utils.api_request(path, 'POST', body)
end

local function bank_deposit(name, code, quantity)
    local path = bank_action_path(name, 'deposit')
    local body = json.encode {
        code = code,
        quantity = quantity,
    }

    return utils.api_request(path, 'POST', body)
end

local function bank_gold_deposit(name, quantity)
    local path = bank_action_path(name, 'deposit/gold')
    local body = json.encode {
        quantity = quantity,
    }

    return utils.api_request(path, 'POST', body)
end

local function bank_withdraw(name, code, quantity)
    local path = bank_action_path(name, 'withdraw')
    local body = json.encode {
        code = code,
        quantity = quantity,
    }

    return utils.api_request(path, 'POST', body)
end

local function bank_gold_withdraw(name, quantity)
    local path = bank_action_path(name, 'withdraw/gold')
    local body = json.encode {
        quantity = quantity,
    }

    return utils.api_request(path, 'POST', body)
end

local function ge_buy(name, code, quantity, price)
    local path = ge_action_path(name, 'buy')
    local body = json.encode {
        code = code,
        quantity = quantity,
        price = price,
    }

    return utils.api_request(path, 'POST', body)
end

local function ge_sell(name, code, quantity, price)
    local path = ge_action_path(name, 'sell')
    local body = json.encode {
        code = code,
        quantity = quantity,
        price = price,
    }

    return utils.api_request(path, 'POST', body)
end

local function task_accept(name)
    local path = task_action_path(name, 'new')

    return utils.api_request(path, 'POST', nil)
end

local function task_complete(name)
    local path = task_action_path(name, 'complete')

    return utils.api_request(path, 'POST', nil)
end

local function task_exchange(name)
    local path = task_action_path(name, 'exchange')

    return utils.api_request(path, 'POST', nil)
end

local function get_characters()
    local path = '/my/characters'

    return utils.api_request(path, 'GET', nil)
end

return {
    slots = slots,
    my_characters = get_characters,
    fight = fight,
    gathering = gathering,
    move = move,
    crafting = crafting,
    equip = equip,
    unequip = unequip,
    recycling = recycling,
    delete = delete,
    deposit = bank_deposit,
    withdraw = bank_withdraw,
    deposit_gold = bank_gold_deposit,
    withdraw_gold = bank_gold_withdraw,
    buy = ge_buy,
    sell = ge_sell,
    task_accept = task_accept,
    task_complete = task_complete,
    task_exchange = task_exchange,
}

