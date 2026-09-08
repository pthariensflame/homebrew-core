class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.69.tar.gz"
  sha256 "b857aa1c164c8aa169607d73c6d7963b1febed24c3a850156c7f9989a94d4b51"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c60626cfaa8b29ddd1a23e19ec2103c195532523def880b65873176f3b27cd86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c60626cfaa8b29ddd1a23e19ec2103c195532523def880b65873176f3b27cd86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c60626cfaa8b29ddd1a23e19ec2103c195532523def880b65873176f3b27cd86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9c962cfc07a6bc4be1dc00cc8d956e2579f13621af55a04602f7890207ee204"
    sha256 cellar: :any,                 x86_64_linux:  "21efa42143019a5cacaa8506e70b21f4e1e9db00baec23b3562d306eba742e9a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
