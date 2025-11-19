class RxivMaker < Formula
  desc "Convert Markdown to professional PDFs with automated figure generation"
  homepage "https://github.com/HenriquesLab/rxiv-maker"
  url "https://files.pythonhosted.org/packages/9a/dc/85c4fb1e3d472b347497e6dbf71685ba3b33f7485d27d3b53c065a82f140/rxiv_maker-1.11.3.tar.gz"
  sha256 "c21b207f817c8cb25c545f910b8702cc5c1bd3b36d1ed6bf10d26f2903494fdd"
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
