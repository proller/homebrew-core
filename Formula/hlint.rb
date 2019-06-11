require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.23/hlint-2.1.23.tar.gz"
  sha256 "12400517c248edfc6ae0088599c80f2e37b45c8796d638a4e75c7c6a9b125bc3"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "45d38a1ba2103d3c0e9bb50217d4442908d412c550263692005c87a7b831e4e5" => :mojave
    sha256 "a3926614ea5424be24ab00347b45537eaa6bee67b113ab4f7811150ec4e3f680" => :high_sierra
    sha256 "0cd12a9448156f7a803dde38170e254a54f6f8534565fc447b96d4118a825f8f" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => ["alex", "happy"]
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~EOS
      main = do putStrLn "Hello World"
    EOS
    assert_match "Redundant do", shell_output("#{bin}/hlint test.hs", 1)
  end
end
