#!/usr/bin/perl
# About: USA copy
use strict; use warnings; use utf8;
require './tools/lib.pl';
our $ARROW;
my $h = load('tools/base/about.html');

set_title(\$h, 'About Mr Yoda | Lab Testing Without the Errand',
  'Mr Yoda sends a phlebotomist to your home, has a physician order and review the panel, and tells you in plain English what moved. Our own CLIA-certified lab is in The Colony, Texas.');

# ---- HERO ----
rep(\$h, q{max-[600px]:font-40">Lab Testing That Starts With You, Not A Referral.</h1>}, q{max-[600px]:font-40">Lab testing without the errand</h1>});
rex(\$h, qr{(<p class="mt-7 max-w-\[560px\] t-lead">)[^<]*</p>\n<p class="mt-4 max-w-\[560px\] t-lead font-medium text-ink">[^<]*</p>},
  q{${1}Getting blood work in the US usually takes a doctor's visit to get the order, a second trip to the lab, and a portal full of numbers nobody explains. Mr Yoda sends a phlebotomist to your home, has a physician order and review the panel, and tells you in plain English what moved.</p>});
rex(\$h, qr{<a href="#" class="btn-primary px-7 py-3\.5">Shop Tests (?:<svg.*?</svg>)?</a><a href="what-we-test\.html" class="btn-secondary px-7 py-3\.5">Memberships(?:<svg.*?</svg>)?</a><a href="#contact" class="btn-secondary px-7 py-3\.5">Contact Us (?:<svg.*?</svg>)?</a>}s,
  q{<a href="what-we-test.html" class="btn-primary px-7 py-3.5">See what we test</a><a href="what-we-test.html#plan" class="btn-secondary px-7 py-3.5">Join for $299 a year</a>});

# ---- THE LAB ----
set_h2_after(\$h, '<span class="block t-eyebrow ">The Lab</span>', 'Our own lab');
rex(\$h, qr{(<p class="mt-6 max-w-\[680px\] t-lead  mx-auto">)Every test ordered through Mr\. Yoda[^<]*</p>\n<p class="mt-6 max-w-\[680px\] t-lead  mx-auto">[^<]*</p>},
  q{${1}Blood and urine samples are run by TestGo Diagnostics, our CLIA-certified, COLA-accredited laboratory in The Colony, Texas. We don't send them to a third party, which is how results come back in 24 to 48 hours.</p>});
rex(\$h, qr{<h3 class="mt-6 t-title">CLIA Certified</h3>\n<p class="mt-2 t-secondary">[^<]*</p>}, q{<h3 class="mt-6 t-title">CLIA-certified and COLA-accredited</h3>});
rex(\$h, qr{<h3 class="mt-6 t-title">HIPAA Compliant</h3>\n<p class="mt-2 t-secondary">[^<]*</p>}, q{<h3 class="mt-6 t-title">Results reviewed by a licensed physician</h3>});
rex(\$h, qr{<h3 class="mt-6 t-title">Physician Reviewed</h3>\n<p class="mt-2 t-secondary">[^<]*</p>}, q{<h3 class="mt-6 t-title">Health data protected under HIPAA</h3>});

# ---- WHY ----
rep(\$h, q{<span class="block t-eyebrow ">Why We Built Mr. Yoda</span>}, q{<span class="block t-eyebrow ">Why we built it</span>});
set_h2_after(\$h, '<span class="block t-eyebrow ">Why we built it</span>', 'Why Mr Yoda');
rex(\$h, qr{(<p class="mt-6 max-w-\[680px\] t-lead  mx-auto">)Getting a blood test shouldn't mean[^<]*</p>\n<p class="mt-6 max-w-\[680px\] t-lead  mx-auto">[^<]*</p>},
  q{${1}Sudhakar Kancharla started Yoda after taking his two-year-old to more than 25 specialists without getting an answer. The idea since then has been the same: run the tests in one place, and explain the result to the person it belongs to.</p>});
# "The Experience" carousel has no USA copy
rexf(\$h, qr{<div class="mb-6 text-center"[^>]*><span class="t-eyebrow">The Experience</span></div></div>\n.*?(?=<section class="py-\[var\(--section-y\)\]  border-t border-hair-strong ">)}s,
  sub { "</div></section>\n" });

# ---- WHERE WE ARE ----
rexf(\$h, qr{<section class="py-\[var\(--section-y\)\]  border-t border-hair-strong ">\n<div class="max-w-\[var\(--page-max\)\] mx-auto px-\[var\(--gutter\)\] ">\n<div[^>]*><span class="block t-eyebrow ">Where We Are Today</span>.*?</section>\n}s,
  sub { where_we_are(lead => 'Home collection across more than 14,000 ZIP codes in 35 states.', zip_id => 'zip-about') });

# Leadership team is kept as is. "Beyond blood work" and the contact strip have no USA copy (Contact has its own page).
rexf(\$h, qr{<section class="py-\[var\(--section-y\)\]  border-t border-hair-strong ">\n<div class="max-w-\[var\(--page-max\)\] mx-auto px-\[var\(--gutter\)\] ">\n<div[^>]*><span class="block t-eyebrow ">Beyond Blood Work</span>.*?(?=</div></main>)}s, sub { '' });

save('about.html', $h);
