# BitWarden_RS Dropbox Nightly Backup
Run this image alongside your bitwarden_rs container for automated nightly (1AM UTC) backups of your BitWarden database and your attachments to your Dropbox account. Backups are encrypted (OpenSSL AES256) and zipped (`.tar.gz`) with a passphrase of your choice.

**IMPORTANT: Make sure you have at least one personal device (e.g. laptop) connected to Dropbox and syncing files locally. This will save you in the event Bitwarden goes down and your Dropbox account login was stored in Bitwarden!!!**

**Note:** Encrypting BitWarden backups is not required since the data is already encrypted with user master passwords. We've added this for good practice and added obfuscation should your Dropbox account get compromised.

## How to Use
- It's highly recommend you run via the `docker-compose.yml` provided.
- Pre-built images are available at `shivpatel/bitwarden_rs_dropbox_backup`.
- Volume mount the `./bwdata` folder your bitwarden_rs container uses.
- Volume mount the `./config` folder that will contain the Dropbox Uploader configuration (Dropbox app key, secret and refresh token). See Initial setup for more details.
- Pick a secure `BACKUP_ENCRYPTION_KEY`. This is for added protection and will be needed when decrypting your backups.
- Follow the steps below to grant upload access to your Dropbox account.
- This image will always run an extra backup on container start (regardless of cron interval) to ensure your setup is working.
- Interactive mode (see [Initial setup](#Initial-setup)) is only needed for the first run to create the configuration file. If you re-create the container with the same `./config` volume mount, the container will not need to be run in interactive mode. 
- Supports an optional `DELETE_AFTER` environment variable which is used to delete old backups after X many days. This job is executed with each backup cron job run.

### Initial setup
1. Open the following URL in your Browser, and log in using your account: https://www.dropbox.com/developers/apps
2. Click on "Create App", then select "Choose an API: Scoped Access"
3. Choose the type of access you need: "App folder"
4. Enter the "App Name" that you prefer (e.g. MyVaultBackups); must be unique
5. Now, click on the "Create App" button.
6. Now the new configuration is opened, switch to tab "permissions" and check "files.metadata.read/write" and "files.content.read/write"
7. Now, click on the "Submit" button.
8. Once your app is created, you can find your "App key" and "App secret" in the "Settings" tab.
9. Run the container in interactive mode (`docker run -it <...>`) to create the configuration. 
    
    If you are using a GUI like Portainer to create the container, you will need to attach to the container. The first input to provide once attached is the App key.

10. Follow the steps in the terminal.
11. Press `Ctrl+P` followed by `Ctrl+Q` to exit interactive mode / detach and keep the container running.

### Decrypting Backup
`openssl enc -d -aes256 -salt -pbkdf2 -in mybackup.tar.gz | tar xz --strip-components=1 -C my-folder`

### Restoring Backup to BitWarden_RS
Volume mount the decrypted `./bwdata` folder to your bitwarden_rs container. Done!
