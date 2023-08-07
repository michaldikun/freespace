# FreeSpace Script

The **FreeSpace script** is a Bash script designed to automate the compression and cleanup of files that meet specified criteria. It allows you to compress and manage files, freeing up disk space on your system. The script accepts various command-line options to customize its behavior according to your needs.

## Usage

```
freespace [-r] [-t ###] file [file...]
```

- `-r`: Enables recursive processing of directories and their contents.
- `-t ###`: Sets the maximum age (in hours) of files that should be considered for compression and removal.

## How It Works

1. **Default Values**: The script starts with default values for the `recursive` flag (off) and the `time` threshold (48 hours).

2. **Command-Line Flags**: The script uses command-line flags to modify its behavior.
   - `-r`: Turns on recursive processing, which includes subdirectories and their contents.
   - `-t ###`: Specifies the maximum age of files (in hours) that should be considered for compression and removal.

3. **File Compression Check**: The script checks if a given file is already compressed by examining its file extension. If the file is already compressed (e.g., `.zip`, `.tgz`, `.tar.gz`, `.bz2`, `.gz`), it acknowledges that fact. Otherwise, it proceeds to compress the file.

4. **File Age Check**: The script checks the age of the file by comparing the current time to the file's modification time. If the file age is within the specified threshold, the script considers the file as "ok" and takes no further action.

5. **File Compression**: If the file is not compressed, the script compresses it. If the file is compressed successfully, the original file is removed to save space.

6. **Recursive Processing**: If the `-r` flag is set, and the provided file is a directory, the script recursively processes all files and subdirectories within it.

7. **Main Loop**: The script processes each file provided on the command line using the `process_file` function.

## Notes

- The script recognizes files with names matching the pattern `fc-*` as files that were compressed by this script. If such a file is found and its age exceeds the specified threshold, it is deleted.
- The script intelligently renames and compresses files, ensuring a consistent naming convention for compressed files (`fc-<filename>`).

## Example Usage

1. Compress a single file:
   ```
   freespace file.txt
   ```

2. Compress multiple files:
   ```
   freespace file1.txt file2.csv
   ```

3. Enable recursive processing and set the age threshold to 24 hours:
   ```
   freespace -r -t 24 my_folder/
   ```

4. Compress files within a directory and its subdirectories:
   ```
   freespace -r my_folder/
   ```

## Important Considerations

- Ensure you have a backup of important files before running the script, especially if using the recursive mode.
- Use the script responsibly and understand its behavior before applying it to critical data.

**Disclaimer**: This description provides an overview of the script's functionality and is not an endorsement of its usage. Please review the script's code carefully and tailor its behavior to your specific needs and requirements.
