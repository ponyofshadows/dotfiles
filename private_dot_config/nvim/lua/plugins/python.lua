-- ~/.config/nvim/lua/plugins/python.lua
-- Python LSP: Pyright using Neovim 0.11+ native API (vim.lsp.config/enable)
-- No require("lspconfig")[...].setup() calls (avoids deprecated framework).

return {
  {
    "neovim/nvim-lspconfig",
    ft = { "python" },
    config = function()
      vim.lsp.config("pyright", {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },

        -- Project root detection ("open folder" style behavior)
        root_markers = {
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          ".git",
        },

        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.lsp.enable("pyright")
    end,
  },
}
