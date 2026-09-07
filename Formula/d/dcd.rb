class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.18.1",
      revision: "314f469490aee868a9f7ca6e8be90b766e401909"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "77918abb3622b57bfee2e2238a4ab7988b319b67c858f5f1ced5aaa0d9ab00e9"
    sha256               arm64_sequoia: "965b8ef733cf96b516a89fae98c25fd49087c513fb4c0bc030f79a25f0418135"
    sha256               arm64_sonoma:  "9939b2afdec9f9cd149760a895a355223b3193435aeb54a5fea53e2f6c4d2452"
    sha256 cellar: :any, arm64_linux:   "76decb17acfcd8328f61dff3ac14f0452abdbb706060725ba7b7d81a4b76cebb"
    sha256 cellar: :any, x86_64_linux:  "56d59cbf3f72f76b02811be788cc949d8f9d8b19b79272bc7db976341e54f218"
  end

  depends_on "ldc" => :build

  def install
    system "make", "ldc"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = spawn bin/"dcd-server", "-p", port.to_s
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system bin/"dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
