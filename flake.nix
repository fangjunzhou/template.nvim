{
  description = "Development launcher for template.nvim";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ]
          (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: {
        docs = pkgs.writeShellScriptBin "template-docs" ''
          set -eu
          mkdir -p doc
          ${pkgs.panvimdoc}/bin/panvimdoc \
            --project-name template --input-file README.md \
            --no-date true --no-vim-version true
          exec ${pkgs.neovim-unwrapped}/bin/nvim --headless -u NONE -n -i NONE \
            -c 'try | helptags doc | catch | cquit 1 | endtry' -c 'qa!'
        '';

        test = pkgs.writeShellScriptBin "template-test" ''
          export PLENARY_DIR=${pkgs.vimPlugins.plenary-nvim}
          exec ${pkgs.neovim-unwrapped}/bin/nvim --headless --noplugin -n -i NONE \
            -u tests/minimal_init.lua \
            -c "PlenaryBustedDirectory tests/ { minimal_init = 'tests/minimal_init.lua' }"
        '';

        dev = pkgs.writeShellScriptBin "template-dev" ''
          export TEMPLATE_ROOT="$PWD"
          editor="$(command -v nvim || true)"
          exec "''${editor:-${pkgs.neovim}/bin/nvim}" \
            -c 'lua vim.opt.runtimepath:prepend(vim.env.TEMPLATE_ROOT)' \
            -c 'runtime plugin/template.lua' \
            -c 'lua require("template").setup()' \
            "$@"
        '';
      });

      formatter = forAllSystems (
        pkgs:
        pkgs.writeShellScriptBin "format-lua" ''
          exec ${pkgs.stylua}/bin/stylua lua plugin tests "$@"
        ''
      );
    };
}
