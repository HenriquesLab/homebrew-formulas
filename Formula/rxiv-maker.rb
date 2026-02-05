class RxivMaker < Formula
  desc "Convert Markdown to professional PDFs with automated figure generation"
  homepage "https://github.com/HenriquesLab/rxiv-maker"
  url "https://files.pythonhosted.org/packages/c8/83/95df1c91a5b7aa3d917df7bb8ecb3147631383d5a62216b7ee9ccb540d4c/rxiv_maker-1.19.1.tar.gz"
  sha256 "6af2015d06f28aca938c8ad87e248f59e568b2da063bcc9a0bc2b09b7351bf61"
  license "MIT"

  depends_on "gh"
  depends_on "git"
  depends_on "latexdiff"
  depends_on "poppler"
  depends_on "python@3.13"
  depends_on "texlive"

  def install
    venv = libexec/"venv"
    system Formula["python@3.13"].opt_bin/"python3.13", "-m", "venv", venv
    system venv/"bin/pip", "install", "-v", "--ignore-installed",
           build.head? ? "git+." : "."
    bin.install_symlink venv/"bin/rxiv"
  end

  def caveats
    <<~EOS
      Rxiv-Maker has been installed!

      Quick Start:
        rxiv init my-paper          # Create new manuscript
        rxiv pdf                    # Generate PDF
        rxiv check-installation     # Verify setup

      Documentation: https://rxiv-maker.henriqueslab.org

      Note: LaTeX distribution (TeX Live) and all dependencies installed automatically.
    EOS
  end

  test do
    # Verify command exists and shows version
    assert_match version.to_s, shell_output("#{bin}/rxiv --version")

    # Verify help command works
    assert_match "LaTeX manuscript", shell_output("#{bin}/rxiv --help")
  end
end
