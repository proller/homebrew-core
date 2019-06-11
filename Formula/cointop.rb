class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.3.0.tar.gz"
  sha256 "26eb1a8a33d63d88e8db4ed7c1112584c8432b9d53fc594c69cc8d7cd4cc7f79"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fc1ec90c6ff4a225b7edfd23a499b56cc0430801f7ebdb81f245cde2ed591cc" => :mojave
    sha256 "e4133d0cc2d632b2243aed1373eac4adf1fbe1ecb565ff83348e06f6f3b4a4f1" => :high_sierra
    sha256 "784f7d3fb9010aa2a84891a242d99328e2b1d390c65addea245cb48873cb3bed" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/miguelmota/cointop"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"cointop"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"cointop", "-test"
  end
end
