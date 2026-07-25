# resources/environments/neovim/home.nix
{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    colorschemes.gruvbox.enable = true;


    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      blink-cmp friendly-snippets
      (nvim-treesitter.withPlugins (p: [
        p.nix p.python p.rust p.r p.julia p.lua
        p.markdown p.markdown_inline p.bash p.toml p.yaml p.json
      ]))
      nvim-treesitter-textobjects
      telescope-nvim plenary-nvim telescope-fzf-native-nvim
      refactoring-nvim
      nvim-web-devicons gitsigns-nvim which-key-nvim lualine-nvim
      # still to add: gruvbox-nvim, vim-matchup
    ];

    extraLuaConfig = ''
      -- (identical to your original neovim.nix extraLuaConfig — 
      --  basics, treesitter setup, blink.cmp setup, LSP on_attach/keymaps,
      --  telescope keymaps, refactoring keymaps, gitsigns/lualine/which-key setup)
    '';
  };
}