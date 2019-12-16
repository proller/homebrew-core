require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.13.1.tar.gz"
  sha256 "a0f33d7605fad80998c9b8dae6678eb8932316235a4ac6e5993f3f2858987719"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d9c1909264dec6736495ad818fbc600ac9c0e83175a798359b4254bd51b6c82" => :catalina
    sha256 "6701e2a413da75db04c8dc91dafee8113b3f27a0b32eb5b61fe811423cdb9302" => :mojave
    sha256 "1172f141580077b575dca45c050b3a86a5f5ebdd3aa15615b4dee7d6b07cbfad" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  def install
    cabal_sandbox do
      cabal_install "hpack"
      system "./.cabal-sandbox/bin/hpack"

      install_cabal_package :using => ["alex", "happy"]
    end

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      let main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
