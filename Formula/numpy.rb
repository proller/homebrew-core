class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/93/48/956b9dcdddfcedb1705839280e02cbfeb2861ed5d7f59241210530867d5b/numpy-1.16.3.zip"
  sha256 "78a6f89da87eeb48014ec652a65c4ffde370c036d780a995edaeb121d3625621"
  revision 1
  head "https://github.com/numpy/numpy.git"

  bottle do
    cellar :any
    sha256 "d1a6b200ef06b691881d2dce01ba40f4b18be032bd8fb75fdec6b098440d7cf5" => :mojave
    sha256 "88c5beef3c5c539ba8991cd87625e5e9ae6608f6e0c67f0fbd7c39552d28fcd8" => :high_sierra
    sha256 "58e0581edfb56698159e2d85b774219a0157bff5b9d11a7e01f034537d0c3f6e" => :sierra
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python"
  depends_on "python@2"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/f8/da/c979464858b257b21a6472a85285548c91f5b4dc773cb049cfdfb3ceeb02/Cython-0.29.7.tar.gz"
    sha256 "55d081162191b7c11c7bfcb7c68e913827dfd5de6ecdbab1b99dab190586c1e8"
  end

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  def install
    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/libopenblas.dylib"

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas}/lib
      include_dirs = #{openblas}/include
    EOS

    Pathname("site.cfg").write config

    ["python2", "python3"].each do |python|
      version = Language::Python.major_minor_version python
      dest_path = lib/"python#{version}/site-packages"
      dest_path.mkpath

      nose_path = libexec/"nose/lib/python#{version}/site-packages"
      resource("nose").stage do
        system python, *Language::Python.setup_install_args(libexec/"nose")
        (dest_path/"homebrew-numpy-nose.pth").write "#{nose_path}\n"
      end

      ENV.prepend_create_path "PYTHONPATH", buildpath/"tools/lib/python#{version}/site-packages"
      resource("Cython").stage do
        system python, *Language::Python.setup_install_args(buildpath/"tools")
      end

      system python, "setup.py",
        "build", "--fcompiler=gnu95", "--parallel=#{ENV.make_jobs}",
        "install", "--prefix=#{prefix}",
        "--single-version-externally-managed", "--record=installed.txt"
    end
  end

  def caveats
    homebrew_site_packages = Language::Python.homebrew_site_packages
    user_site_packages = Language::Python.user_site_packages "python"
    <<~EOS
      If you use system python (that comes - depending on the OS X version -
      with older versions of numpy, scipy and matplotlib), you may need to
      ensure that the brewed packages come earlier in Python's sys.path with:
        mkdir -p #{user_site_packages}
        echo 'import sys; sys.path.insert(1, "#{homebrew_site_packages}")' >> #{user_site_packages}/homebrew.pth
    EOS
  end

  test do
    ["python2", "python3"].each do |python|
      system python, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end
