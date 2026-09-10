class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.15.0.tgz"
  sha256 "18d27de69c7fb53b873d9a8eacb4f0fc24445710211c98c282ed986e5188c6cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "547d9cda161cec9fc9659223ca47cfda40db9bf0da013f9a6f52dedb219e1753"
    sha256 cellar: :any,                 arm64_sequoia: "547d9cda161cec9fc9659223ca47cfda40db9bf0da013f9a6f52dedb219e1753"
    sha256 cellar: :any,                 arm64_sonoma:  "547d9cda161cec9fc9659223ca47cfda40db9bf0da013f9a6f52dedb219e1753"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d5a1860f1a5eaa7254bcfa55f3e88a2d4ad3f1c9aac0e2efbca15f19c5f4781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f073a4ca33a5c2e3430ffc1d8c8a2ad94bcfec40b037b70a04b8f90ebb5b682"
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
