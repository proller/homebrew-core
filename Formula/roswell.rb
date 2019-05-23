class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v19.05.10.99.tar.gz"
  sha256 "bf99b0cbb2eed76f842a63f42a46632afaf2fe5d509e748cdf7a42e69718343d"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "5babd0d5d5e10437c5e79531ba6ad8f3fe7be0b88514dea1b51cc802c2e1e5d2" => :mojave
    sha256 "66b1b19ae94930f2500c13370dc0ca37bc4e40cd7ae9a9fec09b585eb8074eee" => :high_sierra
    sha256 "be29a1ebe5b562918c90bdb22b98bab6b9a75a7d7f4d641ceb2a18710e1f8f41" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_predicate testpath/"config", :exist?
  end
end
