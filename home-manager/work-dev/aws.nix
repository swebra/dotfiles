{
  pkgs,
  lib,
  private,
  ...
}: let
  private_aws = private.work.aws;
  sso_accounts = private_aws.sso.accounts;
  codeartifact_do = private_aws.codeartifact.domainOwner;
in {
  programs.awscli = {
    enable = true;

    settings =
      {
        "sso-session azure" = {
          sso_start_url = "https://drivewyze.awsapps.com/start";
          sso_region = "us-east-1";
          sso_registration_scopes = "sso:account:access";
        };

        default = {
          sso_session = "azure";
          sso_account_id = sso_accounts.default;
          sso_role_name = "AcctPowerUser";
        };
      }
      // # Extend the settings above with the additional profiles generated below
      lib.mapAttrs' (name: id:
        lib.nameValuePair "profile ${name}" {
          sso_session = "azure";
          sso_account_id = id;
          sso_role_name = "AcctPowerUser";
        })
      sso_accounts.others;
  };

  home.file.".docker/config.json".text = builtins.toJSON {
    credsStore = "ecr-login";
  };

  home.packages = with pkgs; [
    amazon-ecr-credential-helper
  ];

  programs.bash.shellAliases.aws-login = let
    # Create script sandbox where package managers (pip, etc.) are available for `aws codeartifact login`
    aws-config-package-managers = pkgs.writeShellApplication {
      name = "aws-config-package-managers";

      runtimeInputs = with pkgs; [
        python3Packages.pip
        nodejs
      ];

      # Skip shellcheck and default set -o errexit / pipefail
      checkPhase = "";
      bashOptions = ["nounset"];

      text = ''
        # https://docs.aws.amazon.com/codeartifact/latest/ug/python-configure-pip.html
        aws codeartifact login --tool pip --domain drivewyze --domain-owner ${codeartifact_do} --repository dw-central-pypi

        # https://docs.aws.amazon.com/codeartifact/latest/ug/npm-auth.html
        aws codeartifact login --tool npm --domain drivewyze --domain-owner ${codeartifact_do} --repository dw-central-npm
      '';
    };

    # Script specifically to be sourced (not otherwise ran) so environment variables are inherited
    aws-login = pkgs.writeText "aws-login.sh" ''
      export AWS_DEFAULT_REGION=us-east-1

      aws-set-codeartifact-vars() {
        export CODEARTIFACT_TOKEN=$(aws codeartifact get-authorization-token --domain drivewyze --domain-owner ${codeartifact_do} --query authorizationToken --output text)
        export PYPI_REPO="https://aws:''${CODEARTIFACT_TOKEN}@drivewyze-${codeartifact_do}.d.codeartifact.us-east-1.amazonaws.com/pypi/dw-central-pypi/simple/"
        export NPM_REPO="registry=https://drivewyze-${codeartifact_do}.d.codeartifact.us-east-1.amazonaws.com/npm/dw-central-npm/"$'\n'"//drivewyze-${codeartifact_do}.d.codeartifact.us-east-1.amazonaws.com/npm/dw-central-npm/:_authToken=''${CODEARTIFACT_TOKEN}"
        echo 'Set CODEARTIFACT_TOKEN, PYPI_REPO and NPM_REPO environment variables'
      }

      export AWS_PROFILE="''${1:-default}"

      ARN=$(aws sts get-caller-identity --query "Arn" 2> /dev/null)
      if [ $? -ne 0 ]; then  # If not already logged in
          aws sso login
          if [ $? -ne 0 ]; then
              return 1
          fi

          ${lib.getExe aws-config-package-managers}
      else
          echo 'Already logged in with following arn:'
          echo $ARN
      fi

      # Always set environment variables in current shell
      aws-set-codeartifact-vars
    '';
  in "source ${aws-login}";
}
