{ config, lib, pkgs, ... }:

{
  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  home.packages = with pkgs; [
    bat
    htop
    jq
    nodejs
    rofi
  ];


  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_CA.UTF-8";
    LC_CTYPE = "en_CA.UTF-8";
    LC_ALL = "en_CA.UTF-8";
    EDITOR = "nvim";
  };

  home.file.".inputrc".source = ./inputrc;

  xdg.configFile."i3/config".text = builtins.readFile ./i3;

  programs.rofi = {
    enable = true;
    theme = "gruvbox-light";
    font = "Fira Code 13";
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      dpi = 192;
    };
  };

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.firefox.enable = true;

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

  programs.zsh.enable = true;
  programs.starship.enable = true;
  programs.fzf = {
    enable = true;
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
      nvim-lspconfig
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
      vim-commentary
      vim-eunuch
      vim-fugitive
      vim-repeat
      vim-rhubarb
      vim-sleuth
      vim-speeddating
      vim-surround
      vim-test
      vim-vinegar
    ];
    extraConfig = ''
      set termguicolors
      set background=light
      colorscheme gruvbox
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
