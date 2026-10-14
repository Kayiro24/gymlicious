# Security policy

Gymlicious keeps all user data on the device and has no server, so most risk is in the app itself, its backup files, and its dependencies.

## Reporting a vulnerability

Please **don't open a public issue**. Use GitHub's private reporting: **Security → Report a vulnerability** on this repository. Include the steps to reproduce and the app version. You should get a reply within a week.

## Scope

In scope: anything that could expose a user's data (backup handling, file sharing, the WhatsApp share channel, notification content), crashes caused by crafted backup files, and vulnerable dependencies.

## Notes for maintainers

- Never commit signing keys, `key.properties`, store credentials or `.env` files; `.gitignore` blocks the usual names. Release secrets live only in GitHub Actions secrets (see `docs/releasing.md`).
- Backup files are plain JSON with a checksum for corruption, not encryption. This is documented for users.
