return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local lsp_zero = require "lsp-zero"
      lsp_zero.extend_cmp()

      local cmp = require "cmp"
      local cmp_action = lsp_zero.cmp_action()

      require('luasnip.loaders.from_vscode').lazy_load()

      local cmp_options = {
        completion = {
          completeopt = "menu,menuone,noinsert,noselect",
        },
        preselect = cmp.PreselectMode.None,
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = require("lspkind").cmp_format {
            mode = "symbol_text",
            preset = "codicons",
            maxwidth = 50,
            ellipsis_char = "...",
            -- symbol_map = { Codeium = "" },
            menu = {
              -- codeium = "[AI]",
              buffer = "[Buffer]",
              rg = "[RG]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              treesitter = "[TS]",
              path = "[Path]",
              crates = "[Crates]",
            },
            -- before = function(entry, item)
            --   -- if entry.source.name == "codeium" then
            --   --   item.kind = fmt("%s %s", "", "Codeium")
            --   -- end
            --   return item
            -- end,
          },
          duplicates = {
            -- codeium = 1,
            buffer = 1,
            rg = 1,
            nvim_lsp = 1,
            luasnip = 1,
            treesitter = 1,
            path = 1,
          },
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete {},
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ["<C-n>"] = cmp_action.luasnip_supertab(),
          ["<C-p>"] = cmp_action.luasnip_shift_supertab(),
          ['<Tab>'] = cmp_action.luasnip_supertab(),
          ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        },
        sources = {
          -- group_index = 1
          { name = "nvim_lsp", priority = 1000 },
          -- { name = "codeium", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
        },
      }


      if vim.o.ft == "lua" then
        table.insert(cmp_options.sources, { name = "nvim_lua", max_item_count = 10, priority_weight = 100 })
      end

      if vim.o.ft == "toml" or vim.o.ft == "rust" then
        table.insert(cmp_options.sources, { name = "crates", priority_weight = 110 })
      end

      cmp.setup(cmp_options)

      -- Use cmdline & path source for ':'.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path", max_item_count = 5 },
        }, {
          { name = "cmdline", max_item_count = 15 },
        }),
      })

      -- lsp_document_symbols
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "nvim_lsp_document_symbol", max_item_count = 8 },
        }, {
          { name = "buffer", max_item_count = 5 },
        }),
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },
      --     {
      --       "jay-babu/mason-null-ls.nvim",
      --       event = { "BufReadPre", "BufNewFile" },
      --       dependencies = {
      --         { "nvimtools/none-ls.nvim", dependencies = { "lukas-reineke/lsp-format.nvim" } },
      --       },
      --     },
      "williamboman/mason-lspconfig.nvim",
      "princejoogie/tailwind-highlight.nvim",
      "b0o/schemastore.nvim",
      "pmizio/typescript-tools.nvim"
    },
    config = function()
      local tw_highlight = require "tailwind-highlight"
      local schemastore = require "schemastore"

      -- local ih = require('lsp-inlayhints')
      -- ih.setup()

      local lsp_zero = require "lsp-zero"
      lsp_zero.extend_lspconfig()

      local function show_documentation()
        local filetype = vim.bo.filetype
        if vim.tbl_contains({ "vim", "help" }, filetype) then
          vim.cmd("h " .. vim.fn.expand "<cword>")
        elseif vim.tbl_contains({ "man" }, filetype) then
          vim.cmd("Man " .. vim.fn.expand "<cword>")
        elseif vim.fn.expand "%:t" == "Cargo.toml" then
          require("crates").show_popup()
        else
          vim.lsp.buf.hover()
        end
      end

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps { buffer = bufnr, exclude = { 'K', '<F4>' } }
        vim.keymap.set('n', 'K', show_documentation, { buffer = bufnr })
        vim.keymap.set({ "v", "n", "i" }, "<F4>",
          function()
            require("actions-preview").code_actions()
          end
        )
        vim.keymap.set({ "v", "n", "i" }, "<A-Enter>",
          function()
            require("actions-preview").code_actions()
          end
        )

        tw_highlight.setup(client, bufnr, {
          single_column = false,
          mode = "background",
          debounce = 200,
        })

        -- ih.on_attach(client, bufnr)
      end)

      lsp_zero.set_sign_icons({
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»'
      })

      local servers = {
        -- tsserver = {},
        jsonls = {
          json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
          },
        },
        dockerls = {},
        yamlls = {},
        bashls = {},
        emmet_ls = {},
        cssls = {},
        html = {},
        tailwindcss = {},
        solargraph = {},
      }

      require("typescript-tools").setup {}

      local ensure_installed = {}
      for server_name, options in pairs(servers) do
        lsp_zero.use(server_name, options)
        table.insert(ensure_installed, server_name)
      end


      -- local lspconfig_util = require "lspconfig.util"
      -- local add_bun_prefix = require("custom.plugins.lsp.bun").add_bun_prefix
      -- lspconfig_util.on_setup = lspconfig_util.add_hook_before(lspconfig_util.on_setup, add_bun_prefix)

      local lua_opts = lsp_zero.nvim_lua_ls()
      require("lspconfig").lua_ls.setup(lua_opts)

      -- require("custom.plugins.lsp.null-ls").setup { on_attach = lsp_zero.on_attach }

      require('mason').setup({
        ui = {
          icons = {
            package_pending = " ",
            package_installed = " ",
            package_uninstalled = " ﮊ",
          },

          keymaps = {
            toggle_server_expand = "<CR>",
            install_server = "i",
            update_server = "u",
            check_server_version = "c",
            update_all_servers = "U",
            check_outdated_servers = "C",
            uninstall_server = "X",
            cancel_installation = "<C-c>",
          },
        },

        max_concurrent_installers = 10,
      })
      require('mason-lspconfig').setup({
        automatic_installation = true,
        ensure_installed = ensure_installed,
        handlers = {
          lsp_zero.default_setup,
        },
      })

      require("custom.plugins.lsp.handlers").setup()
    end,
  },
}
