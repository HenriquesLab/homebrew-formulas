class RxivMaker < Formula
  desc "Convert Markdown to professional PDFs with automated figure generation"
  homepage "https://github.com/HenriquesLab/rxiv-maker"
  url "https://files.pythonhosted.org/packages/d5/01/7d68cb619ce18c6fe1ec0a0e8b3bdd8e7a4f6e359ef02f0cbaf9966667df/rxiv_maker-1.11.2.tar.gz"
  sha256 "3bbbbf62a6072ee4c0ff4d1316e94f98b3d3e81389f7a8aeaa9c929f086277ac"
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
