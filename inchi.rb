require 'formula'

class InchiTest < Formula
  url 'http://www.inchi-trust.org/download/104/INCHI-1-TEST.zip'
  sha1 '6bb3db297747f631af558faf1d6788b233cb0ea1'
end

class Inchi < Formula
  homepage 'http://www.inchi-trust.org/'
  url 'http://www.inchi-trust.org/download/104/INCHI-1-API.zip'
  version '1.04'
  sha1 '46a99a532ae6fcec40efe20abafed0ed52d73c43'

  # option 'with-32-bit', 'Force 32-bit build'

  # Matt Swain (mcs07) patch for compiling libraries on OSX
  patch do
      url 'https://gist.githubusercontent.com/mcs07/6194763/raw/2edc62ed259fa8970a9c9bbd9b937afc2cf45f98/inchi-osx.diff'
      sha1 '33c09c38e5e45d88fa9a04b4289eb05a6c3b678b'
  end

  def install
    args = []
    # args << '-f makefile32' if build.include? 'with-32-bit'

    cd 'INCHI/gcc/inchi-1' do
        system "make", *args
    end

    bin.install('INCHI/gcc/inchi-1/inchi-1')

    cd 'INCHI_API/gcc_so_makefile' do
        system "make", "ISLINUX=1", *args
    end
    
    libexec.install('INCHI_API/gcc_so_makefile/result/libinchi.1.04.00.dylib')
    lib.install_symlink libexec/'libinchi.1.04.00.dylib' => 'libinchi.1.dylib'

    bin.install('INCHI_API/gcc_so_makefile/result/inchi_main')

  end

  def test
    system "inchi-1"
  end
end


__END__

diff --git a/INCHI_API/gcc_so_makefile/libinchi.map b/INCHI_API/gcc_so_makefile/libinchi.map
index 0526992..0f768c8 100755
--- a/INCHI_API/gcc_so_makefile/libinchi.map
+++ b/INCHI_API/gcc_so_makefile/libinchi.map
@@ -1,5 +1,32 @@
-{
-global: CheckINCHI; CheckINCHIKey; FreeINCHI; FreeStdINCHI; FreeStructFromINCHI; FreeStructFromStdINCHI; Free_inchi_Input; Free_std_inchi_Input; GetINCHI; GetINCHIKeyFromINCHI; GetINCHIfromINCHI; GetStdINCHI; GetStdINCHIKeyFromStdINCHI; GetStringLength; GetStructFromINCHI; GetStructFromStdINCHI; Get_inchi_Input_FromAuxInfo; Get_std_inchi_Input_FromAuxInfo; INCHIGEN_Create; INCHIGEN_Destroy; INCHIGEN_DoCanonicalization; INCHIGEN_DoNormalization; INCHIGEN_DoSerialization; INCHIGEN_Reset; INCHIGEN_Setup; STDINCHIGEN_Create; STDINCHIGEN_Destroy; STDINCHIGEN_DoCanonicalization; STDINCHIGEN_DoNormalization; STDINCHIGEN_DoSerialization; STDINCHIGEN_Reset; STDINCHIGEN_Setup; 
-local: *;
-};
-
+_CheckINCHI
+_CheckINCHIKey
+_FreeINCHI
+_FreeStdINCHI
+_FreeStructFromINCHI
+_FreeStructFromStdINCHI
+_Free_inchi_Input
+_Free_std_inchi_Input
+_GetINCHI
+_GetINCHIKeyFromINCHI
+_GetINCHIfromINCHI
+_GetStdINCHI
+_GetStdINCHIKeyFromStdINCHI
+_GetStringLength
+_GetStructFromINCHI
+_GetStructFromStdINCHI
+_Get_inchi_Input_FromAuxInfo
+_Get_std_inchi_Input_FromAuxInfo
+_INCHIGEN_Create
+_INCHIGEN_Destroy
+_INCHIGEN_DoCanonicalization
+_INCHIGEN_DoNormalization
+_INCHIGEN_DoSerialization
+_INCHIGEN_Reset
+_INCHIGEN_Setup
+_STDINCHIGEN_Create
+_STDINCHIGEN_Destroy
+_STDINCHIGEN_DoCanonicalization
+_STDINCHIGEN_DoNormalization
+_STDINCHIGEN_DoSerialization
+_STDINCHIGEN_Reset
+_STDINCHIGEN_Setup
diff --git a/INCHI_API/gcc_so_makefile/makefile b/INCHI_API/gcc_so_makefile/makefile
index 92e5911..a1915b8 100755
--- a/INCHI_API/gcc_so_makefile/makefile
+++ b/INCHI_API/gcc_so_makefile/makefile
@@ -19,16 +19,17 @@ endif
 # In addition, inchi.map restricts set of expoorted from .so
 # functions to those which belong to InChI API
 ifndef windir
