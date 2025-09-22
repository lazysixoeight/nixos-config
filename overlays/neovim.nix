self: super: {
  neovim = super.neovim.overrideAttrs (oldAttrs: {
    nativeBuildInputs = [
      super.makeWrapper
      super.lndir
      super.autoPatchelfHook
    ];

    installPhase = ''
      wrapProgram $out/bin/nvim \
        --prefix LD_LIBRARY_PATH : "${
          super.lib.makeLibraryPath [
            super.brotli.lib
            super.zstd
            super.glib
            super.stdenv.cc.cc
          ]
        }" \
        --prefix PATH : "${
          super.lib.makeBinPath [
            super.clang
            super.rustup
          ]
        }"
    '';
  });
}

