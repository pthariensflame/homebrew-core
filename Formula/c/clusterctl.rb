class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "2dd129c839871dfc74142781ffcf8eeb465c56845e41e39105491c9a94770b6c"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags for this project because a version may not be
  # considered released until the GitHub release is created.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f589346cdf91e22abc09e204776c4ae1cf8fa783773871074a81113e3d03efd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f4d73fcfe0efd67b40676f724cbc5700efa8cf68dd5b76274a7dbf876a972b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "771e3af28d4bfdf2aa996e63f9237f2ae7085cd10924e467e21d7f7b33517525"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7c9c92de31e854247032459825330e0bedfdd67609708776652fdf004688ba3"
    sha256 cellar: :any,                 x86_64_linux:  "ebd3f4faed109e8ff13e870ae1c599c5fdc27b4f93470c0b631d1e6276347272"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X sigs.k8s.io/cluster-api/version.gitMajor=#{version.major}
      -X sigs.k8s.io/cluster-api/version.gitMinor=#{version.minor}
      -X sigs.k8s.io/cluster-api/version.gitVersion=v#{version}
      -X sigs.k8s.io/cluster-api/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/cluster-api/version.gitTreeState=clean
      -X sigs.k8s.io/cluster-api/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clusterctl"

    generate_completions_from_executable(bin/"clusterctl", "completion")
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "clusterctl requires either a valid kubeconfig or in cluster config to connect to " \
                 "the management cluster", output
  end
end
