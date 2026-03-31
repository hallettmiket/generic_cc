# Lab Project Structure

## Naming
- snake_case all the time if possible
- Each project should have a unique name of the form x_y

## Repository Layout
- Project folder at ~/repos/x_y
- GitHub repository at https://github.com/hallettmiket/x_y (private initially)
- Subdirectories:
  - exp/ — individual coding experiments
  - src/ — shared code and data across experiments
  - obsolete/ — code no longer used but not ready to delete
  - data/ — very small files only (avoid large files in git)

## Experiment Organization
- Within exp/, subdirectories of the form z_good_name
  - z = unique integer (starting at 0, incrementing by 1)
  - good_name = meaningful descriptive name
- Each experiment should have:
  - README.md explaining what it does and relevant parameters (e.g., conda environment)
  - run_all.R / run_all.py / run_all.ipynb as the entry point

## Shared Code (src/)
- init.R should be easily sourced by R files in exp/
- For Python, use an Init class defining paths and global constants, easy to import from experiments

## Data Organization
- ~/repos/x_y mirrors /data/lab_vm/raw/x_y and /data/lab_vm/refined/x_y
- raw/x_y — original data from lab/collaborator/public resource (read-only, never modify)
- refined/x_y — mirrors repos/x_y/exp/z_good_name structure
  - refined/x_y/z_good_name/ stores data and analyses for experiment z
  - Subfolders for different types (figures, spreadsheets, pkl files, etc.)
