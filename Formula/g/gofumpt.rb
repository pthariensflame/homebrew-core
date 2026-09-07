class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "b6d5d14692cad23996da4329bf24d30324af30125dd5261e6d9b0c5bc8b20b28"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/gofumpt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc41e101705c25fc2d8b8f0b0fad5448fd6cab901efaf75b4417fbbec0d6b293"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc41e101705c25fc2d8b8f0b0fad5448fd6cab901efaf75b4417fbbec0d6b293"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc41e101705c25fc2d8b8f0b0fad5448fd6cab901efaf75b4417fbbec0d6b293"
    sha256 cellar: :any_skip_relocation, sonoma:        "d44ef827b8ba9803a42a1a9d71ad779995443233acdc15bcc1a7164dd52be6b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4a1117def5675455dcdb3b4ecbff00f87a74abdf29cf147f4285fce76c24933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf2a5aa42679a3f729a4042bc3c0fec857d50f4ea3c0149e54a6a5761ac1c226"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gofumpt -version").split.first

    (testpath/"test.go").write <<~GO
      package foo

      func foo() {
        println("bar")

      }
    GO

    (testpath/"expected.go").write <<~GO
      package foo

      func foo() {
      	println("bar")
      }
    GO

    assert_match shell_output("#{bin}/gofumpt test.go"), (testpath/"expected.go").read
  end
end
