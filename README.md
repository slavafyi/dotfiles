# Dotfiles

Personal system configuration files.

## Philosophy

Keep it simple, even if it means duplicating code. Modular where it makes sense, pragmatic everywhere else. Designed for easy maintenance and clear understanding over clever abstractions.

## Quick Start
```bash
git clone --recursive https://github.com/slavafyi/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

## Available Commands
```bash
make install             # Full system setup
make install PROFILE=desktop  # Run a named profile
make update              # Update system and packages
make fmt                 # Format code files
```

## Profiles
Profiles let you reuse the underlying install modules for different targets:

- `full` – complete workstation setup (default)
- `minimal-server` – essentials only (`system_base`, `user_core`)
- `desktop` – desktop experience without developer extras
- `dev-workstation` – desktop plus developer tooling

Usage examples:
```bash
make install PROFILE=minimal-server
./install.sh profile desktop
./install.sh list-profiles
```

You can still run individual modules when needed:
```bash
./install.sh setup_mise
./install.sh dev_tools
```

## Structure
```
configs/     Configuration files (managed by stow)
packages/    Package lists by OS
scripts/     Installation scripts
misc/        Additional files (dconf dumps, etc)
```

## Supported Systems

- Arch Linux
- macOS
- Fedora (coming soon)
- Debian/Ubuntu

## License

MIT License - see [LICENSE](LICENSE) for details.
