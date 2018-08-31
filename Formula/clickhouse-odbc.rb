class ClickhouseOdbc < Formula
  desc "ClickHouse ODBC driver"
  homepage "https://clickhouse.yandex"
  #  have no submodules
  #  url "https://github.com/yandex/clickhouse-odbc/archive/2018-08-22.tar.gz"
  #  sha256 "4db75964af3e57f4b92686037acc75d62d3dafbc18e19ee56004421e2355a0b8"

  # bottle do
  #    cellar :any
  #    sha256 "256" => :high_sierra
  #    sha256 "256" => :sierra
  #    sha256 "256" => :el_capitan
  # end

  head do
    # url "https://github.com/yandex/clickhouse-odbc.git"
    url "https://github.com/proller/clickhouse-odbc.git"
  end

  option "with-debug", "Install debugging version with advanced logs"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "libiodbc" => :build
  depends_on "openssl"

  needs :cxx14

  def install
    args = std_cmake_args
    args << "-DCMAKE_BUILD_TYPE=Debug" if build.with? "debug"
    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      # system "ninja", "install" # installs to many trash
      lib.install "driver/libclickhouseodbc.dylib"
      lib.install "driver/libclickhouseodbcw.dylib"
    end
    lib.install_symlink "#{lib}/libclickhouseodbc.dylib" => "libclickhouseodbc.so"
    lib.install_symlink "#{lib}/libclickhouseodbcw.dylib" => "libclickhouseodbcw.so"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libclickhouseodbc.so")
    assert_equal "SUCCESS: Loaded #{lib}/libclickhouseodbc.so\n", output
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libclickhouseodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/libclickhouseodbcw.so\n", output
  end
end
