require 'formula'

class OPSINRequirement < Requirement
	def satisfied?
		#system "python", "-c", "from cinfony import opsin; mol = opsin.readstring("iupac", "2-chloro-propane"); print mol.write("smi");"
	end

	def fatal?
		false
	end
end

class IndigoRequirement < Requirement
	def fatal?
		false
	end
end

class JChemRequirement < Requirement
	def fatal?
		false
	end
end

class RDKRequirement < Requirement
	def fatal?
		false
	end
end

class CDKRequirement < Requirement
	def fatal?
		false
	end
end

class Cinfony < Formula
  homepage 'http://code.google.com/p/cinfony/'
  url 'http://cinfony.googlecode.com/files/cinfony-1.2.tar.gz'
  sha1 '4c515449884697d2552818b822372a7c27f3a8ad'
  head 'http://cinfony.googlecode.com/svn/trunk'

	depends_on 'open-babel'
	depends_on 'py2cairo'
	depends_on 'pil'
	depends_on OPSINRequirement.new
	depends_on IndigoRequirement.new
	depends_on JChemRequirement.new
	depends_on RDKRequirement.new
	depends_on CDKRequirement.new

  def install
    # In order to install into the Cellar, the dir must exist and be in the
    # PYTHONPATH.
    temp_site_packages = lib/which_python/'site-packages'
    mkdir_p temp_site_packages
    #ENV['PYTHONPATH'] = temp_site_packages

    args = [
      "install",
      "--install-lib=#{temp_site_packages}",
    ]

    system "python", "-s", "setup.py", *args
  end

  def test
    system "python", "-s", "test/testall.py"
  end

  def caveats
    <<-EOS.undent
      For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH

      If you want to be able to export graphics in PNG and PDF, you need cairo: `brew install py2cairo`.

    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

end
