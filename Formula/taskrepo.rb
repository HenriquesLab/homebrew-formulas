# Formula/taskrepo.rb
class Taskrepo < Formula
  desc "TaskWarrior-inspired task management with markdown files in git repositories"
  homepage "https://github.com/HenriquesLab/TaskRepo"
  url "https://files.pythonhosted.org/packages/78/8f/25236c919fc5d7effb7ce64ad880477942ed8e32a1e87e9fa0ee096c6e98/taskrepo-0.9.8.tar.gz"
  sha256 "6f7e06862f7da864b0504ae88a1ae5282d5cda9492dd61e49e5d3535e4208055"
  license "MIT"

  depends_on "python@3.12"
  depends_on "git"
  depends_on "gh"

  def install
    # Create a virtual environment inside libexec
    venv = libexec/"venv"
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", venv

    # Install the package with all dependencies
    # Binary wheels are allowed for faster installation
    system venv/"bin/pip", "install", "-v", "--ignore-installed",
           build.head? ? "git+." : "."

    # Create wrapper scripts for both executables
    # TaskRepo provides two commands: taskrepo and tsk (short alias)
    bin.install_symlink venv/"bin/taskrepo"
    bin.install_symlink venv/"bin/tsk"
  end

  test do
    assert_match "taskrepo", shell_output("#{bin}/taskrepo --version")
    assert_match "taskrepo", shell_output("#{bin}/tsk --version")
  end
end
