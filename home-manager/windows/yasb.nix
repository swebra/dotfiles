{...}: {
  opt.windows.syncPaths = [
    # Trailing slash so contents are copied in
    ["${./yasb-config}/" ".yasb"]
  ];

  /*
  YASB Setup Instructions (https://github.com/da-rth/yasb#how-do-you-run-it):
  1. Install [Python 3.10](https://www.python.org/downloads/) in Windows
  2. Install dependencies
      1. Updated from PyQt6 6.3.1 to PyQt6 6.6.1 to work around "DLL load failed while importing QtCore" error, though it may have been installling through python directly instead of pip?
          ```powershell
          python -m pip install PyQt6 -U
          ```
      2. Updated from cssutils 2.5.1 to cssutils 2.6.0 to get CSS variable support
          ```powershell
          pip install -U cssutils==2.6.0
          ```
      ```powershell
      pip install -r requirements.txt
      ```
  Default configs copied from repo:
  - https://github.com/da-rth/yasb/blob/main/src/styles.css
  - https://github.com/da-rth/yasb/blob/main/src/config.yaml
  */
}
