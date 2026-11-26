class Slothmore < Formula
  desc "Local dashboard that starts web servers and runs scripts from folders"
  homepage "https://github.com/markusswedpal/slothmore"
  url "https://github.com/markusswedpal/slothmore/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "a3f7bf2399b6af8ad1566846ae95a6883432cf0748d3256fc58a7b4cae43145e"
  license "MIT"

  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    (bin/"slothmore").write <<~EOS
      #!/bin/bash
      exec "#{Formula["python@3.12"].opt_bin}/python3.12" "#{libexec}/bin/slothmore" "$@"
    EOS
  end

  service do
    run [opt_bin/"slothmore", "--no-open"]
    keep_alive true
    working_dir var
    log_path var/"log/slothmore.log"
    error_log_path var/"log/slothmore.log"
    environment_variables SLOTHMORE_SERVICE: "1"
  end

  test do
    assert_match "0.2.0", shell_output("#{bin}/slothmore --version")
  end
end
