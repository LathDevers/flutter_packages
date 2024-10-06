#!/bin/bash

# Save the current directory
original_dir=$(pwd)

# Run "flutter pub get" in each subfolder of "packages" (except 'build')
for package_dir in */; do
    if [ -d "$package_dir" ] && [ "$package_dir" != "build/" ]; then
        echo "Entering $package_dir and executing 'flutter pub upgrade --major-versions'"

        # Enter each subfolder (except 'build') and run "flutter clean"
        cd "$package_dir" || exit

        flutter pub upgrade --major-versions

        # Return to the "packages" directory
        cd "$original_dir" || exit
    fi
done

echo "Script completed successfully."
