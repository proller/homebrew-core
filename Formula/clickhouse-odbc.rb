class ClickhouseOdbc < Formula
  desc "ClickHouse ODBC driver"
  homepage "https://clickhouse.yandex"
  url "https://github.com/yandex/clickhouse-odbc.git",
    :tag => "2018-09-03",
    :revision => "17ecca3993e164d2d49360ed9be68becc11b7b05"
  head "https://github.com/yandex/clickhouse-odbc.git"

  bottle do
  #    cellar :any_skip_relocation
  #    cellar :any
  #    sha256 "256" => :high_sierra
  #    sha256 "256" => :sierra
  #    sha256 "256" => :el_capitan
  end

  option "with-debug", "Install debugging version with advanced logs"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "libiodbc" => :build
  depends_on "openssl" => :build

  needs :cxx14

  def install
    args = std_cmake_args
    args << "-DCMAKE_BUILD_TYPE=Debug" if build.with? "debug"
    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      # system "ninja", "install" # installs too many trash
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
