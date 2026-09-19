<%-- Right panel background matches the reference support portal
     (support.slerptech.com/login), confirmed via live computed-style
     inspection: rgb(238,245,251). --%>
.login-window {
  background: #EEF5FB;
}

.login-window .z-window-content {
  background: transparent;
}

<%-- Fix for clipped action area: the borderlayout's <center autoscroll>
     wraps a vlayout (id=loginCenterLayout, vflex=1, pack=center) that
     centers the LoginWindow vertically. Once the card grew taller than
     the viewport (bigger logo/title/fields), the vlayout's own
     flex-box sizing clipped the centered child's overflow (its own box
     does not overflow even though the centered child visually does),
     so the outer autoscroll never triggered. Forcing these two
     confirmed, theme-controlled ids (set in login.zul) to auto height /
     visible overflow lets the whole card -- including the action
     area/footer -- render fully, scrolling via the outer <center> if it
     is ever taller than the viewport. --%>
#loginCenterLayout, #loginWindow {
  height: auto !important;
  max-height: none !important;
  overflow: visible !important;
}

<%-- Force true horizontal centering of the card within the right panel.
     ZK's vlayout align="center" did not reliably center the LoginWindow
     child in practice (it rendered flush toward the left edge of the
     center region instead) -- override explicitly via flex on the
     confirmed #loginCenterLayout id and a matching auto margin on
     #loginWindow itself as a second, independent centering mechanism. --%>
#loginCenterLayout {
  display: flex !important;
  flex-direction: column !important;
  align-items: center !important;
  justify-content: center !important;
  width: 100% !important;
}

#loginWindow {
  margin: 0 auto !important;
}

.login-window .z-center {
  overflow: visible !important;
}

<%-- Hide the borderlayout's internal splitter/border chrome between the
     west brand panel and the center login area -- scoped to the login
     page's own borderlayout sclass (.login-window), not global. --%>
.login-window .z-west, .login-window .z-center {
  border: none !important;
}

<%-- ============================================================
     LEFT BRAND PANEL
     ZUL override: see login-left.zul (theme-owned file, documented
     there). This panel occupies the borderlayout's west region, which
     WLogin.java (core) already supports as a first-class extension
     point (it auto-shows/hides based on whether this region renders
     any content, and respects MSysConfig.APPLICATION_LOGIN_LEFT_PANEL_SHOWN).
     ============================================================ --%>
