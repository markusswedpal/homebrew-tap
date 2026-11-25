class Slothmore < Formula
  desc "Local dashboard that starts web servers and runs scripts from folders"
  homepage "https://github.com/markusswedpal/slothmore"
  url "https://github.com/markusswedpal/slothmore/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "dfeb155924f2551944c1601cafd15b895149a9931da568f8862f62fe49b1395c"
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
    assert_match "0.1.0", shell_output("#{bin}/slothmore --version")
  end
end
