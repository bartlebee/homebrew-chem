require 'formula'

class CairoRequirement < Requirement
  fatal false

  def satisfied?
    system("python", "-c", "import cairo")
  end

  def message; <<-EOS.undent
    Cairo is are required to export to certain formats. Homebrew provides these:
      brew install py2cairo
    EOS
  end

end

class Bkchem < Formula
  homepage 'http://bkchem.zirael.org/'
  url 'http://BKChem.zirael.org/download/bkchem-0.13.0.tar.gz'
  sha1 'ab38ba090682f36b1f34c7805f888c5c92e75186'
  head 'git://gitorious.org/bkchem/bkchem.git'

  devel do
    url 'http://bkchem.zirael.org/download/bkchem-0.14.0-pre2.tar.gz'
    version '0.14.0-pre2'
    sha1 '9c17e8cbd0443d55b82c32f27f5965dd014033c5'
  end

  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on 'Tkinter' => :python
  depends_on CairoRequirement.new

  # fix import issue on en locales. merge waiting upstream
  # https://gitorious.org/bkchem/bkchem/merge_requests/1
  def patches
    DATA
  end

  def install
    # In order to install into the Cellar, the dir must exist and be in the
    # PYTHONPATH.
    temp_site_packages = lib/which_python/'site-packages'
    mkdir_p temp_site_packages

    args = [
          "install",
          "--install-lib=#{temp_site_packages}",
          "--install-data=#{prefix}",
          "--install-scripts=#{bin}",
        ]

    system "python", "-s", "setup.py", *args

  end

  def test
    system "python", "-c", "import bkchem"
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def caveats
    <<-EOS.undent
      For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH

      If you want to be able to export graphics in PNG and PDF, you need cairo: `brew install py2cairo`.

    EOS
  end
end

__END__
diff --git a/bkchem/bkchem.py b/bkchem/bkchem.py
index 3baaed8..032c529 100644
--- a/bkchem/bkchem.py
+++ b/bkchem/bkchem.py
@@ -51,6 +51,7 @@ else:
 if user_lang == "en":
   import __builtin__
   __builtin__.__dict__['_'] = lambda m: m
+  __builtin__.__dict__['ngettext'] = gettext.ngettext
   Store.lang = "en"
 else:
   Store.lang = None
@@ -76,6 +77,7 @@ else:
   if not Store.lang:
     import __builtin__
     __builtin__.__dict__['_'] = lambda m: m
+    __builtin__.__dict__['ngettext'] = gettext.ngettext
     Store.lang = "en"
