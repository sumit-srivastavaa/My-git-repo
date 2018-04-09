#!/bin/bash

__create_user() {
# Create a user to SSH into as.
useradd ansible
SSH_USERPASS=gfs2linux@999
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin ansible)
echo ssh ansible password: $SSH_USERPASS

}

# Call all functions
__create_user
