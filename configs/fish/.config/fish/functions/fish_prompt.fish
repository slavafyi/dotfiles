set -gx VIRTUAL_ENV_DISABLE_PROMPT true

function fish_prompt
  if set -q VIRTUAL_ENV
    printf '(venv) '
  end

  set_color yellow
  printf '%s' $USER
  set_color normal
  printf ' at '

  set_color magenta
  echo -n (prompt_hostname)
  set_color normal
  printf ' in '

  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  set_color normal

  # Line 2
  echo
  printf '↪ '
  set_color normal
end
