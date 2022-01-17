#!/bin/bash

#If no command-line arguments are provided
if [ $# -eq 0 ]
then
	echo "Usage: $0 <project name>"
	exit 1
fi

#check if there's a folder called $1 in the current directory
if [ -d $1 ]
then
	echo "The project: $1 already exists"
	exit 1
fi

mkdir $1

mkdir $1/src

mkdir $1/build
mkdir $1/build/debug
mkdir $1/build/release
mkdir $1/build/extreme-release

touch $1/create.sh
chmod +x $1/create.sh

#find all files in a directory that end with .cpp or .h
#find . -name "*.cpp" -o -name "*.h" > $1/src/files.txt

buildScript=$(cat <<EOF
#!/bin/bash
FILES=\$(find . -name "*.cpp" -o -name "*.h")

FLAGS="" # <- PUT ANY COMPILER FLAGS HERE

COMPILER="g++ "

COMPILER=\$COMPILER \$FLAGS

DIR=\$(basename \$(pwd))

for f in \$FILES
do
	COMPILER+="\$f "
done

if [ "\$1" = "clean" ]
then
	rm -rf build/debug/*
	rm -rf build/release/*
	rm -rf build/extreme-release/*
	exit 1
fi

if [ -z "\$1" ]
then
	COMPILER=\$COMPILER"-o build/debug/\$DIR"
fi

if [ "\$1" = "release" ]
then
	COMPILER=\$COMPILER"-O2 -o build/release/\$DIR"
fi

if [ "\$1" = "extreme-release" ]
then
	COMPILER=\$COMPILER"-O3 -o build/extreme-release/\$DIR"
fi

eval \$COMPILER
EOF
)

mainFile=$(cat <<EOF
#include <iostream>

int main()
{
	std::cout << "Hello World!" << std::endl;
	return 0;
}
EOF
)

echo "$buildScript" > $1/create.sh
echo "$mainFile" > $1/src/main.cpp
