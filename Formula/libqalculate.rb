class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.6.0/libqalculate-3.6.0.tar.gz"
  sha256 "66b38ed6460f0cd6a1b16ba4145c0396c995939da0ed78f15736f8cd794969b2"

  bottle do
    sha256 "cf553625f296d92c57fa554e650672963bf814669dfecb312051434b76a8d296" => :catalina
    sha256 "6bab97aaa9c7bdac31e6194f48d2c53c9ef1eddca6bccf76c3c6ce50ed79cf60" => :mojave
    sha256 "9ec296234bb5423e62f6c471bf61ed251707f83f2010da920de155794608a59a" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  # Fixed for next version: https://github.com/Qalculate/libqalculate/issues/167
  patch do
    url "https://github.com/Qalculate/libqalculate/commit/6f1aae9c.diff?full_index=1"
    sha256 "3df223259f3925345ed0ebe40a659bbd146f940f54972ff45852d8959a50f62b"
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-icu",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end
