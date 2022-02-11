function source-fish -d "Source fish files under the current directory"
    argparse \
        -x 'a,t' \
        'a/all' 't/test' -- $argv
    or return

    set --local version_tsc "0.0.3"
    # color shortcut
    set --local cc (set_color yellow)
    set --local cn (set_color normal)
    set --local ca (set_color cyan)
    set --local test_flag
    set --local max_find_depth "-3"

    # input arguments
    set --local directory $argv

    if test -n "$directory"
        ## if arguments specified, find fish files in the directories
        ### split last slash character
        set -l list_escaped (string replace --all -r "/\$" "" $directory)
        set -l list_specied_dir_files
        for i in (seq 1 (count $list_escaped))
            set -a list_specied_dir_files (command find . -depth $max_find_depth -type f -path "./$list_escaped[$i]*/*" -name "*.fish")
        end
        if not test -n "$list_specied_dir_files"
            echo "can't find any fish files"
            return 1
        end
        printf '%s\n' "found fish files:"$cc $list_specied_dir_files; set_color normal
        read -l -P "Source these fish files? [Y/n]: " question
        switch "$question"
            case Y y yes
                builtin source $list_specied_dir_files
                and echo $ca"-->complete:"$cc $list_specied_dir_files $cn
            case '*'    
                return 1
        end
    else if set -q _flag_all
        ## find all fish files and try to soruce interactively (find max depth -3)
        echo "Current:"$cc $PWD $cn
        read -l -P "find all fish files in this project? (Max depth = \"$max_find_depth\") [Y/n]: " first
        switch "$first"
            case Y y yes
                set -l list_all_fish_files (command find . -depth $max_find_depth -type f -name "*.fish")
                if not test -n "$list_all_fish_files"
                    echo "can't find any fish files"
                    return 1
                end
                printf '%s\n' "found fish files:"$cc "  "$list_all_fish_files; set_color normal
                read -l -P 'Source all these fish files? [Y/n]: ' second
                switch "$second"
                    case Y y yes
                        builtin source $list_all_fish_files
                        and echo $ca"-->complete:"$cc $list_all_fish_files $cn
                    case '*'    
                        return 1
                end
            case '*'
                return 1
        end
    else if set -q _flag_test
        ## find "test" directory, and source fish files in the directory
        echo "Current:"$cc $PWD $cn
        set -l list_test_dir (command find . -type f -depth $max_find_depth -path "./test*/*" -name "*.fish")
        if not test -n "$list_test_dir"
            echo "can't find any fish files"
            return 1
        end
        printf '%s\n' "found test files:"$cc "  "$list_test_dir; set_color normal
        read -l -P "Source test fish files in this project? [Y/n]: " question
        switch "$question"
            case Y y yes
                builtin source $list_test_dir
                and echo $ca"-->complete:"$cc $list_test_dir $cn
            case '*'    
                return 1
        end        
    else 
        echo "Current:"$cc $PWD $cn
        read -l -P "Source fish files in this project? [Y/n]: " question
        switch "$question"
            case Y y yes
                test -d ./functions
                    and builtin source ./functions/*.fish
                    and echo $ca"-->complete:"$cc ./functions/*.fish $cn
                    and set test_flag "OK"
                test -d ./completions
                    and builtin source ./completions/*.fish
                    and echo $ca"-->complete:"$cc ./completions/*.fish $cn
                    and set test_flag "OK"
                test -d ./conf.d
                    and builtin source ./conf.d/*.fish
                    and echo $ca"-->complete:"$cc ./conf.d/*.fish $cn
                    and set test_flag "OK"
                not test "$test_flag" = "OK"
                    and echo "can't find fish files"
                    and return 1
            case '*'
                return 1
        end
    end
end