self: super: {
  ffmpeg = super.ffmpeg.override {
    withVulkan = true;
    withOpencl = true;
    withOpengl = true;
    withVaapi = true;
  };
}
