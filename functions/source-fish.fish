function source-fish -d "Changed Source fish files under the current directory"
    argparse \
        -x 'a,t' \
        'a/all' 't/test' -- $argv
    or return

    set --local version_tsc "0.0.4"
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
                __source-fish_times $list_specied_dir_files
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
                        __source-fish_times $list_all_fish_files
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
                __source-fish_times $list_test_dir
            case '*'    
                return 1
        end        
    else 
        echo "Current:"$cc $PWD $cn
        read -l -P "Source fish files in this project? [Y/n]: " question
        switch "$question"
            case Y y yes
                set --local list_functions (command find . -type f -depth $max_find_depth -path "./functions*/*" -name "*.fish")
                set --local list_completions (command find . -type f -depth $max_find_depth -path "./completions*/*" -name "*.fish")
                set --local list_conf (command find . -type f -depth $max_find_depth -path "./conf.d*/*" -name "*.fish")
                
                test -n "$list_functions"
                    and __source-fish_times $list_functions
                    and set test_flag "OK"
                test -n "$list_completions"
                    and __source-fish_times $list_completions
                    and set test_flag "OK"
                test -n "$list_conf"
                    and __source-fish_times $list_conf
                    and set test_flag "OK"
                not test "$test_flag" = "OK"
                    and echo "can't find fish files"
                    and return 1
            case '*'
                return 1
        end
    end
end


# helper function
function __source-fish_times
    set --local cc (set_color yellow)
    set --local cn (set_color normal)
    set --local ca (set_color cyan)
    for i in (seq 1 (count $argv))
        builtin source $argv[$i]
        and echo $ca"-->complete:"$cc $argv[$i] $cn 
    end
end

