class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.39.3.tar.gz"
  sha256 "683af636b37f28b4a35175b542fa8093a3502a555cab5b09338732640c4ec6d3"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e38f0ca1d37a6c0b7cf57df9801e424eaf61d114f9f8069de7fa6f2e7ea9fdac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e38f0ca1d37a6c0b7cf57df9801e424eaf61d114f9f8069de7fa6f2e7ea9fdac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e38f0ca1d37a6c0b7cf57df9801e424eaf61d114f9f8069de7fa6f2e7ea9fdac"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0486dfe1ff9d5fe646ad387291525a88caa8786871816762040e907efda97d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "392dc351bf0aa92b2841bb388b9c92dbe57ae9b9d2160a60756281d932de373d"
    sha256 cellar: :any,                 x86_64_linux:  "e94f2461be333d722cd0d983b622ea975bbd95946224bcd616a8726cfd618c96"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/weaviate/weaviate/usecases/build.Version=#{version}
      -X github.com/weaviate/weaviate/usecases/build.BuildUser=#{tap.user}
      -X github.com/weaviate/weaviate/usecases/build.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/weaviate-server"
  end

  test do
    port = free_port
    pid = spawn bin/"weaviate", "--host", "0.0.0.0", "--port", port.to_s, "--scheme", "http"
    sleep 10
    assert_match version.to_s, shell_output("curl localhost:#{port}/v1/meta")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
