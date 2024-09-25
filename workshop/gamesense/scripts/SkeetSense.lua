local tab,container = "LUA","A"

local http = require "gamesense/http"

local lua_data = [[ ]]
local lua_version = ""
local failed = false

local function dowloadlua()
    http.get("https://pastebin.com/raw/bGK5FRpH", function(success, response)
        if not success or response.status ~= 200 then
            print("Failed to download data")
            failed = true
          return
        end
        print(response.body)
        lua_data = response.body
    end)

    http.get("https://pastebin.com/raw/tZNuxGkY", function(success, response)
        if not success or response.status ~= 200 then
            print("Failed to download data")
            failed = true
          return
        end
        lua_version = response.body
    end)
end

local function Initialize() 
    --client.log("Initializing Lua...")

    dowloadlua()

    --client.log("Loading Lua...")

    load(lua_data)()

    --client.log("Lua Loaded")
    --client.log("Version :" .. lua_version)
end

Initialize()