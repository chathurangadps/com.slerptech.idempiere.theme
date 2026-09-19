# SLERPTECH iDempiere Theme

## Purpose
This theme provides SLERPTECH branding for the iDempiere 13 WebUI while keeping the standard UX and functionality intact.

## Supported iDempiere version
release-13

## Bundle / fragment name
Bundle symbolic name: `com.slerptech.idempiere.theme`
Fragment host: `org.adempiere.ui.zk`
Theme identifier: `slerptech`

## Brand assets
- `slerptech-login-logo.png` -> login page
- `slerptech-header.png` -> desktop header logo
- `favicon-32.png` / `favicon-16.png` / `favicon-128.png` -> browser icon
- `slerptech-brand-mark.png` -> general brand mark

## Required System Configurator values
- `ZK_THEME = slerptech`
- `ZK_LOGO_LARGE = ~./theme/slerptech/images/login-logo.png`
- `ZK_LOGO_SMALL = ~./theme/slerptech/images/header-logo.png`
- `ZK_BROWSER_TITLE = SLERPTECH ERP`
- `ZK_BROWSER_ICON = ~./theme/slerptech/images/icon.png`

## Local development instructions
1. Build the plugin from the iDempiere source root using the standard Maven/Tycho workflow.
2. Start the local `server.product` with the existing VM settings preserved.
3. Set the system config values in the local environment as above.

## Build instructions
Run the project build using the standard iDempiere Maven wrapper and Eclipse PDE/OSGi resolution.

## Activation instructions
Use the System Configurator values above or set the JVM property `-DZK_THEME=slerptech` for local testing.

## Deployment instructions
Deploy only to the target local development environment; do not push to production.

## Rollback instructions
Remove the `ZK_THEME` override and restore the default theme or switch to `iceblue_c`.

## Known limitations
- This is a branding-only custom theme; it does not redesign core UX.
- Additional customizations should be separated into dedicated bundles when needed.
# com.slerptech.idempiere.theme
