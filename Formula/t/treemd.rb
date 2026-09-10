class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "c1672f478382c343d41d49ef635b3dc34bb2d123b73821811ab6a926c7e1ce22"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16df77f66956b30d7561e1574d0f6cf7b23b88303bb5c1f776666ce7f53f91ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "571e60744f8f4a7b992b9c54b558a7d33a9c11be05b3310c65befce0515e21bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dba538a74e02fc5c5b6571056ce36b14fba2f625473a3f68b6b0f39b4e6d90f"
    sha256 cellar: :any,                 arm64_linux:   "caec8593cd672b2f765b81ed7327565fc38413f50b958a227ecaca7d26a8f763"
    sha256 cellar: :any,                 x86_64_linux:  "f434f192af10541b9ddec249aede6cbe4a11f0c4209d05f0b0f43e7f7a8176a3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treemd --version")

    (testpath/"test.md").write("# Test Heading\n\nThis is a test paragraph.")

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"treemd", testpath/"test.md", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn("#{bin}/treemd #{testpath}/test.md > #{output_log}")
        r.winsize = [80, 43]
      end
      sleep 3
      assert_match "treemd - test.md - 1 headings", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