.login-west-panel {
  width: 56%;
  min-width: 460px;
  background: linear-gradient(145deg, #0A1B3B 0%, #0F6377 100%);
  position: relative;
  overflow: hidden;
}

.login-brand-panel {
  position: relative;
  height: 100%;
  box-sizing: border-box;
  padding: 56px;
  display: flex;
  flex-direction: column;
  z-index: 1;
}

<%-- Subtle decorative shapes, CSS-only, low opacity --%>
.login-brand-shape {
  position: absolute;
  border-radius: 50%;
  background: rgba(255,255,255,0.06);
  pointer-events: none;
}

.login-brand-shape-1 {
  width: 420px;
  height: 420px;
  top: -160px;
  right: -140px;
}

.login-brand-shape-2 {
  width: 320px;
  height: 320px;
  bottom: -140px;
  left: -100px;
  background: rgba(242,100,60,0.08);
}

.login-brand-content {
  position: relative;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 460px;
}

<%-- Render the company login-logo.png directly on the brand panel. --%>
.login-brand-logo-chip {
  display: inline-block;
  background: transparent;
  border-radius: 0;
  padding: 0;
  margin-bottom: 40px;
  align-self: flex-start;
}

.login-brand-logo-chip img {
  width: 100%;
  max-width: 360px;
  height: auto;
  display: block;
}

.login-brand-heading {
  color: #FFFFFF;
  font-size: 32px;
  font-weight: 700;
  margin: 0 0 16px 0;
  line-height: 1.25;
}

.login-brand-subtext {
  color: rgba(255,255,255,0.75);
  font-size: 15px;
  line-height: 1.6;
  margin: 0 0 32px 0;
  max-width: 420px;
}

.login-brand-features {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.login-brand-features li {
  color: #FFFFFF;
  font-size: 15px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.login-brand-check {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  min-width: 20px;
  border-radius: 50%;
  background: #F2643C;
  color: #FFFFFF;
  font-size: 12px;
  line-height: 1;
}

.login-brand-footer {
  position: relative;
  color: rgba(255,255,255,0.55);
  font-size: 12px;
  margin-top: 32px;
}

@media screen and (max-width: 899px) {
  .login-west-panel {
    display: none;
  }
}

<%-- ============================================================
     RIGHT LOGIN PANEL / CARD
     Card geometry. LoginPanel.java (core) renders 3 sibling blocks that
     we cannot wrap in one new container (no ZUL/Java override point
     exists for that): .login-box-header (thin accent strip),
     #grdLogin.login-box-body (the field table), and .login-box-footer
     (action buttons). We make them read as one card by sharing the same
     width/side-padding and removing the visual seam between body and
     footer. .login-box is a shared sclass set by both LoginPanel.java
     and RolePanel.java (core) on their own root window, so a single
     scope covers the login page and the post-login Select Role page
     consistently -- confirmed in source, not guessed.
     ============================================================ --%>
<%-- table-layout:fixed establishes column widths from the FIRST row
     (the logo/header row, colspan=2) and never recomputes them for
     later rows -- confirmed via live DOM inspection (computed styles /
     getBoundingClientRect in the running app). Since a colspan=2 first
     cell gives no per-column ratio hint, the engine falls back to an
     even 50/50 split, capping every labeled field (#rowUser,
     #rowPassword, etc.) at ~half the card's width no matter what width
     is declared on that row's own cells. Escaping table layout
     entirely (table/tbody blockified to plain block boxes) is the only
     reliable fix; width switches from a parent-relative calc() to a
     viewport-relative one so it isn't circular against the now-block
     table's own shrink-to-fit sizing. --%>
<%-- Card width/radius/shadow tuned to match the reference support
     portal's floating card (440px wide, 24px radius, soft two-layer
     shadow), confirmed via live computed-style inspection. --%>
.login-box-body {
  display: block;
  width: min(440px, calc(100vw - 32px));
  background-color: #FFFFFF;
  border: none;
  border-radius: 24px 24px 0 0;
  box-shadow: 0 20px 42px rgba(15,23,42,0.1), 0 4px 14px rgba(15,23,42,0.06);
  margin: 0 auto;
  text-align: left;
  padding: 0 40px 8px 40px;
  box-sizing: border-box;
  position: relative;
}

.login-box-body > tbody {
  display: block;
}

<%-- The header/logo row's native colspan="2" only spans both columns
     under real table layout; once tbody is blockified (see above), that
     stops working and the cell shrinks to a single ~half-width column,
     making the centered "Welcome back" title look left-aligned within
     the card even though text-align:center is correctly applied to it.
     Confirmed via live DOM inspection (element rect only ~half the
     card's inner width). Fixed by blockifying this row/cell to 100%
     width too, same as every other row. --%>
.login-box-body > tbody > tr:first-child {
  display: block;
  width: 100%;
}

.login-box-header {
  display: none;
}

.login-box-header-txt {
  display: none;
}

.login-box-header-logo {
  display: block;
  width: 100%;
  padding-top: 40px;
  padding-bottom: 0;
  text-align: center;
}

<%-- Logo removed from the card itself per request (it already appears
     in the left brand panel); the cell is kept (not display:none) so
     the "Welcome back" ::after title below still has a place to render. --%>
.login-box-header-logo img {
  display: none;
}

<%-- Welcome title + subtitle. No ZUL/Java override point exists for this
     exact spot (LoginPanel.java builds the header/logo/form in Java, not
     ZUL), so this is CSS-generated content -- the underlying
     command/logic is untouched, only the visual is added. Title and
     subtitle need different typography, so they are two separate
     generated-content rules on two adjacent, confirmed elements: the
     logo cell's ::after (title) and the first field row's (#rowUser)
     ::before (subtitle, right before the first input). --%>
.login-box-header-logo::after {
  content: "Welcome back";
  display: block;
  font-size: 34px;
  font-weight: 700;
  color: #111827;
  line-height: 1.2;
  text-align: center;
}

<%-- RolePanel renders its table with the stable DOM id grdChooseRole. --%>
#grdChooseRole .login-box-header-logo::after {
  content: "Select Role";
}

#rowUser::before {
  content: "Sign in to your ERP Portal.";
  display: block;
  order: -1;
  margin-top: 4px;
  margin-bottom: 20px;
  font-size: 16px;
  font-weight: 400;
  color: #6B7280;
  text-align: center;
  line-height: 1.5;
}

<%-- Field grid: labels ABOVE fields (not left/right columns). Row ids
     (rowUser, rowPassword, rowLanguage, rowSelectRole, rowRememberMe on
     the login page; rowclient, rowRole, rowOrganisation, rowWarehouse,
     rowDate on the Select Role page) are set explicitly in
     LoginPanel.java / RolePanel.java (core) and are stable, confirmed
     selectors -- not guessed. Each row is individually switched to a
     flex column; the table/tbody itself is blockified above (see note
     on .login-box-body) so no row keeps native table-row sizing. --%>
#rowUser, #rowPassword, #rowLanguage,
#rowclient, #rowRole, #rowOrganisation, #rowWarehouse, #rowDate {
  display: flex;
  flex-direction: column;
  width: 100%;
  height: auto;
  text-align: left;
  padding-top: 12px;
}

<%-- #rowUser carries the subtitle (::before, order:-1) right under the
     "Welcome back" title, so it needs a much smaller top gap than the
     other field rows -- overridden here after the shared rule above. --%>
#rowUser {
  padding-top: 2px;
}

#rowUser td, #rowPassword td, #rowLanguage td,
#rowclient td, #rowRole td, #rowOrganisation td, #rowWarehouse td, #rowDate td {
  display: block;
  width: 100% !important;
  padding: 0;
}

