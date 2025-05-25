self: super:
{
  renoise = super.renoise.overrideAttrs (oldAttrs: {
    nativeBuildInputs = with super; [
      makeBinaryWrapper
    ];

    postFixup = ''
      ${oldAttrs.postFixup}
      wrapProgram $out/bin/renoise \
        --prefix LD_LIBRARY_PATH : "${
          super.lib.makeLibraryPath [
            super.curl
          ]
        }"
    '';
  });
}
