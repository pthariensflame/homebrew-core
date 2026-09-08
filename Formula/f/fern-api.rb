class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.115.0.tgz"
  sha256 "2930eba139eb189170485953a1a4834030b62441d4aaac574957b84373476b9a"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dbd80968f282a53525d194f47e82adb1d57c658ed363ecaccc309a840dca3c8c"
    sha256 cellar: :any,                 arm64_sequoia: "dbd80968f282a53525d194f47e82adb1d57c658ed363ecaccc309a840dca3c8c"
    sha256 cellar: :any,                 arm64_sonoma:  "dbd80968f282a53525d194f47e82adb1d57c658ed363ecaccc309a840dca3c8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3b004bcd935c396411db1b2553cdf01a2f7618fdaf987b4900de8f47ea19b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b05d22683015ffa82861428dd0250fba46e0aae46ca23a66eb90a59a1e70cb4e"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
