class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "d34cf4dee599b0ceadf682118267e161f34955bd74aa5108b3c04276105fbfb9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46c44412dbd90ec21e04922315fde48afeca3033ea6d2a416d91f2f31f14bbfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "356baa3a8587a508406662faffd670de638763b0d09d4f4221ccfa618ab37fc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95572e5d34d021dde404cff48c436776c7f535abaeed298d92acf52fc09098d6"
    sha256 cellar: :any,                 arm64_linux:   "58be73a71a5eb98772deca5f2f3ce6ec3468ad595ac479ebb6aaa4671a3eb986"
    sha256 cellar: :any,                 x86_64_linux:  "d221f9e09bfda1e132112b6e7ab1a0c0639ba7d1c42e792cb4fc90973d53cc60"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end
