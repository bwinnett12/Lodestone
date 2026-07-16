# neovim.nix
#
# A home-manager module for a from-scratch Neovim IDE setup.
# Import this from your home-manager config, e.g. in home.nix:
#
#   imports = [ ./neovim.nix ];
#
# Covers, in order of priority: Nix, Python, Rust, then R and Julia.
# LSP gives you go-to-definition, find-references, rename, code actions.
# Treesitter gives accurate highlighting. blink-cmp/nvim-cmp gives
# word-complete + LSP-complete. Telescope gives a fuzzy picker for
# references/definitions ("see other instances of this").

{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Language servers and any CLI tools they shell out to.
    # These land on PATH so lspconfig can find them by name.
    extraPackages = with pkgs; [
      # Nix
      nixd # preferred over `nil` — better eval/completions, actively maintained
      nixpkgs-fmt

      # Python
      python312Packages.python-lsp-server
      python312Packages.pylsp-mypy
      ruff # fast linter; pairs with pylsp via ruff-lsp or native pylsp plugin
      python312Packages.black

      # Rust
      rust-analyzer
      rustc
      cargo
      rustfmt
      clippy

      # R
      # r-languageserver needs to be available inside R's library path.
      # Wrapping R with the languageserver package pulls it in cleanly.
      (rWrapper.override {
        packages = with rPackages; [ languageserver ];
      })

      # Julia
      # NOTE: Julia's LSP is NOT a normal nixpkgs package you point lspconfig
      # at directly — LanguageServer.jl has to be installed *inside* a Julia
      # environment, then invoked via `julia --project=<env> -e '...'`.
      # See the julials block below and the comment above it for the
      # one-time setup this requires.
      julia-bin
    ];

    plugins = with pkgs.vimPlugins; [
      # --- LSP ---
      nvim-lspconfig

      # --- Completion (blink.cmp: faster, Rust-backed fuzzy matcher) ---
      blink-cmp
      friendly-snippets

      # --- Treesitter (syntax highlighting, text objects) ---
      (nvim-treesitter.withPlugins (p: [
        p.nix
        p.python
        p.rust
        p.r
        p.julia
        p.lua
        p.markdown
        p.markdown_inline
        p.bash
        p.toml
        p.yaml
        p.json
      ]))
      nvim-treesitter-textobjects

      # --- Fuzzy finder / reference & definition picker ---
      telescope-nvim
      plenary-nvim # dependency of telescope
      telescope-fzf-native-nvim

      # --- Explicit refactor operations (extract var/function, inline) ---
      refactoring-nvim

      # --- Quality of life ---
      nvim-web-devicons
      gitsigns-nvim
      which-key-nvim
      lualine-nvim
    ];

    extraLuaConfig = ''
      -- ============================================================
      -- Basics
      -- ============================================================
      vim.g.mapleader = " "
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.termguicolors = true
      vim.opt.signcolumn = "yes"
      vim.opt.updatetime = 300

      -- ============================================================
      -- Treesitter
      -- ============================================================
      require('nvim-treesitter.configs').setup({
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })

      -- ============================================================
      -- Completion (blink.cmp)
      -- ============================================================
      require('blink.cmp').setup({
        keymap = { preset = 'default' },
        appearance = { nerd_font_variant = 'mono' },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        completion = {
          documentation = { auto_show = true },
        },
        signature = { enabled = true },
      })

      -- ============================================================
      -- LSP
      -- ============================================================
      local lspconfig = require('lspconfig')
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local on_attach = function(client, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Core navigation — this is your "IntelliSense" layer
        map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
        map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
        map('n', 'gr', require('telescope.builtin').lsp_references, 'Find references (Telescope)')
        map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
        map('n', 'gy', vim.lsp.buf.type_definition, 'Go to type definition')
        map('n', 'K', vim.lsp.buf.hover, 'Hover docs')
        map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
        map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')
        map('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document symbols')
        map('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace symbols')
        map('n', ']d', vim.diagnostic.goto_next, 'Next diagnostic')
        map('n', '[d', vim.diagnostic.goto_prev, 'Prev diagnostic')
        map('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, 'Format buffer')
      end

      -- Nix
      lspconfig.nixd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          nixd = {
            formatting = { command = { "nixpkgs-fmt" } },
          },
        },
      })

      -- Python
      lspconfig.pylsp.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          pylsp = {
            plugins = {
              pyflakes = { enabled = false }, -- let ruff handle linting
              pycodestyle = { enabled = false },
              mccabe = { enabled = false },
              ruff = { enabled = true },
              black = { enabled = true },
            },
          },
        },
      })

      -- Rust
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ['rust-analyzer'] = {
            cargo = { allFeatures = true },
            checkOnSave = { command = "clippy" },
          },
        },
      })

      -- R
      lspconfig.r_language_server.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Julia
      -- One-time setup required before this works:
      --   julia --project=@nvim-lsp -e 'import Pkg; Pkg.add("LanguageServer")'
      -- (pick any project env name; @nvim-lsp keeps it out of your way)
      lspconfig.julials.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = {
          "julia",
          "--startup-file=no",
          "--history-file=no",
          "--project=@nvim-lsp",
          "-e",
          [[
            using LanguageServer;
            server = LanguageServer.LanguageServerInstance(stdin, stdout, "", "");
            server.runlinter = true;
            run(server);
          ]],
        },
      })

      -- ============================================================
      -- Telescope — your "see other instances / peek references" UI
      -- ============================================================
      require('telescope').setup({
        defaults = {
          layout_strategy = "vertical",
        },
      })
      pcall(require('telescope').load_extension, 'fzf')

      local tb = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', tb.find_files, { desc = "Find files" })
      vim.keymap.set('n', '<leader>fg', tb.live_grep, { desc = "Live grep" })
      vim.keymap.set('n', '<leader>fb', tb.buffers, { desc = "Buffers" })

      -- ============================================================
      -- Refactoring
      -- ============================================================
      require('refactoring').setup({})
      vim.keymap.set('x', '<leader>re', ":Refactor extract ", { desc = "Extract function" })
      vim.keymap.set('x', '<leader>rv', ":Refactor extract_var ", { desc = "Extract variable" })
      vim.keymap.set('n', '<leader>ri', ":Refactor inline_var", { desc = "Inline variable" })

      -- ============================================================
      -- QoL
      -- ============================================================
      require('gitsigns').setup({})
      require('lualine').setup({})
      require('which-key').setup({})
    '';
  };
}

