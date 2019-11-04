class ClickhouseOdbc < Formula
  desc "ClickHouse ODBC driver"
  homepage "https://clickhouse.yandex"
  url "https://github.com/yandex/clickhouse-odbc.git",
      :tag      => "v1.1.0.20191028",
      :revision => "db7e851b07e3e6cbe4bd70369860e339b2fb563e"

  depends_on "cmake" => :build
  depends_on "libiodbc" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  depends_on "openssl" => :build

  def install
    args = std_cmake_args
    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "cmake", "--build", "."
      system "ctest", "-V"
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
