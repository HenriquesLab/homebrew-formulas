# Formula/taskrepo.rb
class Taskrepo < Formula
  desc "TaskWarrior-inspired task management with markdown files in git repositories"
  homepage "https://github.com/HenriquesLab/TaskRepo"
  url "https://files.pythonhosted.org/packages/13/8c/bc334e5818ed69a48314bbbe7ce5492752bf950112588da8d583594b463b/taskrepo-0.10.9.tar.gz"
  sha256 "e8871be1af9ba8941f869df1137da2e25d1956c468b3c6900f558403e80fe86c"
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
