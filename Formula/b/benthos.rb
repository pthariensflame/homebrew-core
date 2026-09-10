class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.80.0.tar.gz"
  sha256 "7797b9ed34176f836c8facbf9825317d4f1bf37495c2155d892da8189a7e7f1c"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de6fed65da96773870af9dc358da1e7c8e7d05ab947011e861dab08b99615641"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de6fed65da96773870af9dc358da1e7c8e7d05ab947011e861dab08b99615641"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de6fed65da96773870af9dc358da1e7c8e7d05ab947011e861dab08b99615641"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5b46cf161b061af788a748fd3fb4e438923b9207f76aee9919f353ff124cb21"
    sha256 cellar: :any,                 x86_64_linux:  "5e28344ff6db4e86d91d90a3b68243ac02a65954ae4ef362cf3d004b4e010649"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~YAML
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    YAML
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
