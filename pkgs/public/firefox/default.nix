{
  /*firefox-userChromeJS = { fetchFromUrl }: writeText "userChromeLoader.js" ''
    const {Services} = ChromeUtils.import('resource://gre/modules/Services.jsm');
    //const {OS} = ChromeUtils.import('resource://gre/modules/osfile.jsm');
    const NS_APP_USER_CHROME_DIR = "UChrm";

    if (!Services.appinfo.inSafeMode && Services.prefs.getBoolPref("arc.userChromeJS.enabled", true)) {
      const userChrome = Services.dirsvc.get(NS_APP_USER_CHROME_DIR, Ci.nsIFile);
      userChrome.appendRelativePath("userChrome.js");

      if (userChrome.exists()) {
        //const uri = OS.Path.toFileURI(userChrome.path);
        const uri = Services.io.getProtocolHandler("file").QueryInterface(Ci.nsIFileProtocolHandler).getURLSpecFromFile(userChrome);

        // see also: ChromeUtils.import(uri)
        Services.scriptloader.loadSubScriptWithOptions(
          uri,
          { target: globalThis, ignoreCache: true }
        );
      }
    }
  '';*/
  userChromeJS = { runCommand, writeText, lib }: with lib; let
    manifest = writeText "chrome.manifest" ''
      content userchromejs ./
      resource userchromejs ./res
    '';
    drv = runCommand "userchromejs" {
      inherit manifest;
      userchrome = ./userChrome.jsm;
    } ''
      mkdir -p $out/res

      ln -s $manifest $out/chrome.manifest
      ln -s $userchrome $out/userChrome.jsm
    '';
  in drvPassthru (drv: {
    js = writeText "userChromeLoader.jsm" ''
      let EXPORTED_SYMBOLS = [];
      const manifest = Cc["@mozilla.org/file/local;1"].createInstance(Ci.nsIFile);
      manifest.initWithPath("${drv}/chrome.manifest");
      Components.manager.QueryInterface(Ci.nsIComponentRegistrar).autoRegister(manifest);
      ChromeUtils.import("chrome://userchromejs/content/userChrome.jsm");
    '';
  }) drv;
}
