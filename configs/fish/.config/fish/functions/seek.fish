function seek -d "Search for a pattern in current dir and open it in default \$EDITOR" -a input
  if type -q rg; and type -q fzf; and set -q EDITOR
    if test -z "$input"
      echo "Usage: seek <search-term>"
      echo "Example: seek myFunction"
      return 1
    end
    set --local result (rg -n. . | fzf --query "$input")
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
