class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "d1f27fcbff28890800bc8e8fa4d15cb12d70448d1486f4a56dc86e06c1525629"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db22d6b4ba7fff47594a867c7ec81ab50489e16b45190a3209086c9b9fa365a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c9f3c68992746840ffdbca379fe4691c57fc43f425a42e8a976be333b4dba5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab0b47ed58794f384550de3381493950a7354cd8afc8f5821f1e9de8190ac8e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9482fce68c1132819b380aea1795cb2e70f31e9fe9982d1dc407c05f4360694"
    sha256 cellar: :any,                 arm64_linux:   "cc2e4c5b8bcb035b3d210149592e8d44f1195e38326136250590f25d675105d2"
    sha256 cellar: :any,                 x86_64_linux:  "ce23435b21baba082dbaa40ab180333bfc3510fb5079d225babc40bef9ce803c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@3"
  end

  deny_network_access! :test

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    features = ["image", "notify"]
    system "cargo", "install", *std_cargo_args(path: "spotify_player", features:)
    bin.install "target/release/spotify_player"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")

    assert_match "complete -F _spotify_player", shell_output("#{bin}/spotify_player generate bash")

    (testpath/"config/app.toml").write "client_id = 123\n"
    output = shell_output("#{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config 2>&1", 1)
    assert_match "invalid type: integer `123`, expected a string", output
  end
end
