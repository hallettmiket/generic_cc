# Code Style Guidelines

## General Principles
- Write clear, readable code over clever code
- Prefer explicit over implicit
- Keep functions short and single-purpose

## Python
- Use snake_case for variables and functions
- Use PascalCase for classes
- Use UPPER_SNAKE_CASE for constants
- Type hints required for all function signatures
- Use pathlib for file paths, not os.path
- Prefer f-strings over .format() or concatenation

## R
- Follow tidyverse style guide
- Use <- for assignment, not =
- Pipe with |> (native) or %>% (magrittr)
- Use snake_case for variables and functions

## Naming Conventions
- Descriptive names over abbreviations
- Boolean variables: use is_, has_, should_ prefixes
- Functions: use verb_noun pattern (e.g., load_samples, calculate_qc_metrics)

## Preferred Libraries
- Data manipulation: pandas (Python), tidyverse (R)
- Plotting: matplotlib/seaborn (Python), ggplot2 (R)
- File I/O: Use standard formats (CSV, Parquet, HDF5)

## Documentation
- All functions require docstrings (numpy style for Python)
- Include type information and example usage for complex functions
- Scripts must have header comment with purpose, author, date

## Patterns to Avoid
- No hardcoded absolute paths
- No print() for logging; use logging module
- Avoid wildcard imports (from x import *)
- No magic numbers; use named constants

## Formatting
Run these tools before committing (don't ask Claude to format):
- Python: `black .` and `isort .`
- R: `styler::style_file()`
