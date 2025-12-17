# Formula/folder2md4llms.rb
class Folder2md4llms < Formula
  desc "Convert folder structures and file contents into markdown for LLMs"
  homepage "https://github.com/henriqueslab/folder2md4llms"
  url "https://files.pythonhosted.org/packages/08/81/7de758d2c891010b767e81d0b5f8b219fee3f6b48da7899cd6bb0e06d34d/folder2md4llms-0.5.16.tar.gz"
  sha256 "cf644faa40b4b1b6c22ee708412698133e5c6d62d4fedd5c2b097a81d89a6168"
  license "MIT"

  depends_on "python@3.13"
  depends_on "libmagic"
  depends_on "rust" => :build

  def install
    # Create a virtual environment inside libexec
    venv = libexec/"venv"
    system Formula["python@3.13"].opt_bin/"python3.13", "-m", "venv", venv

    # Set linker flags for proper header padding in compiled extensions
    ENV.prepend "LDFLAGS", "-Wl,-headerpad_max_install_names"

    # Install the package, building rpds-py from source with proper header padding
    system venv/"bin/pip", "install", "-v", "--ignore-installed",
           "--no-binary", "rpds-py",
           build.head? ? "git+." : "."

    # Create wrapper script only for the folder2md executable
    # Homebrew will link this wrapper to your PATH
    bin.install_symlink venv/"bin/folder2md"
  end

  test do
    assert_match "folder2md", shell_output("#{bin}/folder2md --version")
  end
end
