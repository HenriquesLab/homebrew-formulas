# Formula/folder2md4llms.rb
class Folder2md4llms < Formula
  desc "Convert folder structures and file contents into markdown for LLMs"
  homepage "https://github.com/henriqueslab/folder2md4llms"
  url "https://files.pythonhosted.org/packages/54/dc/57fab6e71ca5ba3faa0a5afac9cd97f7a56fbd0e3381353392936fe24927/folder2md4llms-0.5.13.tar.gz"
  sha256 "096e8ac10886371720cbd592a0a40f19636ff895a8c691239f903d295629a72b"
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
