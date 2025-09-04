self: super:
{
  distrho-ports = super.distrho-ports.overrideAttrs (oldAttrs: {
    mesonFlags = [
      "-Dplugins=vitalium"
    ];
  });
}
