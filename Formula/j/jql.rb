class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v9.0.0.tar.gz"
  sha256 "ceaa31419230b51baef3b7084a8510c5fb985220cadcc9e93ed17f2b3b237039"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6518124fe4215be9eefdfb1c0fd95ebf9f8def08918236efe0306c77edeb71d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "010164323f907ac73b5086e5f6e63b0cde81f61707b05ebb4f9464ec02bb7b00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81f683f67fd1efc23ee8a5e521168b3398c67a4ffb7dd4618ad335bd06f6f31e"
    sha256 cellar: :any,                 arm64_linux:   "2635c70abdd884c653402e06bc3ee44a3f7ef8a8b178a1a92e9faddd820d7e78"
    sha256 cellar: :any,                 x86_64_linux:  "f409b30c23a15222818fcc99fee2baf322a2b4dc9e6afb98f2d95263e736f514"
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
