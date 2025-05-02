self: super: {
  cardinal = super.cardinal.override {
    libjack2 = super.pipewire.jack;
  };
}

