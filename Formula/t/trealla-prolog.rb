class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.9.53.tar.gz"
  sha256 "7e6c5c8031539784d6fc6c5fa6dd16264943f16c5f36e4d80af3adfac189c6c5"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "1c2e2d9e8460ba1fecb2bc7f51d90bea5f9be46998099fcd043e2aa8a6830ed7"
    sha256 arm64_sequoia: "f680fa633d7d9fb65a4a588660841b4dc61a1ea4b52054cc002859a465e50110"
    sha256 arm64_sonoma:  "3d4fa71c1342107689fb722f3f6d5aa628453504fd1f3b304ea193dc6c9caf7f"
    sha256 arm64_linux:   "c80ae7fe08821afe647f393df46b909a03891a5bc7ff3f1d72eee40c1caaa9a4"
    sha256 x86_64_linux:  "22f41c9a0b053a6d0e0a25b640a38754696797b1dd67635ea7f945dbf5799bdd"
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
