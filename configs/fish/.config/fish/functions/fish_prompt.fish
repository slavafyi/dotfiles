function fish_prompt
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
