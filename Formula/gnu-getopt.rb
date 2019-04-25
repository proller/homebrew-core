class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.33/util-linux-2.33.2.tar.xz"
  sha256 "631be8eac6cf6230ba478de211941d526808dba3cd436380793334496013ce97"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6405423e6ba2ef844512f647a2a930ab6174b23d6b942a9b05e59ced88ed196" => :mojave
    sha256 "c968853e7b57cd0affcd0e02ae574a340ef9f1c9847feae498964e2e7e2c0ded" => :high_sierra
    sha256 "af870c9c13126e70d368a0506b52509cc9c7bbd82d4ebd3bcdbd068bf45864f6" => :sierra
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