#rowUser td.login-label, #rowPassword td.login-label, #rowLanguage td.login-label,
#rowclient td.login-label, #rowRole td.login-label, #rowOrganisation td.login-label,
#rowWarehouse td.login-label, #rowDate td.login-label {
  text-align: left !important;
  color: #111827;
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 4px;
}

<%-- RolePanel writes text-align:right inline on this nested wrapper. --%>
#grdChooseRole td.login-label > .z-div {
  width: 100% !important;
  text-align: left !important;
}

.login-field {
  text-align: left;
  vertical-align: middle;
}

.login-field input:not([type="checkbox"]) {
  width: 100%;
  height: 30px;
  border-radius: 6px !important;
  border: 1px solid #E5E7EB !important;
  padding: 0 8px !important;
  font-size: 13px;
  box-sizing: border-box;
}

.login-field input:not([type="checkbox"]):focus {
  border-color: #F2643C !important;
  box-shadow: 0 0 0 3px rgba(242,100,60,0.15);
  outline: none;
}

<%-- Login combobox control and popup styling. --%>
.login-box .z-combobox {
  width: 100%;
  height: 30px;
  border: 1px solid #E5E7EB;
  border-radius: 6px;
  background-color: #FFFFFF;
  box-sizing: border-box;
  overflow: visible;
}

.login-box .z-combobox-input {
  width: 100% !important;
  border: none !important;
  background: transparent !important;
  height: 28px !important;
  padding: 0 36px 0 8px !important;
  border-radius: 6px !important;
  font-size: 13px !important;
  line-height: 28px !important;
  box-sizing: border-box;
}

.login-box .z-combobox-button {
  top: 0 !important;
  right: 0 !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  width: 30px !important;
  height: 28px !important;
  padding: 0 !important;
  border: none !important;
  border-left: 1px solid #E5E7EB !important;
  border-radius: 0 5px 5px 0 !important;
  background: #F8FAFC !important;
  box-shadow: none !important;
  color: #475569 !important;
}

.login-box .z-combobox-button:hover {
  background: #EEF5FB !important;
  color: #0F6E8C !important;
}

.login-box .z-combobox-icon {
  font-size: 12px !important;
  line-height: 1 !important;
}

.login-box .z-combobox:focus-within {
  border-color: #F2643C;
  box-shadow: 0 0 0 3px rgba(242,100,60,0.15);
}

.login-box .z-combobox-input:focus {
  outline: none;
}

