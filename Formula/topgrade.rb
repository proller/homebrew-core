class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.10.1.tar.gz"
  sha256 "fce43420c658e43a11b3cd17ee36549467d16504f96f4a84866a6ab6253ee6ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6c532b2ea380dcf3a87f1b943e978c02c598cc705663da22eaf13eaee551fc2" => :mojave
    sha256 "c32ef22295c94cfb0f81ff30e1e35072d22176aeaa1d09467f0c15a341048355" => :high_sierra
    sha256 "a30244cc2a57d005f1d40e9bbaa14198ceddd6ececc2f1e26b4e403c5c9b849d" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
