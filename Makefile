fmt:
	shfmt --write .
	stylua --allow-hidden --search-parent-directories --respect-ignores .
