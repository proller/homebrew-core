class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.6.tar.gz"
  sha256 "63369f519f81988c2d167ba2c59ad53644d3fac2b7be1e12d3f1df9b8fd91839"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d7670e205435be7fa9e08a6d28c15b5df1b868de01371fa1898f3f10b0acc3c" => :catalina
    sha256 "0d7670e205435be7fa9e08a6d28c15b5df1b868de01371fa1898f3f10b0acc3c" => :mojave
    sha256 "0d7670e205435be7fa9e08a6d28c15b5df1b868de01371fa1898f3f10b0acc3c" => :high_sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "pyqt"
  depends_on "python"

  def install
    ENV.delete("PYTHONPATH")
    system "make", "PYTHON=python3", "prefix=#{prefix}", "install"
    system "make", "install-doc", "PYTHON=python3", "prefix=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
