#!/usr/bin/perl
# MedMatch: USA copy
use strict; use warnings; use utf8;
require './tools/lib.pl';
our $ARROW;
my $h = load('tools/base/medmatch.html');
add_css(\$h, '1bz8_fetwzi8s');
drop_drawers(\$h);

set_title(\$h, 'MedMatch: Pharmacogenomic (PGx) Testing at Home | Mr Yoda',
  'A cheek swab shows how your genes process 260+ medications, including antidepressants, statins, blood thinners and pain medication. A report to share with your doctor. $499.');

# ---- HERO ----
rex(\$h, qr{(<h1\b[^>]*>)The right medication for your body, not just your condition\.</h1>}, q{${1}Know how your body handles a medication before you take it.</h1>});
rex(\$h, qr{(<p\b[^>]*>)One cheek swab reads how your genes process 260\+ medications.*?</p>},
  q{${1}The enzymes that break down a drug are built from your genes. One cheek swab shows which medications you're likely to clear too fast, too slowly or about as expected, in a report written for your doctor and pharmacist.</p>});
rep(\$h, q{max-[600px]:w-full">Buy now — $499</button><a href="#panels" class="btn-secondary min-h-12 max-[600px]:w-full">View all panels</a>},
         q{max-[600px]:w-full">Order MedMatch · $499</button><a href="#examples" class="btn-secondary min-h-12 max-[600px]:w-full">See what it checks</a>});
rex(\$h, qr{(<p\b[^>]*>)\$499 for the panel with a year of membership\. HSA and FSA eligible\.</p>},
  q{${1}Includes access to My Health, where you can check any new prescription against your report.</p>});

# ---- THE PANEL (pricing block) ----
rep(\$h, q{<span class="t-eyebrow">Panel + membership</span><span class="rounded-full bg-brand/12 px-3 py-1.5 t-chip text-accentink">Membership included</span>},
         q{<span class="t-eyebrow">One panel</span><span class="rounded-full bg-brand/12 px-3 py-1.5 t-chip text-accentink">Taken once</span>});
rep(\$h, q{<span>MedMatch Plus</span> <span class="MedMatchPanelHero-module__9WBLHW__offerSubtitle">+ a year of membership</span>},
         q{<span>MedMatch</span>});
rep(\$h, q{<p class="mt-5 max-w-[520px] t-body">How your genes may shape your response to 260+ medications, with the comprehensive panel and its specialist sub-panels.</p>},
         q{<p class="mt-5 max-w-[520px] t-body">MedMatch results are for your doctor to use alongside your history and other medications. They don't replace medical advice.</p>});
my @pts = ('260+ medications checked', 'Every major drug class in one report', 'A summary page for your doctor', 'Cheek swab at home', 'My Health access');
rexf(\$h, qr{<ul class="MedMatchPanelHero-module__9WBLHW__benefits">\n<li>\n(<svg[^\n]*?<\/svg>)<span>[^<]*<\/span><\/li>.*?<\/ul>}s, sub {
  my ($icon) = $_[0] =~ m{<li>\n(<svg.*?</svg>)}s;
  qq{<ul class="MedMatchPanelHero-module__9WBLHW__benefits">\n} . join("\n", map { "<li>\n$icon<span>$_</span></li>" } @pts) . '</ul>' });
rep(\$h, q{<span class="t-price MedMatchPanelHero-module__9WBLHW__price">$499</span></p>},
         q{<span class="t-price MedMatchPanelHero-module__9WBLHW__price">$499</span><s class="t-secondary text-ink-2"><span class="sr-only">Was </span>$599</s></p>});
rep(\$h, q{<p class="mt-2 t-caption">One-time payment · Read once, keep for life</p>}, q{<p class="mt-2 t-caption">One payment · taken once</p>});
rep(\$h, q{<button type="button" class="btn-primary h-13 px-7">Choose plan · $499<svg}, q{<button type="button" class="btn-primary h-13 px-7">Order MedMatch · $499<svg});
rep(\$h, q{<button type="button" class="btn-secondary h-13 px-6">Plan details</button>}, q{<a href="#examples" class="btn-secondary h-13 px-6">See what it checks</a>});
rep(\$h, q{MedMatchPanelHero-module__9WBLHW__floatName">MedMatch Plus + membership</span>}, q{MedMatchPanelHero-module__9WBLHW__floatName">MedMatch</span>});
rep(\$h, q{class="btn-primary h-13 shrink-0 px-6">Buy now</button>}, q{class="btn-primary h-13 shrink-0 px-6">Order MedMatch</button>});

# sub-panel list (Comprehensive / Cardio / Psychiatric / Pain) has no USA copy
cut_between(\$h, q{<section class="py-[var(--section-y)]  border-t border-hair-strong overflow-hidden">}, '<section id="problem"');

# ---- THE PROBLEM ----
rep(\$h, q{<h2 class="mt-[18px] t-h2">Same prescription, different bodies.</h2>}, q{<h2 class="mt-[18px] t-h2">Same prescription, different result</h2>});
rex(\$h, qr{(<p class="mt-5 t-lead">)Different bodies process drugs differently\..*?</p>},
  q{${1}Two people take the same antidepressant at the same dose. One feels better in a month. The other gets the side effects and little else, and spends the next year switching. Part of that gap is genetic, and it can be read in advance.</p>});
rex(\$h, qr{(<a href="#who" class="btn-secondary shrink-0">)See how MedMatch fixes this }, q{${1}Who it's for });
# the "What it costs" cards have no USA copy
rexf(\$h, qr{\n<div class="" style="[^"]*"><span class="block t-eyebrow mt-14 max-\[600px\]:mt-10">What it costs</span></div>.*?</div></div></div></section>}s,
  sub { "</div></section>" });

# ---- WHAT IT CHECKS ----
rep(\$h, q{<h2 class="mt-[18px] t-h2">What MedMatch actually checks</h2>}, q{<h2 class="mt-[18px] t-h2">Four things your report can show</h2>});
rex(\$h, qr{\n<p class="mt-5 t-lead">Four findings straight from the MedMatch report.*?</p>}, '');
rex(\$h, qr{<section class="py-\[var\(--section-y\)\]  border-t border-hair-strong ">(\n<div class="max-w-\[var\(--page-max\)\] mx-auto px-\[var\(--gutter\)\] ">\n<div class="mb-12 max-w-\[640px\])},
  q{<section id="examples" class="py-[var(--section-y)]  border-t border-hair-strong scroll-mt-[96px]">${1}});
my @ex = (['Aspirin resistance', 'Aspirin resistance', "Aspirin lowers clotting risk by acting on platelets. Some people don't respond to it. MedMatch shows whether you're likely to be one of them."],
  ['Statin response', 'Statin response', 'Your risk of muscle pain on statins, and whether a particular one such as simvastatin or pravastatin is likely to work well for you.'],
  ['Tacrolimus dosing (CYP3A5)', 'Tacrolimus dosing', "For people on tacrolimus, often after a transplant: whether you're likely to need a standard or a higher starting dose."],
  ['Thiopurine metabolism', 'Thiopurine metabolism', "For people prescribed 6-mercaptopurine or azathioprine, often for Crohn's disease: how your body is likely to process them."]);
for my $e (@ex) { my ($o, $n, $b) = @$e;
  rex(\$h, qr{<h3 class="t-title">\Q$o\E</h3>\n<p class="mt-2\.5 t-secondary">[^<]*</p>}, qq{<h3 class="t-title">$n</h3>\n<p class="mt-2.5 t-secondary">$b</p>}); }

rep(\$h, q{<span class="block t-eyebrow ">Real examples</span>}, q{<span class="block t-eyebrow ">What it checks</span>});

# ---- WHO IT'S FOR ----
my @who = (['You take multiple medications', 'You take several medications', 'One report covers all of them, and the next ones too.'],
  ["You're starting a new prescription", "You're about to start one", 'Your doctor gets your genetics before writing the prescription.'],
  ["You've had a bad reaction", "A medication didn't work, or hit you hard", 'Your genes may explain it.'],
  ["You're starting mental health medication", "You're starting treatment for depression or anxiety", 'This is where doctors use PGx results most often.']);
for my $w (@who) { my ($o, $n, $b) = @$w;
  rex(\$h, qr{(<h3 class="max-w-\[900px\] t-h2 text-white[^"]*">)\Q$o\E(</h3>\n<p class="mt-6[^"]*">)[^<]*(</p>)}, qq{\${1}$n\${2}$b\${3}}); }
rex(\$h, qr{(<span class="block t-eyebrow mb-6 !text-white max-\[600px\]:mb-4">)Who needs this}, q{${1}Who it's for}) for 1 .. 4;

# ---- HOW IT WORKS (in the "Why MedMatch" card design) ----
rep(\$h, q{<span class="block t-eyebrow ">Why MedMatch</span>}, q{<span class="block t-eyebrow ">From your kitchen table</span>});
set_h2_after(\$h, '<section id="benefits"', 'How it works');
rep(\$h, '<section id="benefits"', '<section id="how"');
rep(\$h, q{<div class="grid grid-cols-4 gap-5 max-[1100px]:grid-cols-2 max-[700px]:grid-cols-1">}, q{<div class="grid grid-cols-3 gap-5 max-[1100px]:grid-cols-2 max-[700px]:grid-cols-1">});
my @how = (['01', 'Order', 'We ship the kit to your home.'],
  ['02', 'Swab', 'Swab the inside of your cheek for 30 seconds and send it back using the instructions in the box.'],
  ['03', 'Read', 'Your report arrives in My Health in about 3 weeks. Print the one-page summary for your doctor, or share it from the app.']);
rexf(\$h, qr{(<div class="grid grid-cols-3 gap-5[^"]*">\n).*?(</div></div></section>\n<section id="faqs")}s, sub {
  my $cards = join "\n", map { qq{<div class="h-full" data-reveal>\n<article class="flex h-full flex-col rounded-[24px] border border-hair-strong bg-white p-7 shadow-[0_18px_42px_-32px_rgba(10,23,18,.35)] max-[600px]:p-6"><span class="t-eyebrow">$_->[0]</span>\n<h3 class="mt-7 t-title">$_->[1]</h3>\n<p class="mt-3 flex-1 t-secondary">$_->[2]</p></article>\n</div>} } @how;
  qq{<div class="grid grid-cols-3 gap-5 max-[1100px]:grid-cols-2 max-[700px]:grid-cols-1">\n$cards</div></div></section>\n<section id="faqs"} });

# ---- FAQ ----
set_faq(\$h, '<section id="faqs"',
  'Does MedMatch tell me what to take?', 'No. It tells your doctor how your body is likely to process a medication. The prescribing decision stays with them.',
  'Should I change my dose if the report flags something?', "Don't start, stop or change any medication on your own. Take the report to your doctor or pharmacist.",
  'Does it cover every drug?', "No. It covers 260+ medications where gene effects are well studied. Many drugs aren't affected by the genes we test.",
  'Do I need to repeat it?', "No. Your genes don't change, so the report stays useful for every prescription after this one.",
  'Will my doctor accept it?', 'Most doctors and pharmacists know pharmacogenomic testing. The report has a one-page summary written for them.',
  'Is MedMatch part of DNA Decoder?', '<a href="dna-decoder.html" class="underline underline-offset-4">DNA Decoder</a> includes medication response along with disease risk, carrier status, nutrition and fitness. MedMatch is the medication report alone.');

save('medmatch.html', $h);
