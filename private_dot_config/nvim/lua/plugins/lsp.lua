-- ~/.config/nvim/lua/plugins/lsp.lua
-- LSP core UX only (diagnostics + keymaps + capabilities defaults)

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Apply cmp capabilities to all servers (works even if cmp loads later)
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("ShadowsLspKeymaps", { clear = true }),
        callback = function(ev)
          local bufnr = ev.buf
          local function nmap(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
          end

          nmap("gd", vim.lsp.buf.definition, "Go to definition")
          nmap("gD", vim.lsp.buf.declaration, "Go to declaration")
          nmap("gr", vim.lsp.buf.references, "References")
          nmap("gi", vim.lsp.buf.implementation, "Implementation")
          nmap("K", vim.lsp.buf.hover, "Hover")
          nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
          nmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
          nmap("<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format")
          nmap("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
          nmap("]d", vim.diagnostic.goto_next, "Next diagnostic")
        end,
      })
    end,
  },
}
