#!/usr/bin/perl
# My Health: USA copy
use strict; use warnings; use utf8;
require './tools/lib.pl';
our $ARROW;
my $h = load('tools/base/my-health.html');
add_css(\$h, '18qv15ncp9btc');
drop_drawers(\$h);

set_title(\$h, 'My Health: Your Lab Results, Tracked Over Time | Mr Yoda',
  'My Health sorts every Mr Yoda result by body system, compares visit 1 with visit 2, and connects Apple Health, Oura and WHOOP. Included with the Biomarker Membership.');

# framer-motion start states -> visible (the name prompt is handled below)
$h =~ s{ style="opacity: 0; transform: translateY\([^)]*\)(?: scale\([^)]*\))?;?"}{}g;
$h =~ s{(<span class="inline-block") style="opacity: 0; transform: translateY\([^)]*\);?"}{$1}g;
$h =~ s{(data-state-item="true" class="[^"]*") style="opacity: 0\.4;"}{$1 style="opacity: 1;"}g;

# ---- OPENING (personalisation prompt) ----
rep(\$h, q{<div class="fixed inset-0 z-[90] overflow-hidden bg-[#E8E7E5]/55 backdrop-blur-xl" data-lenis-prevent="true" style="opacity: 0;"><button type="button" aria-label="Skip for now" class="absolute inset-0 cursor-default"></button>},
         q{<div class="fixed inset-0 z-[90] overflow-hidden bg-[#E8E7E5]/55 backdrop-blur-xl" data-lenis-prevent="true" data-name-prompt><button type="button" aria-label="Skip for now" class="absolute inset-0 cursor-default" data-close-prompt></button>});
rep(\$h, q{aria-label="Let’s make this yours."}, q{aria-label="What should we call you?"});
rep(\$h, qq{<h2 class="mt-6 mhp-h3">Let’s make this yours.</h2>\n<p class="mt-2 mhp-body">Just your first name. Nothing else.</p>\n<form>},
         qq{<h2 class="mt-6 mhp-h3">What should we call you?</h2>\n<p class="mt-2 mhp-body">First name only.</p>\n<form data-name-form="dashboard">});
rep(\$h, q{<button type="button" class="mx-auto mt-3 block px-2 py-2 text-[13px] text-[#65655F] transition-colors hover:text-ink">Skip, just show me a sample</button>},
         q{<button type="button" data-skip class="mx-auto mt-3 block px-2 py-2 text-[13px] text-[#65655F] transition-colors hover:text-ink">Skip and see a sample</button>});

# ---- HERO ----
rexf(\$h, qr{<h1 class="mt-7 t-h1 text-\[clamp\(38px,4\.3vw,62px\)\] \[text-wrap:balance\] max-\[600px\]:mt-5">.*?</h1>}s, sub {
  q{<h1 class="mt-7 t-h1 text-[clamp(38px,4.3vw,62px)] [text-wrap:balance] max-[600px]:mt-5" data-hero-name>See what changed since your last draw.</h1>} });
rep(\$h, q{[text-wrap:pretty]">One dashboard. Every result, mapped to you specifically. Biological age, tracked over time. A plan that changes as your numbers do.</p>},
         q{[text-wrap:pretty]">Every result sorted by body system. Visit 1 next to visit 2. A short list of what to do before visit 3.</p>});
rexf(\$h, qr{<button type="button" data-subscribe="true" class="mhp-btn is-primary">Subscribe<svg.*?</svg></button><a href="#body" class="mhp-btn is-ghost">Explore your body systems<svg.*?</svg></a></div>}s, sub {
  my ($svg) = $_[0] =~ m{(<svg.*?</svg>)}s;
  qq{<a href="what-we-test.html#plan" class="mhp-btn is-primary">Join for \$299 a year$svg</a></div>\n}
  . q{<p class="mt-5 max-w-[460px] t-caption">My Health comes with the Biomarker Membership, DNA Decoder, MedMatch and the Yodaara panel.</p>} });

# ---- SORTED RESULTS ----
set_h2_after(\$h, '<section id="sorted"', 'Four labels, so you know where to look');
rex(\$h, qr{\n<p data-sorted-lead="true"[^>]*>Four states, so it’s clear at a glance[^<]*</p>}, '');
rep(\$h, '>Outside the expected range<', '>Outside the expected range<');
rep(\$h, '>Just outside range, keep an eye on it<', '>Just outside, recheck at visit 2<');
rex(\$h, qr{<span class="mt-0\.5 block text-\[13px\] leading-\[1\.45\] text-\[#65655F\]">Normal</span>}, q{<span class="mt-0.5 block text-[13px] leading-[1.45] text-[#65655F]">In range</span>});
rep(\$h, '>Better than normal<', ">Inside the tighter range we'd aim for<");

# ---- BODY SYSTEMS ----
set_h2_after(\$h, '<section id="body"', 'Your results, by body system');
rex(\$h, qr{(<p data-head-lead="true"[^>]*>)Click into any system\.[^<]*</p>},
  q{${1}Heart, liver, kidneys, thyroid, blood sugar, hormones and the rest, each scored from your own biomarkers. Anything worth a look is colored before you read a number.</p>});
rep(\$h, q{<p class="mt-6 t-caption">Illustrative example. Your actual results will look like this once testing is complete.</p>},
         q{<p class="mt-6 t-caption">Sample data. Your results appear here after your first draw.</p>});

# ---- FEATURES ----
set_h2_after(\$h, '<section id="biological-age"', 'An estimate of how old your body is acting');
rex(\$h, qr{(<p data-head-lead="true"[^>]*>)Calculated from blood biomarkers[^<]*</p>},
  q{${1}Worked out from your blood biomarkers, genetics and everyday vitals. It moves between visits. It's a wellness score, so read it as a guide.</p>});

set_h2_after(\$h, '<section id="plan"', 'What to do next');
rex(\$h, qr{(<p data-head-lead="true"[^>]*>)Results become specific next steps\.[^<]*</p>}, q{${1}Which markers to recheck and when, and what to raise with your doctor.</p>});
# Food and movement tile (one block)
rexf(\$h, qr{<p class="mhp-eyebrow">Eat and Move</p>\n<div class="mt-5 grid flex-1 gap-6 min-\[520px\]:grid-cols-2">\n<div>\n(<p class="flex items-center gap-3[^\n]*\n<svg.*?</svg></span>)Eat</p>\n<p class="mt-3 mhp-body">[^<]*</p></div>\n<div>\n.*?Move</p>\n<p class="mt-3 mhp-body">[^<]*</p></div></div>}s, sub {
  my ($ico) = $_[0] =~ m{<div>\n(<p class="flex items-center gap-3[^\n]*\n<svg.*?</svg></span>)Eat</p>}s;
  qq{<p class="mhp-eyebrow">Food and movement</p>\n<div class="mt-5 grid flex-1 gap-6">\n<div>\n${ico}Meal plan</p>\n<p class="mt-3 mhp-body">A meal plan built from your biomarkers, diet and allergies. Photograph a plate and it logs the calories.</p></div></div>} });
rexf(\$h, qr{</span>Supplements and medication</p>\n<h3 class="mt-5 mhp-h4">[^<]*</h3>\n<p class="mt-2 mhp-body">[^<]*</p>\n<p class="mt-3 text-\[12px\][^"]*">[^<]*</p>}, sub {
  qq{</span>Supplements</p>\n<p class="mt-5 mhp-body">Log what you take by photographing the bottle. Suggestions come from your results, for supplements only.</p>\n<p class="mt-3 text-[12px] leading-[1.5] text-[#65655F]">Prescriptions are your doctor's call. These statements have not been evaluated by the FDA.</p>} });
# the Recheck tile repeats "What to do next"; Supplements takes its column
rexf(\$h, qr{<div data-day-tile="true" class="mhp-tile flex flex-col"( style="[^"]*")?>\n(?=<p class="flex items-center gap-3[^\n]*\n<svg.*?</svg></span>Supplements</p>)}, sub {
  my ($st) = $_[0] =~ /( style="[^"]*")/; $st //= ''; qq{<div data-day-tile="true" class="mhp-tile flex flex-col min-[700px]:col-span-2"$st>\n} });
rex(\$h, qr{\n<div data-day-tile="true" class="mhp-tile flex flex-col"[^>]*>\n<p class="flex items-center gap-3[^\n]*\n<svg.*?</svg></span>Recheck</p>.*?Set reminders</button></div></div>}s, '');
my @feat = (['Wearables', 'Wearables', 'Connect Apple Health, Oura or WHOOP. Sleep, heart rate and steps sit beside the lab numbers that explain them.'],
  ['Family', 'Family', 'One sign-in for the household. Switch profiles and the dashboard switches with you.'],
  ['Consultations', 'Talk to someone', 'Book a doctor, nutritionist, therapist or fitness specialist. They see your results before the call.'],
  ['Already tested elsewhere', 'Tested elsewhere', 'Upload a Quest or Labcorp report and it joins your timeline.']);
for my $f (@feat) { my ($o, $t, $b) = @$f;
  rex(\$h, qr{<p class="mt-5 mhp-eyebrow !text-\[11px\]">\Q$o\E</p>\n<h3 class="mt-2 mhp-h4">[^<]*</h3>\n<p class="mt-2 mhp-body">[^<]*</p>},
    qq{<h3 class="mt-5 mhp-h4">$t</h3>\n<p class="mt-2 mhp-body">$b</p>}); }

# roadmap tiles
rex(\$h, qr{(</span>)Longevity roadmap</p>\n<h3 class="mt-6 mhp-h3">[^<]*</h3>\n<p class="mt-3 mhp-body">[^<]*</p>},
  q{${1}Longevity score</p>} . "\n" . q{<h3 class="mt-6 mhp-h3">One number out of 100, with each missing point traced to a result you can change.</h3>});
rex(\$h, qr{(</span>)Genetics, in plain language</p>\n<h3 class="mt-6 mhp-h3">[^<]*</h3>\n<p class="mt-3 mhp-body">[^<]*</p>},
  q{${1}Genetics</p>} . "\n" . q{<h3 class="mt-6 mhp-h3">Once you've taken DNA Decoder or MedMatch, your genetic risks sit under the same body systems as your blood work.</h3>});

# ---- FAQ (this page's own accordion markup) ----
my @qa = ('What is My Health?', 'The place your Mr Yoda results live, on the web and in the app. It sorts them by body system and compares each visit with the last.',
  'Does it cost extra?', 'No. It comes with the Biomarker Membership and with every genetic panel.',
  'Can I upload old lab results?', 'Yes: PDFs or photos from any US lab.',
  'Which wearables connect?', 'Apple Health, Oura and WHOOP.',
  'Is my data private?', "Your results are encrypted, and we follow HIPAA. We don't sell health data. You can download or delete yours from Settings.",
  'Is the assistant a doctor?', "No. It explains what a marker is and what your number means. It can't diagnose or prescribe.");
rexf(\$h, qr{(<ul class="border-t border-\[rgba\(28,31,26,\.1\)\]">\n)(<li data-faq-row="true".*?</li>)\n?.*?</ul>}s, sub {
  my ($tpl) = $_[0] =~ m{(<li data-faq-row="true".*?</li>)}s;
  my $out = qq{<ul class="border-t border-[rgba(28,31,26,.1)]">\n}; my @x = @qa;
  while (my ($q, $a) = splice(@x, 0, 2)) {
    my $li = $tpl; $li =~ s{(<span class="t-title-sm">)[^<]*}{$1$q}; $li =~ s{(<p class="max-w-\[640px\] pb-6[^"]*">)[^<]*}{$1$a}; $out .= "$li\n"; }
  $out . '</ul>' });

save('my-health.html', $h);
