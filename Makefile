.PHONY: help install update fmt

help:
	@echo "→ Make targets"
	@echo "  make install            Full installation (PROFILE=<name> to select)"
	@echo "  make update             Update system and packages"
	@echo "  make fmt                Format code files"
	@echo ""
	@echo "For full usage and profiles:"
	@echo "  ./install.sh help"

install:
	@if [ -n "$$PROFILE" ]; then \
		./install.sh profile "$$PROFILE"; \
	else \
		./install.sh; \
	fi

update:
	@echo "→ Updating system and packages"
	@./install.sh system_base || true
	@echo "✓ Update complete"

fmt:
	@echo "→ [1/3] Formatting bash files"
	@shfmt --write .
	@echo "→ [2/3] Formatting fish files"
	@fish --command "fish_indent -w configs/fish/.config/**/*.fish"
	@echo "✓ Formatting complete"
