# Shared helpers for the per-page content scripts in tools/pages/.
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';

sub load { my $f = shift; local $/; open my $fh, '<:utf8', $f or die "$f: $!"; my $h = <$fh>; close $fh; $h }
sub save { my ($f, $h) = @_; open my $o, '>:utf8', $f or die $!; print $o $h; close $o; print "saved $f\n" }

# literal replace; must match exactly $n times (default 1)
sub rep { my ($hr, $old, $new, $n) = @_; $n //= 1;
  my $c = () = $$hr =~ /\Q$old\E/g;
  die "rep: expected $n match(es), found $c for: " . substr($old, 0, 120) . "\n" unless $c == $n;
  $$hr =~ s/\Q$old\E/$new/g; }

# regex replace (single, /s); must match
sub rex { my ($hr, $re, $new) = @_;   # ${1}..${9} in $new = capture groups
  $$hr =~ s/$re/my @g = map { defined $_ ? $_ : "" } ($1,$2,$3,$4,$5,$6,$7,$8,$9); (my $r = $new) =~ s{\$\{(\d)\}}{$g[$1-1]}g; $r/e or die "rex: no match for $re\n"; }

# regex replace with a code block receiving the match
sub rexf { my ($hr, $re, $fn) = @_;
  $$hr =~ s/$re/$fn->($&)/e or die "rexf: no match for $re\n"; }

sub esc { my $t = shift; $t =~ s/&/&amp;/g; $t =~ s/</&lt;/g; $t =~ s/>/&gt;/g; $t }

