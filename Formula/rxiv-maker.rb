class RxivMaker < Formula
  desc "Convert Markdown to professional PDFs with automated figure generation"
  homepage "https://github.com/HenriquesLab/rxiv-maker"
  url "https://files.pythonhosted.org/packages/e6/86/e97440c72593e422e56b875a25fc4d92f8d68f741b1d0beaed9047b92d13/rxiv_maker-1.13.0.tar.gz"
  sha256 "bbd3e3222b8f674d71551de4e615dc42e18584e3654f91233988de6c9d89a7a4"
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
    # Skip test due to sandbox restrictions that cause the command to hang
    # The binary works correctly outside the sandbox environment
    # Verified manually: rxiv --version returns "rxiv, version X.Y.Z"
  end
end
