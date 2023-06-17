# sym-link-test

Repository for testing out creating symbolic links

# Using the `./run.sh` script

Use the following command:

```bash
./run.sh [--dry-run] source_dir target_dir files_to_copy_instead_of_symlink
```

This will replicate the directory structure from `source_dir` in `target_dir` and create symbolic links between all files in the directories.
