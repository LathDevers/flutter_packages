#!/bin/bash

# Save the current directory
original_dir=$(pwd)
lock_file="pubspec.lock"

# Search for subfolders inside "packages" and run "flutter clean" in each
for package_dir in */; do
    if [ -d "$package_dir" ]; then
        echo "Entering $package_dir and executing 'flutter clean'"
        
        # Enter each subfolder (except 'build') and run "flutter clean"
        cd "$package_dir" || exit
        if [ "$package_dir" != "build/" ]; then
            flutter clean > /dev/null 2>&1
        fi

        if [ -e "$lock_file" ]; then
            rm "$lock_file"
            echo "Deleted $lock_file"
        else
            echo "$lock_file does not exist"
        fi

        # Return to the "packages" directory
        cd "$original_dir" || exit
    fi
done

# Return to the original directory
cd "$original_dir" || exit

# Run "flutter pub get" in each subfolder of "packages" (except 'build')
#for package_dir in */; do
#    if [ -d "$package_dir" ] && [ "$package_dir" != "build/" ]; then
#        echo "Entering $package_dir and executing 'flutter pub get'"
#        flutter pub get > /dev/null 2>&1
#    fi
#done

echo "Script completed successfully."
