class CryptoKitCLI < Formula
  desc "CryptoKitCLI"
  homepage "https://github.com/alexruperez/CryptoKitCLI"
  url "https://github.com/alexruperez/CryptoKitCLI/archive/0.1.0.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  head "https://github.com/alexruperez/CryptoKitCLI.git"

  depends_on :xcode => "11.4"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
