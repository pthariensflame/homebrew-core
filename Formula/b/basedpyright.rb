class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://docs.basedpyright.com"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.40.0.tgz"
  sha256 "c0b77ad073a62247fa9201403a2fcbaf4ee20afb400719052aa36079e5faf19e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cdfea7794605dd7cbccbe46e1ca5dcd726d9bda43b1ca10324c02e5ef3ac09ae"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"

    # Remove empty folder to make :all bottle
    rm_r libexec/"lib/node_modules/basedpyright/node_modules" if OS.mac?
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = shell_output("#{bin}/basedpyright broken.py 2>&1", 1)
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
