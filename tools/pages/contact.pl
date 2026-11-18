#!/usr/bin/perl
# Contact: USA copy
use strict; use warnings; use utf8;
require './tools/lib.pl';
our $ARROW;
my $h = load('tools/base/contact.html');

set_title(\$h, 'Contact Mr Yoda | Talk to a Person',
  'Tell us what you need about a booking, a draw, a result or a charge. A person replies by email.');

# ---- HERO ----
rep(\$h, q{max-[600px]:font-40">We're Here To Help.</h1>}, q{max-[600px]:font-40">Talk to a person</h1>});
rex(\$h, qr{(<p class="mt-7 max-w-\[560px\] t-lead">)Have a question about your account[^<]*</p>\n<div class="mt-9"><a href="#message" class="btn-secondary px-7 py-3\.5">Contact Support .*?</ul>\n}s,
  q{${1}Tell us what you need about a booking, a draw, a result or a charge. A person replies by email.</p>} . "\n"
  . q{<div class="mt-9"><a href="#message" class="btn-primary px-7 py-3.5">Send us a message</a></div>} . "\n");

# ---- FORM ----
set_h2_after(\$h, '<section id="message"', 'Send us a message');
rex(\$h, qr{\n<p class="mt-6 max-w-\[680px\] t-lead  mx-auto">Fill out the form below[^<]*</p>}, '');
my $in = 'mt-2 w-full border-b border-hair-strong bg-transparent py-2.5 font-16 text-ink outline-none transition-colors placeholder:text-ink-3 focus:border-brand';
sub field { my ($id, $label, $ph, $type, $ac) = @_;
  qq{<div>\n<label for="c-$id" class="t-eyebrow text-ink-2">$label</label>\n<input id="c-$id" name="$id"} . ($ac ? qq{ autocomplete="$ac"} : '') . qq{ placeholder="$ph" class="$in"} . ($type ? qq{ type="$type"} : '') . qq{ value=""></div>\n} }
