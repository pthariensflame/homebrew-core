class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1307.2.tgz"
  sha256 "e45e6bbabf0161eba00fd90cf248f3c446a8f9ff183e835de3c9301fb7178924"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ac91b3a5b9b432da0f162060e17dfc29f5c47236a190470d528e9208437395e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ac91b3a5b9b432da0f162060e17dfc29f5c47236a190470d528e9208437395e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ac91b3a5b9b432da0f162060e17dfc29f5c47236a190470d528e9208437395e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe3e49d3e747c67c5c7393e32099a7b544e3fe9f4282ca388ed169b8de55e30d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eed7dd810ad34a46ce4596d3d384776c1957842589082f083dda28faa4984f1"
  end

  depends_on "node"

  def install
    # Highly dependents on npm scripts to install wrapper bin files
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove x86-64 ELF binaries on incompatible platforms
    # TODO: Check if these should be built from source
    rm(libexec.glob("lib/node_modules/snyk/dist/cli/*.node")) if !OS.linux? || !Hardware::CPU.intel?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "authentication failed (timeout)", output
  end
end
