const { chromium } = require('playwright');
(async () => {
  const b = await chromium.launch();
  const p = await b.newPage({ viewport: { width: 1123, height: 794 } });
  await p.goto('file://' + __dirname + '/' + (process.argv[2]||'mindmap') + '.html');
  await p.waitForSelector('body[data-ready="1"]');
  const zooms = await p.$$eval('.bi', els => els.map(e => e.dataset.zoom));
  console.log('zooms', zooms.join(' '));
  await p.pdf({ path: __dirname + '/' + (process.argv[3]||'out') + '.pdf', width: '297mm', height: '210mm', printBackground: true, preferCSSPageSize: true });
  const pages = await p.$$('.page');
  for (let i = 0; i < pages.length; i++) {
    await pages[i].screenshot({ path: __dirname + '/' + (process.argv[4]||'shot') + '-' + String(i + 1).padStart(2, '0') + '.png' });
  }
  await b.close();
})();
