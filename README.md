# HenriquesLab Homebrew Formulas

A Homebrew tap for custom formulas maintained by [HenriquesLab](https://github.com/HenriquesLab).

## Installation

### Tap this repository

```bash
brew tap henriqueslab/formulas
```

### Install formulas

```bash
# Install folder2md4llms
brew install folder2md4llms

# Install taskrepo
brew install taskrepo
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

### 📋 taskrepo

TaskWarrior-inspired task management with markdown files in git repositories.

**Version:** 0.9.4
**Homepage:** https://github.com/HenriquesLab/TaskRepo
**License:** MIT

**Features:**
- Git-backed task storage
- TaskWarrior-inspired workflow (priorities, tags, dependencies, due dates)
- Rich YAML frontmatter metadata
- Interactive TUI with autocomplete
- Multiple repository support
- GitHub integration
- Beautiful terminal output

**Usage:**
```bash
# Initialize TaskRepo
taskrepo init

# Add a new task (short alias: tsk)
tsk add "Complete project documentation" +docs priority:high

# List tasks
tsk list

# Mark task as done
tsk done 1

# View help
tsk --help
```

**Dependencies:** Python 3.12, git, gh

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
