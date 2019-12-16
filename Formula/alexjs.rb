require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/get-alex/alex/archive/8.0.1.tar.gz"
  sha256 "c095af21d1d24a6609813f8bc78d16d8aa62c1b37621029a3b3cb3d331533414"

  bottle do
    cellar :any_skip_relocation
    sha256 "6abea77ea83c396fc6d7d27438d5983eba84641cae29d183996a7acde4686d70" => :catalina
    sha256 "9609b9f838eced07e64e5bffbc5af7ebdb591446b4bd0474e1887402ff7af817" => :mojave
    sha256 "e9e4839fe27d5adb5db3370089bd0d34a3132ce94718d872c54f6518ecded248" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "garbageman"
    assert_match "garbage collector", shell_output("#{bin}/alex test.txt 2>&1", 1)
  end
end
