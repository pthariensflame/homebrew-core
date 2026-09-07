class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "ec4a4b9a9db393792d8757471dd7ffcaf0e0f66efd9f3e52c0297086a4c38e48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8f54fdc161227970b4ac55779f835c18393ec0ef24c17616cf73986227a048c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76763270627f6d5ec4cdccdb3a9c254a914fde5ef5af0087139b1524a5bbfc6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98fc120b48dc7191960016317bd69cc53b8ba5c24d7c05c29c2cbcc86b58bee8"
    sha256 cellar: :any,                 arm64_linux:   "cfc589ad309b83d6e994926d0a300e792ab9326411c8d8d182ce15b32dbae494"
    sha256 cellar: :any,                 x86_64_linux:  "72feb6d365fd13f4b9573abf2d921bf673763378cb6318c2b926afd3dfb13b60"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Open3.popen2("script", "-q", "screenlog.ansi") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 130"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/netwatch"
      sleep 1
      # bring up help dialog
      input.puts "?"
      sleep 1
      input.close
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.ansi").read
    assert_match "topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end
