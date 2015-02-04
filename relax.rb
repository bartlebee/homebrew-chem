class Relax < Formula
  homepage "http://www.nmr-relax.com/"
  url "http://download.gna.org/relax/relax-3.3.6.src.tar.bz2"
  version "3.3.6"
  sha1 "2eed0df4b0e64d6daf0d809f0a96fcb6d2a87409"
  head "svn://svn.gna.org/svn/relax/trunk", :using => :svn

  depends_on 'python'
  depends_on 'scons'
  depends_on 'numpy' => :python

  def install
      # sconstruct file doesn't include a --prefix method. Set brew defaults.
      inreplace "sconstruct" do |s|
        s.gsub! "# Mac OS X installation path.
    INSTALL_PATH = sys.prefix + sep + 'local'",
        "INSTALL_PATH = '#{prefix}'"
      end

      bin.mkdir
      scons
      scons "install"
  end

  test do
    system "relax"
  end
end
