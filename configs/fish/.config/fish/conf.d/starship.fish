#!/usr/bin/env fish

if status --is-interactive; and type -q starship
  starship init fish | source
end
