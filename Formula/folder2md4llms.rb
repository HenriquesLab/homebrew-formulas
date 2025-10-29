# Formula/folder2md4llms.rb
class Folder2md4llms < Formula
  desc "Convert folder structures and file contents into markdown for LLMs"
  homepage "https://github.com/henriqueslab/folder2md4llms"
  url "https://files.pythonhosted.org/packages/ab/d0/bece53d00585f9d6fa125c40c669aeb814003f2a0943f0c722b7b40ab8c2/folder2md4llms-0.5.11.tar.gz"
  sha256 "cf17685c26d66830d9a87b4f08a39e3d4f320456e299a7d99768358c63d432ee"
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
