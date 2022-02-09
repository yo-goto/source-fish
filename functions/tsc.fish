function tsc -d "Source fish files under the current project"
    set --local version_tsc "0.0.1"
    # color shortcut
    set --local cc (set_color yellow)
    set --local cn (set_color normal)
    set --local ca (set_color cyan)
    
    echo "Current:"$cc $PWD $cn
    read -l -P 'Source fish files in this project? [Y/n]: ' question
    switch "$question"
        case Y y yes
            test -d ./functions
                and source $PWD/functions/*.fish
                and echo $ca"-->complete:"$cc ./functions/*.fish $cn
            test -d ./completions
                and source $PWD/completions/*.fish
                and echo $ca"-->complete:"$cc ./completions/*.fish $cn
            test -d ./conf.d
                and source $PWD/conf.d/*.fish
                and echo $ca"-->complete:"$cc ./conf.d/*.fish $cn
        case N n no
            return 1
    end
end