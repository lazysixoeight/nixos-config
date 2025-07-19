self: super:
{
  lsp-plugins = super.lsp-plugins.overrideAttrs (oldAttrs: {
    configurePhase = ''
      runHook preConfigure

      make $makeFlags config FEATURES='vst3 doc ui'

      runHook postConfigure
    '';
    postInstall = ''
      rm -rf $out/share/applications
    '';
  });
}
