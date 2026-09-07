class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.10.10.tar.gz"
  sha256 "d7c0aa54c08b3f9f8abd30f26bc3c3f398ed7f4c26729e44b3b1d6ccd99de069"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a19764b9488f6516b7369d15136421a22bcad501384ce1c522549ff1d043959f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a19764b9488f6516b7369d15136421a22bcad501384ce1c522549ff1d043959f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a19764b9488f6516b7369d15136421a22bcad501384ce1c522549ff1d043959f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14bc4d63f76b3e6b130c31341ce9e4b287da62c9445f8cccd5525c40ea75e995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14bc4d63f76b3e6b130c31341ce9e4b287da62c9445f8cccd5525c40ea75e995"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end
