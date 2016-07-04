class Gismo < Formula
  desc ""
  homepage "http://gismo.igs.umaryland.edu/"
  url "http://gismo.igs.umaryland.edu/downloads/gismo_v2.0.tar"
  version "2.0"
  sha256 "537c07bebeaba58417b2be20354e3e7e17f4efbd4168b47777d75e6d4d9a3dce"

  def install
      bin.install "gismo.mac" => "gismo"
  end

  test do
    system "gismo"
  end
end
