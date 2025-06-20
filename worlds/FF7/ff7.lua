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
    print("Injecting item: " .. name)
    -- TODO: Write memory injection for real items
end
