class Slothmore < Formula
  desc "Local dashboard that starts web servers and runs scripts from folders"
  homepage "https://github.com/markusswedpal/slothmore"
  url "https://github.com/markusswedpal/slothmore/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "37e81e2ec1031b4b3a085a2f70d83aaf656b4901e3ae37e45118e174f8c9e8fb"
  license "MIT"

  # Whatever current Python Homebrew ships (3.12 to 3.15 are tested). The server uses only the standard library.
  depends_on "python@3"

  def install
    libexec.install Dir["*"]

    # The wrapper prefers the private venv (rumps + pyobjc for the menu bar icon and its quick panel) and falls back to
    # Homebrew's Python if the venv is missing or broken, for example after a Python upgrade.
    # SLOTHMORE_BIN is a path that survives upgrades; the menu bar login item uses it.
    (bin/"slothmore").write <<~EOS
      #!/bin/bash
      export SLOTHMORE_BIN="#{opt_bin}/slothmore"
      PY="#{opt_libexec}/venv/bin/python"
      if ! "$PY" -c "import sys" >/dev/null 2>&1; then
        PY="#{Formula["python@3"].opt_bin}/python3"
      fi
      exec "$PY" "#{opt_libexec}/bin/slothmore" "$@"
    EOS
  end

  # The menu bar icon (macOS only) needs rumps and pyobjc (Cocoa, plus WebKit for the quick panel). They are installed here, after Homebrew has
  # relocated the keg, from pinned, hash-checked wheels (macos/requirements-menubar.txt): nothing is compiled.
  # If this step fails (for example offline), Slothmore still works; run `brew postinstall slothmore` to retry.
  def post_install
    return unless OS.mac?

    venv = libexec/"venv"
    system Formula["python@3"].opt_bin/"python3", "-m", "venv", "--clear", venv
    ok = quiet_system venv/"bin/python", "-m", "pip", "install",
                      "--disable-pip-version-check", "--no-deps", "--require-hashes",
                      "--only-binary", "pyobjc-core,pyobjc-framework-Cocoa,pyobjc-framework-WebKit",
                      "-r", libexec/"macos/requirements-menubar.txt"
    opoo "Could not install the menu bar packages. Run `brew postinstall slothmore` to retry." unless ok
  end

  def caveats
    s = <<~EOS
      Open the dashboard:       slothmore
      Run it in the background: brew services start slothmore   (then: slothmore open)
    EOS
    if OS.mac?
      s += <<~EOS

        Menu bar icon:            slothmore menubar   (click: quick panel, right-click: menu)
        Start it at every login:  slothmore menubar --install-login
      EOS
    end
    s
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
    assert_match "0.2.3", shell_output("#{bin}/slothmore --version")
    assert_match "login item", shell_output("#{bin}/slothmore menubar --status")
  end
end
