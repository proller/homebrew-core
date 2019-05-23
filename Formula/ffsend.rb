class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.46.tar.gz"
  sha256 "f026d57388e1af565430a84fb52e4feeeab9b8a4804d40125915e2d4011d84d5"

  bottle do
    cellar :any
    sha256 "29385daffc58b00d7589d71de173d32931a65cf5967756dd2168bafa873623b3" => :mojave
    sha256 "5061bcd5bdf65402d36ed490eeba87dbfad593555320501ac450f854431b34a1" => :high_sierra
    sha256 "868467a2c04209fdfd723f4be93c1120a478eb4743b2f5e2af17e3111df39485" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/0.10.19/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/ffsend"

    (testpath/"file.txt").write("test")
    url = shell_output("#{bin}/ffsend upload -Iq #{testpath}/file.txt").strip
    output = shell_output("#{bin}/ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end
