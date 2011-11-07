local eventId = 0
local eventsTable = { }
local orig = { scheduleEvent = scheduleEvent,
               addEvent = addEvent }

-- fix original scheduleEvent
function scheduleEvent(func, delay)
  eventId = eventId + 1
  local id = eventId
  local function proxyFunc()
    if eventsTable[id] then
      func()
      eventsTable[id] = nil
    end
  end
  eventsTable[id] = proxyFunc
  orig.scheduleEvent(proxyFunc, delay)
  return id
end

-- FIXME: the event function can be collected
-- and the dispatcher would call an invalid function, generating an warning
function removeEvent(id)
  if id and eventsTable[id] then
    eventsTable[id] = nil
    return true
  end
end

-- fix original addEvent
function addEvent(func)
  eventId = eventId + 1
  local id = eventId
  local function proxyFunc()
    if eventsTable[id] then
      func()
      eventsTable[id] = nil
    end
  end
  eventsTable[id] = proxyFunc
  orig.addEvent(proxyFunc)
  return id
end