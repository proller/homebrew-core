class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "https://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.9.tar.xz"
  sha256 "59caed8ca72b1ac6437c9844f0677f8a296d52cfd1c0049116026abfb1d87d9b"

  bottle do
    sha256 "0eef60c3caf722f54a6930f425b4579439145fa418640ac03fe949ebd0d14ce9" => :mojave
    sha256 "bd5ae9ab6d59032a00f92d0abfde3fc36920da2dd04312eb35c07e53102d276c" => :high_sierra
    sha256 "b6a6663b434c84ed92deae11a8784082954ec1096741940108df43bed2775ad0" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgcrypt"
  depends_on "libgee"
  depends_on "openssl"
  depends_on "readline"

  def install
    # this build uses the sqlite source code that comes with libgda,
    # as opposed to using the system or brewed sqlite3, which is not supported on macOS,
    # as mentioned in https://github.com/GNOME/libgda/blob/95eeca4b0470f347c645a27f714c62aa6e59f820/libgda/sqlite/README#L31

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-binreloc",
                          "--disable-gtk-doc",
                          "--without-java",
                          "--enable-introspection",
                          "--enable-system-sqlite=no"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gda-sql", "-v"
  end
end
