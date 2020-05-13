{ config, pkgs, lib, system, ... }: {
    options = {
        vscode.extensions = lib.mkOption { default = []; };
        vscode.user = lib.mkOption { };     # <- Must be supplied
        vscode.homeDir = lib.mkOption { };  # <- Must be supplied
    };

    config = {
        home.packages = [ pkgs.vscode ];

        home.activation.fix-vscode-extensions = config.lib.dag.entryAfter ["writeBoundary"] ''
            EXT_DIR=${config.vscode.homeDir}/.vscode/extensions
            $DRY_RUN_CMD mkdir -p $EXT_DIR
            $DRY_RUN_CMD chown ${config.vscode.user}:users $EXT_DIR
            for x in ${lib.concatMapStringsSep " " toString config.vscode.extensions}; do
                SRC_DIR=$(dirname $(find $x -not -path "*/node_modules/*" -name package.json))
                ln -sf $SRC_DIR $EXT_DIR/
            done
            $DRY_RUN_CMD chown -R ${config.vscode.user}:users $EXT_DIR
        '';
    };
}
