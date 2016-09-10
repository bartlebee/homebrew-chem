class Relax < Formula
  homepage "http://www.nmr-relax.com/"
  url "http://download.gna.org/relax/relax-4.0.2.src.tar.bz2"
  version "4.0.2"
  sha256 "7c12582ffb021ce728c5c4927c7dbb386bdb7121634eb30f687e5524e4bc4919"
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
