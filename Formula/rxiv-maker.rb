class RxivMaker < Formula
  desc "Convert Markdown to professional PDFs with automated figure generation"
  homepage "https://github.com/HenriquesLab/rxiv-maker"
  url "https://files.pythonhosted.org/packages/2f/8f/c7bc666c2590b7a95cf72f6d0f46a120c655e52df54b63460c7b18b5736b/rxiv_maker-1.9.3.tar.gz"
  sha256 "99ab482766150f47022b6656f75f97ade931c7901d95a63a173d95b5d0c45d9c"
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
