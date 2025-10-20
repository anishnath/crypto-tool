<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Time Zone Converter & Meeting Scheduler</title>
    <meta name="description" content="Convert times between world cities and find overlapping meeting slots. DST-aware using your browser's time zone data.">
    <meta name="keywords" content="time zone converter, world time calculator, meeting time finder, time difference">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Time Zone Converter & Meeting Scheduler",
      "applicationCategory": "ProductivityApplication",
      "description": "Convert times across cities and find best meeting windows with DST-aware calculations.",
      "url": "https://8gwifi.org/timezone-converter.jsp",
      "author": { "@type": "Person", "name": "Anish Nath" },
      "datePublished": "2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Time Zone Converter & Meeting Scheduler</h1>
    <p>Build a multi-city time bar to coordinate meetings. Drag across the timeline to select a slot and see local times for each city—similar to World Time Buddy.</p>

    <form id="tz-form">
        <div class="card mb-3">
            <div class="card-header">Cities & Date</div>
            <div class="card-body">
                <div class="form-row align-items-end">
                    <div class="form-group col-md-4 position-relative">
                        <label for="citySearch">Add City</label>
                        <input type="text" class="form-control" id="citySearch" placeholder="Type to search...">
                        <div id="citySuggest" class="list-group position-absolute w-100" style="z-index:1000; display:none; max-height:240px; overflow:auto;"></div>
                        <small class="text-muted">Examples: London, UK · New York, US · Tokyo, JP</small>
                    </div>
                    <div class="form-group col-md-2">
                        <button type="button" class="btn btn-primary btn-block" id="addCity">Add</button>
                        <button type="button" class="btn btn-light btn-block mt-2" id="addMine">Use My Timezone</button>
                    </div>
                    <div class="form-group col-md-3">
                        <label for="selDate">Date</label>
                        <input type="date" class="form-control" id="selDate">
                    </div>
                    <div class="form-group col-md-3">
                        <label for="workHours">Working Hours (local)</label>
                        <input type="text" class="form-control" id="workHours" value="09:00-18:00">
                        <small class="text-muted">Format: HH:MM-HH:MM</small>
                    </div>
                </div>
                <div class="d-flex flex-wrap" id="cityChips"></div>
                <small class="text-muted d-block mt-2">Tip: Reorder cities with ↑ ↓. Up to 8 cities.</small>
            </div>
        </div>

        <div class="card mb-3">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span>Timeline (24 hours)</span>
                <div>
                    <button type="button" class="btn btn-sm btn-outline-secondary" id="scrollNow">Jump to current hour</button>
                </div>
            </div>
            <div class="card-body p-0">
                <!-- Hour header -->
                <div class="wtb-header d-flex sticky-top">
                    <div class="wtb-citycol bg-light">City</div>
                    <div id="wtb-hours" class="wtb-hours d-flex"></div>
                </div>
                <!-- Rows -->
                <div id="wtb-rows" class="wtb-rows"></div>
            </div>
        </div>

        <div class="card mb-3">
            <div class="card-header">Selection & Overlap</div>
            <div class="card-body">
                <div id="selSummary" class="mb-2 text-monospace"></div>
                <button type="button" class="btn btn-outline-primary btn-sm" id="findBest">Suggest 5 best overlaps (next 3 days)</button>
                <ul id="bestList" class="mt-2"></ul>
            </div>
        </div>

        <div class="alert alert-secondary">
            <ul class="mb-0">
                <li>Drag on the timeline to select a start and end hour. The block will show in each city’s local time.</li>
                <li>Green cells indicate local working hours; grey cells are off-hours. Current hour is marked.</li>
                <li>DST-aware via your browser’s time zone data. Results are estimates; verify before scheduling.</li>
            </ul>
        </div>
    </form>

