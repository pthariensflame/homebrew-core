class Kata < Formula
  desc "Local-first, federated issue tracker for humans and coding agents"
  homepage "https://katatracker.com"
  url "https://github.com/kenn-io/kata/releases/download/v0.17.2/kata_0.17.2_source.tar.gz"
  sha256 "4ce3161dac6b390750713800af4dd0b21b42a18c49683b93ee1bf9b064edb6ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7090cbb47ee010111b8eb3dbd0398920a7f9d1b6002dc5445bd59910bffaf1c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7090cbb47ee010111b8eb3dbd0398920a7f9d1b6002dc5445bd59910bffaf1c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7090cbb47ee010111b8eb3dbd0398920a7f9d1b6002dc5445bd59910bffaf1c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f58825cb6aea953028d6c3a3fae5cf03f9a037648ad8e6333d70c79b443f71a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c82818cc6b5d3aedcedf0338c523263cd6f79c8d4fb166ccb9e61c16524d1f9a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X go.kenn.io/kata/internal/version.Version=v#{version}
      -X go.kenn.io/kata/internal/version.Distribution=homebrew
      -X go.kenn.io/kata/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "-mod=vendor", "-buildvcs=false", "./cmd/kata"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kata version")

    ENV["KATA_HOME"] = testpath/"kata-home"
    ENV["KATA_TELEMETRY_ENABLED"] = "0"
    begin
      system bin/"kata", "init", "--project", "homebrew-test"
      system bin/"kata", "create", "Homebrew test issue"
      assert_match "Homebrew test issue", shell_output("#{bin}/kata list")
    ensure
      system bin/"kata", "daemon", "stop"
    end
  end
end
