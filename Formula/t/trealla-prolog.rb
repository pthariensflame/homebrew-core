class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.9.45.tar.gz"
  sha256 "5c0f4e71b1846ea5b92a8b2036aa5c971675b51dd6076b79366540ee700687b2"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "efda1d92abc77fcc2f5fda2af90345ef9f2a30b7c9f72d7b961691f182d3982c"
    sha256 arm64_sequoia: "1f8ca3264170d95ef64a29bdc8c416282e0c6c8e10f73d766c6a5c25381d25e0"
    sha256 arm64_sonoma:  "3c3fc7aeb441188e9b3e32e9b548aefbc2c0f55ccf389e6f080118ecceeb4508"
    sha256 arm64_linux:   "7a47e64a1d446912802d8850c163c104e0201b72d4ab82b02d2041fd4ac3cdfe"
    sha256 x86_64_linux:  "21ee806d633a42329f7e690e34f418c9c91d29112904e8b2d564bcbfb5a90f57"
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
