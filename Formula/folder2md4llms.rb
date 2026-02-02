# Formula/folder2md4llms.rb
class Folder2md4llms < Formula
  desc "Convert folder structures and file contents into markdown for LLMs"
  homepage "https://github.com/henriqueslab/folder2md4llms"
  url "https://files.pythonhosted.org/packages/0c/37/0789c261f233ceca74a6a20e600c4bd1285fa5db08b4cf2ee9aa9f541bfc/folder2md4llms-0.5.17.tar.gz"
  sha256 "85ee02a446cc3545aa33d49c215a606b5e58024f3ecae9a4b38ae915020519e5"
  license "MIT"

  depends_on "libmagic"
  depends_on "python@3.13"

  uses_from_macos "rust" => :build

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
