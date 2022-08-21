class Openvr < Formula
  desc "Virtual Reality SDK from Valve"
  homepage "http://steamvr.com"
  url "https://github.com/ValveSoftware/openvr/archive/refs/tags/v1.23.7.tar.gz"
  sha256 "cbe2afbfc9ed9c6c5ed7df7929f9b1f5ecfd858b849b377005d4881b72b910b3"
  license "BSD-3-Clause"
  head "https://github.com/ValveSoftware/openvr.git", branch: "master"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    cd "build" do
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
