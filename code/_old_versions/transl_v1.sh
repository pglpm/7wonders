#!/bin/bash

# Check if a file is provided as input
if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"
output_file="${input_file%.m}.py"

# Initialize a set of needed imports
needed_imports=()

# Clear or create the output file
: > "$output_file"

# Read the input file line by line and process
while IFS= read -r line; do
    # Handling inline comments and semicolons
    if echo "$line" | grep -q -E ";[[:space:]]*[%#]"; then
        line=$(echo "$line" | sed -E 's/;( *[%#].*)/\1/')  # Remove semicolon before inline comment
    else
        line=$(echo "$line" | sed 's/;$//')  # Remove semicolon at the end of lines
    fi

    # Translate basic operations and functions
    translated_line=$(echo "$line" |
        sed -E 's/\bexp\b/math.exp/g;s/\bsin\b/math.sin/g;s/\bcos\b/math.cos/g;s/\btan\b/math.tan/g;s/\bsqrt\b/math.sqrt/g;s/\bpi\b/math.pi/g' |
        sed 's/\.\^/**/g' |
        sed 's/%/#/g')

    # Check if any math functions need to be imported
    if echo "$translated_line" | grep -q -E '\bmath\.(exp|sin|cos|tan|sqrt|pi)\b'; then
        needed_imports+=(math)
    fi

    # Handling comments
    if [[ $translated_line == \#* ]] || [[ $translated_line == *"#"* ]]; then
        echo "$translated_line" >> "$output_file"
    # Handling while loops and removing end statements
    else
        translated_line=$(echo "$translated_line" | sed -E 's/^[ \t]*while[ \t]+(.*)/while \1:/')
        if ! echo "$translated_line" | grep -q -E '^[ \t]*end[ \t]*$'; then
            echo "$translated_line" >> "$output_file"
        fi
    fi
done < "$input_file"

# Add necessary imports to the beginning of the output file
if [ ${#needed_imports[@]} -gt 0 ]; then
    {
        for import in "${needed_imports[@]}"; do
            echo "import $import"
        done
        echo ""  # Add a blank line after imports
    } | cat - "$output_file" > temp && mv temp "$output_file"
fi

# echo "Translation complete. Saved to $output_file"

output_file="${input_file%.m}.R"

# Clear or create the output file
: > "$output_file"

# Read the input file line by line and process
while IFS= read -r line; do
    # Handling inline comments and semicolons
    if echo "$line" | grep -q -E ";[[:space:]]*[%#]"; then
        line=$(echo "$line" | sed -E 's/;( *[%#].*)/\1/')  # Remove semicolon before inline comment
    else
        line=$(echo "$line" | sed 's/;$//')  # Remove semicolon at the end of lines
    fi

    # Translate basic operations and functions
    translated_line=$(echo "$line" |
        sed -E 's/\bexp\b/exp/g;s/\bsin\b/sin/g;s/\bcos\b/cos/g;s/\btan\b/tan/g;s/\bsqrt\b/sqrt/g;s/\bpi\b/pi/g' |
        sed 's/\.\^/\^/g' |
        sed 's/%/#/g')

    # Handling comments
    if [[ $translated_line == \#* ]] || [[ $translated_line == *"#"* ]]; then
        echo "$translated_line" >> "$output_file"
    # Handling while loops and removing end statements
    else
        translated_line=$(echo "$translated_line" | sed -E 's/^[ \t]*while[ \t]+(.*)/while (\1) {/' \
                                                   | sed -E 's/^[ \t]*end[ \t]*$/}/')
        echo "$translated_line" >> "$output_file"
    fi
done < "$input_file"

# echo "Translation complete. Saved to $output_file"
echo "Translation complete."
