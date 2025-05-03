-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local diagnostics_active = true
vim.keymap.set("n", "<leader>td", function()
  diagnostics_active = not diagnostics_active
  vim.diagnostic.config({
    virtual_text = diagnostics_active,
  })
end, { desc = "Toggle inline diagnostics" })
