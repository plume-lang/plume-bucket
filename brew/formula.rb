class Plume < Formula
  desc "Portable, powerful and easy to use programming language"
  homepage "https://github.com/plume-lang/plume"
  url "https://github.com/plume-lang/plume.git", tag: "0.4.2", revision: "2636c7c6b3291b42654cd1c62d660c0deaa0e2b3"
  license "MIT"
  head "https://github.com/plume-lang/plume.git", branch: "main"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build, version: "9.8.2"
  depends_on "python@3.12" => :build
  depends_on "xmake" => :build

  def install
    # Updating Cabal packages
    system "cabal", "update"

    # Building the project
    system "python3.12", "./scripts/build_project.py"
    
    # Installing the project
    ENV.prepend_path "PATH", bin
    prefix.install Dir["*"]
  end

  def post_install
    ohai "ℹ️  Add PLUME_PATH=#{prefix}/standard/ to your bashrc/zshrc"
  end

  test do
    # Check if `plumec` and `plume` are set up correctly
    system "which", "plumec"
    system "which", "plume"

    # Set the PLUME_PATH environment variable for the test
    ENV["PLUME_PATH"] = "#{prefix}/standard/"

    # Try compiling and running a simple Hello world program
    (testpath/"hello.plm").write <<~EOS
      println("Hello, world!")
    EOS

    system "plumec", "hello.plm"
    assert_equal "Hello, world!\n", shell_output("plume hello.bin")
  end
end
