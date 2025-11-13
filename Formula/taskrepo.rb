# Formula/taskrepo.rb
class Taskrepo < Formula
  desc "TaskWarrior-inspired task management with markdown files in git repositories"
  homepage "https://github.com/HenriquesLab/TaskRepo"
  url "https://files.pythonhosted.org/packages/83/a5/591672a73e7de28391ecb4bc4a243d85731156f32e7a270b5e8ad007a33b/taskrepo-0.10.7.tar.gz"
  sha256 "259d52d244874252200beb6806429bc5599a35ca636d78ea53a5dc17c7933254"
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
