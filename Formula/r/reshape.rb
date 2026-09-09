class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "00899334c4aff1723b8176fe38d828d3d4af60e582c6de4cad77594eba3ae27f"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b67b6836ca9ffd2426f4776ee599371797e6eec96f6bab06b02b889cbb059115"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77df0cb00e5b1f2999382165f35882612a7f521f2c1782ed818b474e5b372a9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1117eb48f7fb7f607be706900a614d6c01e4bca63d26f0b412fb3e84d692e17c"
    sha256 cellar: :any,                 arm64_linux:   "d8b2077020c68767f4cc487e6ec564a5b9406cc11218588ae65a5c7a7099be5e"
    sha256 cellar: :any,                 x86_64_linux:  "0dcee6335ffc7decf91e3599c88bf0fa15e808302c3e08284cd0de0b3cd8db5d"
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
