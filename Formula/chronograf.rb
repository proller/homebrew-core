require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.7.11.tar.gz"
  sha256 "576e24ab31f3134edaf72651fa288eb4e6f1461662730a57af63096a088d0664"
  head "https://github.com/influxdata/chronograf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3482c2d6ba13a49c943cc17a4334ca61730bdacdf658b1345870d30c7e8e855f" => :mojave
    sha256 "b3e32c0c49a56455d1b2208bdc9978f85b999d39ac11b5de3cfc4d8e9f839a2e" => :high_sierra
    sha256 "f52ec78ab92ab591df495dfd28dc7339a2b57915c397fc0cd25da3e7cb763210" => :sierra
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "influxdb"
  depends_on "kapacitor"

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Node.setup_npm_environment
    chronograf_path = buildpath/"src/github.com/influxdata/chronograf"
    chronograf_path.install buildpath.children

    # fixes yarn + upath@1.0.4 incompatibility, remove once upath is upgraded to 1.0.5+
    Pathname.new("#{ENV["HOME"]}/.yarnrc").write("ignore-engines true\n")

    cd chronograf_path do
      system "make", "dep"
      system "make", ".jssrc"
      system "make", "chronograf"
      bin.install "chronograf"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "chronograf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/chronograf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/chronograf.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/chronograf.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/chronograf"
      end
      sleep 1
      output = shell_output("curl -s 0.0.0.0:8888/chronograf/v1/")
      sleep 1
      assert_match %r{/chronograf/v1/layouts}, output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
