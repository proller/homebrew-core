require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.4.5.tgz"
  sha256 "23950a9e697f5efee8dae8e6d7855f0dd22885c40a5243df1c0fd5b0b522f0e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "10de68ed13d494a2750fdb4d75c3d3d63ec0e0b22d59bb86ed5a52da2f0fd0bc" => :mojave
    sha256 "c5e2502abb92627796ccba65fdb03127cd1936667d063fcde73b2143cc506aa5" => :high_sierra
    sha256 "bfb3aa84ac016e54ec4da94db862728a2e988781c637d6b98942184f17e31ae7" => :sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.4.4.tgz"
    sha256 "aa6b4c8d5564e44f68e0ac1198e8a13ae641fcd9af3119e38538e34a691f1dbb"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundledDependencies"] = ["@babel/core"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
