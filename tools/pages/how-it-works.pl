#!/usr/bin/perl
# How it works: USA copy
use strict; use warnings; use utf8;
require './tools/lib.pl';
our $ARROW;
my $h = load('tools/base/how-it-works.html');

set_title(\$h, 'How the Membership Works | Mr Yoda',
  'Join online, pick a morning, and a phlebotomist comes to you. A licensed physician reviews every report before you see it.');

# ---- HERO ----
rep(\$h, q{<h1 class=" t-h1 font-64 max-[600px]:font-40">How membership works.</h1>}, q{<h1 class=" t-h1 font-64 max-[600px]:font-40">How the membership works</h1>});
rep(\$h, q{<p class="mt-6 max-w-[620px] t-lead">One membership, two visits a year, results in 24-48 hours. No referral and no doctor’s appointment first.</p>},
         q{<p class="mt-6 max-w-[620px] t-lead">Join online, pick a morning, and a phlebotomist comes to you. A licensed physician reviews every report before you see it.</p>});
rep(\$h, q{>02</span>Give a sample</a>}, q{>02</span>Get drawn</a>});
rep(\$h, q{>03</span>Results and visit 2</a>}, q{>03</span>Read, then repeat</a>});

# ---- THREE STEPS ----
rep(\$h, qq{<h2 class="mt-5 max-w-[560px] t-h2">Join the membership.</h2>\n<p class="mt-5 max-w-[560px] t-body">One membership covers 150+ biomarkers across 17 categories, tested at two visits a year. Join for yourself or a family member, anywhere we collect. Open any test to see what it measures and why it matters.</p>},
         qq{<h2 class="mt-5 max-w-[560px] t-h2">Join</h2>\n<p class="mt-5 max-w-[560px] t-body">\$299 covers both visits for one person, and the year starts the day you join. Booking for your mother in Plano while you live in Seattle? Add her at checkout with her address.</p>});
rep(\$h, qq{<h2 class="mt-5 max-w-[560px] t-h2">A phlebotomist at your door. Or visit our lab.</h2>\n<p class="mt-5 max-w-[560px] t-body">Pick a day and a 2-hour arrival window. A certified phlebotomist comes to the address you choose, or visit one of our two Dallas-area labs. The draw takes 5-10 minutes, and every sample is processed in our own lab.</p>},
         qq{<h2 class="mt-5 max-w-[560px] t-h2">Get drawn</h2>\n<p class="mt-5 max-w-[560px] t-body">Pick a day and a 2-hour arrival window. Your phlebotomist checks your ID, labels the tubes in front of you and is gone in about 10 minutes. Prefer to come in? Use our Irving or The Colony clinic.</p>});
rep(\$h, qq{<h2 class="mt-5 max-w-[560px] t-h2">Results in 24-48 hours. Then see what changed.</h2>\n<p class="mt-5 max-w-[560px] t-body">Results land in MyHealth 24-48 hours after your sample reaches our lab, grouped by body system and explained in plain language. Three to six months later, visit 2 runs the full panel again so you can see what improved. Retest anything that still needs a closer look.</p>},
         qq{<h2 class="mt-5 max-w-[560px] t-h2">Read, then repeat</h2>\n<p class="mt-5 max-w-[560px] t-body">Results land in My Health in 24 to 48 hours, grouped by health area, each marker shown as in range, low or high with a plain explanation. From month three, book visit 2 and see what changed. Use it before your year ends.</p>});
rep(\$h, q{</svg>150+ biomarkers · 2 visits a year</span>}, q{</svg>$299 · both visits</span>});
rep(\$h, q{</svg>Results in 24-48 hours</span>}, q{</svg>Results in 24 to 48 hours</span>});

# ---- DRAW DAY / AFTER YOUR RESULTS ----
rep(\$h, q{<h2 class=" t-h3">Collection day tips</h2>}, q{<h2 class=" t-h3">On the morning</h2>});
rexf(\$h, qr{(<h2 class=" t-h3">On the morning</h2>\n<ul class="mt-8 space-y-\[18px\]">\n).*?(</ul>)}s, sub {
  my $m = shift; my ($a) = $m =~ /^(.*?space-y-\[18px\]">\n)/s;
  $a . check_items(0, 'Follow the fasting time in your confirmation; drink water.', 'Wear sleeves that roll up.', 'Have a photo ID ready.', 'Most people feel a quick pinch and nothing after.') . '</ul>' });
rep(\$h, q{<h2 class=" t-h3 text-white">After results arrive</h2>}, q{<h2 class=" t-h3 text-white">Once results are in</h2>});
rexf(\$h, qr{(<h2 class=" t-h3 text-white">Once results are in</h2>\n<ul class="mt-8 space-y-\[18px\]">\n).*?(</ul>)}s, sub {
  my $m = shift; my ($a) = $m =~ /^(.*?space-y-\[18px\]">\n)/s;
  $a . check_items(1, 'You get a text and an email when results are in.', 'Send your doctor a secure link or a PDF.',
    "Ask the My Health assistant what a marker means. It explains results; it doesn't give medical advice.",
    "If a result is at a critical level, it's flagged in My Health and our team contacts you.") . '</ul>' });

# ZIP check under the two cards (sitewide block)
rexf(\$h, qr{Once results are in</h2>.*?</ul>\n</div></div></div>}s, sub {
  shift() . "\n" . q{<div class="mt-6 rounded-[28px] border border-hair-strong bg-white p-10 max-[600px]:p-6" data-reveal><div class="grid grid-cols-[1fr_1.1fr] items-center gap-12 max-[900px]:grid-cols-1 max-[900px]:gap-6"><div><h2 class="t-h3">Check your address</h2><p class="mt-3 t-body">Home collection across more than 14,000 ZIP codes in 35 states, or our Irving and The Colony clinics in Texas.</p></div>}
  . zip_form('zip-how') . q{</div></div>} });

# ---- CLOSING BAND ----
rep(\$h, q{<section class="bg-[linear-gradient(160deg,#123527_0%,#0A1F16_100%)] py-[118px] max-[900px]:py-[84px] max-[600px]:py-16">},
         q{<section class="bg-white py-[118px] max-[900px]:py-[84px] max-[600px]:py-16">});
rep(\$h, q{<h2 class="t-h2 text-white">Two visits a year between you and answers.</h2>}, q{<h2 class="t-h2 text-ink">Book visit 1 this week.</h2>});
rex(\$h, qr{\n?<p class="mt-5 t-lead text-white/85">No referral\. No waiting room\. Results in 24-48 hours, explained in plain language\.</p>(<a href=")#(" class="btn-primary group mt-10[^"]*">)Join membership}, '${1}what-we-test.html#plan${2}Join for $299 a year');

rep(\$h, 'results in MyHealth"', 'results in My Health"');

save('how-it-works.html', $h);
