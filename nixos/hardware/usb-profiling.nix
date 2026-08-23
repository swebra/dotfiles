{pkgs, ...}: {
  # Use a fork of usbtop with better units
  # https://github.com/aguinet/usbtop/pull/46
  nixpkgs.overlays = [
    (final: prev: {
      usbtop = prev.usbtop.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "thomaslienbacher";
          repo = "usbtop";
          rev = "output-formatting";
          hash = "sha256-FEQ7L0wgWkctE7Sp6FeUgkW0KMpIJN2omqZBs+9bjXM=";
        };
      };
    })
  ];

  programs.usbtop.enable = true;

  environment.systemPackages = [pkgs.usbutils];
}
/*
Based on experimentation informed by
- https://askubuntu.com/questions/279689/how-do-you-interpret-the-lsusb-output
- https://askubuntu.com/questions/279689/how-do-you-interpret-the-lsusb-output
... a couple notes on build-two:
- MOBO has 2 USB controllers
- Each controller has 2 buses, a USB 3 bus and a USB 1/2 bus for backwards compat
- Controller 1: Bus 1/2, controller 2: Bus 3/4
- Front USB seems to be connected to buses 1/2 / controller 1
- Monitor KVM seems to be connected to buses 3/4 / controller 2
- MOBO bluetooth is connected via an internal USB connection on bus 1
  - A high-bandwidth USB device (like webcam) can pull bluetooth down

Based on lsusb and usbtop:
- Logi mouse: <10 KiB/s, USB 1
- Razer mouse: 70 KiB/s, USB 1
- DAC/AMP: 540 KiB/s to device, 285 KiB/s from device, USB 2
- Webcam: 140 KiB/s to device, 115 MiB/s from device, USB 3

USB 1 is around ~1.4 MiB/s (half duplex)
USB 2 is around ~35 MiB/s (half duplex)
USB 3 is has practical limit of ~450/500 MiB/s (full duplex, i.e. both ways)
*/