# FAQ items in the live site's accordion markup
sub faq_items { my @qa = @_; my $out = '';
  while (my ($q, $a) = splice(@qa, 0, 2)) {
    $out .= qq{<div class="border-b border-hair-strong">\n<h3 class="m-0"><button type="button" aria-expanded="false" class="flex w-full items-center gap-6 py-6 text-left max-[600px]:gap-4 max-[600px]:py-5"><span class="t-title-sm">$q</span>\n}
      . qq{<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" class="ml-auto h-5 w-5 shrink-0 transition-transform duration-[250ms] text-ink-3"><path d="m6 9 6 6 6-6" stroke-linecap="round" stroke-linejoin="round"></path></svg></button></h3>\n}
      . qq{<div class="grid transition-[grid-template-rows] duration-[320ms] ease-[cubic-bezier(.22,.7,.3,1)] grid-rows-[0fr]">\n<div class="overflow-hidden">\n<p class="max-w-[680px] pb-7 pr-12 t-body max-[600px]:pr-0">$a</p></div></div></div>\n};
  }
  $out }

# replace every accordion item inside the element that starts at $anchor (first occurrence after it)
sub set_faq { my ($hr, $anchor, @qa) = @_;
  my $i = index($$hr, $anchor); die "set_faq: anchor not found: $anchor\n" if $i < 0;
  my $tail = substr($$hr, $i);
  $tail =~ s/(<div class="border-b border-hair-strong">\n<h3 class="m-0">.*?<\/p><\/div><\/div><\/div>\n?)+/faq_items(@qa)/se
    or die "set_faq: no items after $anchor\n";
  substr($$hr, $i) = $tail; }

# plain h2 replacing the live site's word-split heading markup
sub h2 { my ($text, $cls) = @_; $cls //= 't-h2'; qq{<h2 class="$cls">$text</h2>} }

# ZIP check block (sitewide copy). $variant: 'light' | 'dark'
sub zip_block { my (%o) = @_;
  my $id = $o{id} // 'zip';
  my $title = $o{title} // 'Check your address';
  my $wrap = ($o{variant} // '') eq 'dark' ? ' zip-dark' : '';
  qq{<div class="zip-wrap$wrap" data-usa="zip"><div class="zip-card">\n<label for="$id" class="t-eyebrow">$title</label>\n<form class="zip-form" data-zip-form novalidate><input id="$id" name="zip" inputmode="numeric" autocomplete="postal-code" maxlength="5" placeholder="ZIP code" aria-label="ZIP code"/><button type="submit" class="btn-primary">Check</button></form>\n<p class="zip-result" data-zip-result aria-live="polite"></p></div></div>} }

sub ticks { my ($cls, @items) = @_; '<ul class="usa-ticks ' . $cls . '">' . join('', map { "<li>$_</li>" } @items) . '</ul>' }

1;

# --- shared section builders -------------------------------------------------
sub pin_card { my ($title, $text, $icon) = @_;
  $icon //= '<path d="M12 21s7-5.686 7-11a7 7 0 1 0-14 0c0 5.314 7 11 7 11Z" stroke-linejoin="round"></path><circle cx="12" cy="10" r="2.4"></circle>';
  qq{<div class="h-full"><div class="rounded-[24px] border border-hair-strong bg-white flex h-full items-center gap-4 p-6"><span class="grid h-11 w-11 shrink-0 place-items-center rounded-full bg-emerald/10 text-accentink"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" class="h-5 w-5">$icon</svg></span>\n<div>\n<h3 class="t-title-sm">$title</h3>\n<p class="mt-0.5 t-secondary">$text</p></div></div></div>\n} }

my $HOME_ICON = '<path d="M3.5 10.5 12 4l8.5 6.5" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.5 9.5V20h13V9.5" stroke-linejoin="round"></path><path d="M10 20v-5h4v5" stroke-linejoin="round"></path>';

sub us_map { my $dots = load('tools/snippets/usmap-dots.svg');
  qq{<svg viewBox="0 0 960 600" class="block h-auto w-full" role="img" aria-label="Map of the United States with the Irving and The Colony clinics in North Texas marked">$dots}
  . q{<g transform="translate(456 424)"><circle r="34" fill="rgba(53,179,74,.10)"></circle><circle r="18" fill="rgba(53,179,74,.18)"></circle><path d="M0 6C0 6 -9 -2 -9 -8a9 9 0 0 1 18 0c0 6 -9 14 -9 14Z" fill="#35B34A" stroke="#fff" stroke-width="1.5"></path><circle cy="-8" r="3.2" fill="#fff"></circle><text x="22" y="-14" fill="#1c2a22" font-size="15" font-weight="600" font-family="inherit" style="letter-spacing:-0.01em">Irving</text><text x="22" y="5" fill="#1c2a22" font-size="15" font-weight="600" font-family="inherit" style="letter-spacing:-0.01em">The Colony</text></g></svg>} }

# "Where we are" (Home, About): header, 3 location cards, map card with ZIP check
sub where_we_are { my (%o) = @_;
  my $lead = $o{lead} // 'Home collection across more than 14,000 ZIP codes in 35 states. Enter your ZIP to check your address.';
  my $eyebrow = $o{eyebrow} ? qq{<span class="block t-eyebrow ">$o{eyebrow}</span>\n} : '';
  my $h2m = $o{eyebrow} ? ' mt-[18px]' : '';
  my $zip = zip_form($o{zip_id} // 'zip-where');
  qq{<section id="where-we-are" class="py-[var(--section-y)] border-t border-hair-strong" data-usa="where-we-are">\n<div class="max-w-[var(--page-max)] mx-auto px-[var(--gutter)] ">\n}
  . qq{<div class="mb-14 max-w-[820px] max-[600px]:mb-10 mx-auto text-center" data-reveal>$eyebrow<h2 class="t-h2 text-balance$h2m">Where we are</h2>\n<p class="mt-6 max-w-[680px] t-lead mx-auto">$lead</p></div>\n}
  . qq{<div class="grid grid-cols-3 gap-4 max-[760px]:grid-cols-1" data-reveal>\n}
  . pin_card('Home collection', 'More than 14,000 ZIP codes in 35 states.', $HOME_ICON)
  . pin_card('Irving clinic', '2925 N Skyway Cir, Suite 140, Irving, TX 75038')
  . pin_card('The Colony clinic', '6600 Paige Road, Suite 100, The Colony, TX 75056')
  . qq{</div>\n<div class="mt-6" data-reveal>\n<div class="rounded-[24px] border border-hair-strong bg-white p-10 max-[900px]:p-7 max-[600px]:p-5">\n<div class="grid grid-cols-[.85fr_1.15fr] items-center gap-12 max-[900px]:grid-cols-1 max-[900px]:gap-8">\n<div>\n<h3 class="t-h3">Check your address</h3>\n}
  . qq{<div class="mt-6 grid grid-cols-2 gap-4 max-[400px]:grid-cols-1">\n<div class="rounded-[20px] bg-[#EEF5EF] p-5">\n<div class="t-price font-40 text-accentink">14,000+</div>\n<div class="mt-2 t-secondary">ZIP codes with home collection</div></div>\n<div class="rounded-[20px] bg-[#EEF5EF] p-5">\n<div class="t-price font-40 text-accentink">35</div>\n<div class="mt-2 t-secondary">States</div></div></div>\n}
  . qq{<div class="mt-7">$zip</div>\n<p class="mt-5 t-caption">More clinics are opening this year.</p></div>\n<div class="max-[900px]:order-first">\n<div class="\@container">\n} . us_map() . qq{</div></div></div></div></div></div></section>\n} }

# bare ZIP form (label + field + button + result), used inside cards
sub zip_form { my ($id, $label) = @_; $label //= 'Check your address';
  qq{<div data-usa="zip"><label for="$id" class="t-eyebrow">$label</label>\n<form class="zip-form" data-zip-form novalidate><input id="$id" name="zip" inputmode="numeric" autocomplete="postal-code" maxlength="5" placeholder="ZIP code" aria-label="ZIP code"/><button type="submit" class="btn-primary">Check</button></form>\n<p class="zip-result" data-zip-result aria-live="polite"></p></div>} }

# closing band, in the What-we-test final CTA design
sub closing_band { my ($id, $headline, $sub, $buttons) = @_;
  my $p = $sub ? "\n<p>$sub</p>" : '';
  qq{<section id="$id" class="WhatWeTest-module__xNTvmW__finalCta" aria-labelledby="$id-h" data-usa="closing">\n<div class="max-w-[var(--page-max)] mx-auto px-[var(--gutter)] ">\n<h2 id="$id-h" class="t-h2">$headline</h2>$p\n<div class="WhatWeTest-module__xNTvmW__finalButtons">$buttons</div></div></section>\n} }

our $ARROW = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="h-4 w-4"><path d="M5 12h14M13 6l6 6-6 6" stroke-linecap="round" stroke-linejoin="round"></path></svg>';

sub set_title { my ($hr, $title, $desc) = @_;
  $$hr =~ s{<title>.*?</title>}{<title>$title</title>}s;
  $$hr =~ s{<meta name="description" content="[^"]*"/>}{<meta name="description" content="$desc"/>}; }

# delete from the line containing $from up to (not including) the line containing $to
sub cut_between { my ($hr, $from, $to) = @_;
  my $a = index($$hr, $from); die "cut: from not found: $from\n" if $a < 0;
  $a = rindex($$hr, "\n", $a) + 1;
  my $b = index($$hr, $to, $a); die "cut: to not found: $to\n" if $b < 0;
  $b = rindex($$hr, "\n", $b) + 1;
  substr($$hr, $a, $b - $a) = ''; }

# insert $html before the line containing $anchor
sub insert_before { my ($hr, $anchor, $html) = @_;
  my $a = index($$hr, $anchor); die "insert: anchor not found: $anchor\n" if $a < 0;
  $a = rindex($$hr, "\n", $a) + 1; substr($$hr, $a, 0) = $html; }

1;

# add page stylesheets (from the live page's own CSS chunks) after the shared ones
sub add_css { my ($hr, @names) = @_;
  my $links = join '', map { qq{\n<link rel="stylesheet" href="assets/css/$_.css"/>} } @names;
  $$hr =~ s{(<link rel="stylesheet" href="assets/css/3hr5ki1bkz99h.css"/>)}{$1$links} or die "add_css: anchor missing\n"; }
1;

# tick list in the How-it-works "Collection day tips" card style. $dark: white-on-forest variant
sub check_items { my ($dark, @items) = @_;
  my $badge = $dark ? 'bg-white/10 text-brand-bright' : 'bg-emerald/[.07] text-accentink';
  my $txt = $dark ? 't-secondary text-white/90' : 't-secondary';
  join "\n", map { qq{<li class="flex items-start gap-3.5"><span class="mt-px grid h-6 w-6 shrink-0 place-items-center rounded-full $badge">\n<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" class="h-[13px] w-[13px]"><path d="m5 13 4 4L19 7" stroke-linecap="round" stroke-linejoin="round"></path></svg></span><span class="$txt">$_</span></li>} } @items }

# white card + forest card pair (How-it-works tips design)
sub card_pair { my (%o) = @_;
  my $l = $o{left_html} // ('<ul class="mt-8 space-y-[18px]">' . "\n" . check_items(0, @{$o{left}}) . "</ul>");
  my $r = $o{right_html} // ('<ul class="mt-8 space-y-[18px]">' . "\n" . check_items(1, @{$o{right}}) . "</ul>");
  my $id = $o{id} ? qq{ id="$o{id}"} : '';
  qq{<section$id class="py-[var(--section-y)] bg-card-2 border-t border-hair-strong " data-usa="card-pair">\n<div class="max-w-[var(--page-max)] mx-auto px-[var(--gutter)] ">\n}
  . ($o{head} // '')
  . qq{<div class="grid grid-cols-2 gap-6 max-[900px]:grid-cols-1">\n<div data-reveal>\n<div class="h-full rounded-[28px] border border-hair-strong bg-white p-10 max-[600px]:p-6">\n<h2 class=" t-h3">$o{left_title}</h2>\n$l\n</div></div>\n}
  . qq{<div data-reveal>\n<div class="h-full rounded-[28px] bg-[linear-gradient(160deg,#123527_0%,#0A1F16_100%)] p-10 text-white shadow-[0_30px_70px_-45px_rgba(13,56,43,.5)] max-[600px]:p-6">\n<h2 class=" t-h3 text-white">$o{right_title}</h2>\n$r\n</div></div></div>}
  . ($o{after} // '') . qq{</div></section>\n} }
1;

# literal replace everywhere; must match at least once
sub rep_all { my ($hr, $old, $new) = @_;
  my $c = () = $$hr =~ /\Q$old\E/g; die "rep_all: no match for: " . substr($old, 0, 120) . "\n" unless $c;
  $$hr =~ s/\Q$old\E/$new/g; $c }

# replace a word-split heading (spans with data-w) inside the first <h2 ...> after $anchor
sub set_h2_after { my ($hr, $anchor, $text) = @_;
  my $i = index($$hr, $anchor); die "set_h2_after: anchor missing: $anchor\n" if $i < 0;
  my $tail = substr($$hr, $i);
  $tail =~ s{(<h2\b[^>]*>).*?</h2>}{$1$text</h2>}s or die "set_h2_after: no h2 after $anchor\n";
  substr($$hr, $i) = $tail; }

# remove every React drawer/overlay root (plan details etc.)
sub drop_drawers { my $hr = shift;
  $$hr =~ s{<div class="fixed inset-0 z-\[90\] pointer-events-none" aria-hidden="true">\n<div class="absolute inset-0 bg-\[#0a1712\]/40.*?</aside></div>\n?}{}sg; }
1;

# replace the content of the <h2> that contains $needle
sub set_h2_with { my ($hr, $needle, $text) = @_;
  $$hr =~ s{(<h2\b[^>]*>)((?:(?!</h2>).)*?\Q$needle\E.*?)</h2>}{$1$text</h2>}s or die "set_h2_with: no h2 containing $needle\n"; }
1;
