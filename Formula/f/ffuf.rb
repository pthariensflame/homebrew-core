class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "cdb2e58259f380862850eba587f71a9dc1738fb5edc1ea60414fae30fd0ed4f2"
  license "MIT"
  head "https://github.com/ffuf/ffuf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f7bff427a9b01e9e838e6e4ad84acfd795fdf8f10f25fe12b8fef0e441a9a0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f7bff427a9b01e9e838e6e4ad84acfd795fdf8f10f25fe12b8fef0e441a9a0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f7bff427a9b01e9e838e6e4ad84acfd795fdf8f10f25fe12b8fef0e441a9a0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7fefda311b795ec2d14ad0192d5cbe677b1fb480b32610d495151d16eaae03c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef9e46a28a38ca7855f0d3e5ce1015b3b0c982508649d0048b34d3cda9ef0033"
    sha256 cellar: :any,                 x86_64_linux:  "cbe18b4e2872c7ed54d5a50b22f85415f81691fedd24d1789fc5513895aca93f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/ffuf -u https://example.org/FUZZ -w words.txt 2>&1")
    assert_match %r{:: Progress: \[5/5\].*Errors: 0 ::$}, output
  end
end
