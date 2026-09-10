class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.26.1.tgz"
  sha256 "d2eb6909dcdf70317d862d77c761711786c8781268dd6840238782687cc61afc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ca59061783f5372f6e7deaec6c47c7d68bb7150ac126f759d634c8498f2540c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ca59061783f5372f6e7deaec6c47c7d68bb7150ac126f759d634c8498f2540c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ca59061783f5372f6e7deaec6c47c7d68bb7150ac126f759d634c8498f2540c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd2f29bf4da85c27fe93482e3b66d121b4a745704d3079b351fcf902bce2dfba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd2f29bf4da85c27fe93482e3b66d121b4a745704d3079b351fcf902bce2dfba"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
