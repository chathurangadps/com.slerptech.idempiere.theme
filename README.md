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

## Light desktop header logo
The active [header-logo.png](src/web/theme/slerptech/images/header-logo.png)
uses the supplied white/orange artwork for contrast against the navy header.
Its transparent margins are cropped, then downsampled to a 640px-wide PNG,
preserving transparency and proportions (within raster pixel rounding).
This supplies four image pixels per maximum displayed CSS pixel while
avoiding unnecessary upload size. The existing 30px height
and 160px maximum width remain unchanged; the login logo is unchanged.
This image-only change is LOW upgrade risk and needs no Application
Dictionary, database, Java, ZUL, or configuration change.

Build from the iDempiere source root with `./mvnw verify -DskipTests -T 1C`
using Java 17. Refresh the project in Eclipse and restart the local product
if ZK retains the previous image, then hard-refresh the browser. Check the
white lettering, orange block, image loading, header height, and adjacent
search/user controls. Promote the rebuilt fragment through approved DEV/UAT
validation before production; do not edit a running container.
Rollback by restoring the previous header image and rebuilding, or redeploying
the previous approved fragment and restarting. Preserve login branding,
theme selection, and server-push settings.
Before uploading, verify the actual exported JAR size, not just the source
image. Keep the JAR comfortably below 1 MiB when the upload endpoint has a
1 MiB request limit, allowing room for multipart overhead. Use the newly
rebuilt artifact; older Eclipse exports retain the larger image until
re-exported. Do not modify an already exported JAR in place.

## Dashboard header contrast
White link text and orange link-hover branding are scoped to `.desktop-header`.
Views and other body links use the standard toolbar foreground and hover
tokens, so their text and icons remain readable on white without hovering.
Validate Views idle, hover, and keyboard-focus states alongside header links.

The desktop stylesheet scopes ZK header-title and panel-icon color variables
to `.z-panel-head`: white on navy, with dark foregrounds restored for the
white headers inside `.desktop-home-tabpanel`. Header help links use the same
foreground; help popups retain their existing independent colors.
The foreground is also applied directly to the panel's caption/content/title
elements. Changing only the inherited variable is insufficient when a deployed
ZK skin assigns a foreground directly to those descendants. Direct-child
selectors deliberately exclude nested help popups and panel body content.
No global ZK color token, window-header styling, or panel-body color is changed.
This CSS-only fix is LOW upgrade risk and requires no metadata changes.
Build and deploy the fragment normally, restart the host to clear cached DSP
styles, then hard-refresh the browser. Verify Favorites/Recent Items titles,
collapse/maximize controls, help hover, and white home-panel headers.
Rollback by redeploying the previous approved fragment and restarting.

For the task082 caption fix, deploy the uniquely qualified artifact
`com.slerptech.idempiere.theme_13.0.0.202610190400.jar`, not an older export.
Verify that its desktop stylesheet contains the direct `.z-caption-content`
selector above. Update the existing fragment, ensure there is only one
SLERPTECH theme fragment installed, and restart its WebUI host/server: fragments
are attached to a host and do not independently start. Hard-refresh or open a
new private browser session after the restart. Confirm the served theme CSS,
not only the uploaded filename, contains the new selector. Do not change
theme selection, proxy routes or server-push settings for this correction.

## Select Role Date control
The login stylesheet sizes the Date input and calendar trigger together at
40px high, matching the other login controls. These rules are scoped to
`.login-box`; standard ERP dateboxes and the native calendar popup are unchanged.
This CSS-only customization is LOW upgrade risk and needs no Application
Dictionary, database, Java, or System Configurator changes.

After building and refreshing the theme resources in Eclipse, restart the
local server if ZK still serves a cached DSP stylesheet. Check the Date field
width, calendar-button alignment, focus ring, popup opening, and date selection.
For an approved DEV/UAT/PROD release, package the fragment through the normal
Maven/Tycho build and deployment workflow, then restart the host runtime.
Rollback by redeploying the previous theme artifact and restarting; preserve
the existing theme selection and server-push settings.

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
