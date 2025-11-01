.PHONY: help install update fmt

help:
	@echo "Available commands:"
	@echo ""
	@echo "  make install    Full system installation"
	@echo "  make update     Update system and packages"
	@echo "  make fmt        Format code files"
	@echo ""
	@echo "For partial installation, use:"
	@echo "  ./install.sh <function_name>"
	@echo ""
	@echo "Examples:"
	@echo "  ./install.sh setup_mise"
	@echo "  ./install.sh dev_tools"

install:
	@echo "⚡ Starting full installation..."
	@./install.sh
	@echo "✓ Installation complete!"

update:
	@echo "⚡ Updating system and packages..."
	@./install.sh system_base || true
	@echo "✓ Update complete!"

fmt:
	@echo "⚡ [1/3] Formatting bash files..."
	@shfmt --write .
	@echo "⚡ [2/3] Formatting lua files..."
	@stylua --allow-hidden --search-parent-directories --respect-ignores .
	@echo "⚡ [3/3] Formatting fish files..."
	@fish --command "fish_indent -w configs/fish/.config/**/*.fish"
	@echo "✓ Formatting complete!"
