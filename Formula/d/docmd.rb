class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.9.5.tgz"
  sha256 "1ace48c99c0c3f8375c2541d313ac8cf64a95f1a5ec7acd1c4c28441b9a153be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b27209ffab4d8e7a528f8df90d6a6e22f24ad2bcd27ee2bf4e448b4264251126"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@docmd/core/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.json"
    assert_match 'title: "Quick Start"', (testpath/"docs/index.md").read
  end
end
