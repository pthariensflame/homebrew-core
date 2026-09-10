class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.9.60.tar.gz"
  sha256 "413254afdd0d7eee9906ecb1a7eb5f10115533f485fd5fa2e807fcaccf9f2913"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "6070ff1880e22c9ab6b9a530a6d420323ed9488cb85fb787577a2b5c7373d7f4"
    sha256 arm64_sequoia: "2435c8a4050053f92f1d877483d28a5a75a764fff0566b7ca9655673f893719c"
    sha256 arm64_sonoma:  "55fe6c463c7e82aa70aa08c41977617986bc4e08bf9dc5c75b9676b136683e22"
    sha256 arm64_linux:   "9608d0108a83af2e02f503a1245e47b7a044f083fbaa26f3e12a054d6314d61d"
    sha256 x86_64_linux:  "d91bd6e3f27a67173a541f3ea334cebd22f68558391d42d3d22ade40496b439b"
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
