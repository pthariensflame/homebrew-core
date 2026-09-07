class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.17.9",
      revision: "4a3350b1b0c22aed821aef26fb3c078caf6f9ced"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "fac9ad188340b34aa82726e8e859ed3a934b4af78c21fe04fa9fab93f670822b"
    sha256               arm64_sequoia: "2cb83875a1525f0a5f1d10901a9b32f6c72c9212c7360bd30440a653584cc3f4"
    sha256               arm64_sonoma:  "e7af4ff5f3d544c86315ac17bc54e1849ec57eda5198a5cb853f73ec988d19aa"
    sha256 cellar: :any, arm64_linux:   "d6b393e1748bd4614238fa269f50ba07123e6d137e122b7df91033ec187f4d41"
    sha256 cellar: :any, x86_64_linux:  "870c852d2ac60668d85143ad216db7792fb8e1505c884de0ba30603be1e89dcc"
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
