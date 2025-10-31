function capitalize -d "Capitalize the first letter of a string" -a input
    if test -z "$input"
        echo "Usage: capitalize <string>"
        echo "Example: ls | xargs -I {} fish -c 'mv \"{}\" \$(capitalize \"{}\")'"
        echo "Example: ls -d PATTERN | xargs -I {} fish -c 'mv \"{}\" \$(capitalize \"{}\")'"
        return 1
    end
    set --local first_char (string sub -l 1 -- $input | string upper)
    set --local rest_of_string (string sub -s 2 -- $input | string lower)
    echo "$first_char$rest_of_string"
end
