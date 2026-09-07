class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "1593fc4ab238323724bc1a34d7e393f85dc7a7f2e0a900a6e5a48efe3b345179"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "505364ce1a7376679cb1eec85d5a34dfc2c0500822eeb75b5bbd309bdd94c19d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "505364ce1a7376679cb1eec85d5a34dfc2c0500822eeb75b5bbd309bdd94c19d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "505364ce1a7376679cb1eec85d5a34dfc2c0500822eeb75b5bbd309bdd94c19d"
    sha256 cellar: :any_skip_relocation, sonoma:        "28a5f154b2dce4d23d35dcd24c5db7a3a276e541d89a52488026514babe89840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51756cb6e7a0af27d0d0d0bbe6c1927e6093eacfd88780029b508f2da69f170d"
    sha256 cellar: :any,                 x86_64_linux:  "34c2d065befef733e752cdcedac39cb8f855b82f83bcdab8928174da9936992d"
  end

  depends_on "go" => :build

  resource "aliyun-openapi-meta" do
    url "https://github.com/aliyun/aliyun-openapi-meta/archive/00db11354cc523f310b1bd1bd73bdecc478e8ad2.tar.gz"
    version "00db11354cc523f310b1bd1bd73bdecc478e8ad2"
    sha256 "cbd5c1252b351130a1767e98dfb53ce40bd0cfa824301b256e220e5348ae20ea"

    livecheck do
      url "https://api.github.com/repos/aliyun/aliyun-cli/contents/aliyun-openapi-meta?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  def install
    (buildpath/"aliyun-openapi-meta").install resource("aliyun-openapi-meta")
    system "go", "generate", "./bundledmeta"

    ldflags = "-X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "-tags", "aliyun_cli_packed_meta", "./main"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "Quick Start:", help_out
    assert_match "aliyun ecs DescribeRegions", help_out

    dry_run_out = shell_output("#{bin}/aliyun ecs DescribeRegions --cli-dry-run --region cn-hangzhou")
    assert_match "Endpoint: ecs-cn-hangzhou.aliyuncs.com", dry_run_out
    assert_match "Action:   DescribeRegions", dry_run_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
