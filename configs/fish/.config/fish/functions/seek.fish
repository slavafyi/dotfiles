function seek
  if type -q rg; and type -q fzf; and set -q EDITOR
    set --local result (rg -n . | fzf --query "$argv")
    if test -n "$result"
      set --local parts (string split ":" "$result")
      set --local file "$parts[1]"
      set --local line "$parts[2]"
      echo "Seeking file: $file at line $line"
      "$EDITOR" "$file" "+$line"
    else
      echo "No results found"
    end
  else
    echo "Missing required tools: rg, fzf or \$EDITOR"
  end
end
