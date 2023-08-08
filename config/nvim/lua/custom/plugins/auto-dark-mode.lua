return {
  "f-person/auto-dark-mode.nvim",
  lazy = false,
  opts = {
    update_interval = 1000,
    set_dark_mode = function()
      require("core.theming.themes").activate_theme("rosepine", "moon", false)
    end,
    set_light_mode = function()
      require("core.theming.themes").activate_theme("rosepine", "dawn", false)
    end,
  },
}
