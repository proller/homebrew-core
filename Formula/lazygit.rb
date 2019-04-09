class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.7.2.tar.gz"
  sha256 "d0be7a4ef6b5946fc10808d17439962d914782e7b47977d79370b595eada2493"

  bottle do
    cellar :any_skip_relocation
    sha256 "88e9e481164fea96aa885292f0dc64b5f6d392b660bdb3a2c8c5807daf5ccadb" => :mojave
    sha256 "b4eb79e9501602e20e2a438650fc622d11814310be03987ca7f48fed1585f2e7" => :high_sierra
    sha256 "48966c29484af44cbe369798b6bcff81fa8e2902c848153d9f962664150a10c4" => :sierra
  end

  depends_on "go" => :build

  # adapted from https://kevin.burke.dev/kevin/install-homebrew-go/
  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/jesseduffield/lazygit"
    # Copy all files from their current location (GOPATH root)
    # to $GOPATH/src/github.com/jesseduffield/lazygit
    bin_path.install Dir["*"]
    cd bin_path do
      # Install the compiled binary into Homebrew's `bin` - a pre-existing
      # global variable
      system "go", "build", "-ldflags", "-X main.version=0.7.2 -X main.buildSource=homebrew", "-o", bin/"lazygit", "."
    end
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' for example to write to git's todo file
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_CLIENT_COMMAND"] = "INTERACTIVE_REBASE"
    ENV["LAZYGIT_REBASE_TODO"] = "foo"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "foo", (testpath/"git-rebase-todo").read
  end
end
