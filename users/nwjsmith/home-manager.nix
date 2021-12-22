{ config, lib, pkgs, ... }:

{
  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  home.packages = [
    pkgs.bat
    pkgs.fzf
    pkgs.htop
    pkgs.jq
    pkgs.rofi
  ];

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_CA.UTF-8";
    LC_CTYPE = "en_CA.UTF-8";
    LC_ALL = "en_CA.UTF-8";
  };

  home.file.".inputrc".source = ./inputrc;

  xdg.configFile."i3/config".text = builtins.readFile ./i3;
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./rofi;

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
      gruvbox-material
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
      gitsigns-nvim
      nvim-lspconfig
      vim-commentary
      vim-eunuch
      vim-fugitive
      vim-repeat
      vim-rhubarb
      vim-sleuth
      vim-speeddating
      vim-surround
      vim-test
      telescope-fzy-native-nvim
      vim-vinegar
    ];
    extraConfig = ''
      set termguicolors
      set background=light
      let g:gruvbox_material_palette="original"
      colorscheme gruvbox-material
    '';
  };

  programs.i3status = {
    enable = true;
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
