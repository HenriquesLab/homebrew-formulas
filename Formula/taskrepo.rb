# Formula/taskrepo.rb
class Taskrepo < Formula
  desc "TaskWarrior-inspired task management with markdown files in git repositories"
  homepage "https://github.com/HenriquesLab/TaskRepo"
  url "https://files.pythonhosted.org/packages/08/7c/caf00615965f113d45627bc8e02ae587d61b0c1c0edfa80a010462322da7/taskrepo-0.11.0.tar.gz"
  sha256 "411ca66a32bbd7e1da46822f748d3777ca2076738ae32061f593bde281394958"
  license "MIT"

  depends_on "gh"
  depends_on "git"
  depends_on "python@3.13"

  def install
    # Create a virtual environment inside libexec
    venv = libexec/"venv"
    system Formula["python@3.13"].opt_bin/"python3.13", "-m", "venv", venv

    # Install the package with all dependencies
    # Binary wheels are allowed for faster installation
    system venv/"bin/pip", "install", "-v", "--ignore-installed",
           build.head? ? "git+." : "."

    # Create wrapper scripts for both executables
    # TaskRepo provides two commands: taskrepo and tsk (short alias)
    bin.install_symlink venv/"bin/taskrepo"
    bin.install_symlink venv/"bin/tsk"
  end

  def caveats
    <<~EOS
      TaskRepo has been installed!

      Quick Start:
        tsk init                  # Initialize configuration
        tsk create-repo work      # Create your first repository
        tsk add                   # Add a task (interactive)

      Documentation: https://taskrepo.henriqueslab.org

      Note: Both 'tsk' and 'taskrepo' commands are available.
    EOS
  end

  test do
    # Verify both commands work and show correct version
    assert_match version.to_s, shell_output("#{bin}/taskrepo --version")
    assert_match version.to_s, shell_output("#{bin}/tsk --version")

    # Verify help command works
    assert_match "TaskWarrior-inspired", shell_output("#{bin}/tsk --help")
  end
end
