class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.4.4.tar.gz"
  sha256 "b910a33ddaa474c369991ba345187a8a2f4aa420389083671ba3a6c305a491d6"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "a4ff4b3815cfbeb102e2d072722a5283095b1b5387e76524bfcaf5e8827ad753" => :mojave
    sha256 "80feb44a31199cc5fc0508f27d629a91fc6d07fecb01405c2ba7cfea1f5cb094" => :high_sierra
    sha256 "c911748d585c7acb50e28d3e7ccb7f300f7bfb9e6c70471f7579d4fa40828458" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libwebsockets"
  depends_on "openssl"

  def install
    cmake_args = std_cmake_args + ["-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
