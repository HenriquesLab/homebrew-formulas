# Formula/taskrepo.rb
class Taskrepo < Formula
  desc "TaskWarrior-inspired task management with markdown files in git repositories"
  homepage "https://github.com/HenriquesLab/TaskRepo"
  url "https://files.pythonhosted.org/packages/ef/1f/ccbbc5d5f51d0536107cc505ef9eb1a006cb73963c461fd594fd9355aad3/taskrepo-0.9.11.tar.gz"
  sha256 "63f8ae3c7d54ce1c481088b5c381402f25b4f7b8aaf3b5ea49608f16f37e70db"
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
    # Skip interactive test - taskrepo requires filesystem access for config
    # Just verify the binaries exist
    assert_predicate bin/"taskrepo", :exist?
    assert_predicate bin/"tsk", :exist?
  end
end
