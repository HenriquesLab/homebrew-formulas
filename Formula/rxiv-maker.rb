class RxivMaker < Formula
  desc "Convert Markdown to professional PDFs with automated figure generation"
  homepage "https://github.com/HenriquesLab/rxiv-maker"
  url "https://files.pythonhosted.org/packages/1e/7b/36a4ae645763c6586036e03088da1ef3b913d6dce0d88574dbd79a5da123/rxiv_maker-1.8.6.tar.gz"
  sha256 "bcc803adf82d11b5d0ff8c48cf800a784c4a8df973845f93ef5f45a39e4f703e"
  license "MIT"

  depends_on "python@3.12"

  def install
    venv = libexec/"venv"
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", venv
    system venv/"bin/pip", "install", "-v", "--ignore-installed",
           build.head? ? "git+." : "."
    bin.install_symlink venv/"bin/rxiv"
  end

  def caveats
    <<~EOS
      rxiv-maker requires a LaTeX distribution to generate PDFs.
      Install one of the following:
        brew install --cask mactex-no-gui
        brew install basictex
    EOS
  end

  test do
    assert_match "1.8.6", shell_output("#{bin}/rxiv --version")
  end
end
