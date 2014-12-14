require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Oasa < Formula
  homepage 'http://bkchem.zirael.org/oasa_en.html'
  url 'http://bkchem.zirael.org/download/oasa-0.13.1.tar.gz'
  version '0.13.1'
  sha1 'ac4e19d47bf81d8431c6d3c0bcc5b72e8025961b'

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
    # were more thorough. Run the test with `brew test oasa`.
    system "false"
  end
end
