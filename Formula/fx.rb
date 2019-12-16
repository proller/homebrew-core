require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-16.0.0.tgz"
  sha256 "a33b2b9253ed8326b176f279082b0893f5c4f352d522f6f1a26e77d3d5968565"

  bottle do
    cellar :any_skip_relocation
    sha256 "36ddc0e350ff7ae1062cd0df400a79130f09266789022e6429507aa23673ed4e" => :catalina
    sha256 "2c1ae109290298de69e5d4da69cc2c5a4c7bf2562b025418fdafef5d057864f6" => :mojave
    sha256 "22d1392c616faceb5f9016d3e0bafecaf0fb8d26efa2cc01d38ebb87f41de9de" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "bar", shell_output("echo '{\"foo\": \"bar\"}' #{bin}/fx .foo")
  end
end
