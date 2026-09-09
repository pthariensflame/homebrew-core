class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49897",
      revision: "fe6a888d671e7735583e113b8339cf240d2fb731"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f5fe4f22bb2408a403881b2e26edca0df85ceca40e6aca4c6eb1b3fc835a391"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8df39de81d6773dc3062eb72b0bad1aa189a79eeab242f56cef8cefcf28b0ec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c656dca6a24f23dc6c340ca9d6c8ace863b3418ebd15562999be16233e896339"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "912c6b26ee7b203df1b8aa4b39846e3debdc9a701f675955ae4b8222db1010ce"
    sha256 cellar: :any,                 x86_64_linux:  "5b35bf3e740f86e4fbe09cc676b7706b04fb97ac97a717611770488c4f638918"
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
