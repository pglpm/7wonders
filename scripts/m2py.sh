#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_octave_file>"
    exit 1
fi

input_file=$1
output_file=${input_file%.m}.py

# Write the required imports at the beginning of the output file
{
    echo 'from matplotlib.pyplot import *'
    echo 'from numpy import *'
    echo 'from numpy.linalg import norm'
    echo 'from numpy import array as vector'
    echo 'import matplotlib.pyplot as plt'
} > "$output_file"

convert_brackets () {
    perl -pe 's/ \[([^\[\]]*)\] / vector([\1]) /g'
}

convert_italics () {
    perl -pe 's/(\{\\it [^\}]*\})/\$\1\$/g'
}

convert_round_to_square () {
    perl -pe 's/\(([0-9]+)\)/sprintf("[%d]", $1-1)/ge'
}

while IFS= read -r line
do
    # Remove lines containing "end" statements, including those preceded by whitespace and followed by comments
    if [[ "$line" =~ ^[[:space:]]*end[[:space:]]*(%.*)?$ ]]; then
        continue
    fi
    
    # # Remove lines containing "pause(...)" statements, including those preceded by whitespace
    # if [[ "$line" =~ ^[[:space:]]*pause\(.*\)[[:space:]]*$ ]]; then
    #     continue
    # fi

    # Replace "%" with "#"
    new_line=$(echo "$line" | sed 's/%/#/g')
    
    # Replace "^" with "**"
    new_line=$(echo "$new_line" | sed 's/\^/**/g')
    
    # Remove semicolons at the end of lines or before inline comments, preserving trailing spaces
    new_line=$(echo "$new_line" | sed 's/;\(\s*#.*\)/\1/' | sed 's/;[[:space:]]*$//')
    
    # Change [content] to vector([content])
    new_line=$(convert_brackets <<< "$new_line")
    
    # Change italics
    new_line=$(convert_italics <<< "$new_line")
    
    # Change (number) to [number-1]
    new_line=$(convert_round_to_square <<< "$new_line")
    
    # Add ":" at the end of "while" and "if" statements
    new_line=$(echo "$new_line" | sed -E 's/(while|if|else)(.*)$/\1\2:/')

    # Remove "hold on", possibly followed by semicolon and space
    new_line=$(echo "$new_line" | sed 's/hold on\s*; //g' | sed 's/hold on//g')

    # Replace "axis equal" with "axis('equal')"
    new_line=$(echo "$new_line" | sed 's/axis equal/gca().set_aspect("equal", adjustable="box")/g')

    # Replace "axis equal" with "axis('equal')"
    new_line=$(echo "$new_line" | sed 's/pause\([^)]*\)/# pause(0.0001) # comment for matplotlib.online/g')

    # Replace "hold off" with "clf"
    new_line=$(echo "$new_line" | sed 's/hold off/# clf() # comment for matplotlib.online/g')

    # Replace "grid on" with "grid(True)"
    new_line=$(echo "$new_line" | sed 's/grid on/grid(True)/g')
    
    echo "$new_line" >> "$output_file"
done < "$input_file"

# Add the plt.show() at the end of the output file
echo '' >> "$output_file"
echo 'plt.show()' >> "$output_file"
