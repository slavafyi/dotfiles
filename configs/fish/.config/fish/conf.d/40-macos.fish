set os (uname)

if test "$os" != Darwin
    return
end

set -gx TMPDIR (getconf DARWIN_USER_TEMP_DIR)

if not type -q brew
    return
end

set -l brew_prefix (brew --prefix)

fish_add_path $brew_prefix/bin
fish_add_path $brew_prefix/opt/*/libexec/gnubin

set -gx MANPATH $brew_prefix/opt/*/libexec/gnuman $MANPATH
