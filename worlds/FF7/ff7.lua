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
    if name == "Potion" then
        give_item_to_inventory(0x01, 10)
    elseif name == "Phoenix Down" then
        give_item_to_inventory(0x05, 5)
    elseif name == "Keystone" then
        give_item_to_inventory(0xC3, 1)
    elseif name == "Buggy" then
        unlock_buggy()
    else
        print("Unknown item: " .. name)
    end
end

function give_item_to_inventory(item_id, quantity)
    local base = 0xDBFD2C
    for i = 0, 19 do  -- Check 20 slots
        local slot = base + i * 2
        local id = readByte(slot)
        local count = readByte(slot + 1)

        if id == item_id then
            writeByte(slot + 1, math.min(count + quantity, 99))
            return
        elseif id == 0 then
            writeByte(slot, item_id)
            writeByte(slot + 1, quantity)
            return
        end
    end
    print("Inventory full, could not add item " .. string.format("%02X", item_id))
end

function unlock_buggy()
    -- Hypothetical example: set story flag or vehicle state
    writeByte(0xCC06B9, 0x01)  -- Buggy available flag (replace with actual)
    print("Buggy unlocked!")
end

