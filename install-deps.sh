#!/bin/bash
set -e

mkdir -p components

IDF_DEPS="dependencies.yaml"
CMAKELISTS="CMakeLists.txt"

if ! command -v vcs &> /dev/null; then
    echo "'vcs' command not found. Installing python3-vcstool"
    if [[ "$(uname -s)" =~ "Linux" ]]; then
        sudo apt install python3-vcstool
    else
	# Probably on macos otherwise Brew won't exist
	brew install python3-vcstool
    fi
fi

download() {
    vcs import --recursive --input "$1" "$2"
    vcs pull "$2"
}

SECONDS=0

# Install IDF dependencies

if ! [ -f "$IDF_DEPS" ]; then
    echo "Couldn't find '$IDF_DEPS' so unable to install dependencies. Exiting." 1>&2
    exit 1
fi
echo "Installing ESP-IDF dependencies..."
download "$IDF_DEPS" components

# Generate any missing CMakeLists.txt(s)
# cd components
# for lib in ./*; do
#     lib_basename="$(basename "$lib")"
#     cd "$lib"
#     if ! [ -f "$CMAKELISTS" ]; then
#         echo "Generating CMakeLists.txt for $lib_basename"
#         touch "$CMAKELISTS"
#         echo "cmake_minimum_required(VERSION 3.5)" >> "$CMAKELISTS"

#         # Find source files
#         files="$(find . -maxdepth 1 -type f -name "*.cpp" &&\
#                  find . -maxdepth 1 -type f -name "*.c" &&\
#                  find . -maxdepth 1 -type f -name "*.h" &&\
#                  find . -maxdepth 1 -type f -name "*.hpp")"
#         if [ -d "src" ]; then
#             files="$files $(find src/ -maxdepth 1 -type f -name "*.cpp" &&\
#                             find src/ -maxdepth 1 -type f -name "*.c" &&\
#                             find src/ -maxdepth 1 -type f -name "*.h" &&\
#                             find src/ -maxdepth 1 -type f -name "*.hpp")"
#         fi
        
#         files="$(echo "$files" | tr '\n' ' ')" # Replace newlines with spaces
#         files="${files//.\/}" # Remove leading "./" which isn't needed but is more readable

#         echo "idf_component_register(SRCS $files" >> "$CMAKELISTS"
        
#         # Include common directories
#         include="\".\""
#         if [ -d "src" ]; then
#             include="$include \"src\""
#         fi
#         if [ -d "include" ]; then
#             include="$include \"include\""
#         fi
#         if [ -d "main" ]; then
#             include="$include \"main\""
#         fi
#         if [ -d "utility" ]; then
#             include="$include \"utility\""
#         fi
#         echo "                       INCLUDE_DIRS $include" >> "$CMAKELISTS"

#         # Require dependencies specified in arduino libraries
#         if [ -f "library.properties" ]; then
#             requires="arduino"

#             set +e # Grep will fail with a non-zero exit code if there are no specified dependencies
#             dep_line="$(grep "depends=" library.properties)"
#             set -e

#             if [ -n "$dep_line" ]; then
#                 deps="${dep_line//depends=/}"

#                 IFS_OLD="$IFS" # IFS normally needs to be =" " for the outer loop to succeed
#                 IFS=","
#                 for dep_raw in ${deps//, /,}; do
#                     dep="${dep_raw//(*)/}" # Remove versioning from library name e.g. "ghostl(>=1.0.0)" goes to "ghostl"
#                     # Try and find library in components dir so the name can be perfectly replicated (case insensitive + ignoring spaces)
#                     name="$(basename "$(find .. -type d -iname "${dep// /*}")")"
#                     # Otherwise use the underscored convention for names although this isn't followed 100% of the time (e.g. Arduino-GFX-Library :( )
#                     if [ -z "$name" ]; then
#                         name="${dep// /_}"
#                         echo "Warning: Couldn't find dependency '$dep' when resolving dependencies for '$lib_basename', specified in it's library.properties" 1>&2
#                     fi
#                     requires="$requires $name"
#                 done
#                 IFS="$IFS_OLD"
#             fi

#             echo "                       REQUIRES $requires)" >> "$CMAKELISTS"
#         elif grep -rm1 "Arduino.h"; then
#             echo "                       REQUIRES arduino)" >> "$CMAKELISTS"
#         else
#             echo ")" >> "$CMAKELISTS"
#         fi

#         # Project decleration
#         echo "project($lib_basename)" >> "$CMAKELISTS"
#     fi
#     cd .. # Return to components/ dir
# done
# cd .. # Return to project dir

echo "Done. Took $SECONDS seconds."
