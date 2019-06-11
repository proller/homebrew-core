class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/2019-05-20.tar.gz"
  version "2019-05-20"
  sha256 "bc01afeacd77ff786a10755117a7aeb219c8d50e3db3931e59bf8f50f4cad55d"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a0631cdeb2dd788b597916ef29860b1ba5d987aaa7f5f7b2ffa0fd6e043ea78" => :mojave
    sha256 "a269f10b71778c73cd12898d0e43c35cab2fb3c13bb498084a5d7107e3ce6ff8" => :high_sierra
    sha256 "09ed1348576dcc976245bb022dd4e09007601548e5069e69286ea65c4e40bcba" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "glm" => :test
  depends_on "glslang" => :test

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    # required for tests
    prefix.install "samples"
    (include/"spirv_cross").install Dir["include/spirv_cross/*"]
  end

  test do
    cp_r Dir[prefix/"samples/cpp/*"], testpath
    inreplace "Makefile", "-I../../include", "-I#{include}"
    inreplace "Makefile", "../../spirv-cross", "spirv-cross"

    system "make"
  end
end
