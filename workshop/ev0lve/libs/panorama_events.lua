local panorama = require("panorama")
local _UnhandledEvents = panorama.loadstring([[
    let RegisteredEvents = {};
    let EventQueue = [];

    function _registerEvent(event) {
        if ( typeof RegisteredEvents[event] != 'undefined' ) return;
        RegisteredEvents[event] = $.RegisterForUnhandledEvent(event, (...data) => {
            EventQueue.push([event, data]);
        })
    }

    function _UnRegisterEvent(event) {
        if ( typeof RegisteredEvents[event] == 'undefined' ) return;
        $.UnregisterForUnhandledEvent(event, RegisteredEvents[event]);
        delete RegisteredEvents[event];
    }

    function _getEventQueue() {
        let Queue = EventQueue;
        EventQueue = [];
        return Queue;
    }

    function _shutdown() {
        for ( event in RegisteredEvents ) {
            _UnRegisterEvent(event);
        }
    }

    return  {
        register: _registerEvent,
        unRegister: _UnRegisterEvent,
        getQueue: _getEventQueue,
        shutdown: _shutdown
    }
]], "CSGOJsRegistration")()

local panorama_events = {callbacks={}}

function panorama_events.register_event(event, callback)
    _UnhandledEvents.register(event)
    panorama_events.callbacks[event] = panorama_events.callbacks[event] or {}
	table.insert(panorama_events.callbacks[event], callback)
	return callback
end

function panorama_events.unregister_event(event, callback)
    _UnhandledEvents.unRegister(event)
    panorama_events.callbacks[event] = panorama_events.callbacks[event] or {}
    for i, func in ipairs(panorama_events.callbacks[event]) do
        if func == callback then
            table.remove(panorama_events.callbacks[event], i)
        end
    end
end

local cache_speed = 30
function panorama_events.cache_speed(_set)
    if type(_set) == "number" and _set > 0 then
        cache_speed = _set
    elseif type(_set) ~= "number" then
        return cache_speed
    end
end

local LastEventTick = global_vars.framecount
function on_frame_stage_notify(stage, pre_original)
    if stage == csgo.frame_render_end then
        if global_vars.framecount - LastEventTick > cache_speed then
            --print("Framecount: ", global_vars.framecount)
            local EventQueue = _UnhandledEvents.getQueue()
            for index = 0, EventQueue.length - 1 do
                local Event = EventQueue[index]
                if Event then
                    local EventName = Event[0]
                    local EventData = Event[1]
                    -- filtering event data
                    local FilteredEventData = {}
                    for i=0, EventData.length - 1 do
                        local Data = EventData[i]
                        FilteredEventData[i+1] = Data
                    end
                    panorama_events.callbacks[EventName] = panorama_events.callbacks[EventName] or {}
                    for i, callback in ipairs(panorama_events.callbacks[EventName]) do
                        callback(unpack(FilteredEventData))
                    end
                end
            end
            LastEventTick = global_vars.framecount
        end
    end
end

function on_shutdown()
    _UnhandledEvents.shutdown()
end

return panorama_events