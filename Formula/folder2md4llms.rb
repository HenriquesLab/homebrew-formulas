# Formula/folder2md4llms.rb
class Folder2md4llms < Formula
  desc "Convert folder structures and file contents into markdown for LLMs"
  homepage "https://github.com/henriqueslab/folder2md4llms"
  url "https://files.pythonhosted.org/packages/eb/a1/45c7464701672a9b836433f73a46f99a84b397691c9abdb51e038ce3c972/folder2md4llms-0.5.18.tar.gz"
  sha256 "c5e99219b4bf56b957389208b7ef3def0fcff8eb3e60eaffaa17f4ee044ecc01"
  license "MIT"

  depends_on "libmagic"
  depends_on "python@3.13"
  depends_on "rust" => :build

  def install
    # Create a virtual environment inside libexec
    venv = libexec/"venv"
    system Formula["python@3.13"].opt_bin/"python3.13", "-m", "venv", venv

    # Set linker flags for proper header padding in compiled extensions
    ENV.prepend "LDFLAGS", "-Wl,-headerpad_max_install_names"
    ENV.prepend "RUSTFLAGS", "-C link-arg=-Wl,-headerpad_max_install_names"

    # Install the package, building rpds-py from source with proper header padding
    system venv/"bin/pip", "install", "-v", "--ignore-installed",
           "--no-binary", "rpds-py",
           build.head? ? "git+." : "."

    # Create wrapper script only for the folder2md executable
    # Homebrew will link this wrapper to your PATH
    bin.install_symlink venv/"bin/folder2md"
  end

  def caveats
    <<~EOS
      folder2md4llms has been installed!

      Quick Start:
        folder2md .                     # Process current directory
        folder2md /path --limit 80000t  # Process with token limit
        folder2md --init-ignore         # Generate ignore file

      Documentation: https://folder2md4llms.henriqueslab.org

      Note: Package name is 'folder2md4llms', but the command is 'folder2md'.
    EOS
  end

  test do
    # Verify command works and shows version
    assert_match version.to_s, shell_output("#{bin}/folder2md --version")

    # Verify help command works
    assert_match "Convert folder structures", shell_output("#{bin}/folder2md --help")
  end
end
