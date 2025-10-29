# Formula/folder2md4llms.rb
class Folder2md4llms < Formula
  desc "Convert folder structures and file contents into markdown for LLMs"
  homepage "https://github.com/henriqueslab/folder2md4llms"
  url "https://files.pythonhosted.org/packages/41/2f/3e9cf25f8ff4913ef4310c08ff1d471c9e09c55b4fd138d8daf6e92d1329/folder2md4llms-0.5.10.tar.gz"
  sha256 "624a3bd62a4678f94dbec6a2d599c49f298ac76513c0b1e19a817eac5d083e79"
  license "MIT"

  depends_on "python@3.12"
  depends_on "libmagic"

  # Skip cleaning the virtualenv to avoid relocation issues with compiled extensions
  skip_clean "libexec"

  def install
    # Create a virtual environment inside libexec
    venv = libexec/"venv"
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", venv

    # Activate the venv and install the package with all dependencies
    # We use the pip from inside our new venv
    # Allow binary wheels for faster installation
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
