
let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
in stdenv.mkDerivation {
  name = "HaskordEnv";
  buildInputs = with pkgs; [
    ghc
    cabal-install
    haskellPackages.ghcid
    gcc
    zlib.dev
    postgresql
  ];
  shellHook = ''
   alias repl="ghcid --command=cabal v2-repl"
    export PGDATA=$PWD/postgres_data
    export PGHOST=$PWD/postgres
    export LOG_PATH=$PWD/postgres/LOG
    export PGDATABASE=postgres
    export DATABASE_URL="postgresql:///postgres?host=$PGHOST"
    if [ ! -d $PGHOST ]; then
      mkdir -p $PGHOST
    fi
    if [ ! -d $PGDATA ]; then
      echo 'Initializing postgresql database...'
      initdb $PGDATA --auth=trust >/dev/null
    fi
    pg_ctl start -l $LOG_PATH -o "-c listen_addresses= -c unix_socket_directories=$PGHOST"  
  '';
  LD_LIBRARY_PATH="${pkgs.zlib}/lib";
}
