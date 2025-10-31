fmt:
	@echo "⚡ [1/3] Formatting bash files..."
	@shfmt --write .
	@echo "⚡ [2/3] Formatting lua files..."
	@stylua --allow-hidden --search-parent-directories --respect-ignores .
	@echo "⚡ [3/3] Formatting fish files..."
	@fish --command "fish_indent -w configs/fish/.config/**/*.fish"
