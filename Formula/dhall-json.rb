require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.2.8/dhall-json-1.2.8.tar.gz"
  sha256 "edfd0f1cac49047f75f3096716ed961998df4bc9ce3661f6e8b0ba9ce0f3b168"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "61a8c523c47ca8d2f95da8bff97f70f2bf627f8febc8f8c7f54521c46facff24" => :mojave
    sha256 "d4713f73f9b860ca4e311c637282430e66f9d72e823f8c9bcfe85b1fa0d734f9" => :high_sierra
    sha256 "2ded62ecaaae75894f0114d7e48d47bc14ba4eeb1a92ed7b9bc6821716475735" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
