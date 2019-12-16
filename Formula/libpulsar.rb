class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.4.1/apache-pulsar-2.4.1-src.tar.gz"
  sha256 "6fb764b0d15506884905b781cfd2f678ad6a819f2c8d60cc34f78966b4676d40"
  revision 2

  bottle do
    cellar :any
    sha256 "758c5a7f3e535f2d1b090e0ebc7ea2cfe897610eb0e5f8c65f6c2347edea681e" => :catalina
    sha256 "829dc72cdc0ef1061f3ce318daade47dd081b207343a6624701bf2a018c37648" => :mojave
    sha256 "fe4d957fb5fdce6880fddc04d5da05ef044865e038845934f2a03c0493e56dbe" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "zstd"

  def install
    cd "pulsar-client-cpp" do
      # Stop opportunistic linking to snappy
      # (Snappy was broken in 2.4.0 - could be added now)
      inreplace "CMakeLists.txt",
                "HAS_SNAPPY 1",
                "HAS_SNAPPY 0"

      system "cmake", ".", *std_cmake_args,
                      "-DBUILD_TESTS=OFF",
                      "-DBUILD_PYTHON_WRAPPER=OFF",
                      "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
                      "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf"].include}",
                      "-DProtobuf_LIBRARIES=#{Formula["protobuf"].lib}/libprotobuf.dylib"
      system "make", "pulsarShared", "pulsarStatic"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
