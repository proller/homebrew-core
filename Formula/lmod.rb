class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://www.tacc.utexas.edu/research-development/tacc-projects/lmod"
  url "https://github.com/TACC/Lmod/archive/8.2.8.tar.gz"
  sha256 "9fc1fee73ba9d1b762f8902b72aff8b15df99efa8cc511159294fbfed813f93b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6937a8a1c70b354a2cf8e87a1f58d4cf5b916482d64a066e632bb1afa682c3f" => :catalina
    sha256 "68a92d9163fca62d31fa723d0e61b00e71fa7e051762eb0cd9d242597c04aaa0" => :mojave
    sha256 "6a733e50d180283dfce4148311c83400aefbf408fde1189fa51f9b5b366b0445" => :high_sierra
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_7_0_2.tar.gz"
    sha256 "23b4883aeb4fb90b2d0f338659f33a631f9df7a7e67c54115775a77d4ac3cc59"
  end

  resource "luaposix" do
    url "https://github.com/luaposix/luaposix/archive/v34.1.1.tar.gz"
    sha256 "7948f4ac8b953172e928753632e37ad97cc3014df74b524fe7839f71216a7e90"
  end

  def install
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/5.3/?.lua;" \
                      "#{luapath}/share/lua/5.3/?/init.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/5.3/?.so"

    resources.each do |r|
      r.stage do
        system "luarocks", "make", "--tree=#{luapath}"
      end
    end

    system "./configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To use Lmod, you should add the init script to the shell you are using.

      For example, the bash setup script is here: #{opt_prefix}/init/profile
      and you can source it in your bash setup or link to it.

      If you use fish, use #{opt_prefix}/init/fish, such as:
        ln -s #{opt_prefix}/init/fish ~/.config/fish/conf.d/00_lmod.fish
    EOS
  end

  test do
    system "#{prefix}/init/sh"
    output = shell_output("#{prefix}/libexec/spider #{prefix}/modulefiles/Core/")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end
