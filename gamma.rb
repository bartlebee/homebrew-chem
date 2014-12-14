require "formula"

class Gamma < Formula
  homepage "http://scion.duhs.duke.edu/vespa/gamma"
  head "http://scion.duhs.duke.edu/guest_svn/gamma/trunk", :using => :svn

  head do
      patch :DATA
  end

  option "with-pygamma", "Builds pygamma interface to gamma"
  option "with-test", "Runs test suite after building"

  depends_on :python if build.with? "pygamma"
  depends_on "sip" if build.with? "pygamma"
  depends_on "swig" if build.with? "pygamma"

  def install
    args = %W[-C platforms/OSX]
    args << "SWIG_OPTIONS=-c++ -python -builtin" if build.with? "pygamma"

    system "make", *args
    system "make", "pysgdist", *args if build.with? "pygamma"
    system "make", "test", *args if build.with? "test"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make", "install", "INSTALLDIR=#{prefix}", *args

    if build.with? "pygamma"
      cd "pygamma"
      ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
      system "python", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
      if build.with? "pygamma"
        system "python", "-c", "import pygamma"
      end
  end

end

__END__
diff --git a/platforms/OSX/Makefile b/platforms/OSX/Makefile
index 8054ea4..b131e6b 100644
--- a/platforms/OSX/Makefile
+++ b/platforms/OSX/Makefile
@@ -126,8 +126,9 @@ WARNINGS = -Wall
 # the 10.5 SDK with Xcode 4.0. Since Xcode 4 is what most people have these
 # days, we set MIN_OSX_VERSION to a value compatible with that. If you have
 # Xcode 3.x, feel free to set MIN_OSX_VERSION = 10.5.
-MIN_OSX_VERSION = 10.6
-PLATFORM_FLAGS = -mmacosx-version-min=${MIN_OSX_VERSION} 
+MIN_OSX_VERSION = 10.9
+PLATFORM_FLAGS = -mmacosx-version-min=${MIN_OSX_VERSION} -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX${MIN_OSX_VERSION}.sdk
+
 
 
 CC       =    gcc
diff --git a/platforms/OSX/gamma b/platforms/OSX/gamma
index 78eddd4..fad20d4 100755
--- a/platforms/OSX/gamma
+++ b/platforms/OSX/gamma
@@ -99,7 +99,7 @@ GAMMA_LIB=${GAMMA_PATH}"/lib/gamma-"${GAMMA_VERSION}"/"
 
 CXX="g++"
 CXXFLAGS="-g -O3 -Wall"
-EXTRALIB="-framework veclib"
+EXTRALIB="-framework Accelerate"
 LDFLAGS=""
 NAME=
 GPROF=""
