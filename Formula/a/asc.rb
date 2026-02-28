class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.36.0.tar.gz"
  sha256 "c4bbcf5a229a5d878a084743cd46a2f7322c47d06ac7c6b2d9683d514df47fe3"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ea9414a46d12d25688820cc655241e59011948cd87f43a9ce9b825796635a66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b79eefc9ce8358ede53df0d5a9a672b4312131a740e53599d7aba13a734e631a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94f2b1b473b7b82ee14bec7e03d55f5cdc5a421e44242f238902561157fe672f"
    sha256 cellar: :any_skip_relocation, sonoma:        "45d83b207f3f77ff575ec91a53db4a719510a61b439a60abdad06b1b3b0a76e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d9b162845fb2012fb1204837a2063d34fbccb851115b31aa709f97bf6294a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c34d09ab4d8691167dcab88ffb7e428f26a6c6abff57719fab26ed1debf7098a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
