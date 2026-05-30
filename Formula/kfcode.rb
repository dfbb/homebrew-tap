class Kfcode < Formula
  desc "KFCode CLI — an AI-powered coding agent"
  homepage "https://github.com/dfbb/KFCode"
  version "0.1.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/dfbb/KFCode/releases/download/v0.1.3/kfcode-cli-aarch64-apple-darwin.tar.gz"
    sha256 "e27e97cfaaa640e19f1bee3def5dba0d179104b1aa415933a71cca9c2138c927"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/dfbb/KFCode/releases/download/v0.1.3/kfcode-cli-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "b4fcd587cd563eaf368930d9e18a7eed37c459f696aa6489cbc4cef0b7a56164"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "kfcode" if OS.mac? && Hardware::CPU.arm?
    bin.install "kfcode" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
