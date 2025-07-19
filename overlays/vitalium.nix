self: super:
{
  vitalium = super.distrho-ports.overrideAttrs (oldAttrs: {
    mesonFlags = [
      "-Dplugins=vitalium"
    ];
  });
}
