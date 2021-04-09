self: super: let
  arc = import ../canon.nix { inherit self super; isOverlay = true; };
in {
  arc = super.lib.recurseIntoAttrs arc // {
    _internal = super.arc._internal or { } // super.lib.dontRecurseIntoAttrs { };
  };
}
