# resources/environments/neovim/home.nix
{ ... }:
{
  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
    globalOpts.mouse = "a";
    plugins = {
      telescope.enable = true;
      cmp.enable = true;
      cmp-nvim-lsp.enable = true;
      lsp.enable = true;
      lsp.servers = { rust-analyzer.enable = true; nil-ls.enable = true; };
      matchup.enable = true;
    };
    keymaps = [
      { mode = "n"; key = "gd"; action = "<cmd>lua vim.lsp.buf.definition()<CR>"; }
      { mode = "n"; key = "gx"; action = "<cmd>lua vim.ui.open(vim.fn.expand('<cfile>'))<CR>"; }
    ];
  };
}