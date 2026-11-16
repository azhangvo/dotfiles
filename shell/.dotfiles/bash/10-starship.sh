# Interactive-only: starship's prompt rendering emits terminal
# synchronized-output escape codes (CSI ?2026) that get prepended to
# whatever line comes next. Over SSH with a pty allocated (-tt, which
# `become` always requests), that line is sudo's password prompt --
# Ansible's become detection does a strict startswith() match on it,
# so those escape codes make it fail every time, consistently, no
# matter the timeout. Guarding on `$-` (bash's own interactive flag)
# keeps this out of any non-interactive remote command execution.
if [[ $- == *i* ]] && command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi
