class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v1.18.2/pup_1.18.2_source.tar.gz"
  sha256 "3b61036177855a9e21f83c7865dd1099982d281f1d393fc442c86cbc812a24cd"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1c87584f7cb87f314bfd0cf1fd72837e45fa439b5158bd62945df04f7f8e59a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4233f4ae23eb68819e6d28131a344806c3a8a8e1581a33ba38164660836a519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31603b7f98308b67b7cebb8d47c3091d1187a32ba10184445dd7cf59e2b609e6"
    sha256 cellar: :any,                 arm64_linux:   "42cbc10140f6acf73b88030fd9f13b5fd036cf9193f4ccf99c87520fc61762d6"
    sha256 cellar: :any,                 x86_64_linux:  "137da30c4fb985edabd9ce8d1331353484e47f4db34e6260ed3f081f083833d8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
