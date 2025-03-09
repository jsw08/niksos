{
  inputs,
  osConfig,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

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
      useSystemClipboard = true;
      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };
      options.shiftwidth = 2;
      languages = {
        enableLSP = true; # Thses options enable the things automatically for every language.
        enableFormat = true; #You can also manually overwrite each language.
        enableTreesitter = true;

        bash.enable = true;
        css.enable = true;
        html.enable = true;
        markdown.enable = true;
        nix.enable = true;
        svelte.enable = false;
        ts.enable = true;
        typst.enable = true;
        rust.enable = true;
      };
      lsp = {
        formatOnSave = true;
        lspkind.enable = true; # Autocomplete icons
        lightbulb.enable = true; # Lightbulb icon when lsp is available
        trouble.enable = true; # Adds error view
        lspSignature.enable = true; # Shows function properties while typing
        mappings = {
          hover = "gh";
          codeAction = "<leader>.";
        };
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
      presence.neocord.enable = true;
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
      utility.vim-wakatime.enable = true;
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