<style>
/* Basic WTB-style grid */
.wtb-header { border-bottom: 1px solid #ddd; }
.wtb-citycol { width: 220px; min-width: 220px; padding: 8px 10px; border-right: 1px solid #eee; font-weight: 600; }
.wtb-hours { overflow-x: auto; white-space: nowrap; width: calc(100% - 220px); }
.wtb-hour { width: 60px; min-width: 60px; text-align: center; padding: 6px 0; border-right: 1px solid #f0f0f0; font-size: 12px; color: #666; }
.wtb-rows { max-width: 100%; overflow-x: auto; }
.wtb-row { display: flex; border-bottom: 1px solid #f3f3f3; }
.wtb-citycell { width: 220px; min-width: 220px; padding: 8px 10px; border-right: 1px solid #eee; }
.wtb-cells { display: flex; position: relative; }
.wtb-cell { width: 60px; min-width: 60px; height: 36px; border-right: 1px solid #fafafa; background: #fff; cursor: crosshair; }
.wtb-cell.work { background: #e8f5e9; } /* working hours */
.wtb-cell.off { background: #f8f9fa; }
.wtb-cell.sel { background: rgba(66,133,244,0.25); outline: 1px solid #4285f4; }
.wtb-nowline { position: absolute; top: 0; bottom: 0; width: 2px; background: #ff7043; pointer-events: none; }
#wtb-hours::-webkit-scrollbar, .wtb-rows::-webkit-scrollbar { height: 8px; background: #f1f1f1; }
#wtb-hours::-webkit-scrollbar-thumb, .wtb-rows::-webkit-scrollbar-thumb { background: #c1c1c1; }
.city-chip { background: #f1f3f4; padding: 4px 8px; border-radius: 12px; margin: 0 6px 6px 0; display: inline-flex; align-items: center; }
.city-chip button { margin-left: 6px; }
@media (max-width: 768px) {
  .wtb-citycol, .wtb-citycell { width: 160px; min-width: 160px; }
  .wtb-hour, .wtb-cell { width: 48px; min-width: 48px; }
}
</style>

<script>
/* City database (expanded) */
var CITY_TZ = {
  // Americas (US)
  "New York, US":"America/New_York","Boston, US":"America/New_York","Philadelphia, US":"America/New_York",
  "Washington DC, US":"America/New_York","Miami, US":"America/New_York","Atlanta, US":"America/New_York",
  "Detroit, US":"America/Detroit","Chicago, US":"America/Chicago","Minneapolis, US":"America/Chicago",
  "Dallas, US":"America/Chicago","Houston, US":"America/Chicago","Austin, US":"America/Chicago",
  "Denver, US":"America/Denver","Phoenix, US":"America/Phoenix",
  "Los Angeles, US":"America/Los_Angeles","San Diego, US":"America/Los_Angeles","San Francisco, US":"America/Los_Angeles",
  "Portland, US":"America/Los_Angeles","Seattle, US":"America/Los_Angeles",
  "Anchorage, US":"America/Anchorage","Honolulu, US":"Pacific/Honolulu",

  // Americas (Canada/LatAm/Caribbean)
  "Toronto, CA":"America/Toronto","Ottawa, CA":"America/Toronto","Montreal, CA":"America/Toronto",
  "Quebec City, CA":"America/Toronto","Halifax, CA":"America/Halifax","St. John's, CA":"America/St_Johns",
  "Winnipeg, CA":"America/Winnipeg","Calgary, CA":"America/Edmonton","Edmonton, CA":"America/Edmonton",
  "Vancouver, CA":"America/Vancouver",
  "Mexico City, MX":"America/Mexico_City","Guadalajara, MX":"America/Mexico_City","Monterrey, MX":"America/Monterrey",
  "Guatemala City, GT":"America/Guatemala","San Salvador, SV":"America/El_Salvador","Tegucigalpa, HN":"America/Tegucigalpa",
  "San Jose, CR":"America/Costa_Rica","Panama City, PA":"America/Panama","Havana, CU":"America/Havana",
  "Santo Domingo, DO":"America/Santo_Domingo","San Juan, PR":"America/Puerto_Rico","Port of Spain, TT":"America/Port_of_Spain",
  "Kingston, JM":"America/Jamaica","Nassau, BS":"America/Nassau",
  "Bogota, CO":"America/Bogota","Quito, EC":"America/Guayaquil","Lima, PE":"America/Lima",
  "La Paz, BO":"America/La_Paz","Asuncion, PY":"America/Asuncion",
  "Sao Paulo, BR":"America/Sao_Paulo","Rio de Janeiro, BR":"America/Sao_Paulo","Brasilia, BR":"America/Sao_Paulo",
  "Buenos Aires, AR":"America/Argentina/Buenos_Aires","Santiago, CL":"America/Santiago",
  "Paramaribo, SR":"America/Paramaribo","Georgetown, GY":"America/Guyana","Caracas, VE":"America/Caracas",

  // Europe
  "London, UK":"Europe/London","Manchester, UK":"Europe/London","Edinburgh, UK":"Europe/London","Belfast, UK":"Europe/London",
  "Dublin, IE":"Europe/Dublin",
  "Reykjavik, IS":"Atlantic/Reykjavik",
  "Oslo, NO":"Europe/Oslo","Stockholm, SE":"Europe/Stockholm","Copenhagen, DK":"Europe/Copenhagen","Helsinki, FI":"Europe/Helsinki",
  "Tallinn, EE":"Europe/Tallinn","Riga, LV":"Europe/Riga","Vilnius, LT":"Europe/Vilnius",
  "Amsterdam, NL":"Europe/Amsterdam","Brussels, BE":"Europe/Brussels","Luxembourg, LU":"Europe/Luxembourg",
  "Berlin, DE":"Europe/Berlin","Hamburg, DE":"Europe/Berlin","Munich, DE":"Europe/Berlin","Frankfurt, DE":"Europe/Berlin",
  "Paris, FR":"Europe/Paris","Lyon, FR":"Europe/Paris","Marseille, FR":"Europe/Paris",
  "Madrid, ES":"Europe/Madrid","Barcelona, ES":"Europe/Madrid","Lisbon, PT":"Europe/Lisbon","Porto, PT":"Europe/Lisbon",
  "Rome, IT":"Europe/Rome","Milan, IT":"Europe/Rome","Naples, IT":"Europe/Rome","Valletta, MT":"Europe/Malta",
  "Vienna, AT":"Europe/Vienna","Zurich, CH":"Europe/Zurich","Geneva, CH":"Europe/Zurich",
  "Prague, CZ":"Europe/Prague","Warsaw, PL":"Europe/Warsaw","Krakow, PL":"Europe/Warsaw","Budapest, HU":"Europe/Budapest",
  "Bratislava, SK":"Europe/Bratislava","Ljubljana, SI":"Europe/Ljubljana","Zagreb, HR":"Europe/Zagreb","Belgrade, RS":"Europe/Belgrade",
  "Sarajevo, BA":"Europe/Sarajevo","Podgorica, ME":"Europe/Podgorica","Tirana, AL":"Europe/Tirane","Skopje, MK":"Europe/Skopje",
  "Bucharest, RO":"Europe/Bucharest","Sofia, BG":"Europe/Sofia","Athens, GR":"Europe/Athens",
  "Chisinau, MD":"Europe/Chisinau","Kyiv, UA":"Europe/Kyiv","Minsk, BY":"Europe/Minsk",
  "Moscow, RU":"Europe/Moscow","Saint Petersburg, RU":"Europe/Moscow","Kazan, RU":"Europe/Moscow",
  "Istanbul, TR":"Europe/Istanbul","Nicosia, CY":"Asia/Nicosia","Monaco, MC":"Europe/Monaco","San Marino, SM":"Europe/San_Marino",
  "Andorra la Vella, AD":"Europe/Andorra","Vaduz, LI":"Europe/Vaduz",

  // Middle East & North Africa
  "Casablanca, MA":"Africa/Casablanca","Algiers, DZ":"Africa/Algiers","Tunis, TN":"Africa/Tunis","Tripoli, LY":"Africa/Tripoli",
  "Cairo, EG":"Africa/Cairo",
  "Jerusalem, IL":"Asia/Jerusalem","Amman, JO":"Asia/Amman","Beirut, LB":"Asia/Beirut","Damascus, SY":"Asia/Damascus",
  "Riyadh, SA":"Asia/Riyadh","Kuwait City, KW":"Asia/Kuwait","Manama, BH":"Asia/Bahrain","Doha, QA":"Asia/Qatar",
  "Abu Dhabi, AE":"Asia/Dubai","Dubai, AE":"Asia/Dubai","Muscat, OM":"Asia/Muscat","Sana'a, YE":"Asia/Aden",
  "Baghdad, IQ":"Asia/Baghdad","Tehran, IR":"Asia/Tehran",

  // Sub-Saharan Africa
  "Accra, GH":"Africa/Accra","Abidjan, CI":"Africa/Abidjan","Dakar, SN":"Africa/Dakar","Banjul, GM":"Africa/Banjul",
  "Lagos, NG":"Africa/Lagos","Niamey, NE":"Africa/Niamey","Douala, CM":"Africa/Douala","Yaounde, CM":"Africa/Douala",
  "Kinshasa, CD":"Africa/Kinshasa","Brazzaville, CG":"Africa/Brazzaville","Luanda, AO":"Africa/Luanda",
  "Libreville, GA":"Africa/Libreville","Malabo, GQ":"Africa/Malabo",
  "Nairobi, KE":"Africa/Nairobi","Addis Ababa, ET":"Africa/Addis_Ababa","Kampala, UG":"Africa/Kampala","Kigali, RW":"Africa/Kigali",
  "Dar es Salaam, TZ":"Africa/Dar_es_Salaam","Maputo, MZ":"Africa/Maputo","Harare, ZW":"Africa/Harare","Lusaka, ZM":"Africa/Lusaka",
  "Gaborone, BW":"Africa/Gaborone","Windhoek, NA":"Africa/Windhoek","Johannesburg, ZA":"Africa/Johannesburg","Cape Town, ZA":"Africa/Johannesburg",
  "Antananarivo, MG":"Indian/Antananarivo","Port Louis, MU":"Indian/Mauritius","Victoria, SC":"Indian/Mahe","Moroni, KM":"Indian/Comoro",
  "Nouakchott, MR":"Africa/Nouakchott","Bamako, ML":"Africa/Bamako","Ouagadougou, BF":"Africa/Ouagadougou","Conakry, GN":"Africa/Conakry",
  "Freetown, SL":"Africa/Freetown","Monrovia, LR":"Africa/Monrovia","Bissau, GW":"Africa/Bissau","Praia, CV":"Atlantic/Cape_Verde",

  // South/Central/West Asia
  "Ankara, TR":"Europe/Istanbul","Baku, AZ":"Asia/Baku","Yerevan, AM":"Asia/Yerevan","Tbilisi, GE":"Asia/Tbilisi",
  "Ashgabat, TM":"Asia/Ashgabat","Dushanbe, TJ":"Asia/Dushanbe","Tashkent, UZ":"Asia/Tashkent","Bishkek, KG":"Asia/Bishkek",
  "Almaty, KZ":"Asia/Almaty","Astana, KZ":"Asia/Almaty",
  "Kabul, AF":"Asia/Kabul","Islamabad, PK":"Asia/Karachi","Karachi, PK":"Asia/Karachi","Lahore, PK":"Asia/Karachi",
  "Delhi, IN":"Asia/Kolkata","Mumbai, IN":"Asia/Kolkata","Bangalore, IN":"Asia/Kolkata","Hyderabad, IN":"Asia/Kolkata",
  "Chennai, IN":"Asia/Kolkata","Kolkata, IN":"Asia/Kolkata","Pune, IN":"Asia/Kolkata","Ahmedabad, IN":"Asia/Kolkata",
  "Dhaka, BD":"Asia/Dhaka","Thimphu, BT":"Asia/Thimphu","Colombo, LK":"Asia/Colombo","Kathmandu, NP":"Asia/Kathmandu",
  "Male, MV":"Indian/Maldives",

  // East/Southeast Asia & Oceania
  "Beijing, CN":"Asia/Shanghai","Shanghai, CN":"Asia/Shanghai","Shenzhen, CN":"Asia/Shanghai","Guangzhou, CN":"Asia/Shanghai","Chengdu, CN":"Asia/Shanghai",
  "Hong Kong, HK":"Asia/Hong_Kong","Macau, MO":"Asia/Macau","Taipei, TW":"Asia/Taipei",
  "Seoul, KR":"Asia/Seoul","Busan, KR":"Asia/Seoul","Tokyo, JP":"Asia/Tokyo","Osaka, JP":"Asia/Tokyo","Sapporo, JP":"Asia/Tokyo",
  "Ulaanbaatar, MN":"Asia/Ulaanbaatar","Hanoi, VN":"Asia/Ho_Chi_Minh","Ho Chi Minh City, VN":"Asia/Ho_Chi_Minh",
  "Bangkok, TH":"Asia/Bangkok","Phnom Penh, KH":"Asia/Phnom_Penh","Vientiane, LA":"Asia/Vientiane",
  "Kuala Lumpur, MY":"Asia/Kuala_Lumpur","Singapore, SG":"Asia/Singapore","Jakarta, ID":"Asia/Jakarta","Manila, PH":"Asia/Manila",
  "Yangon, MM":"Asia/Yangon","Bandar Seri Begawan, BN":"Asia/Brunei",
  "Sydney, AU":"Australia/Sydney","Melbourne, AU":"Australia/Melbourne","Brisbane, AU":"Australia/Brisbane",
  "Adelaide, AU":"Australia/Adelaide","Perth, AU":"Australia/Perth","Hobart, AU":"Australia/Hobart","Canberra, AU":"Australia/Sydney",
  "Auckland, NZ":"Pacific/Auckland","Wellington, NZ":"Pacific/Auckland","Port Moresby, PG":"Pacific/Port_Moresby",
  "Suva, FJ":"Pacific/Fiji","Nuku'alofa, TO":"Pacific/Tongatapu","Apia, WS":"Pacific/Apia","Honiara, SB":"Pacific/Honiara",
  "Port Vila, VU":"Pacific/Efate","Papeete, PF":"Pacific/Tahiti","Majuro, MH":"Pacific/Majuro","Palikir, FM":"Pacific/Pohnpei",
  "Tarawa, KI":"Pacific/Tarawa","Funafuti, TV":"Pacific/Funafuti"
};

var selectedCities = ["London, UK","New York, US","Mumbai, IN"];
var maxCities = 8;
var hoursHeaderEl, rowsEl, hoursScroller, rowsScroller;
var isDragging = false, dragStart = null, dragEnd = null;
var activeDate = null;

/* Autocomplete helpers */
var suggestEl = null, suggestIdx = -1, suggestItems = [];

function getCityNames(){ return Object.keys(CITY_TZ); }

function rankMatches(q, names){
  q = q.toLowerCase();
  var starts = [], contains = [];
  names.forEach(function(n){
    var s = n.toLowerCase();
    if (s.startsWith(q)) starts.push(n);
    else if (s.indexOf(q) !== -1) contains.push(n);
  });
  return starts.concat(contains);
}

function showSuggestions(list){
  if (!suggestEl) suggestEl = document.getElementById("citySuggest");
  suggestEl.innerHTML = "";
  if (!list || list.length === 0){ suggestEl.style.display = "none"; suggestIdx = -1; suggestItems = []; return; }
  suggestItems = list.slice(0, 10);
  suggestItems.forEach(function(name, i){
    var a = document.createElement("a");
    a.href="#"; a.className="list-group-item list-group-item-action";
    a.textContent = name;
    a.dataset.index = i;
    a.addEventListener("mousedown", function(e){ e.preventDefault(); addCityByName(name); });
    suggestEl.appendChild(a);
  });
  suggestEl.style.display = "block";
  suggestIdx = -1;
}

function hideSuggestions(){
  if (!suggestEl) suggestEl = document.getElementById("citySuggest");
  suggestEl.style.display = "none";
  suggestIdx = -1; suggestItems = [];
}

function addCityByName(name){
  if (!CITY_TZ[name]) return;
  if (selectedCities.indexOf(name) === -1 && selectedCities.length < maxCities){
    selectedCities.push(name);
    document.getElementById("citySearch").value = "";
    hideSuggestions();
    renderAll();
  }
}

/* Enhanced addCity and events */
function addCity(){
  var q = (document.getElementById("citySearch").value || "").trim();
  if (!q) return;
  // if exact match add directly
  if (CITY_TZ[q]){ addCityByName(q); return; }
  // else pick top ranked
  var names = getCityNames();
  var ranked = rankMatches(q, names);
  if (ranked.length > 0){ addCityByName(ranked[0]); }
}

function addMyTimezone(){
  try{
    var tz = Intl.DateTimeFormat().resolvedOptions().timeZone;
    // find any city with same tz
    var name = getCityNames().find(function(n){ return CITY_TZ[n] === tz; });
    if (name){ addCityByName(name); }
  }catch(e){}
}

(function bindAutocomplete(){
  var input = document.getElementById("citySearch");
  suggestEl = document.getElementById("citySuggest");
  input.addEventListener("input", function(){
    var q = input.value.trim();
    if (!q){ hideSuggestions(); return; }
    var ranked = rankMatches(q, getCityNames());
    showSuggestions(ranked);
  });
  input.addEventListener("keydown", function(e){
    if (suggestEl.style.display !== "block") return;
    if (e.key === "ArrowDown"){ e.preventDefault(); suggestIdx = Math.min(suggestIdx+1, suggestItems.length-1); highlightSuggest(); }
    else if (e.key === "ArrowUp"){ e.preventDefault(); suggestIdx = Math.max(suggestIdx-1, 0); highlightSuggest(); }
    else if (e.key === "Enter"){ e.preventDefault(); if (suggestIdx >= 0){ addCityByName(suggestItems[suggestIdx]); } else { addCity(); } }
    else if (e.key === "Escape"){ hideSuggestions(); }
  });
  document.addEventListener("click", function(ev){
    if (!suggestEl.contains(ev.target) && ev.target.id !== "citySearch"){ hideSuggestions(); }
  });
})();

function highlightSuggest(){
  var children = suggestEl.querySelectorAll(".list-group-item");
  children.forEach(function(el, i){ el.classList.toggle("active", i === suggestIdx); });
}

/* Utils */
function fmtInTZ(date, tz, opts){
  var f = new Intl.DateTimeFormat('en-GB', Object.assign({ timeZone: tz, hour12:false, hour:'2-digit', minute:'2-digit' }, opts||{}));
  return f.format(date);
}
function parseWork(s){ var m=s.split("-"); return {start:m[0]||"09:00", end:m[1]||"18:00"}; }
function hToStr(h){ return ("0"+h).slice(-2)+":00"; }

/* Build header hours */
function buildHours(date){
  var wrap = document.getElementById("wtb-hours");
  wrap.innerHTML = "";
  for (var h=0; h<24; h++){
    var d = new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(), h, 0, 0));
    var cell = document.createElement("div");
    cell.className = "wtb-hour";
    cell.textContent = ("0"+h).slice(-2)+":00";
    wrap.appendChild(cell);
  }
}

/* Build rows */
function buildRows(){
  rowsEl = document.getElementById("wtb-rows");
  rowsEl.innerHTML = "";
  var date = activeDate;
  var work = parseWork(document.getElementById("workHours").value);

  selectedCities.forEach(function(city, idx){
    var tz = CITY_TZ[city]; if (!tz) return;

    var row = document.createElement("div");
    row.className = "wtb-row";

    var cityCell = document.createElement("div");
    cityCell.className = "wtb-citycell";
    cityCell.innerHTML = '<div class="d-flex align-items-center justify-content-between">'+
      '<span><strong>'+city+'</strong><br><small>'+tz+'</small></span>'+
      '<span>'+
        '<button class="btn btn-sm btn-light" data-act="up" data-idx="'+idx+'">↑</button> '+
        '<button class="btn btn-sm btn-light" data-act="down" data-idx="'+idx+'">↓</button> '+
        '<button class="btn btn-sm btn-outline-danger" data-act="remove" data-idx="'+idx+'">&times;</button>'+
      '</span>'+
    '</div>';
    row.appendChild(cityCell);

    var cellsWrap = document.createElement("div");
    cellsWrap.className = "wtb-cells position-relative";
    cellsWrap.dataset.city = city;

    // draw now line if same date as today in that tz
    var now = new Date();
    var todayStr = new Intl.DateTimeFormat('en-GB', { timeZone: tz, year:'numeric', month:'2-digit', day:'2-digit'}).format(now);
    var rowDateStr = new Intl.DateTimeFormat('en-GB', { timeZone: tz, year:'numeric', month:'2-digit', day:'2-digit'}).format(date);
    if (todayStr === rowDateStr) {
      var hourNow = parseInt(fmtInTZ(now, tz, { hour:'2-digit'}), 10);
      var nowLine = document.createElement("div");
      nowLine.className = "wtb-nowline";
      nowLine.style.left = (hourNow*60/60*60) + "px"; // hour index * cell width (60px)
      cellsWrap.appendChild(nowLine);
    }

    for (var h=0; h<24; h++){
      var lc = document.createElement("div");
      lc.className = "wtb-cell off";
      lc.dataset.hour = h;
      // mark working hours in local time
      var wh = work;
      var whStart = parseInt(wh.start.split(":")[0],10);
      var whEnd = parseInt(wh.end.split(":")[0],10);
      var isWork = (h>=whStart && h<whEnd);
      if (isWork) lc.classList.remove("off"), lc.classList.add("work");
      // selection handlers
      lc.addEventListener("mousedown", onDragStart);
      lc.addEventListener("mouseenter", onDragOver);
      lc.addEventListener("mouseup", onDragEnd);
      cellsWrap.appendChild(lc);
    }
    row.appendChild(cellsWrap);
    rowsEl.appendChild(row);
  });

  // row controls
  rowsEl.addEventListener("click", function(ev){
    var b = ev.target.closest("button");
    if (!b) return;
    var act = b.getAttribute("data-act"), i = parseInt(b.getAttribute("data-idx"),10);
    if (act==="remove") { selectedCities.splice(i,1); renderAll(); }
    if (act==="up" && i>0) { var t=selectedCities[i-1]; selectedCities[i-1]=selectedCities[i]; selectedCities[i]=t; renderAll(); }
    if (act==="down" && i<selectedCities.length-1) { var t=selectedCities[i+1]; selectedCities[i+1]=selectedCities[i]; selectedCities[i]=t; renderAll(); }
  }, { once:true });
}

/* Selection logic */
function clearSelection(){
  document.querySelectorAll(".wtb-cell.sel").forEach(function(c){ c.classList.remove("sel"); });
  dragStart = dragEnd = null;
  document.getElementById("selSummary").textContent = "";
}
function onDragStart(e){
  isDragging = true;
  clearSelection();
  dragStart = { wrap: e.currentTarget.parentElement, hour: parseInt(e.currentTarget.dataset.hour,10) };
  e.currentTarget.classList.add("sel");
}
function onDragOver(e){
  if (!isDragging || !dragStart) return;
  dragEnd = { wrap: e.currentTarget.parentElement, hour: parseInt(e.currentTarget.dataset.hour,10) };
  highlightSelection();
}
function onDragEnd(e){
  if (!dragStart) return;
  isDragging = false;
  dragEnd = dragEnd || { wrap: e.currentTarget.parentElement, hour: parseInt(e.currentTarget.dataset.hour,10) };
  highlightSelection();
  summarizeSelection();
}
function highlightSelection(){
  document.querySelectorAll(".wtb-cell.sel").forEach(function(c){ c.classList.remove("sel"); });
  var start = Math.min(dragStart.hour, dragEnd.hour);
  var end = Math.max(dragStart.hour, dragEnd.hour);
  // apply to all rows aligned by UTC hour index
  var rows = document.querySelectorAll(".wtb-cells");
  rows.forEach(function(wrap){
    var cells = wrap.querySelectorAll(".wtb-cell");
    for (var h=start; h<=end; h++) cells[h] && cells[h].classList.add("sel");
  });
}
function summarizeSelection(){
  var date = activeDate;
  var startH = Math.min(dragStart.hour, dragEnd.hour);
  var endH = Math.max(dragStart.hour, dragEnd.hour) + 1; // inclusive end -> +1 hour
  var baseUTC = new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(), startH, 0, 0));
  var lines = [];
  selectedCities.forEach(function(city){
    var tz = CITY_TZ[city];
    var startStr = fmtInTZ(baseUTC, tz, { year:'numeric', month:'2-digit', day:'2-digit', hour:'2-digit', minute:'2-digit' });
    var endUTC = new Date(baseUTC.getTime() + (endH - startH)*60*60*1000);
    var endStr = fmtInTZ(endUTC, tz, { year:'numeric', month:'2-digit', day:'2-digit', hour:'2-digit', minute:'2-digit' });
    lines.push(city + ": " + startStr + " — " + endStr);
  });
  document.getElementById("selSummary").textContent = lines.join(" | ");
}

/* Chips and search */
function renderChips(){
  var holder = document.getElementById("cityChips");
  holder.innerHTML = "";
  selectedCities.forEach(function(c, i){
    var div = document.createElement("div");
    div.className = "city-chip";
    div.innerHTML = '<span>'+c+'</span>'+
      '<button class="btn btn-sm btn-light ml-2" data-act="up" data-idx="'+i+'">↑</button>'+
      '<button class="btn btn-sm btn-light ml-1" data-act="down" data-idx="'+i+'">↓</button>'+
      '<button class="btn btn-sm btn-outline-danger ml-1" data-act="remove" data-idx="'+i+'">&times;</button>';
    holder.appendChild(div);
  });
  holder.addEventListener("click", function(ev){
    var b = ev.target.closest("button"); if (!b) return;
    var act=b.getAttribute("data-act"), idx=parseInt(b.getAttribute("data-idx"),10);
    if (act==="remove"){ selectedCities.splice(idx,1); renderAll(); }
    if (act==="up" && idx>0){ var t=selectedCities[idx-1]; selectedCities[idx-1]=selectedCities[idx]; selectedCities[idx]=t; renderAll(); }
    if (act==="down" && idx<selectedCities.length-1){ var t=selectedCities[idx+1]; selectedCities[idx+1]=selectedCities[idx]; selectedCities[idx]=t; renderAll(); }
  }, { once:true });
}
function addCity(){
  var q = (document.getElementById("citySearch").value || "").trim();
  if (!q) return;
  // simple case-insensitive match against known cities
  var match = Object.keys(CITY_TZ).find(function(n){ return n.toLowerCase().indexOf(q.toLowerCase()) !== -1; });
  if (!match) return;
  if (selectedCities.indexOf(match) === -1 && selectedCities.length < maxCities){
    selectedCities.push(match);
    document.getElementById("citySearch").value = "";
    renderAll();
  }
}

/* Best overlap finder (next 3 days) */
function withinWorkHM(hm, wstart, wend){
  var mins = hm.h*60+hm.m, s = wstart.h*60+wstart.m, e = wend.h*60+wend.m;
  return mins>=s && mins<=e;
}
function parseHM(s){ var a=s.split(":").map(Number); return {h:(a[0]||0), m:(a[1]||0)}; }
function findBestOverlaps(){
  var bestList = document.getElementById("bestList");
  bestList.innerHTML = "";
  var work = parseWork(document.getElementById("workHours").value);
  var sHM = parseHM(work.start), eHM = parseHM(work.end);

  var out = [];
  var startUTC = new Date(Date.UTC(activeDate.getUTCFullYear(), activeDate.getUTCMonth(), activeDate.getUTCDate(), 0, 0, 0));
  for (var d=0; d<3; d++){
    for (var h=6; h<=20; h++){ // scan plausible hours
      var slotUTC = new Date(startUTC.getTime() + d*24*3600*1000 + h*3600*1000);
      var okAll = selectedCities.every(function(city){
        var tz = CITY_TZ[city];
        var hh = parseInt(fmtInTZ(slotUTC, tz, { hour:'2-digit'}),10);
        var mm = parseInt(fmtInTZ(slotUTC, tz, { minute:'2-digit'}),10);
        return withinWorkHM({h:hh,m:mm}, sHM, eHM);
      });
      if (okAll){
        var line = "Day +"+d+": "+ selectedCities.map(function(city){ return city+" "+fmtInTZ(slotUTC, CITY_TZ[city], { year:'numeric', month:'2-digit', day:'2-digit', hour:'2-digit', minute:'2-digit'}); }).join(" | ");
        out.push(line);
        if (out.length>=5) break;
      }
    }
    if (out.length>=5) break;
  }
  if (out.length===0) out.push("No strong overlaps found. Try adjusting working hours.");
  out.forEach(function(l){ var li=document.createElement("li"); li.textContent=l; bestList.appendChild(li); });
}

/* Render everything */
function renderAll(){
  // date
  var today = new Date();
  var dInput = document.getElementById("selDate");
  if (!dInput.value){
    dInput.value = today.toISOString().slice(0,10);
  }
  var parts = dInput.value.split("-");
  activeDate = new Date(Date.UTC(parseInt(parts[0],10), parseInt(parts[1],10)-1, parseInt(parts[2],10), 0, 0, 0));

  // chips, header, rows
  renderChips();
  buildHours(activeDate);
  buildRows();

  // sync horizontal scroll between header and rows
  var hoursWrap = document.getElementById("wtb-hours");
  var rowsWrap = document.getElementById("wtb-rows");
  hoursWrap.addEventListener("scroll", function(){ rowsWrap.scrollLeft = hoursWrap.scrollLeft; });
  rowsWrap.addEventListener("scroll", function(){ hoursWrap.scrollLeft = rowsWrap.scrollLeft; });

  clearSelection();
}

/* Events */
document.getElementById("addCity").addEventListener("click", addCity);
document.getElementById("addMine").addEventListener("click", addMyTimezone);
document.getElementById("citySearch").addEventListener("keydown", function(e){ if (e.key==="Enter"){ e.preventDefault(); addCity(); }});
document.getElementById("selDate").addEventListener("change", renderAll);
document.getElementById("workHours").addEventListener("change", renderAll);
document.getElementById("scrollNow").addEventListener("click", function(){
  var hoursWrap = document.getElementById("wtb-hours");
  var now = new Date(); var hour = now.getUTCHours(); // base on UTC column indexes
  hoursWrap.scrollLeft = hour * 60 - 120; // center-ish
});
document.getElementById("findBest").addEventListener("click", findBestOverlaps);

/* Global mouseup to end drag */
document.addEventListener("mouseup", function(){ isDragging=false; });

/* Init */
(function init(){
  // Pre-fill date
  var today = new Date(); document.getElementById("selDate").value = today.toISOString().slice(0,10);
  renderAll();
})();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
