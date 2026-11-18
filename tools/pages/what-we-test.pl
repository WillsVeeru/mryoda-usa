#!/usr/bin/perl
# What we test: USA copy
use strict; use warnings; use utf8;
require './tools/lib.pl';
our $ARROW;
my $h = load('tools/base/what-we-test.html');
add_css(\$h, '44tzt5kjohgtk');

set_title(\$h, 'What We Test: 164 Biomarkers in 17 Health Areas | Mr Yoda',
  'Every biomarker in the Biomarker Membership, grouped by health area: heart, blood sugar, liver, kidney, thyroid, hormones, vitamins, blood count and urine. Read what each one measures before you join.');

# ---- HERO ----
rep(\$h, q{text-[clamp(32px,9vw,40px)]">Know what we test.</h1>}, q{text-[clamp(32px,9vw,40px)]">164 biomarkers. Here's every one.</h1>});
rep(\$h, q{max-[600px]:text-[16px]">164 biomarkers. 17 health areas. One clear view of your health.</p>},
         q{max-[600px]:text-[16px]">Read what each test measures and what a result can and can't tell you, before you pay for anything.</p>});
rex(\$h, qr{(<a href="#biomarkers" class="btn-primary[^"]*">)Explore the tests }, '${1}Browse the 17 areas ');
rex(\$h, qr{(<a href=")what-we-test.html(" class="btn-secondary-dark[^"]*">)View membership}, '${1}#wwt-plan${2}Join for $299 a year');
rex(\$h, qr{\n<p class="mt-4 t-caption text-white/70 max-\[600px\]:mt-3">The full panel, twice a year · \$299/year</p>}, '');

# ---- HOW WE COUNT + 17 AREAS ----
rep(\$h, q{<h2 class="t-h2">Explore by health area.</h2>}, q{<h2 class="t-h2">How we count</h2>});
rep(\$h, q{<p class="WhatWeTest-module__xNTvmW__subtitle">Pick an area to see its tests. Every biomarker is included at both yearly visits.</p>},
         q{<p class="WhatWeTest-module__xNTvmW__subtitle">66 are measured directly on your sample. 63 are calculated from those (eGFR from creatinine, for example). 35 are the individual readings inside your blood count and urine profiles. We list all three kinds separately so the number isn't padded.</p>});
rep(\$h, q{placeholder="Search a test or condition"}, q{placeholder="Search a test or a condition"});
rep(\$h, q{aria-pressed="true">All<span>164</span>}, q{aria-pressed="true">All<span>164</span>});

my @areas = (
  ['Heart &amp; cholesterol', 'Heart and cholesterol', 21, "Cholesterol, the particles that carry it, and Lp(a), the inherited one most checkups skip."],
  ['Blood sugar &amp; metabolism', 'Blood sugar and metabolism', 11, 'Glucose, HbA1c and fasting insulin, which can rise years before blood sugar does.'],
  ['Liver', 'Liver', 17, "How well your liver makes proteins and clears waste, and whether it's under strain."],
  ['Kidney', 'Kidney', 7, 'How well your kidneys filter your blood, and whether protein is leaking into your urine.'],
  ['Electrolytes &amp; minerals', 'Electrolytes and minerals', 7, 'Sodium, potassium, calcium and magnesium: what your nerves and muscles run on.'],
  ['Thyroid', 'Thyroid', 10, 'TSH with free T3, free T4 and both antibodies. Most checkups stop at TSH.'],
  ['Hormones', 'Hormones', 19, 'Cortisol, testosterone, estradiol and the rest of the hormones behind sleep, energy and fertility.'],
  ['Iron &amp; vitamins', 'Iron and vitamins', 8, 'Iron stores, B12, folate and vitamin D.'],
  ['Inflammation &amp; blood count ratios', 'Inflammation and blood count ratios', 15, 'hs-CRP and ratios worked out from your blood count that point to low-level inflammation.'],
  ['Autoimmunity &amp; joints', 'Autoimmunity and joints', 2, 'Two antibodies linked to rheumatoid arthritis.'],
  ['Bone &amp; muscle', 'Bone and muscle', 3, 'Parathyroid hormone for bone health, and creatine kinase for muscle strain.'],
  ['Pancreas', 'Pancreas', 2, 'Amylase and lipase, which rise when the pancreas is inflamed.'],
  ['Prostate', 'Prostate', 3, 'Total and free PSA. Only relevant if you have a prostate.'],
  ['Tumor markers', 'Tumor markers', 4, "AFP, CEA, CA 19-9 and CA 15-3. A raised result calls for follow-up with your doctor; it isn't a cancer screen."],
  ['Complete blood count (CBC)', 'Complete blood count', 16, 'Red cells, white cells and platelets.'],
  ['Urinalysis', 'Urinalysis', 11, 'A chemical read of your urine for sugar, protein, blood and signs of infection.'],
  ['Urine microscopy', 'Urine microscopy', 8, 'What the lab sees under the microscope: cells, crystals, bacteria.'],
);
for my $a (@areas) {
  my ($old, $new, $n, $intro) = @$a;
  rep(\$h, qq{<span class="WhatWeTest-module__xNTvmW__cardName">$old</span><span class="WhatWeTest-module__xNTvmW__cardCount">$n biomarkers</span>},
           qq{<span class="WhatWeTest-module__xNTvmW__cardName">$new</span><span class="WhatWeTest-module__xNTvmW__cardCount">$n biomarkers · tested at both visits</span><span class="wwt-card-intro">$intro</span>});
}

# ---- PLAN CARD ----
rep(\$h, q{<h2 id="wwt-plan-h" class="t-h2">All 164 biomarkers, in one membership.</h2>}, q{<h2 id="wwt-plan-h" class="t-h2">All 164 are in the membership</h2>});
rep(\$h, q{<p class="WhatWeTest-module__xNTvmW__subtitle">No single tests, no add-ons to choose. One price for the year.</p>},
         q{<p class="WhatWeTest-module__xNTvmW__subtitle">There are no single tests to choose and no add-ons to price. You get the whole panel, two times.</p>});
rep(\$h, q{<p class="WhatWeTest-module__xNTvmW__planName">Biomarker membership</p>}, q{<p class="WhatWeTest-module__xNTvmW__planName">Biomarker Membership</p>});
rep(\$h, q{<p class="WhatWeTest-module__xNTvmW__planTagline">One panel. Twice a year. Paid once, covers 12 months.</p><button type="button" class="btn-primary mt-6 w-full justify-center">Join membership<svg},
         q{<p class="WhatWeTest-module__xNTvmW__planTagline">Renews yearly; cancel any time.</p><button type="button" class="btn-primary mt-6 w-full justify-center">Join for $299 a year<svg});
# replace the six plan list texts in order, keeping their icons
my @plan_new = ('164 biomarkers across 17 health areas', 'Two visits a year, the full panel at both', 'Home draw in a 2-hour window, or our Irving or The Colony clinic',
  'Results in 24 to 48 hours', 'Both visits compared in My Health', 'Add family members and book them at their own address');
rexf(\$h, qr{<ul class="WhatWeTest-module__xNTvmW__planList">.*?</ul>}s, sub {
  my $ul = shift; my $i = 0;
  $ul =~ s{(</svg>)([^<]+)(</li>)}{$1 . $plan_new[$i++] . $3}ge;
  die "plan list: expected 6 items, got $i\n" unless $i == 6; $ul });
rep(\$h, q{<section id="wwt-plan"}, q{<section id="plan" class="sr-only" aria-hidden="true"></section>} . "\n" . q{<section id="wwt-plan"});

# ---- BEFORE YOUR VISIT (new, How-it-works tips design) ----
my $before = card_pair(id => 'before-your-draw',
  left_title => 'Before your draw',
  left => ['Plan to fast before your draw. Water is fine. Your booking confirmation gives the exact fasting time.',
    'Book a morning slot if you can. Cortisol and testosterone are highest early.',
    'Skip hard exercise the day before; it can raise CK and liver enzymes.',
    'Tell us about medications and supplements. High-dose biotin (often sold for hair and nails) can affect thyroid and hormone results.',
    'If you have periods, note the first day of your last one.',
    'For the urine sample, collect midstream.'],
  right_title => "Who it's for",
  right_html => q{<p class="mt-8 t-lead text-white/85">Adults 18 and over. PSA applies only to people with a prostate. If you're pregnant, tell us when you book.</p>}
    . "\n" . q{<div class="mt-10 border-t border-white/15 pt-8">} . zip_form('zip-wwt') . q{</div>},
);
$before =~ s/class="zip-form"/class="zip-form zip-on-dark"/;
# the old final CTA has no USA copy; "Before your draw" takes its place
cut_between(\$h, '<section id="wwt-final"', '<section id="faqs"');
insert_before(\$h, '<section id="faqs"', $before);

# ---- FAQ ----
set_faq(\$h, '<section id="faqs"',
  'Are all 164 run at both visits?', 'Yes. Visit 2 repeats the whole panel, any time from three months after visit 1.',
  'Why do you count calculated results?', 'Because your doctor uses them. eGFR, non-HDL cholesterol and HOMA-IR are all calculated. We label them so you can see which is which.',
  'Is this a cancer screening?', "No. PSA and the four tumor markers can prompt a follow-up, but on their own they don't screen for or diagnose cancer.",
  "Can I add a test that isn't on the list?", 'Not at launch. Tell our support team what you wanted; we keep a list.');

# ---- PAGE FOOTER LINE ----
rexf(\$h, qr{More frequently asked questions .*?<\/a><\/div><\/div><\/section>}s, sub { my $m = shift; $m =~ s{<\/div><\/section>$}{<p class="mx-auto mt-12 max-w-[720px] text-center t-caption">Results describe your health on the day of the draw. They can't predict every future condition or rule out disease. Review them with your doctor.</p></div></section>}; $m });
rep(\$h, q{<button type="button" class="btn-primary shrink-0">Join membership<svg}, q{<button type="button" class="btn-primary shrink-0">Join for $299 a year<svg});

save('what-we-test.html', $h);
