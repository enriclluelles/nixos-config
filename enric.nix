{
  config,
  pkgs,
  lib,
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

  gpkgname = g: lib.strings.removeSuffix "-grammar" g.pname;

  gpkg = g: pkgs.tree-sitter-grammars.${(gpkgname g)};

  all_grammar_pgs = map (g: gpkg g) pkgs.tree-sitter.allGrammars;
in {
  home = {
    inherit username homeDirectory;
    shellAliases = {
      gco = "git checkout";
      glr = "git pull --rebase";
      gp = "git push";
      gd = "git diff";
      gss = "git status --short";
    };
    stateVersion = "22.05";
    packages = [];
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
      prefix = "C-b";
      enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      escapeTime = 0;
      clock24 = true;
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
            bind c new-window -c '#{pane_current_path}'
            bind-key t choose-tree
            bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
            bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel 'reattach-to-user-namespace pbcopy'

            # Update default binding of `Enter` to also use copy-pipe
            unbind -T copy-mode-vi Enter
            bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
            set -g mouse on
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
    package = pkgs.neovim-nightly;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = [pkgs.vimPlugins.packer-nvim];

    extraPackages = with pkgs; [
      rubyPackages.solargraph
      sumneko-lua-language-server
      nodePackages.typescript-language-server
      nodePackages.prettier
      gopls
      terraform-ls
      terraform-lsp
      tree-sitter
    ] ++ pkgs.tree-sitter.allGrammars;

    extraConfig = ''
    lua require('init')
    '';
  };

  xdg.configFile."nvim/lua" = {
    source = ./neovim/lua;
    recursive = true;
  };

  xdg.desktopEntries.slack = {
    name = "Slack";
    exec = "slack --ozone-platform-hint=auto --enable-features=WebRTCPipeWireCapturer";
  };
}
