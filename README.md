# BitWarden_RS Dropbox Nightly Backup
Run this image alongside your bitwarden_rs container for automated nightly (1AM UTC) backups of your BitWarden database to your Dropbox account. Backups are encrypted (OpenSSL AES256) and zipped (`.tar.gz`) with a passphrase of your choice.

**IMPORTANT: Make sure you have at least one personal device (e.g. laptop) connected to Dropbox and syncing files locally. This will save you in the event Bitwarden goes down and your Dropbox account login was stored in Bitwarden!!!**

**Note:** Encrypting BitWarden backups is not required since the data is already encrypted with user master passwords. We've added this for good practice and added obfuscation should your Dropbox account get compromised.

## How to Use
- It's highly recommend you run via the `docker-compose.yml` provided.
- Pre-built images are available at `shivpatel/bitwarden_rs_dropbox_backup`.
- You only need to volume mount the `.sqlite3` file your bitwarden_rs container uses.
- Pick a secure `BACKUP_ENCRYPTION_KEY`. This is for added protection and will be needed when decrypting your backups.
- A `DROPBOX_ACCESS_TOKEN` access token will be needed to upload to your Dropbox account.
- To run backups on a different interval/time, modify the `Dockerfile` and build a custom image.
- This image will always run an extra backup on container start (regardless of cron interval) to ensure your setup is working.

### Generating Dropbox Access Token
1. Visit: https://www.dropbox.com/developers/apps
2. Click on "Create App", then select "Dropbox API App".
4. Complete configuration and pick an app name (e.g. MyVaultBackups).
6. Once your app is created, click the Generate button under 'Generated access token'.
7. This token should be provided to the container as `DROPBOX_ACCESS_TOKEN` env var.

### Decrypting Backup
`openssl enc -d -aes256 -salt -pbkdf2 -in mybackup.tar.gz | tar xz -C my-folder`

### Restoring Backup to BitWarden_RS
Volume mount the decrypted `.sqlite3` file to your bitwarden_rs container. Done!
