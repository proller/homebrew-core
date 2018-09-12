class ClickhouseOdbc < Formula
  desc "ClickHouse ODBC driver"
  homepage "https://clickhouse.yandex"
  url "https://github.com/yandex/clickhouse-odbc.git",
    :tag => "v1.0.0.20180903",
    :revision => "17ecca3993e164d2d49360ed9be68becc11b7b05"
  # head "https://github.com/yandex/clickhouse-odbc.git"

  depends_on "cmake" => :build
  depends_on "libiodbc" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  depends_on "openssl" => :build

  needs :cxx14

  def install
    args = std_cmake_args
    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "cmake", "--build", "."
      # system "ninja", "install" # installs too many trash
      lib.install "driver/libclickhouseodbc.dylib"
      lib.install "driver/libclickhouseodbcw.dylib"
    end
    lib.install_symlink "#{lib}/libclickhouseodbc.dylib" => "libclickhouseodbc.so"
    lib.install_symlink "#{lib}/libclickhouseodbcw.dylib" => "libclickhouseodbcw.so"
  end

  test do
    assert_match "/usr/lib/libSystem.B.dylib", shell_output("otool -L #{lib}/libclickhouseodbc.so")
    assert_match "/usr/lib/libSystem.B.dylib", shell_output("otool -L #{lib}/libclickhouseodbcw.so")
    # TODO: fix build with unixodbc and enable:
    # output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libclickhouseodbc.so")
    # assert_equal "SUCCESS: Loaded #{lib}/libclickhouseodbc.so\n", output
    # output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libclickhouseodbcw.so")
    # assert_equal "SUCCESS: Loaded #{lib}/libclickhouseodbcw.so\n", output
  end
end
