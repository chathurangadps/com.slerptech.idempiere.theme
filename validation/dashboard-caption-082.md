# Dashboard caption foreground fix (task082)

## Symptom and source evidence

The supplied deployed screenshot shows Favorites and Recent Items in dark text
against navy, while the panel controls and body content remain visible.

The inspected previous export `13.0.0.202610160854` already contains task041's
`--zk-container-header-color` and icon variables, but no explicit foreground on
caption/content/title descendants. Therefore uploading the same variable-only
fix again cannot address a skin that colors a descendant directly. The remote
application's actual computed style and winning rule were not available.

Release13 `DashboardController.newGadgetPanel` creates a standard `org.zkoss.zul.Caption`.
The checked-out ZK10.3.0.1 panel/caption molds render:

```text
.z-panel-head > .z-panel-header > .z-caption > .z-caption-content
```

The new desktop stylesheet explicitly colors that header/caption/content and
optional title span using the existing locally scoped header token. More-specific
home-panel variables still produce dark text on white. Direct-child paths exclude
help-popup contents, nested body components, and unrelated window captions.

## Validation

- Java17 Maven wrapper full reactor:
  `./mvnw verify -DskipTests -T 1C -DforceContextQualifier=202610190400`
  **BUILD SUCCESS**,1m25s. Unit tests were skipped; CSS browser checks are below.
- Focused `-pl com.slerptech.idempiere.theme -am` first failed on the existing
  `${project_loc:...}` target reference outside the full reactor. No build/core
  configuration was changed; full reactor resolved it successfully.
- Browser regression harness used the actual source desktop stylesheet with DSP
  directives stripped and the header SysConfig expression replaced by its default.
  Exact upstream panel/caption DOM was used, with directly black caption/title
  styles to reproduce the reported inheritance failure.
- Removing the new selector block reproduced black Favorites/Recent Items;
  applying it yielded white `rgb(255,255,255)` on `rgb(10,27,59)`.
- White home-panel titles remained `rgb(21,48,74)`; body and help popup text
  remained dark. Help hover revealed its independently colored popup, and
  keyboard focus reached a panel control. No JavaScript page errors in the harness.
- Text contrast: white/navy **17.03:1**; dark/white **13.52:1**.
- Editor reported no errors for the changed stylesheet.
- Packaged CSS matches source/generated classes; manifest has the exact qualified
  version below and retains the original fragment-host contract.

## Artifact and promotion

Artifact: `/Users/disa/development/plugins/plugins/plugins/com.slerptech.idempiere.theme_13.0.0.202610190400.jar`

Size:620885bytes, below1MiB before multipart overhead.

SHA-256:`65a59b3bb98a290e3b8a3c41f860df8c8be5cc4137f87bbc32382e2553c359b8`.

Update the existing fragment, retain one installed SLERPTECH fragment, restart
the WebUI host/server and hard-refresh/new private session. Verify the **served**
desktop CSS contains the direct caption selector before diagnosing further caching.
Do not require ACTIVE state for a fragment; it attaches to its host.

No remote deployment or authenticated full-application session was available.
Local server was not listening on localhost8080; no operational database was
started/used for this CSS-only regression. Login, live desktop collapse/maximize
events and actual server log/network checks remain post-deployment validation.
Do not present the browser harness as a live application test.

LOW upgrade risk, CSS-only. No core, ZUL, database, proxy, JVM or server-push
change. Rollback by updating to the previous approved fragment and restarting.
