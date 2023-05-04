class Picolibc < Formula
  desc "C library designed for embedded systems, built for the host machine"
  homepage "https://keithp.com/picolibc/"
  url "https://github.com/picolibc/picolibc/releases/download/1.8.1/picolibc-1.8.1.tar.xz"
  sha256 "f5366cc5b0103769f518c06979be5e600d48d3f35d0cf2fe8a08098fb37447bb"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause",
    :public_domain,
    :cannot_represent, # assorted other licenses
  ]
  head "https://github.com/picolibc/picolibc.git", branch: "main"

  depends_on "llvm" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    ENV.llvm_clang

    args = std_meson_args
    args.delete_at(1) # remove conflicting libdir argument
    mkdir "build" do
      system "../scripts/do-native-configure",
             "-Dtests=false",
             *args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "false"
  end
end
