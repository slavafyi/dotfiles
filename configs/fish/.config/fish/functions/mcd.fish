function mcd --description "Create directory and change into it"
    mkdir -pv $argv
    and cd $argv[1]
end
