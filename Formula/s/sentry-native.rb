class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/releases/download/0.16.6/sentry-native.zip"
  sha256 "d35145daaafddc50c0c87ec564acf0ba9968e67b23981e7f57c702b2dd6f2ff1"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "61b63cc808107249fe0b39ba204249dcad5058f1075465a9b022447912134974"
    sha256 cellar: :any, arm64_sequoia: "fd09ffebee81619946471f752bb0776b24e541728911a27be11d479aae5aaa87"
    sha256 cellar: :any, arm64_sonoma:  "1fcf6990bfb23f6ea95fa20e67d5b6d9fd9040e8a9f4a4294639cf42b3bb0e4e"
    sha256 cellar: :any, arm64_linux:   "252e97d8fe23d5e383de7a1805be9053ff35b6ea307be27bebbb66effbc9a85f"
    sha256 cellar: :any, x86_64_linux:  "48df89b82d73e21e9586764fb4bf06672ba84570a8424612cb89a58222c2bd07"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  def install
    rm_r("vendor/libunwind")

    args = %w[
      -DSENTRY_BUILD_EXAMPLES=OFF
      -DSENTRY_BUILD_TESTS=OFF
    ]
    args << "-DSENTRY_LIBUNWIND_SYSTEM=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <sentry.h>
      int main() {
        sentry_options_t *options = sentry_options_new();
        sentry_options_set_dsn(options, "https://ABC.ingest.us.sentry.io/123");
        sentry_init(options);
        sentry_close();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{HOMEBREW_PREFIX}/include", "-L#{HOMEBREW_PREFIX}/lib", "-lsentry", "-o", "test"
    system "./test"
  end
end
