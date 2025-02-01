#!/bin/bash

# This script will generate a Dart file for asset classes with correct naming conventions and use AssetGen for PNG files.

# Folders containing asset files (icons, logos, images).
icons_folder="assets/icons"
logo_folder="assets/logo"
image_folder="assets/image"

# Output Dart file.
output_file="lib/assets/assets.dart"

# Start by writing the basic structure of the Dart file.
echo "import 'package:flutter/material.dart';" >$output_file
echo "" >>$output_file
echo "class Assets {" >>$output_file
echo "  Assets._();" >>$output_file
echo "  static const \$Icons icons = \$Icons();" >>$output_file
echo "  static const \$Logo logo = \$Logo();" >>$output_file
echo "  static const \$Images images = \$Images();" >>$output_file
echo "}" >>$output_file
echo "" >>$output_file

# Function to generate class for a folder
generate_class() {
    local class_name=$1
    local folder=$2

    echo "class $class_name {" >>$output_file
    echo "  const $class_name();" >>$output_file

    # Loop through all files and create getters for them.
    for file in $folder/*; do
        # Extract file name without extension.
        filename=$(basename -- "$file")
        filename_noext="${filename%.*}"
        # Convert filename to camelCase (for example: app_launcher.png => appLauncher)
        camel_case_name=$(echo $filename_noext | sed -r 's/(_[a-z])/\U\1/g' | sed 's/_//g')

        # Check if the file is a PNG file
        extension="${filename##*.}"
        if [ "$extension" == "png" ]; then
            # Use AssetGen for PNG files.
            echo "  AssetGen get $camel_case_name => const AssetGen('$file');" >>$output_file
        else
            # Use the regular string getter for other file types.
            echo "  String get $camel_case_name => '$file';" >>$output_file
        fi
    done

    # Add the list of values.
    echo "  List<dynamic> get values => [" >>$output_file
    for file in $folder/*; do
        filename=$(basename -- "$file")
        filename_noext="${filename%.*}"
        camel_case_name=$(echo $filename_noext | sed -r 's/(_[a-z])/\U\1/g' | sed 's/_//g')

        echo "        $camel_case_name," >>$output_file
    done
    echo "      ];" >>$output_file
    echo "}" >>$output_file
    echo "" >>$output_file
}

# Generate classes for icons, logos, and images
generate_class "\$Icons" "$icons_folder"
generate_class "\$Logo" "$logo_folder"
generate_class "\$Images" "$image_folder"

echo "Assets Generation Completed 🚀"
