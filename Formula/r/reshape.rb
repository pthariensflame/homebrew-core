class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "260aba3b8272cef372c06cb7654b5635e178e965f6b0a804a37a25c0236ec120"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d99dcf90c805d636ff06d9499e99b79add177cbbbb272f7bcbb38ad61ade3b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ca22277d1f9370e2ef74d231077626cee90790b76ec982d542c613fccb8afcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80bbeb336c832c8d5744ec9a6898d0e8a81bd1d413e169b6d2a493bb049dbb1c"
    sha256 cellar: :any,                 arm64_linux:   "d3ac98d8202ad4e7b95db5e35a3da9711f27422b839ef0119139275f711d5caa"
    sha256 cellar: :any,                 x86_64_linux:  "d97ef05e5d03bbc59957254d78a77b823e37db74e6fb234123358a54d2d31d34"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build pg_query

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"migrations/test.toml").write <<~TOML
      [[actions]]
      type = "create_table"
      name = "users"
      primary_key = ["id"]

        [[actions.columns]]
        name = "id"
        type = "INTEGER"
        generated = "ALWAYS AS IDENTITY"

        [[actions.columns]]
        name = "name"
        type = "TEXT"
    TOML

    assert_match "SET search_path TO migration_test",
      shell_output("#{bin}/reshape generate-schema-query")

    assert_match "Error: error connecting to server",
      shell_output("#{bin}/reshape migrate 2>&1", 1)
  end
end
