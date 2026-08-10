class RxivMaker < Formula
  desc "Convert Markdown to professional PDFs with automated figure generation"
  homepage "https://github.com/HenriquesLab/rxiv-maker"
  url "https://files.pythonhosted.org/packages/63/e2/d92959b8c6ae7f5e37ab6566e31b31c2341133ae6992016270c04f55f93c/rxiv_maker-1.23.3.tar.gz"
  sha256 "9a4552cc0594885db191f16bb5a422bc677fca09a562a3541df2691e5fb59023"
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
