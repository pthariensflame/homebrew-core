class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.9.53.tar.gz"
  sha256 "7e6c5c8031539784d6fc6c5fa6dd16264943f16c5f36e4d80af3adfac189c6c5"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "75a6ce329c8d70d2b3d147526116bc93999a0be66876d5c89c1ea46f65894559"
    sha256 arm64_sequoia: "e0e9ff86b1280b60382c0e46aec7b08ba52bb7bfe6e8eac414135a268ebe9fe3"
    sha256 arm64_sonoma:  "1a3754bf2d6f3c27e5af2317a11dfd0a2117781d2e2151e29aea045b878330a1"
    sha256 arm64_linux:   "21bf016ffb010658436d033e42d7e25fe731fa50f3e0be8e781230a074bc2e0a"
    sha256 x86_64_linux:  "fb6700b30ee389b5e80997820fed35f8b3d88f9458d27158f5f0ceae37130079"
  end

  depends_on "openssl@4"

  uses_from_macos "libedit"
  uses_from_macos "libffi"

  def install
    args = ["PREFIX=#{prefix}", "OPENSSL=openssl@4"]
    # macOS keeps ffi.h in an ffi/ subdirectory, which the build's plain
    # `#include <ffi.h>` misses. TARGET_CFLAGS is the makefile's append hook.
    args << "TARGET_CFLAGS=-I#{MacOS.sdk_path}/usr/include/ffi" if OS.mac?
    system "make", "install", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tpl --version")

    assert_equal "42", shell_output("#{bin}/tpl -g 'X is 6*7, write(X), halt'").chomp

    # library(assoc) is not embedded in the binary, so this also proves the
    # installed library path was baked in correctly.
    goal = "use_module(library(assoc)), list_to_assoc([a-1, b-2], A), " \
           "get_assoc(b, A, V), write(V), halt"
    assert_equal "2", shell_output("#{bin}/tpl -g '#{goal}'").chomp
  end
end
