class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.30.1.tar.gz"
  sha256 "2ac83f3dabb3d0a024fbd5b80caea2d5e6075d7f8628375db383fe7e6186ca9e"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cb27bf76973bcb68e84c941b76b92e27d5e1521990b5cf6ce8f62179029cdcd" => :catalina
    sha256 "80f9703982e2d5e8f46b98b9e9d39635a19a2ae9fb21f00a42e4d1eb797b6414" => :mojave
    sha256 "ea97014294507ee73972f3eb8b27b7151adc98a3d453456dbf4029234e9543a2" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
