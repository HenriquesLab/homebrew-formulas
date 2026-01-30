# HenriquesLab Homebrew Formulas

A Homebrew tap for custom formulas maintained by [HenriquesLab](https://github.com/HenriquesLab).

## Installation

### Quick Installation (Recommended)

Install formulas directly with a single command:

```bash
# Install TaskRepo
brew install henriqueslab/formulas/taskrepo

# Install rxiv-maker
brew install henriqueslab/formulas/rxiv-maker

# Install folder2md4llms
brew install henriqueslab/formulas/folder2md4llms
```

### Alternative: Manual Tap

```bash
# Tap this repository first
brew tap henriqueslab/formulas

# Then install formulas
brew install taskrepo
brew install rxiv-maker
brew install folder2md4llms
```

## Available Formulas

### 📄 Rxiv-Maker

Create beautiful LaTeX manuscripts for preprint servers (bioRxiv, arXiv) with automated formatting and validation.

**Installation:**
```bash
brew install henriqueslab/formulas/rxiv-maker
```

**Quick Start:**
```bash
rxiv init my-paper          # Create new manuscript
rxiv pdf                    # Generate PDF
rxiv check-installation     # Verify setup
```

**Documentation:** https://rxiv-maker.henriqueslab.org
**Repository:** https://github.com/HenriquesLab/rxiv-maker
**License:** MIT

**Key Features:**
- Automated LaTeX manuscript generation for bioRxiv/arXiv
- Template-based workflow with validation
- Track changes support with latexdiff
- GitHub integration for collaborative writing
- PDF generation with quality checks
- Bibliography management

**Dependencies:** Python 3.13, LaTeX (TeX Live), git, gh, poppler, latexdiff (all installed automatically)

---

### 📄 folder2md4llms

Convert folder structures and file contents into markdown for Large Language Models.

**Installation:**
```bash
brew install henriqueslab/formulas/folder2md4llms
```

**Quick Start:**
```bash
folder2md .                     # Process current directory
folder2md /path --limit 80000t  # Process with token limit
folder2md --init-ignore         # Generate ignore file
```

**Documentation:** https://folder2md4llms.henriqueslab.org
**Repository:** https://github.com/henriqueslab/folder2md4llms
**License:** MIT

**Key Features:**
- Smart content condensing for LLMs with token/character limits
- Document conversion (PDF, DOCX, XLSX, PPTX, etc.)
- Binary file analysis
- Parallel processing for large codebases
- Advanced filtering with .gitignore-style patterns
- Interactive file analysis and ignore suggestions
- YAML configuration support

**Dependencies:** Python 3.13, libmagic (all installed automatically)

**Note:** Package name is `folder2md4llms`, command is `folder2md`.

---

### 📋 TaskRepo

TaskWarrior-inspired task management with markdown files in git repositories.

**Installation:**
```bash
brew install henriqueslab/formulas/taskrepo
```

**Quick Start:**
```bash
tsk init                  # Initialize configuration
tsk create-repo work      # Create your first repository
tsk add                   # Add a task
```

**Documentation:** https://taskrepo.henriqueslab.org
**Repository:** https://github.com/HenriquesLab/TaskRepo
**License:** MIT

**Key Features:**
- Git-backed task storage with markdown files
- TaskWarrior-inspired workflow (priorities, tags, dependencies, due dates)
- Interactive TUI with autocomplete and color-coded statuses
- Multiple repository support
- GitHub integration for task creation from issues
- Rich YAML frontmatter metadata
- Beautiful terminal output with modern UI

**Dependencies:** Python 3.13, git, gh (all installed automatically)

## Updating Formulas

To update to the latest version of a formula:

```bash
brew update
brew upgrade rxiv-maker
brew upgrade folder2md4llms
brew upgrade taskrepo
```

## Uninstalling

```bash
# Uninstall a specific formula
brew uninstall rxiv-maker
brew uninstall folder2md4llms
brew uninstall taskrepo

# Untap this repository
brew untap henriqueslab/formulas
```

## Development

### Testing formulas locally

```bash
# Clone this repository
git clone https://github.com/HenriquesLab/homebrew-formulas.git
cd homebrew-formulas

# Install formula from local file
brew install ./Formula/rxiv-maker.rb
brew install ./Formula/folder2md4llms.rb
brew install ./Formula/taskrepo.rb
```

### Running tests

The repository includes automated tests via GitHub Actions that run on macOS 13 and 14.

To test manually:
```bash
# Test installation
brew install formula-name

# Verify executables
rxiv --version
folder2md --version
taskrepo --version
tsk --version
```

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

See individual formula files for license information.

## Links

- **HenriquesLab:** https://github.com/HenriquesLab
- **rxiv-maker:** https://github.com/HenriquesLab/rxiv-maker
- **folder2md4llms:** https://github.com/henriqueslab/folder2md4llms
- **TaskRepo:** https://github.com/HenriquesLab/TaskRepo
