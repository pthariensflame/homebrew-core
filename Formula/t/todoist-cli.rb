class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.2.2.tgz"
  sha256 "17782209f9c61dd0e7b5c8e60d20c470715a077b405020e1a80c8546781c32a5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e38a49562ca154b26e23fb2e349bb9da15ace79d199c858b72c44e8a218543ed"
    sha256 cellar: :any,                 arm64_sequoia: "e38a49562ca154b26e23fb2e349bb9da15ace79d199c858b72c44e8a218543ed"
    sha256 cellar: :any,                 arm64_sonoma:  "e38a49562ca154b26e23fb2e349bb9da15ace79d199c858b72c44e8a218543ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb14ed300a4296240ee6a1ec8b06950a0122e71b388effec180eeb55a93cf1aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8014e336c0b32952e244f10e2899b2bb596adf64bec767f24516471b595ed39"
  end

  depends_on "rust" => :build
  depends_on "node"

  resource "keyring" do
    url "https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.0.0.tar.gz"
    sha256 "0a3eb14fe07b733e945d25d1a5425021c728ed19886f426d22afa84fc97c7754"

    livecheck do
      url "https://raw.githubusercontent.com/Doist/todoist-cli/v#{LATEST_VERSION}/package-lock.json"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :json do |json, regex|
        json.dig("packages", "node_modules/@napi-rs/keyring", "version")&.[](regex, 1)
      end
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    node_modules = libexec/"lib/node_modules/@doist/todoist-cli/node_modules"

    resource("keyring").stage do
      system "cargo", "build", "--lib", "--release"
      dylib = Pathname.pwd/"target/release/libnapi_keyring.dylib"
      node_modules.glob("@doist/cli-core/node_modules/@napi-rs/keyring-darwin-*/*.node").each do |prebuilt|
        cp dylib, prebuilt
      end
    end

    deuniversalize_machos node_modules/"app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end
