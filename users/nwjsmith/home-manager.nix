{ config, lib, pkgs, ... }:

{
  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  home.packages = with pkgs; [
    deno
    fd
    flyctl
    gcc
    jq
    ngrok
    nodejs
    python
    ripgrep
    sqlite
    (nodePackages.typescript-language-server)
    zeal
  ];


  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_CA.UTF-8";
    LC_CTYPE = "en_CA.UTF-8";
    LC_ALL = "en_CA.UTF-8";
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    PAGER = "less -FR";
  };


  home.file.".inputrc".source = ./inputrc;

  xdg.configFile."i3/config".text = builtins.readFile ./i3;
  xdg.configFile."nvim/nvim.lua".text = builtins.readFile ./nvim.lua;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.firefox.enable = true;

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.rofi = {
    enable = true;
    theme = "gruvbox-light";
    font = "FiraCode Nerd 10";
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      dpi = 192;
    };
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
  };

  programs.gpg.enable = true;

  programs.direnv= {
    enable = true;

    config = {
      whitelist = {
        exact = ["/home/nwjsmith/.envrc"];
      };
    };
  };

  programs.zoxide.enable = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "viins";
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "gruvbox-light";
    };
  };

  programs.fzf = {
    enable = true;
    defaultCommand = "${pkgs.fd}/bin/fd --type f";
    defaultOptions = [
      "--color=bg+:#ebdbb2,bg:#fbf1c7,spinner:#b57614,hl:#b57614"
      "--color=fg:#3c3836,header:#bdae93,info:#076678,pointer:#076678"
      "--color=marker:#af3a03,fg+:#3c3836,prompt:#7c6f64,hl+:#b57614"
    ];
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";

  };

  programs.git = {
    enable = true;
    userName = "Nate Smith";
    userEmail = "nate@theinternate.com";
    aliases = {
      co = "checkout";
      dc = "diff --cached";
      di = "diff";
      st = "status";
    };
    extraConfig = {
      core.askpass = "";
      init.defaultBranch = "main";
    };
    signing = {
      key = "F2089547768B6CCA";
      signByDefault = true;
    };
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty;
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      fzf-vim
      gitsigns-nvim
      gruvbox-community
      lightline-vim
      null-ls-nvim
      nvim-lspconfig
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
      vim-commentary
      vim-dadbod
      vim-dispatch
      vim-eunuch
      vim-fugitive
      vim-nix
      vim-repeat
      vim-rhubarb
      vim-sleuth
      vim-speeddating
      vim-surround
      vim-test
      vim-unimpaired
      vim-vinegar
    ];
    extraConfig = ''
      let s:nvim = expand("<sfile>:p:h") . "/nvim.lua"
      execute "luafile " . s:nvim
    '';
  };

  programs.i3status = {
    enable = true;
    enableDefault = false;
    general = {
      colors = true;
      color_good = "#98971a";
      color_bad = "#cc241d";
      color_degraded = "#d79921";
      color_separator = "#7c6f64";
      interval = 1;
    };
    modules = {
      "ethernet _first_" = {
        position = 1;
        settings = {
          format_down = "E: down";
          format_up = "%ip";
        };
      };
      "disk /" = {
        position = 2;
        settings = {
          format = "%avail";
        };
      };
      memory = {
        position = 3;
        settings = {
          format = "%used / %available";
          format_degraded = "MEMORY < %available";
          threshold_degraded = "4G";
        };
      };
      "tztime local" = {
        position = 4;
        settings = {
          format = "%y-%m-%d %H:%M";
          separator = false;
        };
      };
      "tztime utc" = {
        position = 5;
        settings = {
          format = "(%H:%M)";
          timezone = "UTC";
        };
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "tty";
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  xsession.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
  };
}
