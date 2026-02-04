if command -v starship >/dev/null 2>&1; then
    # See: https://github.com/wezterm/wezterm/issues/6776
    alias star='eval "$(starship init bash)" && command -v __bp_install >/dev/null 2>&1 && __bp_install'
fi
