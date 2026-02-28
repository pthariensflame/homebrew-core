class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.31.tar.gz"
  sha256 "b4096dcdb825e69f92462671f9ef14eb25dd2d665a1ce52b2c6e0b31689499ed"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8922cf2a09c02edeb46cb3f8ac29aa678978e51096888ef9cbcd0894bdd5f61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4890305c4dbbe41c565b44e21419d1c85c87e250969bbf6df8854e9314e7972b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e2214e68cdbf34eaf7403695b1754833d3bdf36f68ff7a796b222f94aeb925e"
    sha256 cellar: :any_skip_relocation, sonoma:        "877da74272a590312606a2db58fa2bb3eeb36ac50c3ba2b4367bb6f4adc4fc1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c781e9b9187d5e25d1675516958fbb71e47fa298d5418825b2e6a4fe73cc91cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05b6f1d12d6f1c06e2bcc978e57a770ac4a1b7692866859a02cee34e48359ef8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
