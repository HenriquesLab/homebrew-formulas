# Formula/taskrepo.rb
class Taskrepo < Formula
  desc "TaskWarrior-inspired task management with markdown files in git repositories"
  homepage "https://github.com/HenriquesLab/TaskRepo"
  url "https://files.pythonhosted.org/packages/84/ab/cc4198ed92ffe566ef0cf8faa4d7ab09f1f8385e50a53dae491224db31cd/taskrepo-0.9.9.tar.gz"
  sha256 "99a6ef7fe7eb630fbe30b22a1a546011792afa630f0c1711f8d20be8525f8a7f"
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
