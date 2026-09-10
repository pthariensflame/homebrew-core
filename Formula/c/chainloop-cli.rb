class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.109.1.tar.gz"
  sha256 "3e15add64a6a0cf93d6b52bff1ad03c0152a6e9c15686b4057dd08dffd4c3ea7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "223b7580fc3a379f7e17365d7034d6d74bca43febc2d9e14aa431a8808263260"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "223b7580fc3a379f7e17365d7034d6d74bca43febc2d9e14aa431a8808263260"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "223b7580fc3a379f7e17365d7034d6d74bca43febc2d9e14aa431a8808263260"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0e995ec1fd9e077e971d5d40e3dff6243a5edc79744472e007c0c44c88c3766"
    sha256 cellar: :any,                 x86_64_linux:  "608d7c54512280029363de80a9772700ccf1db3b852056f69883a55b38d55468"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
