# Formula/folder2md4llms.rb
class Folder2md4llms < Formula
  desc "Convert folder structures and file contents into markdown for LLMs"
  homepage "https://github.com/henriqueslab/folder2md4llms"
  url "https://files.pythonhosted.org/packages/c1/7f/c3c696f28e5a4f32fe9e9939967194e5cd9648482cba9fa001fd9447c631/folder2md4llms-0.5.12.tar.gz"
  sha256 "f968a9fdb65ee578cd0b41be25d5f8f0bcf3a99039a7c6689cd5944904a0411e"
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
