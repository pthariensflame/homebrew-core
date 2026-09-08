class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v9.0.0.tar.gz"
  sha256 "ceaa31419230b51baef3b7084a8510c5fb985220cadcc9e93ed17f2b3b237039"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adc7527b8f1589109ff130df60fb683473b37f080c40ab4ad03fa2d24267ea07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4a3224f47ba20c0515069b4831981268ba9476ed97dabd96264f777f12d4507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c882aee0fd59bf11baa6acfaa26c04b368aa0e36915717a9c17870b971166a3a"
    sha256 cellar: :any,                 arm64_linux:   "33340f08b5eebd79a1c4790ddad2398ec20ea9654b832e52ce159d708e6b80b5"
    sha256 cellar: :any,                 x86_64_linux:  "d0034282ff49b964ea42758cadc66ba18453bfc9c208313d9e0aa650d4d98464"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jql")
  end

  test do
    (testpath/"example.json").write <<~JSON
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    JSON
    output = shell_output("#{bin}/jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end
