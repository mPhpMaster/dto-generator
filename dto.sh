#!/bin/bash

# Define color codes for output
COLOR_RESET="\033[0m"
COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"

# Function to display the usage message
display_help() {
    echo -e "${COLOR_YELLOW}Usage: $0 [options] [model]${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}Options:${COLOR_RESET}"
    echo -e "${COLOR_GREEN}  -h, --help              Show this help message${COLOR_RESET}"
    echo -e "${COLOR_GREEN}  --namespace=<ns>        Optional namespace (default is empty)${COLOR_RESET}"
    echo -e "${COLOR_GREEN}  -B, --base              Create BaseDTO.php${COLOR_RESET}"
    echo -e "${COLOR_GREEN}  -f, --force             Force overwrite of existing files${COLOR_RESET}"
    echo -e "${COLOR_GREEN}  --dir=<dir>             Directory to create (default is 'app/DataTransferObjects')${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}Arguments:${COLOR_RESET}"
    echo -e "${COLOR_GREEN}  model                   Model name (default is 'UserDTO')${COLOR_RESET}"
}

# Function to create directory and files
create_directory_and_files() {
    local dir_name="$1"
    local model_name="$2"
    local namespace="$3"
    local base="$4"
    local force="$5"

    # Display current path and files to be created
    echo -e "${COLOR_YELLOW}Current path: ${COLOR_RESET}${COLOR_GREEN}$(pwd)${COLOR_RESET}"
    if [ -n "$dir_name" ]; then
        echo -e "${COLOR_YELLOW}Directory to create: ${COLOR_RESET}${COLOR_GREEN}$dir_name${COLOR_RESET}"
    else
        dir_name=$(realpath .)
        echo -e "${COLOR_RED}No directory specified. (default is: ${dir_name})${COLOR_RESET}"
    fi

    if [ -n "$namespace" ]; then
        echo -e "${COLOR_YELLOW}Namespace: ${COLOR_RESET}${COLOR_GREEN}$namespace${COLOR_RESET}"
    else
        echo -e "${COLOR_RED}No namespace will be added.${COLOR_RESET}"
    fi

    echo -e "${COLOR_YELLOW}Files to create:${COLOR_RESET}"
    if [ "$base" = true ]; then
        echo -e "${COLOR_GREEN}- $dir_name/BaseDTO.php${COLOR_RESET}"
    fi
    if [ -n "$model_name" ]; then
        echo -e "${COLOR_GREEN}- $dir_name/$model_name.php${COLOR_RESET}"
    fi
    if [ -z "$model_name" ] && [ "$base" = false ]; then
        echo -e "${COLOR_RED}NONE!${COLOR_RESET}"
    fi

    # Ask for confirmation
    echo -ne "${COLOR_YELLOW}\nDo you want to proceed? (y/n) (default is 'y'): ${COLOR_RESET}"
    read -r input
    input="${input:-y}"

    if [[ "${input,,}" != "y" ]]; then
        echo -e "${COLOR_RED}Operation aborted.${COLOR_RESET}"
        return 1
    fi

    # Create directory if it does not exist
    if [ -n "$dir_name" ] && [ ! -d "$dir_name" ]; then
        mkdir -p "$dir_name" || {
            echo -e "${COLOR_RED}Directory '$dir_name' was not created.${COLOR_RESET}"
            return 1
        }
        echo -e "${COLOR_GREEN}Directory '$dir_name' created.${COLOR_RESET}"
    elif [ -z "$dir_name" ]; then
        dir_name=$(realpath .)
        echo -e "${COLOR_YELLOW}Directory '$dir_name'.${COLOR_RESET}"
    else
        echo -e "${COLOR_YELLOW}Directory '$dir_name' already exists.${COLOR_RESET}"
    fi

    local file1="$dir_name/BaseDTO.php"
    local file2="$dir_name/$model_name.php"

    local namespace_declaration=""
    if [ -n "$namespace" ]; then
        namespace_declaration="namespace $namespace;\n"
    fi

    if [ "$base" = true ] && ( [ "$force" = true ] || [ ! -f "$file1" ] ); then
        cat > "$file1" <<- EOF
<?php
declare(strict_types=1);

$namespace_declaration
/**
 *
 */
class BaseDTO
{
    public static function create(array \$values): self
    {
        \$dto = new self();

        foreach (\$values as \$key => \$value) {
            if (property_exists(\$dto, \$key)) {
                \$dto->\$key = \$value;
            }
        }

        return \$dto;
    }

    public function toArray(): array
    {
        return get_object_vars(\$this);
    }
}
EOF
        echo -e "${COLOR_GREEN}File '$file1' created.${COLOR_RESET}"
    elif [ "$base" = true ]; then
        echo -e "${COLOR_YELLOW}File '$file1' already exists. Use -f or --force to overwrite.${COLOR_RESET}"
    fi

    if [ -n "$model_name" ] && ( [ "$force" = true ] || [ ! -f "$file2" ] ); then
        cat > "$file2" <<- EOF
<?php
declare(strict_types=1);

$namespace_declaration
/**
 *
 */
class $model_name extends BaseDTO
{
    public int \$id;
    public string \$name = '';
    public string \$email = '';
}
EOF
        echo -e "${COLOR_GREEN}File '$file2' created.${COLOR_RESET}"
    elif [ -n "$model_name" ]; then
        echo -e "${COLOR_YELLOW}File '$file2' already exists. Use -f or --force to overwrite.${COLOR_RESET}"
    fi
}

# Check if no arguments were provided
if [ $# -eq 0 ]; then
    display_help
    exit 1
fi

# Default values
namespace=""
base=false
force=false
dir_name=""
model_name="UserDTO"

# Parse command line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            display_help
            exit 0
            ;;
        --namespace=*)
            namespace="${1#*=}"
            shift
            ;;
        -B|--base)
            base=true
            shift
            ;;
        -f|--force)
            force=true
            shift
            ;;
        --dir=*)
            dir_name="${1#*=}"
            shift
            ;;
        *)
            model_name="$1"
            shift
            ;;
    esac
done

# Call the function with the provided or default parameters
create_directory_and_files "$dir_name" "$model_name" "$namespace" "$base" "$force"
