{
  config,
  pkgs,
  ...
}: let
  username = "enric";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";
  readFile = builtins.readFile;
  gitConfig = {
    core = {
      editor = "nvim";
    };
    init.defaultBranch = "main";
    merge = {
      tool = "vim_mergetool";
    };
    mergetool."vim_mergetool" = {
      cmd = "nvim -d \"$LOCAL\" \"$MERGED\" \"$REMOTE\"";
      prompt = false;
      keepbackup = false;
      keeptemporaries = false;
      trustexitcode = false;
    };
    pull.rebase = false;
    push.autoSetupRemote = true;
    url = {
      "https://github.com/".insteadOf = "gh:";
      "ssh://git@github.com".pushInsteadOf = "gh:";
      "https://gitlab.com/".insteadOf = "gl:";
      "ssh://git@gitlab.com".pushInsteadOf = "gl:";
    };
  };

  rg = "${pkgs.ripgrep}/bin/rg";
in {
  home = {
    inherit username homeDirectory;
    stateVersion = "22.05";
    packages = with pkgs; [
      tig
      chromium
      ripgrep
      htop
      go
      gopls
      zathura
      jq
      bat
      rubyPackages.solargraph
    ];
  };
  programs = {
    git = {
      enable = true;
      userName = "Enric Lluelles";
      userEmail = "git@lluell.es";
      extraConfig = gitConfig;
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
      tmux = {
        enableShellIntegration = true;
      };
    };
    fish = {
      enable = true;
      shellInit = ''
        # remove greeting
        set fish_greeting
      '';
    };
    starship = {
      enable = true;
    };
    tmux = {
      enable = true;
      shortcut = "a";
      aggressiveResize = true;
      baseIndex = 1;
      escapeTime = 0;
      keyMode = "vi";
      reverseSplit = true;
      customPaneNavigationAndResize = true;
      disableConfirmationPrompt = true;
      historyLimit = 10000;
      plugins = with pkgs.tmuxPlugins; [
        cpu
        resurrect
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60'
          '';
        }
      ];
    };
    htop = {
      enable = true;
    };
    chromium = {
      enable = true;
    };
    alacritty = {
      enable = true;
    };
    rofi = {
      enable = true;
    };
    home-manager = {
      enable = true;
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-fugitive
      nvim-tree-lua
      nvim-treesitter-textobjects
      which-key-nvim
      nvim-cmp
      cmp-path
      cmp-nvim-lsp
      cmp-buffer
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = readFile ./neovim-plugin-configs/lsp.lua;
      }
      nvim-lspconfig
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = readFile ./neovim-plugin-configs/vim-tree.lua;
      }
      {
        plugin = catppuccin-nvim;
        type = "lua";
        config = readFile ./neovim-plugin-configs/catpuccin.lua;
      }
      {
        plugin = which-key-nvim;
        type = "lua";
        config = readFile ./neovim-plugin-configs/which-key.lua;
      }
      {
        plugin = fzf-lua;
        type = "lua";
        config = readFile ./neovim-plugin-configs/fzf.lua;
      }
      {
        plugin = nvim-treesitter.withPlugins (
          plugins: pkgs.tree-sitter.allGrammars
        );
        type = "lua";
        config = readFile ./neovim/nvim-treesitter.lua;
      }
    ];
  };

  xdg.configFile.nvim = {
    source = ./neovim-extra;
    recursive = true;
  };
}
