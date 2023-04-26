class VulkanCapsViewer < Formula
  desc "Vulkan hardware capability viewer application"
  homepage "https://vulkan.gpuinfo.org/download.php"
  url "https://github.com/SaschaWillems/VulkanCapsViewer/archive/refs/tags/3.29.tar.gz"
  sha256 "cc63b4bdbf9bb778eeee7ead460ef31e7eba799aa9d8bac7ad000b5f49156906"
  license "LGPL-3.0-only"
  head "https://github.com/SaschaWillems/VulkanCapsViewer.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "php" => :build
  depends_on "vulkan-headers"
  depends_on "vulkan-loader"
  depends_on "qt@5"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    # remove probably-outdated headers and use current ones
    rm_rf "Vulkan-Headers"
    cd "tools" do
      inreplace "deviceExtensionsFileGenerator.php" do |s|
        s.gsub! "simplexml_load_file(\"..\\\\Vulkan-Headers\\\\registry\\\\vk.xml\")",
                "simplexml_load_file(\"#{Formula["vulkan-headers"].share}/vulkan/registry/vk.xml\")"
        s.gsub! "$output_dir = \"..\\\\\";",
                "$output_dir = \"#{buildpath}\";"
        s.gsub! "$output_dir.\"VulkanDeviceInfoExtensions.cpp\"",
                "$output_dir.\"/VulkanDeviceInfoExtensions.cpp\""
      end
      system "php", "deviceExtensionsFileGenerator.php"
    end
    
    system "cmake", "-S", ".", "-B", "build",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
                    "-DVULKAN_LOADER_INSTALL_DIR=#{Formula["vulkan-loader"].prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "false"
  end
end
