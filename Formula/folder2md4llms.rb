# Formula/folder2md4llms.rb
class Folder2md4llms < Formula
  desc "Convert folder structures and file contents into markdown for LLMs"
  homepage "https://github.com/henriqueslab/folder2md4llms"
  url "https://files.pythonhosted.org/packages/3d/1e/fba9354403e671476911ad408cc8d2a79921321c989021153c4e6d4859cb/folder2md4llms-0.5.14.tar.gz"
  sha256 "dc2080315a6cc1445c4c4b398b8054367449dbf9b1501513212e71561250784f"
  license "MIT"

  depends_on "python@3.12"
  depends_on "libmagic"

  def install
    # Create a virtual environment inside libexec
    venv = libexec/"venv"
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", venv

    # Install the package with all dependencies
    # Binary wheels are allowed for faster installation
    system venv/"bin/pip", "install", "-v", "--ignore-installed",
           build.head? ? "git+." : "."

    # Create wrapper script only for the folder2md executable
    # Homebrew will link this wrapper to your PATH
    bin.install_symlink venv/"bin/folder2md"
  end

  test do
    assert_match "folder2md", shell_output("#{bin}/folder2md --version")
  end
end
