{ fetchgit }:

[
  {
    name = "spork";
    src = fetchgit {
      url = "https://github.com/janet-lang/spork";
      rev = "4c77afc17eb5447a1ae06241478afe11f7db607d";
      hash = "sha256-nYSCWX262nhWn9hfd+kqnkH8ydN+DYg/XbCmGkozYZM=";
    };
    deps = [ ];
  }
]
