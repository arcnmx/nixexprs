{
  go = { buildWeechatScript, pkgs }: buildWeechatScript {
    pname = "go.py";
    version = "2.6";
    sha256 = "0zgy1dgkzlqjc0jzbdwa21yfcnvlwx154rlzll4c75c1y5825mld";
  };
  auto_away = { buildWeechatScript, pkgs }: buildWeechatScript {
    pname = "auto_away.py";
    version = "0.4";
    sha256 = "02my55fz9cid3zhnfdn0xjjf3lw5cmi3gw3z3sm54yif0h77jwbn";
  };
  autosort = { buildWeechatScript, pkgs }: buildWeechatScript {
    pname = "autosort.py";
    version = "3.6";
    sha256 = "0i56y0glp23krkahrrfzrd31y3pj59z7skr1przlkngwdbrpf06r";
  };
  colorize_nicks = { buildWeechatScript, pkgs }: buildWeechatScript {
    pname = "colorize_nicks.py";
    version = "26";
    sha256 = "1ldk6q4yhwgf1b8iizr971vqd9af6cz7f3krd3xw99wd1kjqqbx5";
  };
  unread_buffer = { buildWeechatScript, pkgs }: buildWeechatScript {
    pname = "unread_buffer.py";
    version = "2";
    sha256 = "0xrds576lvvbbimg9zl17s62zg0nyymv4qnjsbjx770hcwbbyp2s";
  };
  urlgrab = { buildWeechatScript, pkgs }: buildWeechatScript {
    pname = "urlgrab.py";
    version = "3.0";
    sha256 = "1z940g7r5w7qsay5jl7mr4ra9nyw3cgp5398i9xkmd0cxqw9aiw7";
  };
  vimode = { buildWeechatScript, pkgs }: buildWeechatScript {
    pname = "vimode.py";
    version = "0.7";
    sha256 = "1ypn5hkz9n7qjmk22h86lz8sikf7a4wql08cc0540a5lwd4m2qgz";
  };
}
