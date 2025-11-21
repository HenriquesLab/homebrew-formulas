class RxivMaker < Formula
  desc "Convert Markdown to professional PDFs with automated figure generation"
  homepage "https://github.com/HenriquesLab/rxiv-maker"
  url "https://files.pythonhosted.org/packages/84/e5/df4ee903dfbdc2624b146f2a8add3086edf65447083910ae6c595859dad0/rxiv_maker-1.12.2.tar.gz"
  sha256 "04965a0789b91199201a7d282f7d2e08f19ff7d719afa4bd74e1f1e3dc676b46"
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
