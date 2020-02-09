class HgFlow < Formula
  desc "Development model for mercurial inspired by git-flow"
  homepage "https://hg.sr.ht/~wu/hgflow"
  url "https://hg.sr.ht/~wu/hgflow", :using => :hg, :branch => "v0.9.8.5"
  version "0.9.8.5"
  head "https://hg.sr.ht/~wu/hgflow", :using => :hg, :branch => "develop"

  bottle :unneeded

  depends_on "mercurial"
  depends_on "python"

  def install
    libexec.install "src/hgflow.py" => "hgflow.py"
  end

  def caveats; <<~EOS
    1. Put following lines into your ~/.hgrc
    2. Restart your shell and try "hg flow".
    3. For more information go to #{homepage}

        [extensions]
        flow = #{opt_libexec}/hgflow.py
        mq =
        [flow]
        autoshelve = true

  EOS
  end

  test do
    (testpath/".hgrc").write <<~EOS
      [extensions]
      flow = #{opt_libexec}/hgflow.py
      mq =
      [flow]
      autoshelve = true
    EOS
    system "hg", "init"
    system "hg", "flow", "init", "-d"
  end
end
