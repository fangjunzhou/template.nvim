if vim.g.loaded_template then
  return
end
vim.g.loaded_template = true

vim.api.nvim_create_user_command("HelloWorld", function()
  require("template").hello()
end, { desc = "Say hello" })