<%-- ZK reparents an open popup under body and positions it for a 24px trigger. --%>
body:has(.login-window) > .z-combobox-popup {
  transform: translateY(6px) !important;
  border: 1px solid #E5E7EB !important;
  border-radius: 6px !important;
  box-shadow: 0 14px 30px rgba(15,23,42,0.14) !important;
  overflow: hidden !important;
}

body:has(.login-window) > .z-combobox-popup .z-comboitem {
  min-height: 30px !important;
  padding: 5px 8px !important;
  background: #FFFFFF !important;
}

body:has(.login-window) > .z-combobox-popup .z-comboitem:hover {
  background: #F8FAFC !important;
}

body:has(.login-window) > .z-combobox-popup .z-comboitem-text {
  color: #334155 !important;
  font-size: 13px !important;
}

body:has(.login-window) > .z-combobox-popup .z-comboitem-selected {
  background: #EEF5FB !important;
}

body:has(.login-window) > .z-combobox-popup .z-comboitem-selected .z-comboitem-text {
  color: #0F6E8C !important;
  font-weight: 600 !important;
}

<%-- Checkbox rows. Known limitation: LoginPanel.java renders
     "Select Role" and "Remember Me" as two SEPARATE <tr> elements (each
     its own table row), and there is no ZUL/Java override point to merge
     them into one row -- the requested flex space-between single row
     would require a core Java change, which is against upgrade-safety.
     Instead: the empty label cell for each row is hidden, and both rows
     are compacted into a tight, consistently full-width vertical stack
     -- documented in the response as a deliberate, disclosed deviation
     from the mockup. Now converted to the same flex-row treatment as
     the other rows (needed once table/tbody were blockified above, so
     no row is left relying on native table-row sizing). --%>
#rowSelectRole, #rowRememberMe {
  display: flex;
  flex-direction: column;
  width: 100%;
  height: auto;
}

#rowSelectRole td.login-label, #rowRememberMe td.login-label {
  display: none;
}

#rowSelectRole td.login-field, #rowRememberMe td.login-field {
  display: block;
  width: 100% !important;
  text-align: left;
  padding: 4px 0;
}

#rowSelectRole {
  margin-top: 12px;
}

#rowRememberMe {
  margin-bottom: 18px;
}

#rowSelectRole .z-checkbox, #rowRememberMe .z-checkbox {
  accent-color: #F2643C;
}

<%-- Action area: merged visually with the card (no border/seam), full
     width primary button, secondary actions rendered as plain text
     links stacked below it. LoginPanel.java renders this as a sibling
     block after #grdLogin.login-box-body, so it always paints on top of
     it in normal DOM order -- its own box-shadow (needed for the outer
     edges) would otherwise bleed upward onto the body's white surface
     right at the seam, looking like two separate floating cards even
     with a matching shadow and zero gap (confirmed via live layout
     inspection). clip-path removes just that upward bleed, keeping the
     shadow intact on the visible bottom/left/right edges. --%>
.login-box-footer {
  background-color: #FFFFFF;
  border-top: none;
  height: auto;
  width: min(440px, calc(100vw - 32px));
  margin: 0 auto;
  padding: 0 40px 40px 40px;
  box-sizing: border-box;
  border-radius: 0 0 24px 24px;
  box-shadow: 0 20px 42px rgba(15,23,42,0.1), 0 4px 14px rgba(15,23,42,0.06);
  clip-path: inset(0 -60px -60px -60px);
}

<%-- ConfirmPanel (ZK core widget) sets an inline height in pixels via
     JavaScript at render time, sized for the original small default
     button. That inline height plus overflow:hidden on its z-hlayout
     children clips our larger buttons -- CSS on .login-btn alone cannot
     fix this because the clipping happens on the ancestor. Overriding
     height/overflow here (with !important, since it must beat an inline
     style) lets the panel grow to fit the real button height. --%>
.login-box-footer .confirm-panel {
  width: 100% !important;
  height: auto !important;
}

.login-box-footer-pnl {
  width: 100%;
  height: auto !important;
  margin: 0;
  padding: 0 !important;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  box-sizing: border-box;
}

.login-box-footer-pnl .confirm-panel-left,
.login-box-footer-pnl .confirm-panel-center,
.login-box-footer-pnl .confirm-panel-right {
  float: none !important;
  width: 100% !important;
  height: auto !important;
  overflow: visible !important;
}

