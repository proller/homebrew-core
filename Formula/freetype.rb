class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.10.0/freetype-2.10.0.tar.bz2"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.10.0.tar.bz2"
  sha256 "fccc62928c65192fff6c98847233b28eb7ce05f12d2fea3f6cc90e8b4e5fbe06"

  bottle do
    cellar :any
    sha256 "d231ab6634051c4b655bbfc07cd5b306ad5489d891ee2b105ed892347f2714af" => :mojave
    sha256 "d19594d298d7357cbcfa700edcb6224a5edf8200924cadda3d2c91f0751f0113" => :high_sierra
    sha256 "e1edfbb0ec07384c366e7fbbdd297ddf003f84bad1486b1aae8fa16fa3576fbd" => :sierra
  end

  depends_on "libpng"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-freetype-config",
                          "--without-harfbuzz"
    system "make"
    system "make", "install"

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end
