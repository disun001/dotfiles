# dotfiles

chezmoi-managed dotfiles for macOS / Linux (incl. WSL). Secrets are age-encrypted.

## Setup on a new machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply disun001/dotfiles
```

This installs chezmoi, applies all configs, decrypts secrets, and runs the
one-time package installer (`run_once_install.sh.tmpl`) for the current OS.

### Before you run it

1. Install your age private key (from a password manager) at
   `~/.config/chezmoi/key.txt` — required to decrypt `dot_config/zsh/envs.age`
   (contains `GH_TOKEN`).
2. Create `~/.config/chezmoi/chezmoi.toml`:

   ```toml
   sourceDir = "~/path/to/your/checkout"   # where you cloned this repo
   encryption = "age"

   [age]
     command = "age"
     identity = "~/.config/chezmoi/key.txt"
     recipientsFile = "~/.config/chezmoi/recipient.txt"
   ```

   Alternatively, after `chezmoi init`, run `chezmoi apply --init` to rebuild
   the config from `.chezmoitoml`.

## Managing configs

```sh
chezmoi add ~/.config/<tool>          # start managing a config
chezmoi re-add ~/.config/<tool>       # update after editing
chezmoi apply                         # apply changes to this machine
chezmoi update                        # pull + apply latest from GitHub
chezmoi diff                          # review pending changes
```

Edit files in the source tree (`dot_config/...`) then `chezmoi apply`. Never
edit files in `~/.config` directly — changes will be overwritten.

## Adding a new machine

```sh
chezmoi init disun001/dotfiles
chezmoi apply
```

The installer script runs once per machine and installs the package set for
that OS (Homebrew on macOS, apt/cargo on Linux/WSL).

## Structure

```
.chezmoitoml                     machine-independent data
.chezmoiignore                   never-synced paths (auth stores, logs, node_modules)
dot_config/<tool>/...            managed configs (map to ~/.config/<tool>/...)
dot_config/zsh/envs.age          age-encrypted secrets (decrypted to ~/.config/zsh/envs)
run_once_install.sh.tmpl         one-time per-OS package installer
```

## Security

- Auth/token stores are never tracked: `gh/`, `github-copilot/`, `devin/`,
  `cagent/`, `sshm/`, `raycast/` (see `.chezmoiignore`).
- The only secret is `dot_config/zsh/envs.age`, encrypted to the age key pair
  held out-of-band. Keep `key.txt` and `recipient.txt` private.
- Rotate `GH_TOKEN` and re-encrypt with `chezmoi re-add ~/.config/zsh/envs` if
  it ever leaks.