<%-- All buttons live inside .confirm-panel-right, side by side, because
     the core z-hlayout keeps its .z-hlayout-inner children inline-block
     with white-space:nowrap. That means a width:100% on the button
     itself has nothing real to resolve against (its wrapper only ever
     shrinks to fit content). Re-declaring the row as a flex column here
     lets the first wrapper (OK) truly stretch full width, while later
     wrappers (Help/Cancel) stay auto-width and centered underneath. --%>
.login-box-footer-pnl .confirm-panel-right {
  display: flex !important;
  flex-direction: column !important;
  align-items: stretch !important;
  white-space: normal !important;
  gap: 10px;
}

.login-box-footer-pnl .z-hlayout-inner {
  display: block !important;
  width: 100% !important;
  padding: 0 !important;
}

.login-box-footer-pnl .z-hlayout-inner:not(:first-child) {
  width: auto !important;
  align-self: center !important;
}

<%-- Strong, guaranteed-visible baseline for every footer button
     (OK/Cancel/Help all share this core .login-btn class). This is
     intentionally defensive with !important so the primary/secondary
     differentiation rules below can only ever refine this, never leave
     a button invisible if a structural assumption about ConfirmPanel's
     internal markup turns out to be wrong. --%>
.login-btn {
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  width: 100% !important;
  height: 30px !important;
  min-height: 30px !important;
  padding: 0 12px !important;
  border-radius: 6px !important;
  background: #0F6E8C !important;
  border: none !important;
  color: #FFFFFF !important;
  font-weight: 700 !important;
  font-size: 13px !important;
  box-sizing: border-box !important;
  visibility: visible !important;
  opacity: 1 !important;
}

<%-- Primary action styling refinements (OK is always the first button
     added by ConfirmPanel). Label intentionally left as the real "OK"
     text -- an earlier attempt to visually replace it with "Sign In" via
     color:transparent + font-size:0 + ::after generated content made the
     button disappear entirely in testing (root cause not fully isolated
     without live DevTools access), so that technique was reverted in
     favor of guaranteed visibility/clickability. --%>
.login-box-footer-pnl .z-hlayout-inner:first-child .login-btn:hover,
.login-box-footer-pnl .z-hlayout-inner:first-child.login-btn:hover {
  background: #0C5A72 !important;
}

.login-box-footer-pnl .z-hlayout-inner:first-child .login-btn:focus-visible,
.login-box-footer-pnl .z-hlayout-inner:first-child.login-btn:focus-visible {
  outline: 2px solid #F2643C;
  outline-offset: 2px;
}

<%-- Secondary actions (Cancel / Help): rendered as plain muted text
     links stacked below the primary button, not as competing buttons.
     Confirmed via source: all footer buttons share the same core
     .login-btn class with no distinct class per action (LoginPanel.java
     has [OK, Help]; RolePanel.java has [OK, Cancel, Help]). OK is always
     the first button added, so "every direct child of the footer panel
     except the first" reliably targets the rest, regardless of button
     count or whether ConfirmPanel wraps each button in its own
     container. --%>
.login-box-footer-pnl .z-hlayout-inner:not(:first-child) .login-btn,
.login-box-footer-pnl .z-hlayout-inner:not(:first-child).login-btn {
  width: auto !important;
  height: auto !important;
  min-height: 0 !important;
  min-width: 0 !important;
  padding: 4px 8px !important;
  background: transparent !important;
  border: none !important;
  box-shadow: none !important;
  color: #5C6B7B !important;
  font-weight: 500 !important;
  font-size: 14px !important;
  text-decoration: none;
}

.login-box-footer-pnl .z-hlayout-inner:not(:first-child) .login-btn:hover,
.login-box-footer-pnl .z-hlayout-inner:not(:first-child).login-btn:hover {
  color: #15304A !important;
  text-decoration: underline;
}

.login-tech-footer {
  text-align: center;
  margin-top: 16px;
  color: #8A97A4;
  font-size: 11px;
}

@media screen and (max-width: 480px) {
  #rowSelectRole td.login-field, #rowRememberMe td.login-field {
    padding: 8px 0;
  }
}

