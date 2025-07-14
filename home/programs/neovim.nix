{
  osConfig,
  pkgs,
  ...
}: {
  home.sessionVariables = {EDITOR = "nvim";};
  programs.nvf = {
    enable = osConfig.niksos.neovim;
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
            key = "<Esc><Esc>";
            mode = ["t"];
            action = "<C-\\><C-n>";
          }

          {
            key = "\\";
            mode = ["t"];
            action = "<cmd>Neotree  <CR>";
          }
        ]
        ++ builtins.map (x: {
          key = "<C-${x}>";
          action = "<C-w><C-${x}>";
          mode = "n";
        }) ["h" "j" "k" "l"];
      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
        registers = "unnamedplus";
      };

      options.shiftwidth = 2;
      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };
      languages = {
        enableFormat = true; #You can also manually overwrite each language.
        enableTreesitter = true;

        ts = {
          enable = true;
          lsp.server = "denols";
          extensions.ts-error-translator.enable = true;
        };
        clang = {
          enable = true;
          lsp.enable = false;
        };

        bash.enable = true;
        css.enable = true;
        html.enable = true;
        markdown.enable = true;
        nix.enable = true;
        svelte.enable = true;
        typst.enable = true;
        rust.enable = true;
        python.enable = true;
      };
      lsp = {
        enable = true;
        formatOnSave = true;
        lspkind.enable = true; # Autocomplete icons
        lightbulb.enable = true; # Lightbulb icon when lsp is available
        trouble.enable = true; # Adds error view
        lspSignature.enable = true; # Shows function properties while typing
        mappings = {
          hover = "gh";
          codeAction = "<leader>.";
        };

        # Emmet LSP. No option for this yet. https://github.com/NotAShelf/nvf/pull/867
        lspconfig.sources.emmet_language_server = ''
          lspconfig.emmet_language_server.setup {
            capabilities = capabilities,
            on_attach = default_on_attach,
            cmd = { "${pkgs.emmet-language-server}/bin/emmet-language-server", "--stdio" }
          }
        '';
      };
      autopairs.nvim-autopairs.enable = true;
      autocomplete.nvim-cmp.enable = true;
      snippets.luasnip.enable = true;
      mini.surround.enable = true;
      # This can also be themed with stylix. Remove `targets.nvf.enable = false` in `../style/default.nix`
      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
        transparent = false;
      };

      dashboard.alpha.enable = true;
      filetree.nvimTree = {
        enable = true; #TODO: Change mapping
        openOnSetup = false;
        mappings.toggle = "\\";
      };
      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false;
      };
      notes.todo-comments.enable = true;
      notify.nvim-notify.enable = true;
      statusline.lualine.enable = true;
      telescope.enable = true;
      terminal.toggleterm = {
        enable = true;
        lazygit.enable = true;
        mappings.open = "<leader>s";
      }; #TODO: Keybinds
      treesitter.context.enable = true;
      ui = {
        noice.enable = true;
        colorizer.enable = true;
        smartcolumn. enable = true;
      };
      utility = {
        vim-wakatime.enable = true;
        motion.leap = {
          enable = true;
          mappings = {
            leapForwardTo = "f";
            leapBackwardTo = "F";
          };
        };
      };
      visuals = {
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        indent-blankline.enable = true;
      };
    };
  };
}
