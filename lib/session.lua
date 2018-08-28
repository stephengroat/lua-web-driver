local requests = require "requests"

-- https://www.w3.org/TR/webdriver1/
local Session = {}

local methods = {}
local metatable = {}

function metatable.__index(session, key)
  -- driver is a Session instance
  return methods[key]
end

function methods:destroy()
  requests.delete(self.base_url)
end

function methods:timeouts()
  local response = requests.get(self:endpoint("timeouts"))
  return response.json()["value"]
end

function methods:set_timeouts(timeouts)
  local response = requests.post(self:endpoint("timeouts"), { data = timeouts })
  return response
end

function methods:visit(url)
  local response = requests.post(self:endpoint("url"), { data = { url = url } })
  return response
end

function methods:url()
  local response = requests.get(self:endpoint("url"))
  return response.json()["value"]
end

function methods:back()
  local response = requests.post(self:endpoint("back"), { data = {}})
  return response
end

function methods:forward()
  local response = requests.post(self:endpoint("forward"), { data = {}})
  return response
end

function methods:refresh()
  local response = requests.post(self:endpoint("refresh"), { data = {}})
  return response
end

function methods:title()
  local response = requests.get(self:endpoint("title"))
  return response.json()["value"]
end

function methods:window_handle()
  local response = requests.get(self:endpoint("window"))
  return response.json()["value"]
end

function methods:close_window()
  local response = requests.delete(self:endpoint("window"))
  return response
end

function methods:switch_to_window(handle)
  local response = requests.post(self:endpoint("window"), { data = { handle = handle } })
  return response
end

function methods:window_handles()
  local response = requests.get(self:endpoint("window/handles"))
  return response.json()["value"]
end

-- TODO
function methods:switch_to_frame(id)
  local response = requests.post(self:endpoint("frame"), { data = { id = id } })
  return response
end

-- TODO
function methods:switch_to_parent_frame()
  local response = requests.post(self:endpoint("frame/parent"), { data = {} })
  return response
end

function methods:window_rect()
  local response = requests.get(self:endpoint("window/rect"))
  return response.json()["value"]
end

-- rect = { height = h, width = w, x = position_x, y = position_y }
function methods:set_window_rect(rect)
  local response = requests.post(self:endpoint("window/rect"), { data = rect })
  return response
end

function methods:window_maximize()
  local response = requests.post(self:endpoint("window/maximize"), { data = {} })
  return response
end

function methods:window_minimize()
  local response = requests.post(self:endpoint("window/minimize"), { data = {} })
  return response
end

function methods:window_fullscreen()
  local response = requests.post(self:endpoint("window/fullscreen"), { data = {} })
  return response
end

function methods:endpoint(template)
  return self.base_url.."/"..template
end

function Session.new(base_url, session_id)
  local session = {
    base_url = base_url.."session/"..session_id
  }
  setmetatable(session, metatable)
  return session
end

return Session
