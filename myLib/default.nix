{
  lib,
  config,
  ...
}: rec {
  /*
  Gets the stem of a file path/name, i.e. the final component without an extension

  `path`: The file path or name

  ```nix
  getFileStem ./path/to/file.txt
  => "file"
  ```
  ```nix
  getFileStem "./path/to/dir"
  => "dir"
  ```
  */
  getFileStem = path: (builtins.head (builtins.split "\\." (builtins.baseNameOf path)));

  /*
  Extends the given module's options to introduce a default-false enable option, and wraps the
  module's config with a conditional of said enable option. If the module's config is empty, the
  module content is returned without modification.

  `optionPrefixPath`: A list of strings representing the attribute path the enable option should be
  declared under

  `moduleContent`: The module content to be wrapped

  ```nix
  wrapModuleWithEnableOption ["example" "z"] { foo = "bar"; };
  => {
    options.example.z.enable = lib.mkEnableOption "Enables z configuration";

    config = lib.mkIf config.example.z.enable { foo = "bar"; };
  }
  ```
  ```nix
  wrapModuleWithEnableOption
    ["example" "z" "y"]
    {
      imports = [ ./file.nix ];
      config = { baz = "qux"};
    }
  => {
      imports = [ ./file.nix ];
      options = {
        example.z.y.enable = lib.mkEnableOption "Enables y configuration";
      };
      config = lib.mkIf config.example.z.y.enable { baz = "qux"};
    }
  }
  ```
  ```nix
  wrapModuleWithEnableOption ["example" "foo"] {};
  => {};
  ```
  */
  wrapModuleWithEnableOption = optionPrefixPath: moduleContent: let
    enableOptionPath = optionPrefixPath ++ ["enable"];
    # Handles content with implicit `config` key in module, i.e. config at the top level
    moduleConfig = moduleContent.config or (builtins.removeAttrs moduleContent ["imports" "options"]);
  in
    if moduleConfig == {}
    then moduleContent
    else {
      imports = moduleContent.imports or [];

      options =
        lib.attrsets.recursiveUpdate
        (lib.attrsets.setAttrByPath
          enableOptionPath
          (lib.mkEnableOption "Enables ${lib.lists.last optionPrefixPath} configuration"))
        (moduleContent.options or {});

      config = lib.mkIf (lib.attrsets.getAttrFromPath enableOptionPath config) moduleConfig;
    };

  /*
  To be used in a module `imports` statement to recursively import all nix files from the given
  directory and wrap them with path-based default-false enable options. Directory-level options are
  also generated to coarsely control all sub-options. `default.nix` files found in the directory
  tree are ignored.

  `optionsPrefixPath`: A list of strings representing the attribute path the enable options should
  be declared under

  `dir`: The directory to import files from

  # Example
  With a file structure like
  ```
  foo/
    bar/
      a.nix
      b.nix
    c.nix
  ```
  the following module
  ```
  { imports = recursiveOptionedImport ["myOptions"] ./foo; }
  ```
  imports a.nix, b.nix, and c.nix where the following options are available:
  ```nix
  myOptions.bar.enable = true; # enables a.nix and b.nix content
  myOptions.bar.a.enable = true; # enables a.nix content
  myOptions.bar.b.enable = true; # enables b.nix content
  myOptions.c.enable = true; # enables c.nix content
  ```

  # Function details
  As all elements of the module system's `imports` are called with propagated module arguments, this
  function actually returns a list of lambda functions that are expecting said arguments in order to
  resolve into content.

  With the example above, the following
  ```nix
  imports = recursiveOptionedImport ["myOptions"] ./foo;
  ```
  roughly becomes
  ```nix
  imports = [
    {pkgs, lib, config, ...}: <bar module content>
    {pkgs, lib, config, ...}: <a.nix module content>
    {pkgs, lib, config, ...}: <b.nix module content>
    {pkgs, lib, config, ...}: <c.nix module content>
  ]
  ```
  where the module resolution system provides the arguments to each lambda function.
  */
  recursiveOptionedImport = optionsPrefixPath: dir:
    lib.mapAttrsToList
    (
      filename: filetype: let
        filepath = dir + "/${filename}";
        filesOptionPath = optionsPrefixPath ++ [(getFileStem filename)];
      in
        if filetype == "directory"
        then
          wrapModuleWithEnableOption filesOptionPath {
            imports = recursiveOptionedImport filesOptionPath filepath;
            config = enableChildOptionsByDefault filesOptionPath filepath;
          }
        # Have to explicitly include `pkgs` for it to be available in imported modules
        else {pkgs, ...} @ module_args: wrapModuleWithEnableOption filesOptionPath (import filepath module_args)
    )
    (readNixDir {inherit dir;});

  /*
  Helper function for `recursiveOptionedImport`, returns a directory's file list in the style of
  builtins.readDir but with non-nix files and `default.nix` files filtered out.

  `dir`: The directory to read files from

  `checkSubDirContents`: Default false option to exclude sub directories if they do not recursively
  contain any relevant nix files. Note this recursive check is somewhat inefficient.
  */
  readNixDir = {
    dir,
    checkSubDirContents ? false,
  }: let
    isNixFile = filename: lib.strings.hasSuffix ".nix" filename && (builtins.baseNameOf filename) != "default.nix";
    isDir = filetype: filetype == "directory";
    # TODO: Note how this inefficient
    containsNixFile = subdir: builtins.any isNixFile (lib.filesystem.listFilesRecursive subdir);
  in
    lib.filterAttrs
    (filename: filetype:
      if !checkSubDirContents
      then (isDir filetype || isNixFile filename)
      else ((isDir filetype && containsNixFile (dir + "/${filename}")) || isNixFile filename))
    (builtins.readDir dir);

  /*
  Helper function for `recursiveOptionedImport`, generates an attribute set of `lib.mkDefault true`
  statements for every expected child option based on the given directory's contents.

  `optionsPrefixPath`: A list of strings representing the attribute path the enable options are
  declared under

  `dir`: The directory containing files with expected child options
  */
  enableChildOptionsByDefault = optionsPrefixPath: dir: let
    children = readNixDir {
      inherit dir;
      checkSubDirContents = true;
    };
  in
    if children == {}
    then {}
    else
      lib.attrsets.setAttrByPath optionsPrefixPath (
        lib.attrsets.concatMapAttrs
        (childFilename: _: {${getFileStem childFilename}.enable = lib.mkDefault true;})
        children
      );
}
