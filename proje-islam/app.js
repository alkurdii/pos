// ===== Data =====
const fatihaData = [
  { num: 1, ar: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", ku: "ب ناڤێ خودێ ئەز خواندنا قورئانێ دەست پێ دکەم، و داخوازا هاریکاریێ ژ وی دکەم، (ئەللاهـ) ناڤێ خودایێ پاک و بلندە، یێ کو پەرستن بۆ وی ب تنێ دهێتە کرن." },
  { num: 2, ar: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ", ku: "مەدح بۆ خودێ بن ب سالۆخەتێن وی کو هەمی سالۆخەتێن کەمالێنە، و ب قەنجیێن وی یێن ئاشکەرا و ڤەشارتی، پەروەردگارێ هەمی جیهانان." },
  { num: 3, ar: "الرَّحْمَٰنِ الرَّحِيمِ", ku: "(الرحمن) خودانێ دلۆڤانییا گشتی بۆ هەمی چێکریان، (الرحیم) یێ دلۆڤانکار ب خودان باوەران." },
  { num: 4, ar: "مَالِكِ يَوْمِ الدِّينِ", ku: "خودان و پادشاهێ رۆژا قیامەتێ و لێپرسینێ." },
  { num: 5, ar: "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ", ku: "ئەم ب تنێ تە دپەرێسین و ب تنێ ژ تە داخوازا هاریکاریێ دکەین." }
];

const recitersData = [
  { name: "أيمن رشدي سويد", style: "المصحف المعلم • فێرکرن" },
  { name: "الحسيني العزازي", style: "المعلم مع الأطفال" },
  { name: "محمد صديق المنشاوي", style: "المصحف المعلم • روایەتا حەفص" },
  { name: "محمود خليل الحصري", style: "المصحف المعلم" },
  { name: "قورئانخوینێن بادینان", style: "دەنگێن دەڤەرا بادینان" }
];

const level1Books = [
  { title: "الأصول الثلاثة وأدلتها", meta: "م. فەهیل عادل • ٠/١٤ وانە", action: "openCourse" },
  { title: "القواعد الأربع", meta: "م. ئەحمەد دۆسکی • ٠/١ وانە" },
  { title: "شروط الصلاة وأركانها وواجباتها", meta: "م. عەلی تەحسین مووسا • ٠/٧ وانە" },
  { title: "الأربعون النووية", meta: "يحيى بن شرف النووي" },
  { title: "تحفة الأطفال", meta: "م. نێچیرڤان شەرەفانی • ٠/٣ وانە" }
];

const scholarsData = [
  { name: "م. ئیبراهیم بەرواری", stats: "٣١٤٤ ڤیدیۆ • ٦٤٤٥ تۆمار • ١٥٣ زنجیرە" },
  { name: "د. محەمەد سەعید نافشکی", stats: "١٣٧١ ڤیدیۆ • ١٤٦٢ تۆمار • ٦٨ زنجیرە" },
  { name: "م. جەلیل باخرنیفی", stats: "١٧٩٠ ڤیدیۆ • ١٠٥٢٨ تۆمار • ٢٢٧ زنجیرە" },
  { name: "م. تەحسین ئیبراهیم دۆسکی", stats: "٢٨٢٣ ڤیدیۆ • ٧٤٣ تۆمار • ١٠٢ زنجیرە" }
];

const dhikrData = [
  { id: 1, time: "morning", len: "short", target: 3, count: 0, ar: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ...", ku: "ئەم کەفتینە سپێدێ و مولک هەمی بۆ خودێ یە، سوپاسی بۆ خودێ بن." },
  { id: 2, time: "morning", len: "long", target: 1, count: 0, ar: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ...", ku: "خودایێ من تو پەروەردگارێ منی، چو پەرستی ب هەق نینن ژبلی تە..." },
  { id: 3, time: "evening", len: "short", target: 3, count: 0, ar: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ...", ku: "ئەم کەفتینە ئێڤاری و مولک هەمی بۆ خودێ یە." },
  { id: 4, time: "night", len: "short", target: 1, count: 0, ar: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا", ku: "ب ناڤێ تە خودایێ من ئەز دمرم و ساغ دبم." }
];

const hadithCats = [
  { title: "قورئانا پیرۆز و زانستێن وێ", info: "٢٢ فەرموودە • ٥ پشک" },
  { title: "فەرموودە و زانستێن وێ", info: "٧ فەرموودە • ١ پشک" },
  { title: "باوەری (عەقیدە)", info: "١٥٠ فەرموودە • ٩ پشک" },
  { title: "فیقهـ و بنەمایێن وێ", info: "١٤١ فەرموودە • ١٠ پشک" },
  { title: "چاکی و رەوشت", info: "١٧٦ فەرموودە • ٥ پشک" },
  { title: "بانگەواز و فەرمانا ب باشیێ", info: "٢٣ فەرموودە • ٣ پشک" },
  { title: "سیرە و دیرۆک", info: "١٢ فەرموودە • ٢ پشک" }
];

const prayerTimes = [
  { name: "سپێدە", time: "5:08" },
  { name: "رۆژهەلات", time: "6:38" },
  { name: "نیڤڕۆ", time: "12:00" },
  { name: "ئێڤاری", time: "2:49" },
  { name: "مەغرەب", time: "5:11" },
  { name: "عەیشا (دویڤدا)", time: "6:32", next: true }
];

// ===== Helpers =====
const $ = (s) => document.querySelector(s);
const $$ = (s) => document.querySelectorAll(s);

function showToast(msg) {
  const t = $("#toast");
  t.textContent = msg;
  t.classList.remove("hidden");
  clearTimeout(window._tt);
  window._tt = setTimeout(() => t.classList.add("hidden"), 2500);
}

// ===== Navigation =====
const titles = {
  home: "سەرەکی",
  quran: "قورئانا پیرۆز",
  lessons: "وانە و ئاست",
  teachers: "مامۆستا",
  dhikr: "زکر و دوعا",
  hadith: "فەرموودە",
  prayer: "دەمێن بانگان"
};

function switchView(viewId) {
  $$(".view").forEach(v => v.classList.toggle("active", v.id === `view-${viewId}`));
  $$(".nav-item, .m-btn").forEach(b => b.classList.toggle("active", b.dataset.view === viewId));
  $("#pageHeading").textContent = titles[viewId] || "پرۆژێ ئیسلام";
  window.scrollTo({ top: 0, behavior: "smooth" });
}

$$("[data-view]").forEach(btn => btn.addEventListener("click", () => switchView(btn.dataset.view)));
$$("[data-jump]").forEach(btn => {
  btn.addEventListener("click", () => {
    switchView(btn.dataset.jump);
    if (btn.dataset.sub === "reciters") openQuranTab("reciters");
    $("#profileModal").classList.add("hidden");
  });
});

// ===== Theme & Mobile Preview =====
$("#themeToggleBtn").addEventListener("click", () => {
  const html = document.documentElement;
  const isDark = html.getAttribute("data-theme") === "dark";
  html.setAttribute("data-theme", isDark ? "light" : "dark");
  $("#themeIcon").textContent = isDark ? "🌙" : "☀️";
  showToast(isDark ? "دۆخێ رۆژێ هاتە چالاککرن" : "دۆخێ شەڤێ هاتە چالاککرن");
});

function toggleMobilePreview() {
  const shell = $("#appShell");
  const active = shell.classList.toggle("mobile-preview");
  $("#previewBtnText").textContent = active ? "زڤڕین بۆ کۆمپیوتەری" : "دیمەنێ موبایلێ (بۆ ئەپی)";
  showToast(active ? "دیمەنێ موبایلێ هاتە چالاککرن" : "دیمەنێ کۆمپیوتەری");
}
$("#toggleMobilePreviewBtn").addEventListener("click", toggleMobilePreview);
$("#mobilePreviewTopBtn").addEventListener("click", toggleMobilePreview);

// ===== Quran Logic =====
function openQuranTab(tab) {
  $$("#quranTabs .seg").forEach(s => s.classList.toggle("active", s.dataset.qtab === tab));
  $$(".qpane").forEach(p => p.classList.toggle("active", p.id === `qtab-${tab}`));
}
$$("#quranTabs .seg").forEach(s => s.addEventListener("click", () => openQuranTab(s.dataset.qtab)));

$("#ayahContainer").innerHTML = fatihaData.map(a => `
  <div class="ayah-card">
    <div class="ayah-ar arabic">${a.ar} ﴿${a.num}﴾</div>
    <div class="ayah-tafsir">${a.ku}</div>
    <div class="ayah-foot">
      <span>🔖 من هەتا ڤێرێ خواند</span>
      <button class="chip" onclick="showToast('گوهداریا ئایەتا ${a.num}')">▶ گوهداری بکە</button>
    </div>
  </div>
`).join("");

$("#recitersList").innerHTML = recitersData.map(r => `
  <div class="list-card">
    <div><strong>${r.name}</strong><small>${r.style}</small></div>
    <button class="btn-outline" onclick="showToast('هەلبژارتنا قاری: ${r.name}')">▶</button>
  </div>
`).join("");

$("#tajweedBtn").addEventListener("click", (e) => {
  const off = $("#mushafText").classList.toggle("no-tj");
  e.target.classList.toggle("active", !off);
  e.target.textContent = off ? "🎨 تەجوید: گرتی" : "🎨 تەجوید: چالاک";
});
$("#hideTextBtn").addEventListener("click", (e) => {
  const hidden = $("#mushafText").classList.toggle("blurred");
  e.target.classList.toggle("active", hidden);
});
$("#bookmarkPageBtn").addEventListener("click", () => showToast("لاپەڕ ١١ هاتە نیشانکرن"));
$("#playSurahBtn").addEventListener("click", () => showToast("دەستپێکرنا خواندنا سورەتێ..."));

// ===== Lessons & Episodes =====
$("#level1List").innerHTML = level1Books.map(b => `
  <div class="list-card">
    <div><strong>${b.title}</strong><small>${b.meta}</small></div>
    <button class="btn-outline" ${b.action ? 'id="openCourseRowBtn"' : `onclick="showToast('${b.title}')"`}>ڤەکرن ‹</button>
  </div>
`).join("");

function openCourse() {
  $("#levelsPanel").classList.add("hidden");
  $("#courseEpisodesPanel").classList.remove("hidden");
}
$("#openCourseBtn").addEventListener("click", openCourse);
$("#openCourseRowBtn")?.addEventListener("click", openCourse);
$("#backLevelsBtn").addEventListener("click", () => {
  $("#courseEpisodesPanel").classList.add("hidden");
  $("#levelsPanel").classList.remove("hidden");
});
$("#changeTeacherBtn").addEventListener("click", () => showToast("م. فەهیل عادل / م. هارون ناجی"));

const episodes = Array.from({ length: 14 }, (_, i) => i + 1);
let completedEps = 0;
$("#episodesList").innerHTML = episodes.map(n => `
  <div class="list-card">
    <div><strong>شڕۆڤەکرنا پەرتووکا {الأصول الثلاثة} وانا (${n})</strong><small>م. فەهیل عادل • هاتە دیتن: ٠%</small></div>
    <button class="chip" onclick="completeEp(this, ${n})">▶ دەستپێک</button>
  </div>
`).join("");

window.completeEp = (btn, num) => {
  if (!btn.classList.contains("active")) {
    btn.classList.add("active");
    btn.textContent = "✓ تمام";
    completedEps++;
    $("#epProgress").textContent = `${completedEps} / ١٤ وانە`;
  }
  showToast(`وانا (${num}) هاتە ڤەکرن`);
};

// ===== Teachers =====
$("#ttab-scholars").innerHTML = scholarsData.map(s => `
  <div class="scholar-card">
    <div class="scholar-avatar">${s.name[0]}</div>
    <div><strong>${s.name}</strong><small style="color:var(--muted);font-size:12px">${s.stats}</small></div>
  </div>
`).join("");

$$("#teacherTabs .seg").forEach(s => {
  s.addEventListener("click", () => {
    $$("#teacherTabs .seg").forEach(x => x.classList.remove("active"));
    s.classList.add("active");
    $("#ttab-scholars").classList.toggle("hidden", s.dataset.ttab !== "scholars");
    $("#ttab-cats").classList.toggle("hidden", s.dataset.ttab !== "cats");
  });
});

// ===== Dhikr =====
let dTime = "morning", dLen = "all", showBadini = true;
function renderDhikr() {
  const items = dhikrData.filter(d => d.time === dTime && (dLen === "all" || d.len === dLen));
  $("#dhikrContainer").innerHTML = items.map(d => `
    <div class="dhikr-card">
      <div class="dhikr-ar arabic">${d.ar}</div>
      ${showBadini ? `<div class="dhikr-ku">${d.ku}</div>` : ""}
      <div class="dhikr-foot">
        <span class="hint">ژمارە: ${d.count} / ${d.target}</span>
        <button class="count-btn ${d.count >= d.target ? 'done' : ''}" onclick="incDhikr(${d.id})">
          ${d.count >= d.target ? "✓ تەمام بوو" : "+ زکر بکە"}
        </button>
      </div>
    </div>
  `).join("");
  const doneCount = dhikrData.filter(d => d.count >= d.target).length;
  $("#homeDhikrCount").textContent = `${doneCount} / 3`;
  $("#homeDhikrBar").style.width = `${Math.max(10, (doneCount / 3) * 100)}%`;
}
window.incDhikr = (id) => {
  const item = dhikrData.find(x => x.id === id);
  if (item && item.count < item.target) item.count++;
  renderDhikr();
};
$$("#dhikrTimeTabs .seg").forEach(s => s.addEventListener("click", () => {
  $$("#dhikrTimeTabs .seg").forEach(x => x.classList.remove("active"));
  s.classList.add("active"); dTime = s.dataset.dtime; renderDhikr();
}));
$$("[data-dlen]").forEach(c => c.addEventListener("click", () => {
  $$("[data-dlen]").forEach(x => x.classList.remove("active"));
  c.classList.add("active"); dLen = c.dataset.dlen; renderDhikr();
}));
$("#badiniToggleBtn").addEventListener("click", (e) => {
  showBadini = !showBadini; e.target.classList.toggle("active", showBadini); renderDhikr();
});
renderDhikr();

// ===== Hadith & Prayer =====
$("#hadithList").innerHTML = hadithCats.map(h => `
  <div class="list-card">
    <div><strong>${h.title}</strong><small>${h.info}</small></div>
    <button class="btn-outline" onclick="showToast('${h.title}')">ڤەکرن ‹</button>
  </div>
`).join("");
$$("#hadithLangTabs .seg").forEach(s => s.addEventListener("click", () => {
  $$("#hadithLangTabs .seg").forEach(x => x.classList.remove("active"));
  s.classList.add("active"); showToast(`زمان هاتە گوهۆڕین بۆ: ${s.dataset.hlang}`);
}));

$("#prayerTimesList").innerHTML = prayerTimes.map(p => `
  <div class="list-card" style="${p.next ? 'border-color: var(--gold);' : ''}">
    <strong>${p.name}</strong>
    <span style="font-weight:700; color:${p.next ? 'var(--gold)' : 'inherit'}">${p.time}</span>
  </div>
`).join("");

// Live Countdown
let secLeft = 41 * 60 + 57;
setInterval(() => {
  if (secLeft > 0) secLeft--;
  const h = String(Math.floor(secLeft / 3600)).padStart(2, "0");
  const m = String(Math.floor((secLeft % 3600) / 60)).padStart(2, "0");
  const s = String(secLeft % 60).padStart(2, "0");
  const txt = `${h}:${m}:${s}`;
  $("#prayerCountdown").textContent = txt;
  $("#prayerCountdownBig").textContent = txt;
}, 1000);

// ===== Profile Modal & Search =====
$("#openProfileBtn").addEventListener("click", () => $("#profileModal").classList.remove("hidden"));
$("#openProfileTopBtn").addEventListener("click", () => $("#profileModal").classList.remove("hidden"));
$("#closeModalBtn").addEventListener("click", () => $("#profileModal").classList.add("hidden"));
$("#halqaBtn").addEventListener("click", () => showToast("حەلەقا زیندی نوکە نە دەمێ وێ یە"));

let isStudent = true;
$("#switchRoleBtn").addEventListener("click", (e) => {
  isStudent = !isStudent;
  $("#userRoleLabel").textContent = isStudent ? "تالب عیلم • ★ ٠" : "خەلکێ گشتی • ★ ٠";
  e.target.textContent = isStudent ? "گوهۆڕین بۆ گشتی" : "گوهۆڕین بۆ تالب عیلم";
  showToast("جۆرێ هەژمارێ هاتە گوهۆڕین");
});

$("#globalSearch").addEventListener("input", (e) => {
  const q = e.target.value.trim();
  $$("#homeFeaturesGrid .tile").forEach(tile => {
    tile.style.display = tile.textContent.includes(q) ? "flex" : "none";
  });
});
