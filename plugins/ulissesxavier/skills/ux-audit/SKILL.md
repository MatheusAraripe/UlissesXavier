---
name: ux-audit
description: UlissesXavier's in-page measurement kit — one script that, injected once into the app under evaluation, answers target sizes, WCAG contrast, the visual-system inventory, Core Web Vitals, and toggles the squint, grayscale, color-blindness, text-spacing, pseudo-localization and network simulations, all with compact JSON. Used by the ulissesxavier agent during an evaluation; not meant to be called by hand.
user-invocable: false
---

# The measurement kit

Inject the script below **once per page load** with `javascript_tool`
(hash-route apps keep it across screens). It stores its own source in
`localStorage`, so after a full reload you re-arm it with the short line

```js
(0, eval)(localStorage.getItem("__uxsrc"))
```

instead of sending the whole script again (if the page's CSP blocks `eval`,
send the script again). Every function returns small JSON — never element
lists — so measuring a screen costs a few hundred tokens.

| Call | Returns / does |
|---|---|
| `__ux.screen()` | everything below that is per-screen, in one object: `targets`, `contrast`, `styles` |
| `__ux.targets(24)` | interactive elements smaller than 24 × 24 CSS px (WCAG 2.5.8): count + up to 15 examples `[selector, w, h, text]` |
| `__ux.contrast()` | text checked, fails of WCAG 1.4.3 grouped by color pair with ratio, size, count and one example |
| `__ux.styles()` | top-10 histograms: families, sizes, weights, line-heights, letter-spacing, text styles (combos), spacing values, radii, border widths, shadows, text colors, backgrounds, durations, easings, z-index, icons (size × stroke) |
| `__ux.styles({all: true})` | the same, every value instead of the top 10 — for the full inventory |
| `__ux.where(prop, value)` | where a value lives: up to 12 `[selector, text]` with that computed style — `where("fontSize", "16px")` |
| `__ux.device(390, 844)` | phone/tablet viewport **without touching the browser window**: the same URL in a same-origin iframe of that size over the page; measure inside with `__uxFrame.__ux.screen()`, screenshot as usual, close with `__ux.device()` |
| `__ux.cwv.start()` / `__ux.cwv.read()` | lab LCP, CLS, max interaction duration (INP proxy) and long tasks since `start()` |
| `__ux.view(mode)` | `"blur"` (squint test), `"gray"`, `"protan"`, `"deutan"`, `"tritan"` (Machado et al. 2009, severity 1.0), `"spacing"` (WCAG 1.4.12), `"zoom"` (200% text, 1.4.4), `"pseudo"` (pseudo-localization: text ×1.4, ×2 when ≤ 10 chars); `__ux.view()` restores everything except `pseudo` (reload for that) |
| `__ux.net(mode, ms)` | wraps `fetch`: `"slow"` (delay GETs by `ms`), `"fail"` (GETs → 500), `"offline"` (all reject), `"safe"` (DELETE/PUT/PATCH answer a fake 204 and are logged in `__ux.net.log`), `"off"` restores |

The measured style is the **declared** one (`getComputedStyle`), so
transforms and CSS zoom do not fabricate values. "Text" means elements with
their own text **and** form fields (value or placeholder); the options of a
closed `<select>` are not on screen and are never counted.

**About `device`.** The iframe gives the layout a real narrow viewport —
media queries, `vw` units and wrapping behave as on a phone — without
resizing the user's window (`resize_window` does nothing on a maximized
window and would move the user's own browser). What it does not emulate:
touch input (`pointer: coarse` stays false), the device pixel ratio and the
browser's own toolbars. Say so in the report: layout checked by viewport
emulation, touch untested. If the app refuses to be framed
(`X-Frame-Options`/`frame-ancestors`), `__uxFrame` reports "blocked" and the
fallback is `resize_window` on a window that is not maximized.

