return {
  "glepnir/lspsaga.nvim",
  event = { "BufReadPost", "BufAdd", "BufNewFile" },
  opts = {
    ui = {
      colors = require("catppuccin.groups.integrations.lsp_saga").custom_colors(),
      kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
    },
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
  },
}
