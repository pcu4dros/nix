{
  description = "Perfect nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {
      # Allow no-opensource apps to be installed
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
	 # Uncomment these three pkgs to enable docker
   # pkgs.colima
	 # pkgs.docker
	 # pkgs.docker-compose
	 pkgs.fzf
	 pkgs.git 
	 pkgs.gnupg
	 pkgs.go
	 pkgs.lazygit
   pkgs.vimPlugins.LazyVim
	 pkgs.neovim
	 pkgs.nodejs_23
	 pkgs.obsidian
	 pkgs.oh-my-zsh
	 pkgs.pinentry_mac
	 pkgs.podman
	 pkgs.podman-desktop
	 pkgs.python313
   pkgs.ripgrep
	 pkgs.typescript
	 pkgs.zsh-powerlevel10k
        ];
      
      # Homebrew packages that have not yet been created as Nix packages
      homebrew = {
        enable = true;
	casks = [
	  "ghostty"
	  "zen-browser"
	  "iina"
	];
	onActivation.cleanup = "zap";
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;
      programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."mini" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
	nix-homebrew.darwinModules.nix-homebrew
	{
	  nix-homebrew = {
	    enable = true;
	    # Apple Silicon stuff
	    # enableRosetta = true;
	    # User owning the homebrew prefix
	    user = "pcu4dros";
	  };
	}  
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mini".pkgs;
  };
}
