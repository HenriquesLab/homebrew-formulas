class RxivMaker < Formula
  desc "Convert Markdown to professional PDFs with automated figure generation"
  homepage "https://github.com/HenriquesLab/rxiv-maker"
  url "https://files.pythonhosted.org/packages/cd/df/654062b8bf007e230df11a7968d3d85d32d4c485129588165a6dbe987685/rxiv_maker-1.8.9.tar.gz"
  sha256 "2e4b99741eccf2a41f34436ca8e5371f3ce9d24eda0552cf3d71437df4bb124d"
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
