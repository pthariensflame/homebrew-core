class WoofDoom < Formula
  desc "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports"
  homepage "https://fabiangreffrath.github.io/woof/"
  url "https://github.com/fabiangreffrath/woof/archive/refs/tags/woof_16.0.0.tar.gz"
  sha256 "293bc5ad61eaac191ee1cb652c797819459a7f7819d4aec78a847c8e13695342"
  license all_of: [
    # Default license is GPL-2.0-or-later but `woof` binary ends up GPL-3.0-or-later
    "GPL-2.0-or-later",
    "GPL-3.0-or-later", # src/v_flextran.*, src/v_video.*

    # Other licenses
    "BSD-2-Clause", # third-party/spng/*
    "BSD-3-Clause", # src/m_scanner.*, base/all-all/sprites/pls*, man/simplecpp
    "CC-BY-3.0",    # base/all-all/sm*.png, data/setup.ico, data/woof*, setup/setup_icon.c, src/icon.c
    "CC0-1.0",      # base/all-all/sbardef.lmp, data/io.github.fabiangreffrath.woof.metainfo.*
    "GPL-2.0-only", # soundfonts/TimGM6mb.sf2
    "MIT",          # src/i_flickstick.*, src/i_gyro.*, src/nano_bsp.*, base/all-all/dmxopl.op2, third-party/miniz/*
    "NCL",          # third-party/pffft/*
    :public_domain, # third-party/md5/*
    "CC-BY-SA-4.0", # textscreen/fonts/hauge-8x18-v1-6.png
    "Zlib",         # netlib
  ]
  head "https://github.com/fabiangreffrath/woof.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5fe5942382f6b24dfd928f023279f36ea7fc8686a92affbfe9dac93d4df6ea50"
    sha256 cellar: :any,                 arm64_sequoia: "9af289e62db9550c0d9d04903f596e46f0ab67a3fe7d42fff1294511549b6fa9"
    sha256 cellar: :any,                 arm64_sonoma:  "eefa1a71e7e29f5a19ee0f50f6332ac37d1334d2b6c72e09eddeb9e9dd2de9a8"
    sha256 cellar: :any,                 sonoma:        "ce1a252768cd9d70a653330c55b3fc53b8a8c922d15fd7184d36561e2403a48a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f97536230d32c3733dbee65719503d45d620112ab004de741542f1c125e193f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f25b3b170b7b2b6bd627f551ea0dd4fe229898bf039a72508a441fd1ecf4ca6"
  end

  depends_on "cmake" => :build
  depends_on "fluid-synth"
  depends_on "libebur128"
  depends_on "libsndfile"
  depends_on "libxmp"
  depends_on "openal-soft"
  depends_on "sdl3"
  depends_on "yyjson"

  on_linux do
    depends_on "alsa-lib"
  end

  conflicts_with "woof", because: "both install `woof` binaries"

  def install
    # Remove bundled libraries
    rm_r("third-party/yyjson")

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test_invalid.wad").write <<~EOS
      Invalid IWAD file
    EOS

    expected_output = "Failed to load test_invalid.wad"
    assert_match expected_output, shell_output("#{bin}/woof -nogui -iwad test_invalid.wad 2>&1", 255)

    assert_match version.to_s, shell_output("#{bin}/woof -version")
  end
end
