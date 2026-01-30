# HenriquesLab Homebrew Formulas

A Homebrew tap for custom formulas maintained by [HenriquesLab](https://github.com/HenriquesLab).

## Installation

### Quick Installation (Recommended)

Install formulas directly with a single command:

```bash
# Install TaskRepo
brew install henriqueslab/formulas/taskrepo

# Install folder2md4llms
brew install henriqueslab/formulas/folder2md4llms
```

### Alternative: Manual Tap

```bash
# Tap this repository first
brew tap henriqueslab/formulas

# Then install formulas
brew install taskrepo
brew install folder2md4llms
```

## Available Formulas

### 📄 folder2md4llms

Convert folder structures and file contents into markdown for Large Language Models.

**Version:** 0.5.10
**Homepage:** https://github.com/henriqueslab/folder2md4llms
**License:** MIT

**Features:**
- Smart content condensing for LLMs
- Document conversion (PDF, DOCX, XLSX, PPTX, etc.)
- Binary file analysis
- Parallel processing
- Advanced filtering with .gitignore-style patterns
- Interactive file analysis and ignore suggestions

**Usage:**
```bash
# Process current directory
folder2md

# Process specific directory with token limit
folder2md /path/to/repo --limit 80000t

# Copy output to clipboard
folder2md /path/to/repo --clipboard

# Generate ignore file
folder2md --init-ignore
```

**Dependencies:** Python 3.12, libmagic

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
brew upgrade folder2md4llms
brew upgrade taskrepo
```

## Uninstalling

```bash
# Uninstall a specific formula
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
- **folder2md4llms:** https://github.com/henriqueslab/folder2md4llms
- **TaskRepo:** https://github.com/HenriquesLab/TaskRepo
