class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/refs/tags/v0.83.0.tar.gz"
  sha256 "9b36be5a666784adaeffa560bd0950691f851a76bdb97e7ae3c989561e91caf3"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

  # New releases of dosbox-staging are indicated by a GitHub release (and
  # an announcement on the homepage), not just a new version tag.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "88db4c380c543140ebfbd668033e1a8ca44e528a3acb1d1c9028be36f0373b30"
    sha256 arm64_sequoia: "c20cfde08ded1db6ade3b0bd762e63008330ef568b4633fcb66a4b6a7e27c7ef"
    sha256 arm64_sonoma:  "b8111b741e94d0a2aacf030ec1cfecf5e47545bf38177757b1d3942f7093e01e"
    sha256 sonoma:        "3feabb1aecd2f540708f685c837a4c4c633bf941a783b44115388d1a2fb19531"
    sha256 arm64_linux:   "e69923a5122d7e81660e996d7222b8a6af8de0f3d3211c47048af92bc4ffa93b"
    sha256 x86_64_linux:  "86a154ce4e2d98e228d8fae799c47ec6f5c1a19d50bb439759a27bee4e6de011"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fluid-synth"
  depends_on "iir1"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "mt32emu"
  depends_on "opusfile"
  depends_on "sdl2-compat"
  depends_on "sdl2_image"
  depends_on "speexdsp"
  depends_on "zlib-ng"

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  # Fix system library builds and installation, upstream PR ref, https://github.com/dosbox-staging/dosbox-staging/pull/5046
  patch do
    url "https://github.com/dosbox-staging/dosbox-staging/commit/e97e927c198960c809d18fae53280554ed0c975f.patch?full_index=1"
    sha256 "838fe6ea1ba409d33b3301d5f53b9a8c80893e3754c208f4d62e689035228891"
    type :unofficial
  end

  deny_network_access! :test

  def install
    # Slirp is loaded at runtime instead of linked by CMake.
    inreplace "src/network/ethernet_slirp.cpp", '"libslirp.', %Q("#{formula_opt_lib("libslirp")}/libslirp.)

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DOPT_TESTS=OFF", "-DUSE_SYSTEM_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"

    if OS.mac?
      bin.install "build/dosbox" => "dosbox-staging"
      man1.install "docs/dosbox.1" => "dosbox-staging.1"
      pkgshare.install Dir["build/Resources/*"]
    else
      system "cmake", "--install", "build"
      mv bin/"dosbox", bin/"dosbox-staging"
      mv man1/"dosbox.1", man1/"dosbox-staging.1"
    end
  end

  test do
    config_path = OS.mac? ? "Library/Preferences/DOSBox" : ".config/dosbox"
    mkdir testpath/config_path
    touch testpath/config_path/"dosbox-staging.conf"

    assert_match "crt/crt-hyllian", shell_output("#{bin}/dosbox-staging --list-shaders")
    assert_match version.to_s, shell_output("#{bin}/dosbox-staging -version")
    output = shell_output("#{bin}/dosbox-staging -printconf")
    assert_equal testpath/config_path/"dosbox-staging.conf", Pathname(output.chomp)
  end
end
