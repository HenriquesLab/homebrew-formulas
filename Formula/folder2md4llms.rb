# Formula/folder2md4llms.rb
class Folder2md4llms < Formula
  desc "Convert folder structures and file contents into markdown for LLMs"
  homepage "https://github.com/henriqueslab/folder2md4llms"
  url "https://files.pythonhosted.org/packages/74/11/0b14de9cd7a1a22b4765fbeb13cb10d225002696ab135fef4ed1761cf006/folder2md4llms-0.5.15.tar.gz"
  sha256 "5b4ad2f89c821f8d5178645a549517d4a5bcd9510cc17d9e8b937f07a52f6a08"
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
