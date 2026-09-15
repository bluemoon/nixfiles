{ lib, ... }:
{
  # New MacBook: native Accessibility API tiling, with SIP left enabled.
  services.yabai.enable = lib.mkForce false;
  services.yabai.enableScriptingAddition = lib.mkForce false;
  services.skhd.enable = lib.mkForce false;

  services.aerospace = {
    enable = true;
    settings = {
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer.left = 8;
        outer.right = 8;
        outer.top = 8;
        outer.bottom = 8;
      };
      on-window-detected = [
        { "if".app-id = "com.apple.systempreferences"; run = "layout floating"; }
        { "if".app-id = "com.apple.ActivityMonitor"; run = "layout floating"; }
      ];
      mode.main.binding = {
        cmd-enter = "exec-and-forget /usr/bin/open -a Ghostty";
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
        alt-shift-h = "swap left";
        alt-shift-j = "swap down";
        alt-shift-k = "swap up";
        alt-shift-l = "swap right";
        alt-x = "workspace-back-and-forth";
        alt-ctrl-q = "workspace prev";
        alt-ctrl-e = "workspace next";
        alt-t = "layout floating tiling";
        alt-d = "fullscreen";
        alt-shift-b = "balance-sizes";
        alt-shift-r = "reload-config";
      } // builtins.listToAttrs (lib.concatMap (n: [
        { name = "alt-${toString n}"; value = "workspace ${toString n}"; }
        { name = "alt-shift-${toString n}"; value = "move-node-to-workspace ${toString n}"; }
      ]) (lib.range 1 8));
    };
  };
}
