class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.16.7.tar.gz"
  sha256 "c3114db827dd947aa96603387318ea0099c65c6d88abb2704f9e63fc11407097"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f44a432ec11e8e7c4c9fa5de9505d13dc04589e609330653cf99f761e74f2dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97e72fb47d4811c6127ea6a8fd7253559f26a28ac8ebb3c6617bb33bc6e8d193"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f521ccd768c4af559920a40d52ea9e8c930fb1fc66f669dc5f9c29822954fab"
    sha256 cellar: :any,                 arm64_linux:   "171d0d1133c5ece9d902c2aef92a41e81f4e28026e3d816f96245bf765783047"
    sha256 cellar: :any,                 x86_64_linux:  "06f7106ec1afd815c5a367129b5b291be279cbc2afaeee2e6622b1b7045013ca"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff check #{testpath}/test.py", 1)
  end
end
