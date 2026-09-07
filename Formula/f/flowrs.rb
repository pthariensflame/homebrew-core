class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.15.2.tar.gz"
  sha256 "a2aaaac9f2652a23c7cdedfc8e750f225d72161884f8aaac9b91cac19ac487d6"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "335abe357cd34858e60a885e5c26137b75dc2b1f5fab9a5a21aeb52bca7eb969"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71488a39620eab3c463aedfc79280f9782d7891af948cc61dfb978598bdc7661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08777659b242ac2ef11115c33ef459bd93c890e45ee9b91582137b85d23fe7be"
    sha256 cellar: :any,                 arm64_linux:   "7a1ae7f22c3dd80f8dc42260752a66a3de4d8808abd04ed8294330a7f8e21d50"
    sha256 cellar: :any,                 x86_64_linux:  "858ca7aec05156b9b6545326b42c7b49f77a3e5e7b304084bd9865fb27635481"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
