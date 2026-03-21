set -gx FZF_DEFAULT_OPTS " \
  --color=bg+:{{ colors.surface_container.default.hex }},bg:{{ colors.surface.default.hex }},spinner:{{ colors.primary.default.hex }},hl:{{ colors.primary.default.hex }} \
  --color=fg:{{ colors.on_surface.default.hex }},header:{{ colors.primary.default.hex }},info:{{ colors.secondary.default.hex }},pointer:{{ colors.primary.default.hex }} \
  --color=marker:{{ colors.tertiary.default.hex }},fg+:{{ colors.on_surface.default.hex }},prompt:{{ colors.primary.default.hex }},hl+:{{ colors.tertiary.default.hex }} \
  --color=border:{{ colors.outline.default.hex }},separator:{{ colors.outline_variant.default.hex }}"
