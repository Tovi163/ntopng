--
-- (C) 2013-19 - ntop.org
--

local dirs = ntop.getDirs()
package.path = dirs.installdir .. "/scripts/lua/modules/?.lua;" .. package.path

if((dirs.scriptdir ~= nil) and (dirs.scriptdir ~= "")) then package.path = dirs.scriptdir .. "/lua/modules/?.lua;" .. package.path end
active_page = "system_interfaces_stats"

require "lua_utils"
local page_utils = require("page_utils")

if not isAllowedSystemInterface() then
   return
end

sendHTTPContentTypeHeader('text/html')

page_utils.print_header(i18n("system_interfaces_status"))

dofile(dirs.installdir .. "/scripts/lua/inc/menu.lua")

local page = _GET["page"] or "overview"

local url = ntop.getHttpPrefix() .. "/lua/system_interfaces_stats.lua"
local info = ntop.getInfo()

print [[
  <nav class="navbar navbar-default" role="navigation">
  <div class="navbar-collapse collapse">
    <ul class="nav navbar-nav">
]]

print("<li><a href=\"#\">" .. i18n("system_interfaces_status") .. "</a></li>\n")

if((page == "overview") or (page == nil)) then
   print("<li class=\"active\"><a href=\"#\"><i class=\"fa fa-home fa-lg\"></i></a></li>\n")
else
   print("<li><a href=\""..url.."?page=overview\"><i class=\"fa fa-home fa-lg\"></i></a></li>")
end

if(page == "internals") then
   print("\n<li class=\"active\"><a href=\"#\"><i class=\"fa fa-wrench fa-lg\"></i></a></li>\n")
else
   print("\n<li><a href=\""..url.."?page=internals\"><i class=\"fa fa-wrench fa-lg\"></i></a></li>")
end

print [[
<li><a href="javascript:history.go(-1)"><i class='fa fa-reply'></i></a></li>
</ul>
</div>
</nav>

   ]]

-- #######################################################

if(page == "overview") then
   print[[
<div id="table-system-interfaces-stats"></div>
<script type='text/javascript'>

$("#table-system-interfaces-stats").datatable({
   title: "]] print(i18n("system_interfaces_status")) print[[",]]

   local preference = tablePreferences("rows_number",_GET["perPage"])
   if preference ~= "" then print ('perPage: '..preference.. ",\n") end

   print[[
   showPagination: true,
   buttons: [],
   url: "]] print(ntop.getHttpPrefix()) print[[/lua/get_system_interfaces_stats.lua",
   columns: [
     {
       field: "column_ifid",
       hidden: true,
     }, {
       title: "]] print(i18n("name")) print[[",
       field: "column_name",
       sortable: true,
       css: {
         textAlign: 'left',
         width: '5%',
       }
     }, {
       title: "]] print(i18n("show_alerts.engaged_alerts")) print[[",
       field: "column_engaged_alerts",
       sortable: true,
       css: {
         textAlign: 'right',
         width: '5%',
       }
     }, {
       title: "]] print(i18n("host_details.active_alerted_flows")) print[[",
       field: "column_alerted_flows",
       sortable: true,
       css: {
         textAlign: 'right',
         width: '5%',
       }
     }, {
       title: "]] print(i18n("system_interfaces_stats.local_hosts")) print[[",
       field: "column_local_hosts",
       sortable: true,
       css: {
         textAlign: 'right',
         width: '5%',
       }
     }, {
       title: "]] print(i18n("system_interfaces_stats.remote_hosts")) print[[",
       field: "column_remote_hosts",
       sortable: true,
       css: {
         textAlign: 'right',
         width: '5%',
       }
     }, {
       title: "]] print(i18n("devices")) print[[",
       field: "column_devices",
       sortable: true,
       css: {
         textAlign: 'right',
         width: '5%',
       }
     }, {
       title: "]] print(i18n("flows")) print[[",
       field: "column_flows",
       sortable: true,
       css: {
         textAlign: 'right',
         width: '5%',
       }
     }, {
       title: "]] print(i18n("details.total_traffic")) print[[",
       field: "column_traffic",
       sortable: true,
       css: {
         textAlign: 'right',
         width: '5%',
       }
     }, {
       title: "]] print(i18n("db_explorer.total_packets")) print[[",
       field: "column_packets",
       sortable: true,
       css: {
         textAlign: 'right',
         width: '5%',
       }
     }, {
       title: "]] print(i18n("if_stats_overview.dropped_packets")) print[[",
       field: "column_drops",
       sortable: true,
       css: {
         textAlign: 'right',
         width: '5%',
       }
     }
   ], tableCallback: function() {
      datatableInitRefreshRows($("#table-system-interfaces-stats"),
                               "column_ifid", 5000,
                               {"column_packets": addCommas,
                                "column_traffic": addCommas,
                                "column_flows": addCommas,
                                "column_devices": addCommas,
                                "column_remote_hosts": addCommas,
                                "column_local_hosts": addCommas,
                                "column_alerted_flows": addCommas,
                                "column_engaged_alerts": addCommas,
                                "column_drops": addCommas});
   },
});
</script>
 ]]

elseif(page == "internals") then
   print[[
<div id="table-system-interfaces-stats"></div>
<script type='text/javascript'>

$("#table-system-interfaces-stats").datatable({
   title: "]] print(i18n("internals.hash_tables")) print[[",]]

   local preference = tablePreferences("rows_number",_GET["perPage"])
   if preference ~= "" then print ('perPage: '..preference.. ",\n") end

   print[[
   showPagination: true,
   buttons: [],
   url: "]] print(ntop.getHttpPrefix()) print[[/lua/get_internals_hash_tables_stats.lua?iffilter=all",
   columns: [
     {
       field: "column_key",
       hidden: true,
     }, {
       field: "column_ifid",
       hidden: true,
     }, {
       title: "]] print(i18n("interface")) print[[",
       field: "column_name",
       sortable: true,
       css: {
         textAlign: 'left',
         width: '5%',
       }
     }, {
       title: "]] print(i18n("internals.hash_table")) print[[",
       field: "column_hash_table_name",
       sortable: true,
       css: {
         textAlign: 'left',
         width: '10%',
       }
     }, {
       title: "]] print(i18n("internals.state_active")) print[[",
       field: "column_active_entries",
       sortable: true,
       css: {
         textAlign: 'right',
         width: '5%',
       }
     }, {
       title: "]] print(i18n("internals.state_idle")) print[[",
       field: "column_idle_entries",
       sortable: true,
       css: {
         textAlign: 'right',
         width: '5%',
       }
     }
   ], tableCallback: function() {
      datatableInitRefreshRows($("#table-system-interfaces-stats"),
                               "column_key", 5000,
                               {"column_active_entries": addCommas,
                                "column_idle_entries": addCommas});
   },
});
</script>
 ]]

end

-- #######################################################

dofile(dirs.installdir .. "/scripts/lua/inc/footer.lua")
