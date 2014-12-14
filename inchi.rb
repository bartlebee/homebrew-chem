require 'formula'

class InchiTest < Formula
  url 'http://www.inchi-trust.org/fileadmin/user_upload/software/inchi-v1.04/INCHI-1-TEST.ZIP'
  sha1 '952e0950d40bb141357be88a63f4cbb58258a4f5'
end

class Inchi < Formula
  homepage 'http://www.inchi-trust.org/'
  url 'http://www.inchi-trust.org/fileadmin/user_upload/software/inchi-v1.04/INCHI-1-API.ZIP'
  version '1.04'
  sha1 '46a99a532ae6fcec40efe20abafed0ed52d73c43'

  option '32-bit', 'Force 32-bit build'

  def install

    args = []
    args << '-f makefile32' if build.include? 'with-32-bits'

    cd 'INCHI/gcc/inchi-1' do
        system "make", *args
    end

    bin.install('INCHI/gcc/inchi-1/inchi-1')
  end

  def test

    system "inchi-1"
  end
end
