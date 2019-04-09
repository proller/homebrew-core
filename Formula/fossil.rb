class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.8.tar.gz"
  sha256 "6a32bec73de26ff5cc8bbb0b7b45360f4e4145931fd215ed91414ed190b3715d"
  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "2155fbb40aaacc783a7254c152837115e780ba5675b985a8427198bf0c7f9e90" => :mojave
    sha256 "39c90e8c292e4759cbfe09e1055127201b8ac8acd0177bd5cb08c79c22cf01ed" => :high_sierra
    sha256 "8aa65a2ef9b2d15814fc0a19645f21a5c07f66c62e4f0c9c2444247acc798e22" => :sierra
  end

  depends_on "openssl"

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
      "--disable-fusefs",
    ]

    if MacOS.sdk_path_if_needed
      args << "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      args << "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
