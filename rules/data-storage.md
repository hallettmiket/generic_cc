# Data Storage Rules

All data, except for very small files that are sometimes kept in the repo, should be stored either in the /data/lab_vm/raw or /data/lab_vm/refined in the appropriate subdirectories. For example, if the current project is called x_y and I am working on experiment z_good_name, then the output analysis from scrips in z_good_name should be saved in /data/lab_vm/refined/x_y/z_good_name/ potentially in subfolders when that makes sense.

The raw data used in a project is always located in /data/lab_vm/raw and should only be readable, not writeable. No code should perform any operation on this data directly other than to copy it to an appropriate location in /data/lab_vm/refined.

Names should be meaningful and if there are multiple copies of the same data or analyses, an integer versioning system should be used where the largest integer is the most recent file.

In the corresponding repo/x_y/src there should be a file ready_to_delete.md to track whether data in refined/x_y can be safely deleted. For example, if a file is out of date, it should be listed in ready_to_delete.md. If a file is placed in an obsolete folder anywhere, it should be listed in ready_to_delete.md.
