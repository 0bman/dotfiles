return {
  "f-person/auto-dark-mode.nvim",
  lazy = false,
  config = {
    update_interval = 1000,
    set_dark_mode = function()
      require("core.theming.themes").activate_theme("nightowl", "night-owl", false)
    end,
    set_light_mode = function()
      require("core.theming.themes").activate_theme("edge", "edge", false)
    end,
  },
}
