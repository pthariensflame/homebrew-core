class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen-monorepo"
  url "https://github.com/joernio/astgen-monorepo/archive/refs/tags/javascript-astgen/v3.50.0.tar.gz"
  sha256 "e742dd8581032f9855b43961fa584851a0b082415ac0cae4c4213622755a1dad"
  license "Apache-2.0"
  head "https://github.com/joernio/astgen-monorepo.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^javascript[._-]astgen/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_tahoe:   "709728d99aa27054e60e6065a6f3f7137d395b04c3e187975ab4aeb003347bbc"
    sha256 arm64_sequoia: "fa401160268031f3712b4808f8767f295978c7ccaaec01e7ec6c2ad2c1e5a7a5"
    sha256 arm64_sonoma:  "19e091bf1eed0c9461d8125dce177cecfe3e67b2868c4d765ae936b8db700a0f"
    sha256 arm64_linux:   "a86ec1cc0e24e71c8dc666d034f9179b51cb0129ebf680efcfba3a9d88756d09"
    sha256 x86_64_linux:  "bfd3744c9227a1e769b6ee7ce61136a00edb61009dfb57f78d58cd91c72fdc4b"
  end

  depends_on "bun" => :build

  on_linux do
    depends_on "icu4c@78"
  end

  def install
    cd "javascript-astgen" do
      system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
      system "bun", "run", "binary"

      os = OS.mac? ? "macos" : "linux"
      arch = Hardware::CPU.arm? ? "arm64" : "x64"

      bin.install "astgen-#{os}-#{arch}" => "astgen"
    end
  end

  test do
    (testpath/"main.js").write <<~JS
      console.log("Hello, world!");
    JS

    assert_match "Converted AST", shell_output("#{bin}/astgen -t js -i . -o #{testpath}/out")
    assert_match "\"fullName\":\"#{testpath}/main.js\"", (testpath/"out/main.js.json").read
    assert_match '"0:7":"Console"', (testpath/"out/main.js.typemap").read
  end
end
