{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;

      keymaps =
        [
          # alt backspace to delete word backwards
          {
            key = "<Esc>";
            mode = ["n"];
            action = "<cmd>nohlsearch<CR>";
          }
          {
            key = "<leader>q";
            mode = ["n"];
            action = ":lua vim.diagnostic.setloclist()";
          }

          {
            key = "<Esc><Esc>";
            mode = ["t"];
            action = "<C-\\><C-n>";
          }
        ]
        ++ builtins.map (x: {
          key = "<C-${x}>";
          action = "<C-w><C-${x}>";
          mode = "n";
        }) ["h" "j" "k" "l"];
      useSystemClipboard = true;

      ui = {
        smartcolumn.enable = true; # Changes cursor color depending on mode.
        illuminate.enable = true; #
        modes-nvim.enable = true;
        noice.enable = true;
      };
      treesitter.enable = true;

      lsp = {
        lspconfig.enable = true;
        enable = true;
        formatOnSave = true;
        lightbulb.enable = true;
        lspSignature.enable = true;
        mappings = {
          hover = "<leader>h";
          codeAction = "<leader>.";
        };
      };
      languages = {
        nix = {
          enable = true;
          format.enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        ts = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          extensions.ts-error-translator.enable = true;
        };
      };

      telescope = {
        enable = true;
        setupOpts.defaults.vimgrep_arguments = [
          "${pkgs.ripgrep}/bin/rg"
          "--color=never"
          "--no-heading"
          "--with-filename"
          "--line-number"
          "--column"
          "--smart-case"
          "--hidden"
        ];
        mappings.liveGrep = "<leader>/";
      };

      utility = {
        motion.precognition.enable = true;
        ccc.enable = true;
      };
      mini.surround.enable = true;
      autopairs.nvim-autopairs.enable = true;
      binds.whichKey.enable = true;

      theme.enable = true;
    };
  };
}
