class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "https://wildfly.org/"
  url "https://download.jboss.org/wildfly/16.0.0.Final/wildfly-16.0.0.Final.tar.gz"
  sha256 "65ec8881c073e1fda0be293037eb7c8d19b38d6e57f83044086d39dc40a26385"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    rm_f Dir["bin/*.ps1"]
    libexec.install Dir["*"]
    mkdir_p libexec/"standalone/log"
  end

  def caveats; <<~EOS
    The home of WildFly Application Server #{version} is:
      #{opt_libexec}
    You may want to add the following to your .bash_profile:
      export JBOSS_HOME=#{opt_libexec}
      export PATH=${PATH}:${JBOSS_HOME}/bin
  EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/wildfly-as/libexec/bin/standalone.sh --server-config=standalone.xml"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>KeepAlive</key>
      <dict>
        <key>SuccessfulExit</key>
        <false/>
        <key>Crashed</key>
        <true/>
      </dict>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_libexec}/bin/standalone.sh</string>
        <string>--server-config=standalone.xml</string>
      </array>
      <key>EnvironmentVariables</key>
      <dict>
        <key>JBOSS_HOME</key>
        <string>#{opt_libexec}</string>
        <key>WILDFLY_HOME</key>
        <string>#{opt_libexec}</string>
      </dict>
    </dict>
    </plist>
  EOS
  end

  test do
    ENV["JBOSS_HOME"] = opt_libexec
    system "#{opt_libexec}/bin/standalone.sh --version | grep #{version}"
  end
end
