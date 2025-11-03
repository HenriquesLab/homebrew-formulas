class RxivMaker < Formula
  desc "Convert Markdown to professional PDFs with automated figure generation"
  homepage "https://github.com/HenriquesLab/rxiv-maker"
  url "https://files.pythonhosted.org/packages/a3/20/9d92f40049f7c59d87745bd829d5c9a45462d09f1d817e7a53d18e369009/rxiv_maker-1.8.8.tar.gz"
  sha256 "4a1619b1f1d9613ce937bc6ab7bb0db32f71e24376ac108d4f8b7d10107d7965"
  license "MIT"

  depends_on "python@3.12"
  depends_on "texlive"

  def install
    venv = libexec/"venv"
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", venv
    system venv/"bin/pip", "install", "-v", "--ignore-installed",
           build.head? ? "git+." : "."
    bin.install_symlink venv/"bin/rxiv"
  end

  test do
    assert_match "1.8.6", shell_output("#{bin}/rxiv --version")
  end
end
