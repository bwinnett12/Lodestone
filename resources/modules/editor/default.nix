#### Editor and coding environment
# ./resources/modules/editor/default.nix
#### ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
#### Editor — Zed + language support
##
## Import it, then pick languages:
##   imports = [ self.nixosModules.editor ];
##   ecosystem.editor.languages = [ "rust" "python" "r" "julia" ];
##
## Nix support and spellcheck are always on.
##
## Zed keys (VS Code layout):
##   Ctrl+click / F12   go to definition     Alt+Shift+F12     find references
##   F2                 rename everywhere    Ctrl+.            quick fix
##   Ctrl+Shift+E       file tree            Ctrl+\            split pane
##   ▶ in the margin    run / debug a test   Ctrl+Shift+Enter  send to REPL
{ config, lib, pkgs, ... }:
let
  cfg = config.ecosystem.editor;
  has = lang: builtins.elem lang cfg.languages;

  ## R with just what the editor needs: language server, linter, tests, REPL kernel.
  ## Analysis packages (vegan, phyloseq, ...) belong in each project's own flake.
  rEditor = pkgs.rWrapper.override {
    packages = with pkgs.rPackages; [ languageserver lintr testthat IRkernel ];
  };
in {
  ## ~~~~~ The one setting ~~~~~
  options.ecosystem.editor.languages = lib.mkOption {
    type = lib.types.listOf (lib.types.enum [ "rust" "python" "r" "julia" ]);
    default = [ ];
    example = [ "rust" "r" ];
    description = "Languages to install editor support for (language server, formatter, REPL).";
  };

  config = {
    ## ~~~~~ 1. Language tools on PATH ~~~~~
    ## Any editor finds these. A project's own flake (via direnv) takes priority.
    environment.systemPackages = with pkgs;
      [ nixd alejandra       ## Nix: language server + formatter
        harper typos-lsp     ## spellcheck: prose/comments + names in code
        ripgrep fd ]         ## project-wide search
      ++ lib.optionals (has "rust")   [ rust-analyzer cargo rustc rustfmt clippy ]
      ++ lib.optionals (has "python") [ basedpyright ruff
                                        (python3.withPackages (ps: [ ps.pytest ps.debugpy ps.ipykernel ])) ]
      ++ lib.optionals (has "r")      [ rEditor ]
      ++ lib.optionals (has "julia")  [ julia-bin ];  ## Zed's Julia extension installs its own language server

    fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

    ## Zed downloads a couple of helpers itself (e.g. the Rust debugger).
    ## nix-ld lets those prebuilt Linux binaries run on NixOS.
    programs.nix-ld.enable = true;

    ## ~~~~~ 2. User side: Zed + direnv ~~~~~
    home-manager.sharedModules = [ {

      ## direnv loads a project's flake.nix shell when you enter its folder
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;  ## caches the shell, so re-entry is instant
      };

      ## R REPL kernel, so Zed can run R code (same as IRkernel::installspec())
      xdg.dataFile."jupyter/kernels/ir/kernel.json" = lib.mkIf (has "r") {
        text = builtins.toJSON {
          argv = [ "${rEditor}/bin/R" "--slave" "-e" "IRkernel::main()" "--args" "{connection_file}" ];
          display_name = "R";
          language = "R";
        };
      };

      programs.zed-editor = {
        enable = true;

        ## Rust, Python and Markdown are built into Zed
        extensions = [ "nix" "toml" "harper" "typos" ]
          ++ lib.optionals (has "r")     [ "r" ]
          ++ lib.optionals (has "julia") [ "julia" ];

        ## Settings stay editable in Zed; these get merged back in on each rebuild
        userSettings = {
          base_keymap = "VSCode";
          load_direnv = "direct";  ## use the project's flake shell
          auto_update = false;     ## Nix handles updates
          telemetry = { metrics = false; diagnostics = false; };

          theme = { mode = "system"; dark = "Gruvbox Dark"; light = "Gruvbox Light"; };
          buffer_font_family = "JetBrainsMono Nerd Font";
          buffer_font_size = 14;
          ui_font_size = 15;
          format_on_save = "on";
          inlay_hints.enabled = true;

          lsp = {
            ## Prefer a project's own rust-analyzer; check with clippy on save
            rust-analyzer = {
              binary.path_lookup = true;
              initialization_options.check.command = "clippy";
            };
            ## Point extensions at the Nix-built servers instead of letting
            ## them download binaries that won't run on NixOS
            nixd = {
              binary.path = "${pkgs.nixd}/bin/nixd";
              settings.formatting.command = [ "${pkgs.alejandra}/bin/alejandra" ];
            };
            harper-ls = {
              binary.path = "${pkgs.harper}/bin/harper-ls";
              settings.harper-ls.dialect = "American";
            };
            typos.binary.path = "${pkgs.typos-lsp}/bin/typos-lsp";
          };

          languages.Nix.language_servers = [ "nixd" "!nil" ];
        };
      };
    } ];
  };
}
