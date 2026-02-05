class RxivMaker < Formula
  desc "Convert Markdown to professional PDFs with automated figure generation"
  homepage "https://github.com/HenriquesLab/rxiv-maker"
  url "https://files.pythonhosted.org/packages/66/25/bfd650d85a21b450cf17add4564f35ad3dd7055e31bc925adc997c60a471/rxiv_maker-1.19.0.tar.gz"
  sha256 "49d833b60dc6f64482ba19da90b3f1770c313a90f0d68abda7e0c01c8c856ccf"
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
