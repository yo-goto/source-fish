function source-fish -d "Source fish files under the current directory"
    argparse \
        -x 'v,h,r,a,t,c' \
        -x 'p,v,h,c' \
        'v/version' 'h/help' \
        'r/recent' 'a/all' 't/test' 'p/permit' \
        'c/config' \
        -- $argv
    or return 1

    set --local version_source_fish "v0.2.0"
    # color shortcut
    set --local cc (set_color yellow)
    set --local cn (set_color normal)
    set --local ca (set_color cyan)

    set --local directory $argv # input arguments
    set --local max_find_depth "-3" # find depth

    if set -q _flag_version
        echo "source-fish:" $version_source_fish
        return
    else if set -q _flag_help
        __source-fish_help
        return
    else if test -n "$directory"
        ## if arguments aer specified, find fish files in the directories
        ### trim last slash character
        set --local list_replaced (string replace --all -r "/\$" "" $directory)
        set --local list_specified_dir_files
        for i in (seq 1 (count $list_replaced))
            set -a list_specified_dir_files (command find . -depth $max_find_depth -type f -path "./$list_replaced[$i]/*.fish")
        end
        if not test -n "$list_specified_dir_files"
            echo "No files found"
            return 1
        end

        if not set -q _flag_permit
            printf '%s\n' "found fish files:"$cc $list_specified_dir_files; set_color normal
            while true
                read -l -P "Source these fish files? [Y/n]: " question
                switch "$question"
                    case Y y yes
                        __source-fish_times $list_specified_dir_files
                        return
                    case N n q no
                        return
                end
            end
        else
            __source-fish_times $list_specified_dir_files
        end
    else if set -q _flag_recent
        set --local list_recent
        set -a list_recent (command find . -type f -depth $max_find_depth -path "*.fish" -mmin "-60")
        if not test -n "$list_recent"
            echo "No files found"
            return 1
        end

        if not set -q _flag_permit
            echo "Current:"$cc $PWD $cn
            printf '%s\n' "found fish files modified in the last hour:"$cc "  "$list_recent; set_color normal
            while true
                read -l -P "Source these fish files? [Y/n]: " question
                switch "$question"
                    case Y y yes
                        __source-fish_times $list_recent
                        return
                    case N n q no
                        return
                end
            end
        else
            __source-fish_times $list_recent
        end
    else if set -q _flag_all
        ## find all fish files and try to soruce interactively (find max depth -3)
        set --local display_depth_num (string trim -lc "-" -- $max_find_depth)
        set --local list_all_fish_files (command find . -depth $max_find_depth -type f -name "*.fish")
        if not test -n "$list_all_fish_files"
            echo "No files found"
            return 1
        end

        if not set -q _flag_permit
            echo "Current:"$cc $PWD $cn
            printf '%s\n' "found fish files:"$cc "  "$list_all_fish_files; set_color normal
            while true
                read -l -P 'Source all these fish files? [Y/n]: ' second
                switch "$second"
                    case Y y yes
                        __source-fish_times $list_all_fish_files
                        return
                    case N n q no
                        return
                end
            end
        else
            __source-fish_times $list_all_fish_files
        end
    else if set -q _flag_test
        ## find "test" directory, and source fish files in the directory
        set --local list_test_dir
        set -a list_test_dir (command find . -type f -depth $max_find_depth -path "./test/*.fish")
        set -a list_test_dir (command find . -type f -depth $max_find_depth -path "./tests/*.fish")
        # set -a list_test_dir (command find . -type f -depth $max_find_depth -name "*test.fish")
        if not test -n "$list_test_dir"
            echo "No files found"
            return 1
        end

        if not set -q _flag_permit
            echo "Current:"$cc $PWD $cn
            printf '%s\n' "found test files:"$cc "  "$list_test_dir; set_color normal
            while true
                read -l -P "Source test fish files in this project? [Y/n]: " question
                switch "$question"
                    case Y y yes
                        __source-fish_times $list_test_dir
                        return
                    case N n q no
                        return
                end
            end
        else
            __source-fish_times $list_test_dir
        end
    else if set -q _flag_config
        __source-fish_config
    else
        ## no option flags & no arguments
        set --local list_functions (command find . -type f -depth $max_find_depth -path "./functions/*.fish")
        set --local list_completions (command find . -type f -depth $max_find_depth -path "./completions/*.fish")
        set --local list_conf (command find . -type f -depth $max_find_depth -path "./conf.d/*.fish")

        if not test \( -n "$list_functions" \) -o \( -n "$list_completions" \) -o \( -n "$list_conf" \)
            echo "No files found"
            return 1
        end

        if not set -q _flag_permit
            ## normal process
            echo "Current:"$cc $PWD $cn
            while true
                read -l -P "Source fish files in this project? [Y/n]: " question
                switch "$question"
                    case Y y yes
                        test -n "$list_functions"; and __source-fish_times $list_functions
                        test -n "$list_completions"; and __source-fish_times $list_completions
                        test -n "$list_conf"; and __source-fish_times $list_conf
                        return
                    case N q n no
                        return
                end
            end
        else
            ## with permission
            test -n "$list_functions"; and __source-fish_times $list_functions
            test -n "$list_completions"; and __source-fish_times $list_completions
            test -n "$list_conf"; and __source-fish_times $list_conf
        end
    end