my @topics = ('Booking or visit', 'Results', 'Billing or refund', 'Genetic kit', 'Something else');
my $radios = ''; my $i = 0;
for my $t (@topics) {
  my $on = $i++ == 0;
  my $cls = $on ? 'border-accentink bg-accentink text-white' : 'border-hair-strong bg-white text-ink hover:border-brand';
  $radios .= qq{<button type="button" role="radio" aria-checked="} . ($on ? 'true' : 'false') . qq{" class="rounded-full border px-4 py-2 font-14 font-medium transition-colors $cls">$t</button>};
}
my $form = qq{<form novalidate="" data-contact-form class="rounded-[24px] border border-hair-strong bg-white mx-auto max-w-[820px] p-10 max-[600px]:p-6">\n<div class="grid grid-cols-2 gap-x-8 gap-y-7 max-[600px]:grid-cols-1">\n}
  . qq{<div class="col-span-2 max-[600px]:col-span-1"><span class="t-eyebrow text-ink-2" id="c-topic">Topic</span>\n<div role="radiogroup" aria-labelledby="c-topic" data-radios class="mt-3 flex flex-wrap gap-2">$radios</div></div>\n}
  . field('name', 'Name', 'Enter your name', '', 'name')
  . field('email', 'Email', 'Enter your email', 'email', 'email')
  . field('phone', 'Phone (optional)', 'Enter your phone number', 'tel', 'tel')
  . field('order', 'Order number (if you have one)', 'e.g. MY-102938', '', '')
  . qq{<div class="col-span-2 max-[600px]:col-span-1">\n<div>\n<label for="c-message" class="t-eyebrow text-ink-2">Message</label>\n<textarea id="c-message" name="message" rows="4" placeholder="Enter your message" class="$in resize-none leading-[1.55]"></textarea></div></div></div>\n}
  . qq{<p class="mt-8 text-center t-caption">Don't put medical details in this form. For anything about your results, message us from My Health.</p>\n}
  . qq{<div class="mt-6 flex justify-center"><button type="submit" class="btn-primary px-8 py-3.5">Send$ARROW</button></div></form>\n}
  . qq{<p data-contact-ok hidden class="mx-auto mt-6 max-w-[820px] rounded-[16px] bg-[#EEF5EF] px-6 py-4 text-center t-label text-accentink">Got it. We'll reply to the email you gave us.</p>};
rexf(\$h, qr{<form novalidate="".*?</form>}s, sub { $form });

# ---- DIRECT: email ----
set_h2_with(\$h, 'Get&nbsp;', 'Email us');
rex(\$h, qr{\n<div class="h-full"[^>]*><a href="mailto:info\@mryoda\.com".*?</a></div>}s, '');
rep(\$h, q{<div class="grid grid-cols-4 gap-4 max-[900px]:grid-cols-2 max-[600px]:grid-cols-1">}, q{<div class="grid grid-cols-3 gap-4 max-[900px]:grid-cols-2 max-[600px]:grid-cols-1">});
rex(\$h, qr{<h3 class="t-title-sm">Customer Support</h3>(<span[^>]*>support\@mryoda\.com</span>)\n<p class="mt-2 t-secondary">[^<]*</p>}, q{<h3 class="t-title-sm">Support</h3>${1}});
rex(\$h, qr{<h3 class="t-title-sm">Partnerships</h3>(<span[^>]*>partnerships\@mryoda\.com</span>)\n<p class="mt-2 t-secondary">[^<]*</p>}, q{<h3 class="t-title-sm">Partnerships</h3>${1}});
rex(\$h, qr{<h3 class="t-title-sm">Press</h3>(<span[^>]*>press\@mryoda\.com</span>)\n<p class="mt-2 t-secondary">[^<]*</p>}, q{<h3 class="t-title-sm">Press</h3>${1}});

# ---- DIRECT: address + ZIP check (map card) ----
set_h2_with(\$h, 'Our&nbsp;', 'Where we are');
rex(\$h, qr{(<p class="mt-6 max-w-\[680px\] t-lead  mx-auto">)Mr\. Yoda currently serves communities[^<]*</p>},
  q{${1}Home collection across more than 14,000 ZIP codes in 35 states. Enter your ZIP to check your address.</p>});
rexf(\$h, qr{<div><span class="t-eyebrow text-ink-2">Headquarters</span>.*?</ul>\n</div>}s, sub {
  q{<div><span class="t-eyebrow text-ink-2">Address</span><address class="mt-3 not-italic">}
  . q{<p class="t-title">Irving</p><p class="mt-1 t-body">2925 N Skyway Cir, Suite 140<br>Irving, TX 75038</p>}
  . q{<p class="mt-5 t-title">The Colony</p><p class="mt-1 t-body">6600 Paige Road, Suite 100<br>The Colony, TX 75056</p></address>}
  . q{<div class="mt-8">} . zip_form('zip-contact') . q{</div></div>} });
rexf(\$h, qr{<svg viewBox="0 0 960 600" class="block h-auto w-full".*?</svg>\n<ul class="mt-4 flex flex-wrap justify-center gap-2 \@min-\[640px\]:hidden" aria-hidden="true">.*?</ul>}s, sub { us_map() });

# ---- EMERGENCY LINE ----
set_h2_with(\$h, 'Contact&nbsp;', 'Contact information');
rexf(\$h, qr{<div class="h-full"[^>]*><a href="tel:\+19134353535".*?</a></div>}s, sub {
  q{<div class="h-full"><div class="rounded-[24px] border border-hair-strong bg-white flex h-full items-center gap-5 p-7"><span class="grid h-12 w-12 shrink-0 place-items-center rounded-full bg-[#fce6e0] text-[#b8453b]"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" class="h-5 w-5"><path d="M12 8v5M12 16.5v.5" stroke-linecap="round"></path><path d="M10.3 3.9 2.6 17.5A2 2 0 0 0 4.3 20.5h15.4a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0Z" stroke-linejoin="round"></path></svg></span><span class="min-w-0"><span class="t-eyebrow text-ink-2 block">Emergency</span><span class="mt-1.5 block t-title-sm">If this is a medical emergency, call 911.</span></span></div></div>} });

save('contact.html', $h);
