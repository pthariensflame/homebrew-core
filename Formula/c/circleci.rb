class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49978",
      revision: "e1fb0e13cf8e280610c8b7c70508313b591aa4a5"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dd9493be4462e597b5cf1df68e7a293ba5ad05e79d2979d04bbcafd87e8a084"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd9cf92d1c3863d29625c9642247a72f500815025a5ceeb3e120ca1a6e9ec68d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4ce04a297bab7be1a9c6fc149c1fc0fd223f574960653f487c2e230c886ba57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dee3958b28fc8563d8e3fafdc4caace9b68d63db1306919692b46b102ba975dc"
    sha256 cellar: :any,                 x86_64_linux:  "d3ac063432a84c92a349be14462f009dab6db760844c5c791bee43c07a90d590"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/circleci"

    generate_completions_from_executable(bin/"circleci", "completion")
    system bin/"circleci", "man", "--output", man1/"circleci.1"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    # assert basic script execution
    assert_match(/^circleci #{version} \(\h{12}\)$/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
  end
end
