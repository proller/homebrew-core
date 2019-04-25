class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.8.tar.gz"
  sha256 "d5f2c4bc1f57f0566242c4a0a721a5ceaa6d6d407f9d6dd29009a714a0abec74"
  revision 8

  bottle do
    cellar :any_skip_relocation
    sha256 "b56f49aefecf4225eda480219282235aa452247037ea5d4cbc54f51eec14e2af" => :mojave
    sha256 "9f648ee048f0e967eabb2b1135f74c5ccc22869c038d395661170fdbea656a76" => :high_sierra
    sha256 "121a21ce674c3a21e7d2ecd3a98c6f91cf26ebe8be3ce7ac81199991bcafa28e" => :sierra
  end

  depends_on "mpv"
  depends_on "python"

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/41/cb/ec840c79942fb0788982963b61a361ecd10e4e58ad3dcaef4f0e809ce2fe/pafy-0.5.4.tar.gz"
    sha256 "e842dc589a339a870b5869cc3802f2e95824edf347f65128223cd5ebdff21024"
  end

  resource "youtube_dl" do
    url "https://files.pythonhosted.org/packages/9c/ef/5cd4138e4b9c04f1c7875d3b64edcddb9355e488019a32df629f9f0dfcec/youtube_dl-2019.4.24.tar.gz"
    sha256 "b20d110e1bed8d16f5771bb938ab6e5da67f08af62b599af65301cca290f2e15"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    %w[youtube_dl pafy].each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  test do
    Open3.popen3("#{bin}/mpsyt", "/Drop4Drop x Ed Sheeran,", "da 1,", "q") do |_, _, stderr|
      assert_empty stderr.read, "Some warnings were raised"
    end
  end
end
