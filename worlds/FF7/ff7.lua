-- Auto-generated lookup table for FF7 Archipelago item injection

item_lookup = {
    ["Fire Materia"] = { id = 0x00, quantity = 1 },
    ["Ice Materia"] = { id = 0x01, quantity = 1 },
    ["Buster Sword"] = { id = 0x10, quantity = 1 },
    ["Mythril Saber"] = { id = 0x11, quantity = 1 },
    ["Iron Bangle"] = { id = 0x20, quantity = 1 },
    ["Carbon Bangle"] = { id = 0x21, quantity = 1 },
    ["Potion"] = { id = 0x01, quantity = 10 },
    ["Phoenix Down"] = { id = 0x05, quantity = 5 },
    ["Turbo Ether"] = { id = 0x0D, quantity = 3 },
    ["Keystone"] = { id = 0xC3, quantity = 1 },
    ["Mythril"] = { id = 0xD6, quantity = 1 },
    ["Sector 5 Key"] = { id = 0xCE, quantity = 1 },
    ["Midgar Keycard 60"] = { id = 0xCC, quantity = 1 },
}

flag_lookup = {
    ["Buggy"] = { address = 0xCC06B9, value = 0x01 },
    ["Tiny Bronco"] = { address = 0xCC06BA, value = 0x01 },
    ["Highwind"] = { address = 0xCC06BB, value = 0x01 },
    ["Huge Materia (North Corel)"] = { address = 0xCC06BC, value = 0x01 },
    ["Bugenhagen Observatory Access"] = { address = 0xCC06BD, value = 0x01 },
}

local socket = require("socket")
local json = require("json")

local host = "127.0.0.1"
local port = 38281
local client = socket.tcp()
client:settimeout(0)
client:connect(host, port)

function onScriptStart()
    print("FF7 Lua script: connecting to Archipelago...")
end

function onScriptUpdate()
    local line, err = client:receive("*l")
    if line then
        local ok, msg = pcall(json.decode, line)
        if ok and msg then
            handle_message(msg)
        end
    end
end

function handle_message(msg)
    if msg.cmd == "Connected" then
        print("Connected to Archipelago as " .. msg.slot)
    elseif msg.cmd == "ReceivedItems" then
        for _, item in ipairs(msg.items) do
            inject_item(item.item_name)
        end
    end
end

function inject_item(name)
    local item = item_lookup[name]
    if item then
        give_item_to_inventory(item.id, item.quantity)
        return
    end

    local flag = flag_lookup[name]
    if flag then
        writeByte(flag.address, flag.value)
        print("Set flag for " .. name)
        return
    end

    print("Unknown item or flag: " .. name)
end

function give_item_to_inventory(item_id, quantity)
    local base = 0xDBFD2C
    for i = 0, 19 do
        local slot = base + i * 2
        local id = readByte(slot)
        local count = readByte(slot + 1)

        if id == item_id then
            writeByte(slot + 1, math.min(count + quantity, 99))
            print("Increased quantity of item ID " .. string.format("0x%02X", item_id))
            return
        elseif id == 0 then
            writeByte(slot, item_id)
            writeByte(slot + 1, quantity)
            print("Added new item ID " .. string.format("0x%02X", item_id))
            return
        end
    end
    print("Inventory full, could not add item ID " .. string.format("0x%02X", item_id))
end
