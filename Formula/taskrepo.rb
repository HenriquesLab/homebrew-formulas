# Formula/taskrepo.rb
class Taskrepo < Formula
  desc "TaskWarrior-inspired task management with markdown files in git repositories"
  homepage "https://github.com/HenriquesLab/TaskRepo"
  url "https://files.pythonhosted.org/packages/28/70/d2a0357058fa854100e33aea32803da1a7fc0dc2be2756c24a77cdf18cf7/taskrepo-0.9.4.tar.gz"
  sha256 "a92691078094edc7583cd21177898950714a66c5f7f3a9d70222ed49cff82973"
  license "MIT"

  depends_on "python@3.12"
  depends_on "git"
  depends_on "gh"

  # Skip cleaning the virtualenv to avoid relocation issues with compiled extensions
  skip_clean "libexec"

  def install
    # Create a virtual environment inside libexec
    venv = libexec/"venv"
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", venv

    # Install without binary wheels to avoid dylib relocation issues
    # Build from source for better compatibility with Homebrew's relocation
    system venv/"bin/pip", "install", "-v", "--ignore-installed", "--no-binary", ":all:",
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
