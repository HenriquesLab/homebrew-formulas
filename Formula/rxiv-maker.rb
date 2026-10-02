class RxivMaker < Formula
  desc "Convert Markdown to professional PDFs with automated figure generation"
  homepage "https://github.com/HenriquesLab/rxiv-maker"
  url "https://files.pythonhosted.org/packages/b6/10/135123819776839bb90f0b80d881ebacf9492859c43f227a0618aef8fbf2/rxiv_maker-1.25.1.tar.gz"
  sha256 "f9daeade94aeddb423a78283e652a62b46bc1a568f8d90c63963e5ff35a26622"
  license "MIT"

  depends_on "gh"
  depends_on "git"
  depends_on "latexdiff"
  depends_on "poppler"
  depends_on "python@3.13"
  depends_on "texlive"

  def install
    venv = libexec/"venv"
    system formula_opt_bin("python@3.13")/"python3.13", "-m", "venv", venv
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
      Paper: https://doi.org/10.1242/jcs.265183

      Note: LaTeX distribution (TeX Live) and all dependencies installed automatically.
    EOS
  end

  test do
    # Verify command exists and shows version
    assert_match version.to_s, shell_output("#{bin}/rxiv --version")

    # Verify help command works
    assert_match "publication-ready PDFs", shell_output("#{bin}/rxiv --help")
  end
end
