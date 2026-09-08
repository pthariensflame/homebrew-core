class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.82.tar.gz"
  sha256 "54bb39ade72edf7243c0a0ba65a7fa33cbc8a2f1f69da42dbdfa0c548c106eff"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8158253c1f0e97ee9ec1b25f7a28d7d59b216eedb7fc3b3648b778936f639954"
    sha256 cellar: :any, arm64_sequoia: "cc0c03c37300eea87c8a53355a87ab4ca6dbea2c4b8c6043a819c270302ee585"
    sha256 cellar: :any, arm64_sonoma:  "5025aed516e2ca47d3815fde4a252e11c3c4a091597feb45fb6b2031ac7465ee"
    sha256 cellar: :any, arm64_linux:   "1ffb8d1b16dc5d8111e5c38e00a0b4c71fbdbd7c8487429215a1734770f69b7b"
    sha256 cellar: :any, x86_64_linux:  "57604a0b6f0313a8cd0fc919fb26a6c74a7a4e191eb1065209d24e5e3af440f7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end
