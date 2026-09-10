class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.14.0.tgz"
  sha256 "d4406a7124daa668292571f05ef333e29ded352c2e2b967a9bafff7e0913301b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8cca50d8573a4514279747ae91eae9680104151be14e3b53bc56143e34a2d06f"
    sha256 cellar: :any,                 arm64_sequoia: "8cca50d8573a4514279747ae91eae9680104151be14e3b53bc56143e34a2d06f"
    sha256 cellar: :any,                 arm64_sonoma:  "8cca50d8573a4514279747ae91eae9680104151be14e3b53bc56143e34a2d06f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3982d38b70b5f82ddfd1495aa0c60b69437f9a7190d2de36ffc67201f718a1cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e714b4688eeacf2cc6961b29297254cb3d602f526a29bdfbba1a65a90fb116ae"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    proxy_arch = Hardware::CPU.intel? ? "amd64" : "arm64"
    ["@vercel/go", "@vercel/rust"].each do |package|
      (node_modules/package/"bin").glob("**/proxy-*").each do |f|
        next if OS.linux? && f.basename.to_s == "proxy-linux-#{proxy_arch}"

        rm f
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
