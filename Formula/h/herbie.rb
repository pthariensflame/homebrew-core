class Herbie < Formula
  desc "Optimize floating-point expressions for accuracy"
  homepage "https://herbie.uwplse.org"
  url "https://github.com/herbie-fp/herbie/archive/refs/tags/v2.2.tar.gz"
  sha256 "299de07d9cbd9aa52726d7ed2e45f6beba140667a9aafb34d370235b8aa3fc60"
  license "MIT"

  depends_on "rust" => :build
  depends_on "minimal-racket"
  
  uses_from_macos "make"

  resource "rival" do
    url "https://github.com/herbie-fp/rival.git",
      branch: "main",
      revision: "ab743e1c5de1b17cb7d21ff27c4b6030811d1a3d"
    sha256 ""
  end

  def install
    cargo = Formula["rust"].bin/"cargo"
    raco = Formula["minimal-racket"].bin/"raco"
    resource("rival").stage "rival"

    system raco, "make", "rival/main.rkt"
    system raco, "exe", "-o", "rival/rival", "rival/main.rkt"
    system raco, "distribute", bin, "rival"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test herbie`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "false"
  end
end
