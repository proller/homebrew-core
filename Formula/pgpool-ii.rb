class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.1.0.tar.gz"
  sha256 "a2515d3d046afda0612b34c2aeca14a2071020dafb1f32e745b4a3054c0018df"

  bottle do
    sha256 "e2b482ffadb79e520b408a064ff4bda02603574f5101a8bc1fd191db7cffc987" => :catalina
    sha256 "1bceb594a417b6daa34c916737debbf859ed44f38548877316b3dbb399ee7237" => :mojave
    sha256 "2e1e98b126df52ce2866677f87998aab39f75c09f69328ca944ac009ce6c0f35" => :high_sierra
  end

  depends_on "postgresql"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    cp etc/"pgpool.conf.sample", testpath/"pgpool.conf"
    system bin/"pg_md5", "--md5auth", "pool_passwd", "--config-file", "pgpool.conf"
  end
end
