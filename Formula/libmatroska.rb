class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.5.0.tar.xz"
  sha256 "f0efdc1827fa8012a16d764a45ed84d544d92a2027113245f522f5e1f713ad1e"
  head "https://github.com/Matroska-Org/libmatroska.git"

  bottle do
    cellar :any
    sha256 "7e38cece965c28a4819f9c1d6e8419c33e136d6ade3edfe718d0fc194e5f9fd8" => :mojave
    sha256 "1c5e2678cc2e54d9a6ad8accff4a3a922ccd35dac70a209fa15c95cd17f42bbc" => :high_sierra
    sha256 "25be768c15454e7295a6c592d4d4ccaecda025eb385758c45c2eb2c7cedb0e5b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libebml"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=YES", *std_cmake_args
      system "make", "install"
    end
  end
end
