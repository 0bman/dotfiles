local M = {
  "glepnir/lspsaga.nvim",
  event = "BufRead",
}

function M.config()
  local lspsaga = require "lspsaga"

  local options = {
    lightbulb = {
      enable = false,
      enable_in_insert = true,
      cache_code_action = true,
      sign = true,
      update_time = 150,
      sign_priority = 20,
      virtual_text = false,
    },
    symbol_in_winbar = {
      in_custom = false,
      enable = true,
      separator = "  ",
      show_file = true,
      respect_root = true,
      color_mode = true,
      hide_keyword = false,
      click_support = false,
    },
  }

  lspsaga.setup(options)
end

return M
