local process = require("process")
local log = require("log")

local RemoteLogger = require("web-driver/remote-logger")
local LogFormatter = require("web-driver/log-formatter")
local pp = require("web-driver/pp")

local Logger = {}

local methods = {}
local metatable = {}

Logger.LEVELS = {
  EMERGENCY = 1,
  ALERT     = 2,
  FATAL     = 3,
  ERROR     = 4,
  WARNING   = 5,
  NOTICE    = 6,
  INFO      = 7,
  DEBUG     = 8,
  TRACE     = 9,
}

local default_level = Logger.LEVELS.NOTICE
local create_default_logger = false
local level_env = process.getenv()["LUA_WEB_DRIVER_LOG_LEVEL"]
if level_env then
  default_level = Logger.LEVELS[level_env:upper()] or default_level
  create_default_logger = true
end

function metatable.__index(geckodriver, key)
  return methods[key]
end

function methods:level()
  return self.backend.level()
end

local function resolve_level(level)
  if type(level) == "string" then
    local level_number = Logger.LEVELS[level:upper()]
    if not level_number then
      error("web-driver: Logger: Invalid level: <" .. level .. ">")
    end
    return level_number
  else
    return level
  end
end

function methods:need_log(level)
  level = resolve_level(level)
  return level <= self:level()
end

function methods:log(level, ...)
  self.backend.log(level, ...)
end

function methods:traceback(level)
  level = resolve_level(level)
  if not self:need_log(level) then
    return
  end
  self:log(level, "web-driver: Traceback:")
  local offset = 2
  local deep_level = offset
  while true do
    local info = debug.getinfo(deep_level, "Sl")
    if not info then
      break
    end
    self:log(level,
             string.format("web-driver: %d: %s:%d",
                           deep_level - offset + 1,
                           info.short_src,
                           info.currentline))
    deep_level = deep_level + 1
  end
end

function methods:emergency(...)
  self:log(Logger.LEVELS.EMERGENCY, ...)
end

function methods:alert(...)
  self:log(Logger.LEVELS.ALERT, ...)
end

function methods:fatal(...)
  self:log(Logger.LEVELS.FATAL, ...)
end

function methods:error(...)
  self:log(Logger.LEVELS.ERROR, ...)
end

function methods:warning(...)
  self:log(Logger.LEVELS.WARNING, ...)
end

function methods:notice(...)
  self:log(Logger.LEVELS.NOTICE, ...)
end

function methods:info(...)
  self:log(Logger.LEVELS.INFO, ...)
end

function methods:debug(...)
  self:log(Logger.LEVELS.DEBUG, ...)
end

function methods:trace(...)
  self:log(Logger.LEVELS.TRACE, ...)
end

local LUA_LOG_WRITER_NAMES = {
  [Logger.LEVELS.EMERGENCY] = "emerg",
  [Logger.LEVELS.ALERT]     = "alert",
  [Logger.LEVELS.FATAL]     = "fatal",
  [Logger.LEVELS.ERROR]     = "error",
  [Logger.LEVELS.WARNING]   = "warning",
  [Logger.LEVELS.NOTICE]    = "notice",
  [Logger.LEVELS.INFO]      = "info",
  [Logger.LEVELS.DEBUG]     = "debug",
  [Logger.LEVELS.TRACE]     = "trace",
}
local function lua_log_writer_name(level)
  return LUA_LOG_WRITER_NAMES[level]
end

local function detect_backend(real_logger)
  if real_logger then
    if RemoteLogger.is_a(real_logger) then
      return {
        level = function() return Logger.LEVELS.TRACE end,
        log = function(level, ...)
          if type(level) == "number" then
            level = lua_log_writer_name(level)
          end
          real_logger:log(level, ...)
        end,
      }
    elseif real_logger.lvl then
      -- lua-log
      -- level is compatible.
      return {
        level = function() return real_logger.lvl() end,
        log = function(level, ...)
          if type(level) == "number" then
            level = lua_log_writer_name(level)
          end
          real_logger[level](...)
        end,
      }
    else
      error("web-driver: Unsupported logger: " .. pp.format(real_logger))
    end
  end
  return {
    level = function() return default_level end,
    log = function(level, ...) end,
  }
end

function Logger.new(real_logger)
  if real_logger == nil and create_default_logger then
    local StdErrWriter = require("log/writer/stderr")
    local formatter = nil
    local log_formatter = LogFormatter.new()
    real_logger = log.new(default_level,
                          StdErrWriter.new(),
                          formatter,
                          log_formatter)
  end
  local logger = {
    logger = real_logger,
    backend = detect_backend(real_logger),
  }
  setmetatable(logger, metatable)
  return logger
end

return Logger
