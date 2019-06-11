class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "http://ftp.denx.de/pub/u-boot/u-boot-2019.04.tar.bz2"
  sha256 "76b7772d156b3ddd7644c8a1736081e55b78828537ff714065d21dbade229bef"

  bottle do
    cellar :any
    sha256 "cc4cc70e9b8e790765b8ca3609338ccfbf704556c6d6c560def6eb80cbe1f838" => :mojave
    sha256 "bc7f17ed82642bcc1419d1414897731c966c772f36ad6e5c077bd96498167f16" => :high_sierra
    sha256 "2f615f90f45ccc6c408bc12566a65ce12a13a60731d7909ec84d5e2ae23e0b99" => :sierra
  end

  depends_on "openssl"

  def install
    system "make", "sandbox_defconfig"
    system "make", "tools"
    bin.install "tools/mkimage"
    bin.install "tools/dumpimage"
    man1.install "doc/mkimage.1"
  end

  test do
    system bin/"mkimage", "-V"
    system bin/"dumpimage", "-V"
  end
end
