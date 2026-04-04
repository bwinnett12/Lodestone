#~~~~~~~

# Define your directories
DIR_A=""
DIR_B=""

## 1. List and Sort Files in DIR_A

# Use sudo and -type f to find all FILES, then sort them.
# The output is saved to a temporary file.
sudo find "$DIR_A" -type f -printf '%P\n' | sort > /tmp/files_A_sorted.txt

## 2. List and Sort Files in DIR_B

# Use sudo and -type f to find all FILES, then sort them.
# The output is saved to a temporary file.
sudo find "$DIR_B" -type f -printf '%P\n' | sort > /tmp/files_B_sorted.txt

## 3. Compare the Lists

echo "Files in DIR_A but NOT in DIR_B (Missing Files):"
# comm -23 suppresses lines unique to B (column 2) and lines common to both (column 3), 
# leaving only files unique to A (column 1).
comm -23 /tmp/files_A_sorted.txt /tmp/files_B_sorted.txt

## 4. Clean up

rm /tmp/files_A_sorted.txt /tmp/files_B_sorted.txt