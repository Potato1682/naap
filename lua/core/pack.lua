local Pack = {}
Pack.__index = Pack

function Pack:ensure_plugin_manager()
end

local pack = setmetatable(Pack, {
  __index = function(_, key)
    return nil
  end
})

pack.disable_builtin_plugins = function()
end

pack.setup = function()
end

return pack
