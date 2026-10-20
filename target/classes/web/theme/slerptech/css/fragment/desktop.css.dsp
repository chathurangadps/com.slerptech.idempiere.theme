<%@ taglib uri="http://www.idempiere.org/dsp/web/util" prefix="u" %>

.desktop-header-left {
  margin: 0;
  margin-left: 1px;
  margin-top: 1px;
  background-color: transparent !important;
  border: none !important;
}

.desktop-header-left,
.desktop-header-left > tbody > tr,
.desktop-header-left > tbody > tr > td {
  height: 44px !important;
  max-height: 44px !important;
}

.desktop-header-logo {
  display: block !important;
  width: auto !important;
  height: 30px !important;
  max-width: 160px !important;
  max-height: 30px !important;
  object-fit: contain !important;
}

.desktop-header {
  background-color: ${u:sysConfig("ZK_DESKTOP_HEADER_BACKGROUND_COLOR", "#0A1B3B")};
  width: 100%;
  height: 46px;
  border-bottom: 1px solid rgba(255,255,255,0.12) !important;
  padding-left: 4px;
}

.desktop-header-font {
  font-size: 10px;
}

.desktop-header-username:hover {
  color: #F2643C;
  text-decoration: underline;
}

.desktop-user-panel {
  float: right;
}

.desktop-layout {
  position: absolute; 
  border: none;
  background-color: #E8EDF4;
}

.desktop-tabbox .z-tab-selected {
  border-top: 2px solid #F2643C;
}

.desktop-home-tabpanel .z-panel-head {
  background-color: #FFFFFF;
  --zk-container-header-color: #15304A;
  --zk-gadget-panel-icon-color: #15304A;
  --zk-gadget-panel-icon-hover-color: #0A1B3B;
}

.desktop-header .link {
  cursor: pointer;
  color: #FFFFFF !important;
}

.desktop-header .link.z-toolbarbutton:hover span {
  color: #F2643C !important;
}

.z-panel-head,
.z-window-header {
  background-color: #0A1B3B;
  color: #FFFFFF;
}

.z-panel-head {
  --zk-container-header-color: #FFFFFF;
  --zk-gadget-panel-icon-color: #FFFFFF;
  --zk-gadget-panel-icon-hover-color: #FFFFFF;
}

<%-- Set the caption foreground itself; deployed ZK skins may give it a
     color instead of inheriting the panel header's foreground. --%>
.z-panel-head > .z-panel-header,
.z-panel-head > .z-panel-header > .z-caption,
.z-panel-head > .z-panel-header > .z-caption > .z-caption-content,
.z-panel-head > .z-panel-header > .z-caption > .z-caption-content > .z-caption-label {
  color: var(--zk-container-header-color);
}

.z-panel-head .dashboard-content-help-icon {
  color: var(--zk-container-header-color);
}
