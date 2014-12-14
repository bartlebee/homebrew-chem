require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Rdkit < Formula
  homepage 'http://www.rdkit.org/'
  url 'http://rdkit.googlecode.com/files/RDKit_2012_12_1beta1.tgz'
  version '2012.12'
  sha1 'c2c2f9e505f1bee8ec768202017c234cda541f29'
  # HEAD 'svn://svn.code.sf.net/p/rdkit/code/trunk'

  # depends_on 'cmake' => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test RDKit_20`.
    system "false"
  end
end
