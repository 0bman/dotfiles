return {
  {
    "ruifm/gitlinker.nvim",
    keys = {
      {
        "<leader>gL",
        function()
          -- require("gitlinker.actions").copy_to_clipboard()
          require("gitlinker").get_buf_range_url(
            "n",
            { action_callback = require("gitlinker.actions").open_in_browser }
          )
        end,
        desc = "[G]it open [L]ine in browser",
      },
      {
        "<leader>gL",
        function()
          -- require("gitlinker.actions").copy_to_clipboard()
          require("gitlinker").get_buf_range_url(
            "v",
            { action_callback = require("gitlinker.actions").open_in_browser }
          )
        end,
        desc = "[G]it open [L]ine in browser",
        mode = "x",
      },
      {
        "<leader>gR",
        function()
          require("gitlinker").get_repo_url { action_callback = require("gitlinker.actions").open_in_browser }
        end,
        desc = "[G]it open [R]epo in browser",
      },
    },
  },
  {
    "rbong/vim-flog",
    cmd = { "Flog", "Flogsplit" },
    init = function()
      vim.g.flog_default_opts = { max_count = 512 }
      -- vim.g.flog_override_default_mappings = {}
      -- vim.g.flog_jumplist_default_mappings = {}
      vim.g.flog_use_internal_lua = true
    end,
    dependencies = {
      "tpope/vim-fugitive",
      cmd = "Git",
      keys = {
        {
          "<leader>gb",
          "<CMD>Git blame<CR>",
          desc = "[G]it [B]lame",
        },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    keys = {
      { "[c", "<cmd> Gitsigns next_hunk<CR>", desc = "Git Next Hunk" },
      { "]c", "<cmd> Gitsigns prev_hunk<CR>", desc = "Git Prev Hunk" },
      { "<leader>gp", "<cmd> Gitsigns preview_hunk<CR>", desc = "[G]it [P]review Hunk" },
    },
    opts = {
      numhl = true,
      signs = {
        add = {
          text = "┃",
        },
        change = {
          text = "┃",
        },
        delete = {
          show_count = true,
        },
        topdelete = {
          show_count = true,
        },
        changedelete = {
          show_count = false,
          text = "┃",
        },
        untracked = {
          show_count = false,
          text = "┃",
        },
      },
      count_chars = {
        [1] = "₁",
        [2] = "₂",
        [3] = "₃",
        [4] = "₄",
        [5] = "₅",
        [6] = "₆",
        [7] = "₇",
        [8] = "₈",
        [9] = "₉",
        ["+"] = "₊",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<localleader>gd", "<Cmd>DiffviewOpen<CR>", desc = "[G]it [D]iff", mode = "n" },
      { "gh", [[:'<'>DiffviewFileHistory<CR>]], desc = "[G]it range [H]istory", mode = "v" },
      {
        "<localleader>gh",
        "<Cmd>DiffviewFileHistory<CR>",
        desc = "[G]it [H]istory",
        mode = "n",
      },
      {
        "<localleader>gH",
        "<Cmd>DiffviewFileHistory %<CR>",
        desc = "[G]it file [H]istory",
        mode = "n",
      },
    },
    opts = function()
      local actions = require "diffview.actions"

      return {
        default_args = {
          DiffviewFileHistory = {},
          DiffviewOpen = {},
        },
        show_help_hints = false,
        icons = {
          folder_closed = "",
          folder_open = "",
        },
        file_panel = {
          listing_style = "list",
          win_config = {
            width = 40,
          },
        },
        hooks = {
          diff_buf_read = function(bufnr)
            vim.opt_local.wrap = false
            vim.opt_local.list = false
            vim.opt_local.relativenumber = false
            vim.opt_local.colorcolumn = ""
          end,
        },
        keymaps = {
          view = { q = "<Cmd>DiffviewClose<CR>" },
          file_panel = {
            q = "<Cmd>DiffviewClose<CR>",
            { "n", "<cr>", actions.focus_entry, { desc = "Focus the selected entry" } },
            {
              "n",
              "s",
              actions.toggle_stage_entry,
              { desc = "[S]tage / un[S]tage the selected entry" },
            },
            { "n", "cc", "<Cmd>Git commit <bar> wincmd J<CR>", { desc = "[C]ommit staged [C]hanges" } },
            { "n", "ca", "<Cmd>Git commit --amend <bar> wincmd J<CR>", { desc = "Amend the last commit" } },
            { "n", "c<space>", ":Git commit ", { desc = 'Populate command line with ":Git commit "' } },
            { "n", "P", "<Cmd>Git push<CR>", { desc = "[G]it [P]ush" } },
          },
          file_history_panel = { q = "<Cmd>DiffviewClose<CR>" },
        },
      }
    end,
    config = function(_, opts)
      require("diffview").setup(opts)
    end,
  },
}