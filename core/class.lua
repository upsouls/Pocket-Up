local M = {}

function M.class(base)
  local cls = {}
  local base = base or {}

  for k, v in pairs(base) do
    cls[k] = v
  end

  cls.__index, cls.is_a = cls, {[cls] = true}
  for c in pairs(base.is_a or {}) do
    cls.is_a[c] = true
  end
  cls.is_a[base] = true
  cls.super = base

  setmetatable(cls, {__call = function (c, ...)
    local instance = setmetatable({}, c)

    local init = instance._init
    if init then init(instance, ...) end
    return instance
  end})

  return cls
end

return M