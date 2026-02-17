-- ~/.config/nvim/lua/plugins/cmp.lua
-- Reliable VSCode-like completion:
-- - popup while typing
-- - <Tab> confirms
-- - <C-e> closes completion menu

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",

      -- Snippets
      { "L3MON4D3/LuaSnip", version = "v2.*", submodules = true },
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      -- Make completion menu behave predictably
      vim.opt.completeopt = { "menu", "menuone", "noselect" }

      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Helper: do we have a word before cursor?
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        if col == 0 then return false end
        local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
        return text:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        completion = {
          autocomplete = { cmp.TriggerEvent.TextChanged, cmp.TriggerEvent.InsertEnter },
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(), -- close completion window
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- Tab confirms if menu visible; otherwise triggers completion if sensible
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }),
      })
    end,
  },
}
