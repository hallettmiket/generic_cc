# Documentation Guidelines

## README.md Requirements
Every repository must have a README.md containing:
- Project title and brief description
- Authors and contact information
- Dependencies and environment setup instructions
- How to reproduce the analysis
- Expected inputs and outputs
- License information (if applicable)

## Script Headers
All scripts must begin with a header comment:

### Python
```python
"""
Purpose: Brief description of what this script does
Author: Your Name
Date: YYYY-MM-DD
Input: Description of expected inputs
Output: Description of outputs generated
"""
```

### R
```r
#' Purpose: Brief description of what this script does
#' Author: Your Name
#' Date: YYYY-MM-DD
#' Input: Description of expected inputs
#' Output: Description of outputs generated
```

## Inline Comments
- Explain why, not what
- Comment complex logic or non-obvious decisions
- Avoid redundant comments like # increment counter

## Analysis Documentation
- Each analysis directory should contain:
  - README.md explaining the analysis purpose and workflow
  - environment.yml or requirements.txt for reproducibility
  - Comments in notebooks explaining biological interpretation

## Versioning
When there are multiple versions of the same file (code, data or analyses), use an integer versioning system 1, 2, 3, ... appended to the name. The largest integer is always the newest version.
