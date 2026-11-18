/* Mr Yoda USA static pages: small replacements for the live site's React behaviour. */
(function () {
  var $ = function (s, r) { return (r || document).querySelector(s); };
  var $$ = function (s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); };

  /* Home header: switch from transparent glass to white after leaving the top of the page. */
  $$('[data-home-header]').forEach(function (header) {
    var ticking = false;
    function paintHeader() {
      header.classList.toggle('is-scrolled', window.scrollY > 16);
      ticking = false;
    }
    window.addEventListener('scroll', function () {
      if (ticking) return;
      ticking = true;
      requestAnimationFrame(paintHeader);
    }, { passive: true });
    paintHeader();
  });

  /* FAQ accordions: button[aria-expanded] in an h3, answer panel is the h3's next sibling */
  $$('h3 > button[aria-expanded]').forEach(function (btn) {
    var panel = btn.parentElement.nextElementSibling;
    if (!panel) return;
    var icon = btn.querySelector('svg');
    function set(open) {
      btn.setAttribute('aria-expanded', open ? 'true' : 'false');
      panel.style.gridTemplateRows = open ? '1fr' : '0fr';
      if (icon) icon.style.transform = open ? 'rotate(180deg)' : '';
    }
    set(btn.getAttribute('aria-expanded') === 'true');
    btn.addEventListener('click', function () { set(btn.getAttribute('aria-expanded') !== 'true'); });
  });

  /* Generic tabs: [data-tabs] holds [data-tab="key"] buttons and [data-panel="key"] panels */
  $$('[data-tabs]').forEach(function (root) {
    var tabs = $$('[data-tab]', root), panels = $$('[data-panel]', root);
    function show(key) {
      tabs.forEach(function (t) {
        var on = t.getAttribute('data-tab') === key;
        t.setAttribute('aria-selected', on ? 'true' : 'false');
        t.classList.toggle('is-active', on);
      });
      panels.forEach(function (p) { p.hidden = p.getAttribute('data-panel') !== key; });
    }
    tabs.forEach(function (t) { t.addEventListener('click', function () { show(t.getAttribute('data-tab')); }); });
    var first = tabs.filter(function (t) { return t.classList.contains('is-active'); })[0] || tabs[0];
    if (first) show(first.getAttribute('data-tab'));
  });

  /* FAQ page filter chips: [data-faq-filter] buttons, [data-faq-group] groups */
  $$('[data-faq-filters]').forEach(function (root) {
    var btns = $$('[data-faq-filter]', root);
    var groups = $$('[data-faq-group]');
    btns.forEach(function (b) {
      b.addEventListener('click', function () {
        var key = b.getAttribute('data-faq-filter');
        var on = 'border-accentink bg-accentink text-white'.split(' '), off = 'border-hair-strong bg-white text-ink hover:bg-[#ecf7ee]'.split(' ');
        btns.forEach(function (x) { var sel = x === b; x.setAttribute('aria-selected', sel ? 'true' : 'false');
          on.forEach(function (c) { x.classList.toggle(c, sel); }); off.forEach(function (c) { x.classList.toggle(c, !sel); }); });
        groups.forEach(function (g) { g.hidden = key !== 'all' && g.getAttribute('data-faq-group') !== key; });
      });
    });
  });

  /* What we test: health-area card rail arrows. Touch/trackpad scrolling remains native. */
  $$('.WhatWeTest-module__xNTvmW__rail').forEach(function (rail, railIndex) {
    var scroller = $('.WhatWeTest-module__xNTvmW__cards', rail);
    var arrows = $$('.WhatWeTest-module__xNTvmW__railArrows button', rail);
    if (!scroller || arrows.length < 2) return;
    if (!scroller.id) scroller.id = 'health-area-cards-' + (railIndex + 1);
    arrows.forEach(function (button) { button.setAttribute('aria-controls', scroller.id); });

    function cardStep() {
      var items = $$(':scope > li', scroller), card = null;
      for (var i = 0; i < items.length; i += 1) {
        if (!items[i].hidden) { card = items[i]; break; }
      }
      if (!card) return scroller.clientWidth;
      var styles = window.getComputedStyle(scroller);
      var gap = parseFloat(styles.columnGap || styles.gap) || 0;
      return (card.getBoundingClientRect().width + gap) * 4;
    }
    function updateArrows() {
      var end = Math.max(0, scroller.scrollWidth - scroller.clientWidth);
      arrows[0].disabled = scroller.scrollLeft <= 1;
      arrows[1].disabled = scroller.scrollLeft >= end - 1;
    }
    function move(direction) {
      var distance = direction * cardStep();
      var reduceMotion = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      if (scroller.scrollBy) scroller.scrollBy({ left: distance, behavior: reduceMotion ? 'auto' : 'smooth' });
      else scroller.scrollLeft += distance;
    }

    arrows[0].addEventListener('click', function () { move(-1); });
    arrows[1].addEventListener('click', function () { move(1); });
    scroller.addEventListener('scroll', updateArrows, { passive: true });
    scroller.addEventListener('wwt-filter', updateArrows);
    window.addEventListener('resize', updateArrows);
    updateArrows();
  });

  /* What we test: filter health areas by the kind of result they contain. */
  $$('.WhatWeTest-module__xNTvmW__pills').forEach(function (group) {
    var buttons = $$('button', group);
    var page = group.closest('[data-wwt-page]');
    var scroller = page && $('.WhatWeTest-module__xNTvmW__cards', page);
    var cards = scroller ? $$(':scope > li', scroller) : [];
    if (!buttons.length || !cards.length) return;
    var types = ['all', 'measured', 'calculated', 'profile'];
    var calculated = {
      'heart and cholesterol': true,
      'blood sugar and metabolism': true,
      'liver': true,
      'kidney': true,
      'electrolytes and minerals': true,
      'hormones': true,
      'iron and vitamins': true,
      'inflammation and blood count ratios': true,
      'prostate': true
    };
    var profiles = {
      'complete blood count': true,
      'urinalysis': true,
      'urine microscopy': true
    };

    function cardName(card) {
      var name = $('.WhatWeTest-module__xNTvmW__cardName', card);
      return name ? name.textContent.trim().toLowerCase() : '';
    }
    function showType(type) {
      buttons.forEach(function (button, index) {
        button.setAttribute('aria-pressed', types[index] === type ? 'true' : 'false');
      });
      cards.forEach(function (card) {
        var name = cardName(card), show = true;
        if (type === 'measured') show = !profiles[name];
        else if (type === 'calculated') show = !!calculated[name];
        else if (type === 'profile') show = !!profiles[name];
        card.hidden = !show;
      });
      page.setAttribute('data-result-type', type);
      scroller.scrollLeft = 0;
      scroller.dispatchEvent(new Event('wwt-filter'));
    }

    buttons.forEach(function (button, index) {
      button.addEventListener('click', function () { showType(types[index]); });
    });
    showType(types[Math.max(0, buttons.findIndex(function (button) {
      return button.getAttribute('aria-pressed') === 'true';
    }))]);
  });

  /* ZIP check */
  var served = /^(75|76|77|78|79)\d{3}$/; // demo rule: Texas ZIPs read as served
  $$('[data-zip-form]').forEach(function (form) {
    var input = $('input', form), out = $('[data-zip-result]', form.parentElement);
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var zip = (input.value || '').trim();
      if (!/^\d{5}$/.test(zip)) { out.textContent = 'Enter a 5-digit ZIP code.'; out.dataset.state = 'error'; return; }
      var ok = served.test(zip);
      out.dataset.state = ok ? 'yes' : 'no';
      out.innerHTML = ok
        ? 'Good news. We come to ' + zip + '. Pick a morning when you join.'
        : 'We aren’t in ' + zip + ' yet. You can visit our Irving or The Colony clinic, or leave your email and we’ll write the week we reach you.';
    });
  });

  /* Section reveal + the live site's one-shot animations */
  var io = 'IntersectionObserver' in window ? new IntersectionObserver(function (entries) {
    entries.forEach(function (en) {
      if (!en.isIntersecting) return;
      var el = en.target;
      el.classList.add('is-in');
      if (el.hasAttribute('data-premium-year')) el.setAttribute('data-run', '1');
      io.unobserve(el);
    });
  }, { threshold: 0.15 }) : null;
  $$('[data-premium-year], [data-reveal]').forEach(function (el) {
    if (io) io.observe(el); else { el.classList.add('is-in'); el.setAttribute('data-run', '1'); }
  });

  /* Home "What two visits show you": tabs swap copy, phone screen, backdrop photo and dots */
  $$('.mh-cases-card').forEach(function (card) {
    var tabs = $$('[role="tab"]', card);
    if (!tabs.length) return;
    var onStyle = tabs[0].getAttribute('style') || '';
    var offStyle = (tabs[1] && tabs[1].getAttribute('style')) || '';
    var copyGrid = $('.grid.w-full', card);
    var copies = copyGrid ? $$(':scope > div', copyGrid) : [];
    var screenGrid = $('#mh-cases-panel .mh-iphone-screen .grid', card) || $('.mh-iphone-screen .grid', card);
    var screens = screenGrid ? $$(':scope > div', screenGrid) : [];
    var films = $$('.mh-case-film img', card);
    var dotWrap = $('[aria-hidden="true"].mt-4.flex.justify-center', card);
    var dots = dotWrap ? $$(':scope > span', dotWrap) : [];
    var dotOn = dots[0] ? dots[0].getAttribute('style') : '', dotOff = dots[1] ? dots[1].getAttribute('style') : '';
    function vis(list, i) { list.forEach(function (el, k) { el.classList.toggle('invisible', k !== i); el.setAttribute('aria-hidden', k === i ? 'false' : 'true'); }); }
    tabs.forEach(function (t, i) {
      t.addEventListener('click', function () {
        tabs.forEach(function (x, k) { x.setAttribute('aria-selected', k === i ? 'true' : 'false'); x.setAttribute('style', k === i ? onStyle : offStyle); x.tabIndex = k === i ? 0 : -1; });
        vis(copies, i); vis(screens, i);
        films.forEach(function (f, k) { f.classList.toggle('is-on', k === i); });
        dots.forEach(function (d, k) { d.setAttribute('style', k === i ? dotOn : dotOff); });
      });
    });
  });

  /* Pinned horizontal scroller (Home "How the membership works") */
  $$('section[class*="h-[260vh]"]').forEach(function (sec) {
    var track = $('.will-change-transform', sec);
    if (!track) return;
    function update() {
      var viewport = document.documentElement.clientWidth || window.innerWidth;
      if (viewport <= 900) { track.style.transform = ''; return; }
      var r = sec.getBoundingClientRect();
      var total = sec.offsetHeight - window.innerHeight;
      var p = Math.min(1, Math.max(0, -r.top / (total || 1)));
      var max = Math.max(0, track.scrollWidth - viewport);
      track.style.transform = 'translate3d(' + (-p * max).toFixed(1) + 'px,0,0)';
    }
    window.addEventListener('scroll', update, { passive: true });
    window.addEventListener('resize', update);
    update();
  });

  /* Marquees: tracks hold 3 identical copies; scroll left forever */
  var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  $$('.w-max.will-change-transform').forEach(function (track) {
    if (reduce) return;
    var x = 0, speed = track.hasAttribute('data-marquee') ? 0.35 : 0.5;
    track.style.translate = 'none';
    (function tick() {
      var third = track.scrollWidth / 3;
      x -= speed; if (-x >= third) x += third;
      track.style.transform = 'translate3d(' + x.toFixed(2) + 'px,0,0)';
      requestAnimationFrame(tick);
    })();
  });

  /* DNA Decoder "What your report covers": autoplay pauses while a card is being read. */
  $$('#reveals').forEach(function (sec) {
    var track = $('.flex.items-start.will-change-transform', sec);
    if (!track) return;
    var cards = $$(':scope > div', track), n = cards.length / 3, counter = $('.tabular-nums', sec), active = n + 2;
    if (!n) return;

    function paint(i) {
      active = i;
      cards.forEach(function (c, k) {
        var on = k === i, btn = $('button', c), img = $('img', c), title = $('p.t-title-sm', c), ov = c.children[1];
        btn.classList.toggle('bg-white', on); btn.classList.toggle('bg-[#f1f1f1]', !on);
        if (on) btn.setAttribute('aria-current', 'true'); else btn.removeAttribute('aria-current');
        img.classList.toggle('opacity-45', !on); img.classList.toggle('opacity-100', on);
        title.classList.toggle('text-ink', on); title.classList.toggle('text-ink-3', !on);
        ov.classList.toggle('opacity-0', !on); ov.classList.toggle('translate-y-2', !on);
        ov.classList.toggle('opacity-100', on); ov.classList.toggle('translate-y-0', on);
        c.setAttribute('aria-hidden', on ? 'false' : 'true');
      });
      var c = cards[i], x = sec.clientWidth / 2 - (c.offsetLeft + c.offsetWidth / 2);
      track.style.transition = 'transform .8s cubic-bezier(.22,.7,.3,1)';
      track.style.transform = 'translate3d(' + x.toFixed(1) + 'px,0,0)';
      if (counter) counter.textContent = ('0' + ((i % n) + 1)).slice(-2) + ' / ' + ('0' + n).slice(-2);
    }

    function showLogical(i) {
      var logical = (i + n) % n;
      paint(n + logical);
    }

    var timer = null, paused = false;
    function stopAutoplay() {
      clearInterval(timer);
      timer = null;
    }
    function startAutoplay() {
      stopAutoplay();
      if (paused || reduce) return;
      timer = setInterval(function () { showLogical((active % n) + 1); }, 4200);
    }
    function pauseAutoplay() { paused = true; stopAutoplay(); }
    function resumeAutoplay() { paused = false; startAutoplay(); }

    cards.forEach(function (c, k) {
      c.addEventListener('mouseenter', pauseAutoplay);
      c.addEventListener('mouseleave', resumeAutoplay);
      $('button', c).addEventListener('click', function () { showLogical(k % n); startAutoplay(); });
    });
    sec.addEventListener('focusin', pauseAutoplay);
    sec.addEventListener('focusout', function (event) {
      if (!sec.contains(event.relatedTarget)) resumeAutoplay();
    });
    document.addEventListener('visibilitychange', function () {
      if (document.hidden) stopAutoplay(); else startAutoplay();
    });
    paint(active);
    startAutoplay();
    window.addEventListener('resize', function () { paint(active); });
  });

  /* MedMatch "Who it's for": pinned photo, one statement at a time as you scroll */
  $$('#who').forEach(function (sec) {
    var items = $$('[data-who-item]', sec);
    if (!items.length) return;
    items.forEach(function (it) { it.style.transition = 'opacity .5s ease, transform .5s ease'; });
    function update() {
      var r = sec.getBoundingClientRect(), total = sec.offsetHeight - window.innerHeight;
      var p = Math.min(.999, Math.max(0, -r.top / (total || 1)));
      var i = Math.floor(p * items.length);
      items.forEach(function (it, k) { it.style.opacity = k === i ? '1' : '0'; it.style.transform = k === i ? 'none' : 'translateY(' + (k < i ? -24 : 24) + 'px)'; });
    }
    window.addEventListener('scroll', update, { passive: true }); update();
  });

  /* Yodaara pinned decks: slides crossfade with scroll progress */
  $$('.usa-pin').forEach(function (pin) {
    var slides = $$('.yrd-slide', pin);
    function update() {
      if (window.innerWidth <= 900) { slides.forEach(function (s) { s.style.opacity = ''; s.style.pointerEvents = ''; }); return; }
      var r = pin.getBoundingClientRect(), total = pin.offsetHeight - window.innerHeight;
      var p = Math.min(.999, Math.max(0, -r.top / (total || 1)));
      var i = Math.floor(p * slides.length);
      slides.forEach(function (s, k) { s.style.opacity = k === i ? '1' : '0'; s.style.pointerEvents = k === i ? '' : 'none'; });
    }
    window.addEventListener('scroll', update, { passive: true }); window.addEventListener('resize', update); update();
  });

  /* Hero join bubble pops once after load, as on the live site */
  setTimeout(function () { $$('.hero-blob, .hero-join').forEach(function (el) { el.setAttribute('data-pop', '1'); }); }, 600);

  /* My Health name prompt */
  $$('[data-name-form]').forEach(function (form) {
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var name = ($('input', form).value || '').trim();
      $$('[data-hero-name]').forEach(function (h) {
        h.textContent = name ? name + ', here’s what changed since your last draw.' : 'See what changed since your last draw.';
      });
      var prompt = form.closest('[data-name-prompt]');
      if (prompt) { prompt.style.transition = 'opacity .35s ease'; prompt.style.opacity = '0'; setTimeout(function () { prompt.hidden = true; }, 360); }
    });
    var skip = $('[data-skip]', form);
    if (skip) skip.addEventListener('click', function () { $('input', form).value = ''; form.requestSubmit ? form.requestSubmit() : form.submit(); });
  });

  $$('[data-close-prompt]').forEach(function (b) {
    b.addEventListener('click', function () { var p = b.closest('[data-name-prompt]'); if (p) p.hidden = true; });
  });

  /* Radio chips (Contact topic) */
  $$('[data-radios]').forEach(function (g) {
    var bs = $$('button', g), on = 'border-accentink bg-accentink text-white'.split(' '), off = 'border-hair-strong bg-white text-ink hover:border-brand'.split(' ');
    bs.forEach(function (b) { b.addEventListener('click', function () {
      bs.forEach(function (x) { var sel = x === b; x.setAttribute('aria-checked', sel ? 'true' : 'false');
        on.forEach(function (c) { x.classList.toggle(c, sel); }); off.forEach(function (c) { x.classList.toggle(c, !sel); }); });
    }); });
  });

  /* Contact form */
  $$('[data-contact-form]').forEach(function (form) {
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var ok = $('[data-contact-ok]', form.parentElement);
      if (ok) { ok.hidden = false; }
      form.reset();
    });
  });
})();
