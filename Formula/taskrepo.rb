# Formula/taskrepo.rb
class Taskrepo < Formula
  desc "TaskWarrior-inspired task management with markdown files in git repositories"
  homepage "https://github.com/HenriquesLab/TaskRepo"
  url "https://files.pythonhosted.org/packages/0c/62/b815c353ccd9d8cf85a781068c572753c556f6bbbf0f2f790d44e8501399/taskrepo-0.9.10.tar.gz"
  sha256 "b2d561e695ee529e5e132c8fb64678225bfad1674f6c2342d539cb106c93f49d"
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