```js
(function () {
  var SRC = "(" + arguments.callee.toString() + ")()";
  try { localStorage.setItem("__uxsrc", SRC); } catch (e) {}
  function vis(el) {
    if (!el.getClientRects().length) return false;
    var cs = getComputedStyle(el);
    return cs.visibility !== "hidden" && +cs.opacity > 0;
  }
  function top(m, n) {
    return Object.keys(m).map(function (k) { return [k, m[k]]; }).sort(function (a, b) { return b[1] - a[1]; }).slice(0, n || 10);
  }
  function inc(m, k) { if (k !== "" && k != null) m[k] = (m[k] || 0) + 1; }
  function sel(el) {
    var c = typeof el.className === "string" && el.className.trim().split(/\s+/)[0];
    return el.tagName.toLowerCase() + (el.id ? "#" + el.id : "") + (c ? "." + c : "");
  }
  function rgba(s) {
    var m = s && s.match(/[\d.]+/g);
    if (!m || m.length < 3) return null;
    return [+m[0], +m[1], +m[2], m.length > 3 ? +m[3] : 1];
  }
  function lum(c) {
    return [0, 1, 2].map(function (i) {
      var v = c[i] / 255;
      return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4);
    }).reduce(function (s, v, i) { return s + v * [0.2126, 0.7152, 0.0722][i]; }, 0);
  }
  function over(fg, bg) { var a = fg[3]; return [0, 1, 2].map(function (i) { return fg[i] * a + bg[i] * (1 - a); }).concat(1); }
  function bgOf(el) {
    var layers = [];
    for (var e = el; e; e = e.parentElement) {
      var c = rgba(getComputedStyle(e).backgroundColor);
      if (c && c[3] > 0) { layers.push(c); if (c[3] >= 1) break; }
    }
    var bg = [255, 255, 255, 1];
    for (var i = layers.length - 1; i >= 0; i--) bg = over(layers[i], bg);
    return bg;
  }
  function ratio(a, b) { var x = lum(a), y = lum(b); return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05); }
  function hex(c) { return "#" + c.slice(0, 3).map(function (v) { return ("0" + Math.round(v).toString(16)).slice(-2); }).join(""); }
  function all() { return Array.prototype.filter.call(document.body.querySelectorAll("*"), vis); }
  /* An element "carries text" if it has its own text node, or is a field
     (its value or placeholder is text the user reads). Options of a closed
     <select> are not on screen and are never counted. */
  var FIELD = /^(INPUT|TEXTAREA|SELECT)$/;
  function isText(el) {
    if (/^(OPTION|OPTGROUP|SCRIPT|STYLE)$/.test(el.tagName) || el.closest("select") && el.tagName !== "SELECT") return false;
    if (FIELD.test(el.tagName)) return !/^(checkbox|radio|range|color|hidden|file)$/.test(el.type);
    return Array.prototype.some.call(el.childNodes, function (n) { return n.nodeType === 3 && n.data.trim(); });
  }
  function textOf(el) {
    return (FIELD.test(el.tagName) ? (el.value || el.placeholder || "") : el.textContent).trim().slice(0, 30);
  }

  var ux = {};
  ux.targets = function (min) {
    min = min || 24;
    var q = "a,button,input,select,textarea,summary,[role=button],[role=link],[role=checkbox],[role=tab],[role=menuitem],[tabindex]:not([tabindex='-1'])";
    var els = Array.prototype.filter.call(document.querySelectorAll(q), vis), small = [];
    els.forEach(function (el) {
      var r = el.getBoundingClientRect();
      if (r.width < min || r.height < min) small.push([sel(el), Math.round(r.width), Math.round(r.height), (el.innerText || el.getAttribute("aria-label") || "").trim().slice(0, 20)]);
    });
    return { checked: els.length, under: small.length, examples: small.slice(0, 15) };
  };
  ux.contrast = function () {
    var groups = {}, checked = 0;
    all().forEach(function (el) {
      if (!isText(el)) return;
      checked++;
      var cs = getComputedStyle(el), fg = rgba(cs.color), bg = bgOf(el);
      if (!fg) return;
      var r = ratio(over(fg, bg), bg), size = parseFloat(cs.fontSize), bold = +cs.fontWeight >= 700;
      var large = size >= 24 || (bold && size >= 18.66), need = large ? 3 : 4.5;
      if (r < need) {
        var k = hex(over(fg, bg)) + " on " + hex(bg);
        var g = groups[k] || (groups[k] = { pair: k, ratio: Math.round(r * 100) / 100, need: need, size: size, count: 0, example: sel(el) + " “" + textOf(el) + "”" });
        g.count++;
      }
    });
    var fails = Object.keys(groups).map(function (k) { return groups[k]; }).sort(function (a, b) { return b.count - a.count; });
    return { checked: checked, failing: fails.reduce(function (s, g) { return s + g.count; }, 0), groups: fails.slice(0, 15) };
  };
  ux.styles = function (opts) {
    var limit = opts && opts.all ? Infinity : 10;
    var H = {}; ["family", "size", "weight", "lineHeight", "tracking", "textStyle", "space", "radius", "border", "shadow", "color", "bg", "duration", "easing", "z", "icon"].forEach(function (k) { H[k] = {}; });
    all().forEach(function (el) {
      var cs = getComputedStyle(el);
      if (isText(el)) {
        var fam = cs.fontFamily.split(",")[0].replace(/["']/g, "").trim();
        inc(H.family, fam); inc(H.size, cs.fontSize); inc(H.weight, cs.fontWeight);
        inc(H.lineHeight, cs.lineHeight); inc(H.tracking, cs.letterSpacing); inc(H.color, cs.color);
        inc(H.textStyle, [fam, cs.fontSize, cs.fontWeight, cs.lineHeight, cs.textTransform !== "none" ? cs.textTransform : ""].join(" ").trim());
      }
      ["paddingTop", "paddingRight", "paddingBottom", "paddingLeft", "marginTop", "marginRight", "marginBottom", "marginLeft", "rowGap", "columnGap"].forEach(function (p) {
        var v = cs[p]; if (v && v !== "0px" && v !== "normal" && v !== "auto") inc(H.space, v);
      });
      if (cs.borderTopLeftRadius !== "0px") inc(H.radius, cs.borderTopLeftRadius);
      if (cs.borderTopWidth !== "0px" && cs.borderTopStyle !== "none") inc(H.border, cs.borderTopWidth);
      if (cs.boxShadow !== "none") inc(H.shadow, cs.boxShadow.slice(0, 60));
      if (rgba(cs.backgroundColor) && rgba(cs.backgroundColor)[3] > 0) inc(H.bg, cs.backgroundColor);
      if (cs.transitionDuration !== "0s") { inc(H.duration, cs.transitionDuration); inc(H.easing, cs.transitionTimingFunction); }
      if (cs.animationName !== "none") inc(H.duration, "anim " + cs.animationDuration);
      if (cs.zIndex !== "auto") inc(H.z, cs.zIndex);
      if (el.tagName === "svg") {
        var r = el.getBoundingClientRect(), path = el.querySelector("[stroke-width],path,circle,line");
        var sw = el.getAttribute("stroke-width") || (path && (path.getAttribute("stroke-width") || getComputedStyle(path).strokeWidth)) || "-";
        inc(H.icon, Math.round(r.width) + "x" + Math.round(r.height) + " stroke " + sw);
      }
    });
    var out = {};
    Object.keys(H).forEach(function (k) { out[k] = { distinct: Object.keys(H[k]).length, top: top(H[k], limit) }; });
    return out;
  };
  /* Where a value lives: up to n visible elements whose computed `prop`
     equals `value` — e.g. where("fontSize", "16px"). Text-bearing only for
     type properties, every element otherwise. */
  ux.where = function (prop, value, n) {
    var typeProp = /^(font|lineHeight|letterSpacing|textTransform|color)/.test(prop), out = [];
    all().forEach(function (el) {
      if (out.length >= (n || 12)) return;
      if (typeProp && !isText(el)) return;
      if (getComputedStyle(el)[prop] === value) out.push([sel(el), textOf(el)]);
    });
    return out;
  };
  ux.screen = function () { return { url: location.href, targets: ux.targets(), contrast: ux.contrast(), styles: ux.styles() }; };

  ux.cwv = {
    start: function () {
      var s = window.__uxCwv = { lcp: 0, cls: 0, inp: 0, long: 0, longMax: 0 };
      function obs(type, fn, opts) { try { new PerformanceObserver(function (l) { l.getEntries().forEach(fn); }).observe(Object.assign({ type: type, buffered: true }, opts || {})); } catch (e) {} }
      obs("largest-contentful-paint", function (e) { s.lcp = Math.round(e.startTime); });
      obs("layout-shift", function (e) { if (!e.hadRecentInput) s.cls = Math.round((s.cls + e.value) * 1000) / 1000; });
      obs("event", function (e) { if (e.interactionId) s.inp = Math.max(s.inp, Math.round(e.duration)); }, { durationThreshold: 16 });
      obs("longtask", function (e) { s.long++; s.longMax = Math.max(s.longMax, Math.round(e.duration)); });
      return "observing";
    },
    read: function () { return Object.assign({ note: "lab values on this machine, not field p75" }, window.__uxCwv || {}); }
  };

  var M = {
    protan: "0.152286 1.052583 -0.204868 0 0 0.114503 0.786281 0.099216 0 0 -0.003882 -0.048116 1.051998 0 0 0 0 0 1 0",
    deutan: "0.367322 0.860646 -0.227968 0 0 0.280085 0.672501 0.047413 0 0 -0.011820 0.042940 0.968881 0 0 0 0 0 1 0",
    tritan: "1.255528 -0.076749 -0.178779 0 0 -0.078411 0.930809 0.147602 0 0 0.004733 0.691367 0.303900 0 0 0 0 0 1 0"
  };
  ux.view = function (mode) {
    var root = document.documentElement;
    root.style.filter = ""; root.style.fontSize = "";
    var old = document.getElementById("__ux-style"); if (old) old.remove();
    if (!mode) return "restored";
    if (mode === "blur") root.style.filter = "blur(6px)";
    else if (mode === "gray") root.style.filter = "grayscale(1)";
    else if (M[mode]) {
      if (!document.getElementById("__ux-svg")) {
        var d = document.createElement("div");
        d.innerHTML = '<svg id="__ux-svg" style="position:absolute;width:0;height:0"><defs>' + Object.keys(M).map(function (k) {
          return '<filter id="__ux-' + k + '"><feColorMatrix type="matrix" values="' + M[k] + '"/></filter>';
        }).join("") + "</defs></svg>";
        document.body.appendChild(d.firstChild);
      }
      root.style.filter = "url(#__ux-" + mode + ")";
    } else if (mode === "spacing") {
      var st = document.createElement("style"); st.id = "__ux-style";
      st.textContent = "*{line-height:1.5!important;letter-spacing:.12em!important;word-spacing:.16em!important}p{margin-bottom:2em!important}";
      document.head.appendChild(st);
    } else if (mode === "zoom") root.style.fontSize = "200%";
    else if (mode === "pseudo") {
      var w = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT), n, k = 0;
      while ((n = w.nextNode())) {
        var t = n.data.trim();
        if (!t || /^(SCRIPT|STYLE)$/.test(n.parentNode.nodeName)) continue;
        var extra = Math.ceil(t.length * (t.length <= 10 ? 1 : 0.4));
        n.data = n.data.replace(t, "[" + t.replace(/a/g, "á").replace(/e/g, "ë").replace(/o/g, "ô") + "~".repeat(extra) + "]");
        k++;
      }
      return "pseudo-localized " + k + " text nodes; reload to restore";
    }
    return mode;
  };

  /* Device viewport without touching the browser window: the same URL in a
     same-origin iframe of w × h CSS px, over the page. Media queries,
     viewport units and layout answer to the iframe's width, as on a phone;
     the kit is injected inside it as window.__uxFrame.__ux. */
  ux.device = function (w, h) {
    var old = document.getElementById("__ux-device");
    if (old) old.remove();
    window.__uxFrame = null;
    if (!w) return "device view closed";
    var wrap = document.createElement("div");
    wrap.id = "__ux-device";
    wrap.style.cssText = "position:fixed;inset:0;z-index:2147483647;background:#888;display:flex;align-items:flex-start;justify-content:center;padding:12px;overflow:auto";
    var f = document.createElement("iframe");
    f.style.cssText = "width:" + w + "px;height:" + h + "px;border:0;background:#fff;flex:none";
    f.src = location.href;
    f.onload = function () {
      try { f.contentWindow.eval(SRC); window.__uxFrame = f.contentWindow; } catch (e) { window.__uxFrame = "blocked: " + e.message; }
    };
    wrap.appendChild(f);
    document.body.appendChild(wrap);
    return "device " + w + "x" + h + " — when loaded, measure with __uxFrame.__ux.screen()";
  };

  var realFetch = window.__uxFetch || (window.__uxFetch = window.fetch);
  ux.net = function (mode, ms) {
    ux.net.log = ux.net.log || [];
    if (!mode || mode === "off") { window.fetch = realFetch; return "fetch restored"; }
    window.fetch = function (input, init) {
      var method = ((init && init.method) || (input && input.method) || "GET").toUpperCase();
      var url = typeof input === "string" ? input : input.url;
      if (mode === "offline") return Promise.reject(new TypeError("Failed to fetch (simulated offline)"));
      if (mode === "safe" && /^(DELETE|PUT|PATCH)$/.test(method)) { ux.net.log.push(method + " " + url); return Promise.resolve(new Response(null, { status: 204 })); }
      if (mode === "fail" && method === "GET") return Promise.resolve(new Response('{"detail":"simulated failure"}', { status: 500, headers: { "Content-Type": "application/json" } }));
      if (mode === "slow" && method === "GET") return new Promise(function (r) { setTimeout(r, ms || 3000); }).then(function () { return realFetch(input, init); });
      return realFetch(input, init);
    };
    return "fetch: " + mode;
  };

  window.__ux = ux;
  return "__ux ready";
})()
```

Restore after every simulation: `__ux.view()` and `__ux.net("off")`, or
reload. `"safe"` is the only acceptable way to exercise a destructive flow
on real data, and only when the profile allows that flow at all.
