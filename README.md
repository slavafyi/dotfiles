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
make install    # Full system setup
make update     # Update system and packages
make fmt        # Format code files
```

For partial installation:
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
