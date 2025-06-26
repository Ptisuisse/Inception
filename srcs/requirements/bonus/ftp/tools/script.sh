#!/bin/bash

# Check for required environment variables
required_vars=("FTP_USER_NAME" "FTP_USER_PASS")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "ERROR: Required environment variable is missing: $var"
        exit 1
    fi
done

# Create the user if it doesn't exist, set home directory, and add to www-data group
if ! id "$FTP_USER_NAME" &>/dev/null; then
    useradd -m -d /var/www/wordpress -G www-data "$FTP_USER_NAME"
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to create user $FTP_USER_NAME."
        exit 1
    fi
else
    echo "User $FTP_USER_NAME already exists."
fi

# Set the user's password
echo "$FTP_USER_NAME:$FTP_USER_PASS" | chpasswd
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to set password for $FTP_USER_NAME."
    exit 1
fi

# Add the user to the vsftpd user list to allow login
> /etc/vsftpd.userlist
echo "$FTP_USER_NAME" >> /etc/vsftpd.userlist
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to write to /etc/vsftpd.userlist."
    exit 1
fi
echo "Contents of /etc/vsftpd.userlist:"
cat /etc/vsftpd.userlist

# Check for the vsftpd secure chroot directory
if [ ! -d "/var/run/vsftpd/empty" ]; then
    echo "FATAL ERROR: Directory /var/run/vsftpd/empty is missing!"
    exit 1
else
    echo "Directory /var/run/vsftpd/empty found."
fi

echo "--- Starting vsftpd ---"

# Start the vsftpd server in the foreground
exec /usr/sbin/vsftpd /etc/vsftpd.conf