class ClickhouseOdbc < Formula
  desc "ClickHouse ODBC driver"
  homepage "https://clickhouse.yandex"
  url "https://github.com/yandex/clickhouse-odbc/archive/2018-08-22.tar.gz"
  sha256 "4db75964af3e57f4b92686037acc75d62d3dafbc18e19ee56004421e2355a0b8"

  bottle do
    cellar :any
    sha256 "256" => :high_sierra
    sha256 "256" => :sierra
    sha256 "256" => :el_capitan
  end

  head do
    # url "https://github.com/yandex/clickhouse-odbc.git"
    url "https://github.com/proller/clickhouse-odbc.git"
    #depends_on "openssl" => :build
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "openssl"
  #depends_on "unixodbc" => :recommended
  #depends_on "libiodbc" => :optional
  depends_on "libiodbc" => :recommended
  #depends_on "unixodbc" => :optional

  def install
    system "cmake", "-G", "Ninja", ".", *std_cmake_args
    system "ninja", "install"

    #lib.install_symlink "#{lib}/libsqlite3odbc.dylib" => "libsqlite3odbc.so"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libclickhouseodbc.so")
    assert_equal "SUCCESS: Loaded #{lib}/libclickhouseodbc.so\n", output
  end
end
