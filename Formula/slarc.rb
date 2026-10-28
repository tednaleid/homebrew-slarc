class Slarc < Formula
  desc "Archive Slack conversations you can see into searchable, re-renderable files"
  homepage "https://github.com/tednaleid/slarc"
  url "https://github.com/tednaleid/slarc/releases/download/v0.2.1/slarc-0.2.1.tar.gz"
  sha256 "fb24d943095db6fbd0129d2659750cf44c58d249ad1bdbfea5625ab3d0b8c3f4"
  license "MIT"

  depends_on "uv" => :build
  depends_on "python@3.15"

  # Installs the dependency versions locked in the sdist's uv.lock, verified by hash.
  def install
    ENV["UV_PYTHON_DOWNLOADS"] = "never"
    python = libexec/"bin/python"
    system "uv", "venv", libexec, "--python", formula_opt_bin("python@3.15")/"python3.15"
    system "uv", "export", "--frozen", "--no-dev", "--no-emit-project",
           "--output-file", "requirements.txt"
    system "uv", "pip", "install", "--python", python, "--require-hashes",
           "--requirement", "requirements.txt"
    system "uv", "pip", "install", "--python", python, "--no-deps", "."
    bin.install_symlink libexec/"bin/slarc"
  end

  test do
    assert_match "slarc #{version}", shell_output("#{bin}/slarc --version")
  end
end
