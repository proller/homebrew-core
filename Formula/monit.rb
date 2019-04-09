class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.25.3.tar.gz"
  sha256 "c10258c8839d20864d30390e7cbf2ff5e0480a67a6fb80c02aa457d6e3390569"

  bottle do
    cellar :any
    sha256 "ae1a633b12f5495837d7fdba90d3da86973a54d5a7f5692f2a791c3a2795f7d8" => :mojave
    sha256 "fd5f2b5b1fb89d5351a2c229c619a83d8f64d92fe2056893b412d74447a6d862" => :high_sierra
    sha256 "9692176694634c95740bf49730cb30437014b99abdbf45ebbbd645987bd62803" => :sierra
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
    pkgshare.install "monitrc"
  end

  test do
    system bin/"monit", "-c", pkgshare/"monitrc", "-t"
  end
end
