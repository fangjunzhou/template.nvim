local M = {}

local config = {}

function M.setup(opts)
  config = vim.tbl_extend("force", { message = "Hello, world!" }, opts or {})
end

function M.hello()
  vim.notify(config.message, vim.log.levels.INFO)
end

---@param a number
---@param b number
---@return number
function M.add(a, b)
  return a + b
end

M.setup()

return M
