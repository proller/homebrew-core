class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.univ-paris-diderot.fr/~jch/software/babel/"
  url "https://www.irif.fr/~jch/software/files/babeld-1.9.1.tar.gz"
  sha256 "1e1b3c01dd929177bc8d027aff1494da75e1e567e1f60df3bb45a78d5f1ca0b4"
  head "https://github.com/jech/babeld.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a612df0aed4630d0ecc4dccc471d616df1d825f5beb0e6454c02f8b2122d31e8" => :catalina
    sha256 "650df4a806dac00287bd3affb40ceb369266d5632ba56453499f2af5b9f602cf" => :mojave
    sha256 "f58c8fef7012518d8adc3ad381dcb95c42c5e05112fcc07b0c5a9042cd2bfc9b" => :high_sierra
  end

  def install
    system "make", "LDLIBS=''"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    shell_output("#{bin}/babeld -I #{testpath}/test.pid -L #{testpath}/test.log", 1)
    expected = <<~EOS
      Couldn't tweak forwarding knob.: Operation not permitted
      kernel_setup failed.
    EOS
    assert_equal expected, (testpath/"test.log").read
  end
end
