# hostdb-datastore
Terraform configuration files to manage the RDS instance used by hostdb-server application.

## Usage

The aws credentials must be in the environment, as well as a password and username for the HostDB application to use.
Add them through your own means or add them to file `creds`:

    cat << EOF > ./envs/<environment>/creds
    export AWS_ACCESS_KEY_ID="<ACCESS>"
    export AWS_SECRET_ACCESS_KEY="<SECRET>"
    export TF_VAR_HOSTDB_DATASTORE_USERNAME="app"
    export TF_VAR_HOSTDB_DATASTORE_PASSWORD="<SECRET>"
    EOF

Setup environment:

    source ./envs/<environment>/init.sh

Create build directory and initialize terraform:

    make init

This will copy all needed files to a build directory: `./build/$ENVIRONMENT/`.
This build directory is where all terraform commands are executed.

Run terraform plan:

    make plan

Run terraform apply:

    make apply

Run any custom terraform commands from the build directory:

    cd ./build/$ENVIRONMENT/
    terraform state list