-LINUX_MAP = ,--version-script=libinchi.map
+LINUX_MAP = ,-exported_symbols_list,libinchi.map
 ifdef ISLINUX
-LINUX_FPIC  = -fPIC
-LINUX_Z_RELRO = ,-z,relro
+LINUX_FPIC  = -fPIC -fno-common
+LINUX_Z_RELRO = 
 endif
 endif
 
 # === version ===
 MAIN_VERSION = .1
 VERSION = $(MAIN_VERSION).04.00
+COMPATIBILITY_VERSION = 1.04.00
 
 # === executable & library directory ===
 ifndef LIB_DIR
@@ -55,17 +56,17 @@ INCHI_MAIN_PATHNAME = $(LIB_DIR)/$(INCHI_MAIN_NAME)
 
 # === Linker to create (Shared) InChI library ====
 ifndef SHARED_LINK
-  SHARED_LINK = gcc -shared
+  SHARED_LINK = gcc -dynamiclib
 endif
 
 # === Linker to create Main program =====
 ifndef LINKER
   ifndef windir
   ifdef ISLINUX
-     LINKER_CWD_PATH = -Wl,-R,""
+     LINKER_CWD_PATH = 
   endif
   endif
-  LINKER = gcc -s $(LINKER_CWD_PATH)
+  LINKER = gcc $(LINKER_CWD_PATH)
 endif
 
 ifndef P_LIBR
@@ -136,9 +137,9 @@ $(INCHI_MAIN_PATHNAME) : $(INCHI_MAIN_OBJS) $(INCHI_LIB_PATHNAME).a
 
 else
 
-$(INCHI_MAIN_PATHNAME) : $(INCHI_MAIN_OBJS) $(INCHI_LIB_PATHNAME).so$(VERSION)
+$(INCHI_MAIN_PATHNAME) : $(INCHI_MAIN_OBJS) $(INCHI_LIB_PATHNAME)$(VERSION).dylib
 	$(LINKER) -o $(INCHI_MAIN_PATHNAME) $(INCHI_MAIN_OBJS) \
-  $(INCHI_LIB_PATHNAME).so$(VERSION) -lm
+  $(INCHI_LIB_PATHNAME)$(VERSION).dylib -lm
 
 endif
 
@@ -209,13 +210,13 @@ $(INCHI_LIB_PATHNAME).a: $(INCHI_LIB_OBJS)
 
 else
 
-$(INCHI_LIB_PATHNAME).so$(VERSION): $(INCHI_LIB_OBJS)
+$(INCHI_LIB_PATHNAME)$(VERSION).dylib: $(INCHI_LIB_OBJS)
 	$(SHARED_LINK) $(SHARED_LINK_PARM) -o \
-  $(INCHI_LIB_PATHNAME).so$(VERSION) \
+  $(INCHI_LIB_PATHNAME)$(VERSION).dylib \
   $(INCHI_LIB_OBJS) \
-  -Wl$(LINUX_MAP)$(LINUX_Z_RELRO),-soname,$(INCHI_LIB_NAME).so$(MAIN_VERSION)
-	ln -fs $(INCHI_LIB_NAME).so$(VERSION) \
-  $(INCHI_LIB_PATHNAME).so$(MAIN_VERSION)
+  -Wl$(LINUX_MAP)$(LINUX_Z_RELRO),-install_name,$(LIBDIR)/$(INCHI_LIB_NAME)$(MAIN_VERSION).dylib -Wl,-compatibility_version,$(COMPATIBILITY_VERSION)
+	ln -fs $(INCHI_LIB_NAME)$(VERSION).dylib \
+  $(INCHI_LIB_PATHNAME)$(MAIN_VERSION).dylib
 
 endif
 