end


# helper functions
## config option mode
function __source-fish_config
    while true
        set --local list_config_files
        
        while true
            set --local loop_exit_flag "loop"
            read -l -P "Config [r:recent | a:all | d:dir | o:open | e:exit]: " choice
            switch "$choice"
                case R r recent
                    set list_config_files (command find "$__fish_config_dir" -type f -depth "-3" -name "*.fish" -mmin "-60")
                    break
                case A a all
                    set list_config_files (command find "$__fish_config_dir" -type f -depth "-3" -name "*.fish")
                    break
                case O o open
                    set --local filer_flag "false"
                    if type -q code
                        read -l -P "Open direcotry in VsCode or Finder? [v:vscode | f:filer]: " input
                        switch "$input"
                            case V v vscode
                                command code $__fish_config_dir
                            case F f finder
                                set filer_flag "true"
                        end
                    end

                    if test "$filer_flag" = "true"
                        if command -q open
                            command open $__fish_config_dir
                        else if type -q xdg-open
                            xdg-open $__fish_config_dir
                        else
                            echo "can't find open or xdg-open command"
                        end
                    end
                case D d dir
                    while true
                        read -l -P "Directory [t:top | c:conf | f:functons | p:completions | b:back | e:exit ]: " select_dir
                        switch "$select_dir"
                            case T t top
                                set list_config_files (command find "$__fish_config_dir" -type f -depth "1" -name "*.fish")
                                set loop_exit_flag "exit"
                                break
                            case C c conf
                                set list_config_files (command find "$__fish_config_dir/conf.d" -type f -depth "1" -name "*.fish")
                                set loop_exit_flag "exit"
                                break
                            case F f functions
                                set list_config_files (command find "$__fish_config_dir/functions" -type f -depth "1" -name "*.fish")
                                set loop_exit_flag "exit"
                                break
                            case P p completions
                                set list_config_files (command find "$__fish_config_dir/completions" -type f -depth "1" -name "*.fish")
                                set loop_exit_flag "exit"
                                break
                            case B b back
                                break
                            case E e q exit
                                return
                        end
                    end
                case E e q exit
                    return
            end
            test "$loop_exit_flag" = "exit" ; and break
        end
        
        ## show the result list
        if test (count $list_config_files) -gt 10
            ## if num of list elements is greater than 10, limit the results
            set --local list_short $list_config_files[1..10]
            __source-fish_times --print $list_short
            set_color -o cyan
            echo "...found" (math (count $list_config_files) - (count $list_short)) "other files"
            set_color normal
            while true
                read -l -P "show all of them? [Y/n]: " check
                switch "$check"
                    case Y y yes
                        __source-fish_times --print $list_config_files
                        break
                    case N n no
                        break
                end
            end
        else
            __source-fish_times --print $list_config_files
        end

        while true
            read -l -P "Source? [y:yes | q:quiet | p:print | b:back | e:exit ]: " question
            switch "$question"
                case Y y yes
                    __source-fish_times $list_config_files
                    return
                case Q q quiet
                    __source-fish_times --quiet $list_config_files
                    return
                case P p print
                    __source-fish_times --print $list_config_files
                case B b back
                    set --erase list_config_files
                    break
                case E e exit
                    return
            end
        end
    end
end


## central (source wrapper: to source bulk files)
function __source-fish_times
    argparse 'quiet' 'print' -- $argv
    or return 1

    set --local cc (set_color yellow)
    set --local cn (set_color normal)
    set --local ca (set_color cyan)
    set --local ce (set_color red)

    set --local argcount (count $argv)
    if test $argcount -ge 1
        if set -q _flag_print
            for i in (seq 1 $argcount)
                echo $ca"-->found:"$cc $argv[$i] $cn
            end
        else if set -q _flag_quiet
            for i in (seq 1 $argcount)
                builtin source $argv[$i]
                if not test "$status" = "0"
                    echo $ce"-->failed:"$cc $argv[$i] $cn
                end
            end
        else
            for i in (seq 1 $argcount)
                builtin source $argv[$i]
                if test "$status" = "0"
                    echo $ca"-->completed:"$cc $argv[$i] $cn
                else
                    echo $ce"-->failed:"$cc $argv[$i] $cn
                end
            end
        end
    else
        echo $ca"No files found" $cn
    end
end

## help option
function __source-fish_help
    set_color yellow
    echo "USAGE:"
    echo "      source-fish [OPTION]"
    echo "      source-fish DIRECOTRIES..."
    echo "OPTIONS:"
    echo "      -v, --version   Show version info"
    echo "      -h, --help      Show help"
    echo "      -p, --permit    Source fish files without confirmation"
    echo "      -r, --recent    Find recently modified files (within 1 hour) & source them"
    echo "      -a, --all       Source all fish files under the current directory"
    echo "      -t, --test      Source all fish files in the \"test\" folder"
    echo "      -c, --config    Source fish files in the config directory"
    set_color normal
end
