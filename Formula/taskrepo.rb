# Formula/taskrepo.rb
class Taskrepo < Formula
  desc "TaskWarrior-inspired task management with markdown files in git repositories"
  homepage "https://github.com/HenriquesLab/TaskRepo"
  url "https://files.pythonhosted.org/packages/54/7c/481c5c62a03c1888404b8839ef1043f261e6f15c367a682cdce418d9b50b/taskrepo-0.10.10.tar.gz"
  sha256 "36858e1ee8e31082aa5c04891228923ae8b5b39cae632e31b0835842e7168052"
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
