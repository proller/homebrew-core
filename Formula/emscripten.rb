class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://kripken.github.io/emscripten-site/"

  stable do
    url "https://github.com/emscripten-core/emscripten/archive/1.38.32.tar.gz"
    sha256 "5316ece4c1d4985ba52c085851cd31dd7c0bb958256a518b6095285b9b8764a2"

    resource "fastcomp" do
      url "https://github.com/emscripten-core/emscripten-fastcomp/archive/1.38.32.tar.gz"
      sha256 "dd40db854f2e777ced36c5723fe85f56d98227bfab23bf3b7161a8458f008704"
    end

    resource "fastcomp-clang" do
      url "https://github.com/emscripten-core/emscripten-fastcomp-clang/archive/1.38.32.tar.gz"
      sha256 "8efe76f26e73d2a0a5f479ca4f379a85b833480c7d5bb90e43f676630c78949f"
    end
  end

  bottle do
    cellar :any
    sha256 "9bb1f2155fcd3f9364425dd83321712d3848c2305c4dc2b5cc9996b42e4076db" => :mojave
    sha256 "2e3d96006f328b7753e42f8d119369e1afc983fe339fe501435a87362e66f0c5" => :high_sierra
    sha256 "efc6ad25da4f744bfbf19bd17464fb847f136bc9e56db3f69e6457f674c0357e" => :sierra
  end

  head do
    url "https://github.com/emscripten-core/emscripten.git", :branch => "incoming"

    resource "fastcomp" do
      url "https://github.com/emscripten-core/emscripten-fastcomp.git", :branch => "incoming"
    end

    resource "fastcomp-clang" do
      url "https://github.com/emscripten-core/emscripten-fastcomp-clang.git", :branch => "incoming"
    end
  end

  depends_on "cmake" => :build
  depends_on "node"
  depends_on "python@2"
  depends_on "yuicompressor"

  def install
    ENV.cxx11
    # rewrite hardcoded paths from system python to homebrew python
    python2_shebangs = `grep --recursive --files-with-matches ^#!/usr/bin/python #{buildpath}`
    python2_shebang_files = python2_shebangs.lines.sort.uniq
    python2_shebang_files.map! { |f| Pathname(f.chomp) }
    python2_shebang_files.reject! &:symlink?
    inreplace python2_shebang_files, %r{^#!/usr/bin/python2?$}, "#!#{Formula["python@2"].opt_bin}/python2"

    # All files from the repository are required as emscripten is a collection
    # of scripts which need to be installed in the same layout as in the Git
    # repository.
    libexec.install Dir["*"]

    (buildpath/"fastcomp").install resource("fastcomp")
    (buildpath/"fastcomp/tools/clang").install resource("fastcomp-clang")

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] }
    cmake_args = [
      "-DCMAKE_BUILD_TYPE=Release",
      "-DCMAKE_INSTALL_PREFIX=#{libexec}/llvm",
      "-DLLVM_TARGETS_TO_BUILD='X86;JSBackend'",
      "-DLLVM_INCLUDE_EXAMPLES=OFF",
      "-DLLVM_INCLUDE_TESTS=OFF",
      "-DCLANG_INCLUDE_TESTS=OFF",
      "-DOCAMLFIND=/usr/bin/false",
      "-DGO_EXECUTABLE=/usr/bin/false",
    ]

    mkdir "fastcomp/build" do
      system "cmake", "..", *cmake_args
      system "make"
      system "make", "install"
    end

    %w[em++ em-config emar emcc emcmake emconfigure emlink.py emmake
       emranlib emrun emscons].each do |emscript|
      bin.install_symlink libexec/emscript
    end
  end

  def caveats; <<~EOS
    Manually set LLVM_ROOT to
      #{opt_libexec}/llvm/bin
    and comment out BINARYEN_ROOT
    in ~/.emscripten after running `emcc` for the first time.
  EOS
  end

  test do
    system bin/"emcc"
    assert_predicate testpath/".emscripten", :exist?, "Failed to create sample config"
  end
end
