class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.18.1.tar.gz"
  sha256 "d19e26698ce4ae73808785f5dd50456632595fe2980697b8fcf3c2826a358ad2"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96c37e8532693837824ffc1ec2f39aaaee41e58c1cc877e87371a49c9d2499a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96c37e8532693837824ffc1ec2f39aaaee41e58c1cc877e87371a49c9d2499a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96c37e8532693837824ffc1ec2f39aaaee41e58c1cc877e87371a49c9d2499a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b91d9ebf93995b24c18d669fb72884f520b153e802d1fd2c20808ae5c0c50f93"
    sha256 cellar: :any,                 x86_64_linux:  "470be8b2053870916e14a940411617cdcd4320d95e727864b3f491a809faa6ac"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    touch testpath/"mark.toml"
    output = shell_output("#{bin}/mark --config mark.toml sync 2>&1", 1)
    assert_match "confluence base URL should be specified", output
  end
end
