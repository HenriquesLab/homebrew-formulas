class RxivMaker < Formula
  desc "Convert Markdown to professional PDFs with automated figure generation"
  homepage "https://github.com/HenriquesLab/rxiv-maker"
  url "https://files.pythonhosted.org/packages/d6/76/b0eb34267d012f4efe9816d5570861eb0331637d7018e1747500cfcd747e/rxiv_maker-1.11.1.tar.gz"
  sha256 "42adb59bfabccd54d349d7db0ef9e62282f6d2ba2d8e365a70ea5002c4070f50"
  license "MIT"

  depends_on "python@3.12"
  depends_on "texlive"
  depends_on "git"
  depends_on "gh"

  def install
    venv = libexec/"venv"
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", venv
    system venv/"bin/pip", "install", "-v", "--ignore-installed",
           build.head? ? "git+." : "."
    bin.install_symlink venv/"bin/rxiv"
  end

  test do
    assert_match "rxiv", shell_output("#{bin}/rxiv --version")
  end
end
