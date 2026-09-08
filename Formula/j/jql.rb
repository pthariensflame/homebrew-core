class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v9.0.3.tar.gz"
  sha256 "271d340c39fb328eb22d3a1dd5151be99f1c38c2169ea28d5f9ebbdd40e4eb82"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a875d200bdf64b0aede44b1989434d6973e3cf1e6514610dc28989681058202"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9982e09e15a9ab126efe5fbc9da0eb5c18dc661c1b36ec3fefc6c93ecc807d1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fbd2a571e277027c26f401a92d21f87c75ef6844699719177b7182f74e582db"
    sha256 cellar: :any,                 arm64_linux:   "9ff1dcbd49eb975513839d8a94ace34bb2c3d17e834d96e501bbb57454446fbd"
    sha256 cellar: :any,                 x86_64_linux:  "051f6585208107a20c4258e8cd060c83deedf748bd41e6ee961c5fc421e94e99"
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
