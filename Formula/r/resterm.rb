class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "568263f5ecb6525f642aa0e7dc691deb193a9363838c31cc6bdbc1ee08f64f8c"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cb472acacc8afb0eccf4e4f4d683b8d6b07c9310e76d6f6153747fe94ba4f48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cb472acacc8afb0eccf4e4f4d683b8d6b07c9310e76d6f6153747fe94ba4f48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cb472acacc8afb0eccf4e4f4d683b8d6b07c9310e76d6f6153747fe94ba4f48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9278cef9f421314c57bc2f1752719050f4da67104631cffd6b73e5a229c288d6"
    sha256 cellar: :any,                 x86_64_linux:  "933c59f96815431d1e5e232701168a9cdf4581cae3dd8769ef51bc24d93d877b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/resterm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resterm -version")

    (testpath/"openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
        description: A simple test API
      servers:
        - url: https://api.example.com
          description: Production server
      paths:
        /ping:
          get:
            summary: Ping endpoint
            operationId: ping
            responses:
              "200":
                description: Successful response
                content:
                  application/json:
                    schema:
                      type: object
                      properties:
                        message:
                          type: string
                          example: "pong"
      components:
        schemas:
          PingResponse:
            type: object
            properties:
              message:
                type: string
    YAML

    system bin/"resterm", "--from-openapi", testpath/"openapi.yml",
                          "--http-out",     testpath/"out.http",
                          "--openapi-base-var", "apiBase",
                          "--openapi-server-index", "0"

    assert_match "GET {{apiBase}}/ping", (testpath/"out.http").read
  end
end
