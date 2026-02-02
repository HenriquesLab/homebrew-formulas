class RxivMaker < Formula
  desc "Convert Markdown to professional PDFs with automated figure generation"
  homepage "https://github.com/HenriquesLab/rxiv-maker"
  url "https://files.pythonhosted.org/packages/08/f6/ab7e0bc94c14999219f0151470f76b18a17f8d1f5f178d9ea3cbf9774fa9/rxiv_maker-1.18.4.tar.gz"
  sha256 "156bd9f3410126b1811282c5419c39cd475d137612addf683db4e5a0d6d0adbe"
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
