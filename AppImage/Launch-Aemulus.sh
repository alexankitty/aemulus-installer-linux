#!/bin/sh
HERE="$(dirname "$(readlink -f "$0")")/.."
version=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/TekkaGB/AemulusModManager/releases/latest)
version=${version##*/}
aemulus="https://github.com/TekkaGB/AemulusModManager/releases/latest/download/AemulusPackageManagerv${version}.7z"
aemulus_dir="$HOME/.local/share/AemulusPackageManager"
export WINEPREFIX="$HERE/wineprefix"
export DOTNET_ROOT=""
export current_tasks=0
export tasks=3

# Start zenity progress bar (manual control)
start_progress_bar() {
    exec 3> >(zenity --progress --title="Working..." --percentage=0 --auto-close --width=400)
}

# Update progress bar (0-100)
update_progress_bar() {
    echo "$1" >&3
}

# Close progress bar
close_progress_bar() {
    exec 3>&-
}

increment_tasks() {
    current_tasks=$((current_tasks + 1))
    update_progress_bar $((current_tasks * 100 / tasks))
}

# Example usage:
# start_progress_bar
# update_progress_bar 10
# ... do work ...
# update_progress_bar 50
# ... do more work ...
# update_progress_bar 100
# close_progress_bar

start_progress() {
    (
        echo "$((current_tasks*100/tasks))"
        echo "# Downloading and installing Aemulus Package Manager. Please wait..."
    ) | zenity --progress --title="Aemulus Package Manager" --width=400 --auto-close
}

# Reads the installed Aemulus version from the runtimeconfig.json file (truncated to 3 parts, ultra-robust)
get_installed_version() {
    local version_file="$aemulus_dir/AemulusPackageManager.deps.json"
    if [[ -f "$version_file" ]]; then
        # Print the matching line for debug
        local line
        line=$(grep -o '"AemulusPackageManager/[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+"' "$version_file" | head -n1)
        # Uncomment for debug:
        # echo "DEBUG: line='$line'" >&2
        local version
        version=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        echo "$version"
    else
        echo "none"
    fi
}

if [[ ! -d "$aemulus_dir" ]]; then
    if [[ -d "/tmp/AemulusPackageManagerv${version}" ]]; then
        rm -rf "/tmp/AemulusPackageManagerv${version}"
    fi
    zenity --info --text="This will download and install Aemulus Package Manager to $aemulus_dir. This is required to run the AppImage. You can safely ignore any windows that pop up during installation. Click OK to continue." --width=400
    start_progress_bar
    curl -Lso "/tmp/AemulusPackageManager.7z" "$aemulus"
    increment_tasks
    7z x "/tmp/AemulusPackageManager.7z" -o"/tmp" -aoa
    rm "/tmp/AemulusPackageManager.7z"
    increment_tasks
    mkdir -p "$aemulus_dir"
    cp -rT "/tmp/AemulusPackageManagerv${version}/" "$aemulus_dir"
    rm -rf "/tmp/AemulusPackageManagerv${version}"
    increment_tasks
fi

if [[ $version > $(get_installed_version) ]]; then
    zenity --question --text="A new version of Aemulus Package Manager is available. Do you want to update?" --width=400
    if [[ $? -eq 0 ]]; then
        mkdir -p "/tmp/AemulusPackageManager"
        if [[ -d "$aemulus_dir/Packages" ]]; then
            mv "$aemulus_dir/Packages" "/tmp/AemulusPackageManager/Packages"
        fi
        if [[ -d "$aemulus_dir/Original" ]]; then
            mv "$aemulus_dir/Original" "/tmp/AemulusPackageManager/Original"
        fi
        if [[ -d "$aemulus_dir/Config" ]]; then
            mv "$aemulus_dir/Config" "/tmp/AemulusPackageManager/Config"
        fi
        rm -rf "$aemulus_dir"
        mkdir -p "$aemulus_dir"
        start_progress_bar
        curl -Lso "/tmp/AemulusPackageManager.7z" "$aemulus"
        increment_tasks
        7z x "/tmp/AemulusPackageManager.7z" -o"/tmp" -aoa
        rm "/tmp/AemulusPackageManager.7z"
        increment_tasks
        cp -rT "/tmp/AemulusPackageManagerv${version}/" "$aemulus_dir"
        cp -rT "/tmp/AemulusPackageManager/" "$aemulus_dir/"
        rm -rf "/tmp/AemulusPackageManagerv${version}"
        increment_tasks
    fi
fi

exec wine "$aemulus_dir/AemulusPackageManager.exe" "$@"
