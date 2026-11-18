#!/usr/bin/perl
# Home: USA copy from "Mr Yoda USA: Website Copy" > Home
use strict; use warnings; use utf8;
require './tools/lib.pl';
our $ARROW;
my $h = load('tools/base/index.html');
add_css(\$h, '44tzt5kjohgtk');

set_title(\$h, 'Mr Yoda | 164 Biomarkers, Two Visits a Year, $299',
  'The Biomarker Membership runs the same 164-biomarker panel two times a year, drawn at your home or at our Irving and The Colony clinics in Texas. Results in 24 to 48 hours. $299 a year.');

# Home-only interaction hooks for the scrolled header and hero membership hover.
$h =~ s{<header class="}{<header data-home-header class="};
$h =~ s{<button type="button" class="group relative mt-auto}{<button type="button" class="hero-membership group relative mt-auto};

# ---- HERO ----
rep(\$h, q{<span class="block">Today's blood work.</span><span class="block">Tomorrow's risk.</span>},
         q{<span class="block">One test is a snapshot.</span><span class="block">Two is a trend.</span>});
rep(\$h, q{max-[600px]:max-w-[84vw] max-[600px]:leading-[1.2] text-white">One membership. The same panel, twice a year.</p>},
         q{max-[600px]:max-w-[84vw] max-[600px]:leading-[1.2] text-white max-w-[640px] [text-wrap:pretty]">The Biomarker Membership runs the same 164 biomarkers two times a year, so you can see what's moving while it's still small.</p>});
rep(\$h, q{>biomarkers</dt><dd class="text-[28px] font-medium leading-none tracking-[-.02em] max-[600px]:text-[24px]">150+</dd>},
         q{>biomarkers</dt><dd class="text-[28px] font-medium leading-none tracking-[-.02em] max-[600px]:text-[24px]">164</dd>});
rep(\$h, q{>visits a year</dt><dd class="text-[28px] font-medium leading-none tracking-[-.02em] max-[600px]:text-[24px]">2</dd></div></dl>},
         q{>visits a year</dt><dd class="text-[28px] font-medium leading-none tracking-[-.02em] max-[600px]:text-[24px]">2</dd></div>}
       . qq{\n<div class="flex flex-col-reverse ml-6 border-l border-white/25 pl-6 max-[600px]:ml-4 max-[600px]:pl-4"><dt class="mt-1 text-[13px] font-medium leading-[1.3] text-white/75">a year</dt><dd class="text-[28px] font-medium leading-none tracking-[-.02em] max-[600px]:text-[24px]">\$299</dd></div></dl>});
rep(\$h, q{<a href="#plans" class="btn-secondary-dark}, q{<a href="what-we-test.html" class="btn-secondary-dark}, 2);
rep(\$h, q{See membership <span aria-hidden="true">→</span>}, q{See what we test <span aria-hidden="true">→</span>}, 2);

# ---- THE MEMBERSHIP ----
rep(\$h, q{<h2 class="max-w-[440px] t-h2">Your health membership.</h2>}, q{<h2 class="max-w-[520px] t-h2">The full panel, two times a year</h2>});
rep(\$h, qq{<p class="t-h3">One full panel. Two visits each year.</p>\n<p class="mt-4 max-w-[560px] t-body">Your membership includes: MyHealth access, the full panel at both visits and results in 24-48 hours.</p>},
         q{<p class="max-w-[600px] t-lead">Visit 1 is your baseline. Visit 2 comes three to six months later and runs every one of the 164 biomarkers again. My Health puts the two side by side, and anything that moved is marked.</p>});
rep(\$h, qq{<p class="t-label">Join today</p>\n<p class="mt-1 t-secondary">Membership starts</p>}, qq{<p class="t-label">Join</p>\n<p class="mt-1 t-secondary">Pay once for the year</p>});
rep(\$h, qq{<p class="t-label">Testing visit 1</p>\n<p class="mt-1 t-secondary">150+ biomarkers across 17 categories</p>}, qq{<p class="t-label">Visit 1</p>\n<p class="mt-1 t-secondary">164 biomarkers, results in 24 to 48 hours</p>});
rep(\$h, qq{<p class="t-label">Testing visit 2</p>\n<p class="mt-1 t-secondary">Full panel again, 3-6 months later</p>}, qq{<p class="t-label">Visit 2</p>\n<p class="mt-1 t-secondary">The same panel, any time from month 3</p>});

# membership card
rep(\$h, q{t-chip bg-white/[.12] text-white/90">Results in 24-48 hours</span>}, q{t-chip bg-white/[.12] text-white/90">Renews each year at $299. Cancel any time.</span>});
my $wdot = q{<li class="flex items-start gap-3 t-secondary text-white/90"><span aria-hidden="true" class="mt-[9px] h-1 w-1 shrink-0 rounded-full bg-white/80"></span>};
rexf(\$h, qr{<li class="flex items-start gap-3 t-secondary text-white/90">.*?Results and trends in MyHealth</li>}s, sub {
  join("\n", map { "$wdot$_</li>" } '164 biomarkers across 17 health areas', 'The full panel at both visits',
    'Blood drawn at home, or at our Irving or The Colony clinic', 'Results 24 to 48 hours after your sample reaches the lab', 'Both visits compared in My Health') });
rep(\$h, q{decoration-white/40 hover:decoration-white">See every biomarker<svg}, q{decoration-white/40 hover:decoration-white">See all 164 biomarkers<svg});
rep(\$h, q{<button type="button" aria-label="Join membership" class="btn-secondary-dark h-14 w-full">Join membership</button>},
         q{<button type="button" aria-label="Join for $299 a year" class="btn-secondary-dark h-14 w-full">Join for $299 a year</button>});

# genetic panels: intro tile sits beside the membership card, timing tile closes the grid
my $intro = <<'HTML';
<div data-usa="genetic-intro" class="flex flex-col py-8" style="grid-column:1 / -1">
<span class="block t-eyebrow">Genetic panels</span>
<h2 class="mt-4 max-w-[560px] t-h2">Then read your genes</h2>
<p class="mt-5 max-w-[620px] t-lead">Blood changes from month to month. Your DNA doesn't, so each of these is taken once. Every panel comes with My Health, where the report sits next to your blood results.</p></div>
HTML
insert_before(\$h, '<div data-plan-cell="premium"', $intro);

my $dot = q{<li class="flex items-start gap-3 t-secondary "><span aria-hidden="true" class="mt-[9px] h-1 w-1 shrink-0 rounded-full bg-ink-2"></span>};
sub points { my ($hr, $first, $last, @items) = @_;
  rexf($hr, qr{\Q$dot\E\Q$first\E</li>.*?\Q$last\E</li>}s, sub { join("\n", map { "$dot$_</li>" } @items) }); }
points(\$h, '300+ genes, one panel', 'Saliva kit at home', '20,000+ genetic markers, one panel', 'Disease risk and carrier status', 'Response to 300+ medications', 'Genetic counselor session included');
points(\$h, '260+ medications checked', 'Cheek swab at home', '260+ medications checked', 'A report to share with your doctor', 'Cheek swab at home');
points(\$h, 'How your genes shape what you eat', 'Saliva kit at home', 'Eat for your body', 'How you handle carbs, fat, caffeine and salt', 'Saliva kit at home');
points(\$h, 'Exercise and recovery insights', 'Saliva kit at home', 'Train smart, recover faster', 'The routine your body is built for', 'Saliva kit at home');
points(\$h, 'Autism Decoder panel for children', 'Choose the tests you need', 'Autism Decoder Panel for children', '21 tests across 8 body systems', '12 months of My Health included');
rep(\$h, q{aria-label="MedMatch Plus plan details"}, q{aria-label="MedMatch plan details"});
rep(\$h, q{<p class="pr-14 t-title-lg ">MedMatch Plus</p>}, q{<p class="pr-14 t-title-lg ">MedMatch</p>});
rep(\$h, q{aria-label="Explore MedMatch Plus"}, q{aria-label="Explore MedMatch"});
rep(\$h, q{<a href="#" data-know-more="true"}, q{<a href="dna-decoder.html#also-available" data-know-more="true"});

rep(\$h, q{<p class="mt-6 t-caption">Biomarker results arrive 24-48 hours after your sample reaches our lab. Genetic panels report in about 3 weeks.</p>},
         q{<p class="mt-6 t-caption">Blood results arrive 24 to 48 hours after your sample reaches our lab. Genetic reports take about 3 weeks.</p>});

# care pathways carousel has no USA copy any more; plan-details drawer was React-only
cut_between(\$h, '<div class="fixed inset-0 z-[90] pointer-events-none" aria-hidden="true">', '<section aria-labelledby="mh-cases-title"');

# ---- MY HEALTH (4 tabs) ----
rep(\$h, q{<img alt="My Health" class="h-[22px] w-auto min-[1024px]:h-[26px]" src="assets/img/myhealth/myhealth-logo.svg">},
         q{<img alt="My Health" class="h-[22px] w-auto min-[1024px]:h-[26px]" src="assets/img/myhealth/myhealth-logo.svg">} . "\n" . q{<h2 class="mt-6 t-eyebrow min-[1024px]:mt-8" style="color: rgb(107, 98, 87);">What two visits show you</h2>});
rep(\$h, q{>Chronic risk</button>}, q{>Heart and metabolism</button>});
rep(\$h, q{>Athletic</button>}, q{>Energy and training</button>});
rep(\$h, q{>Fertility</button>}, q{>Hormones and fertility</button>});
rep(\$h, q{>Nutrition and medication</button>}, q{>Food and medication</button>});
my @cases = (
  ['The diseases that build quietly for years.', 'Watch your risk markers over time, tracked test after test, not told to you once and forgotten.',
   "LDL was 98 in March. It's 118 now.", 'A single report would have called both normal enough. Two of them show the direction.'],
  ["Tired after cardio. Stuck on strength. There's a reason.", "See it scored across your body's systems, mapped and tracked as your training actually changes.",
   'Tired after cardio, stuck on strength?', 'Ferritin, vitamin D, thyroid and testosterone, checked before and after you change something.'],
  ["Before you start a family, know what you're carrying.", 'One shared account for both of you, results side by side, not two separate logins to compare.',
   'Thinking about a family in the next year or two?', 'Thyroid and cycle hormones on one screen, for you and your partner.'],
  ["Food and medicine don't work the same for everyone. Here's why.", 'Meals and medications both checked against your results, logged and flagged in one place, not guessed at separately.',
   'Started a statin, a GLP-1 or a new diet?', 'See what it did to your liver, kidneys, blood sugar and lipids three months on.'],
);
for my $c (@cases) {
  my ($oh, $ol, $nh, $nl) = @$c;
  rexf(\$h, qr{<h2 (id="mh-cases-title" )?class="t-h2 mt-8 max-w-\[700px\] \[text-wrap:balance\] min-\[1024px\]:mt-12">\Q$oh\E</h2>}, sub {
    my $m = shift; my ($id) = $m =~ /(id="mh-cases-title" )/; $id //= '';
    qq{<p ${id}class="t-h2 mt-8 max-w-[700px] [text-wrap:balance] min-[1024px]:mt-12">$nh</p>} });
  rep(\$h, ">$ol</p>", ">$nl</p>");
}
rep(\$h, q{aria-labelledby="mh-cases-title"}, q{aria-label="What two visits show you"});
rep(\$h, q{style="background: rgb(28, 24, 20); color: rgb(245, 242, 235);">Join membership</button>}, q{style="background: rgb(28, 24, 20); color: rgb(245, 242, 235);">Join for $299 a year</button>}, 2);
rexf(\$h, qr{(<div aria-hidden="true" class="mt-4 flex justify-center gap-1\.5 min-\[1024px\]:mt-5">.*?</div>)}s, sub {
  shift() . "\n" . q{<p class="mt-3 text-center text-[13px]" style="color: rgb(107, 98, 87);">Example screens. Your numbers will differ.</p>} });

# ---- HOW IT WORKS ----
rexf(\$h, qr{(<section id="how-it-works".*?)<h2 class=" t-h2">.*?</h2>}s, sub {
  my $m = shift; $m =~ s{<h2 class=" t-h2">.*?</h2>}{<h2 class=" t-h2">How the membership works</h2>}s; $m });
rep(\$h, q{<p class="font-13 text-white">150+ biomarkers · 17 categories</p>}, q{<p class="font-13 text-white">164 biomarkers · 17 health areas</p>});
rep(\$h, q{A phlebotomist arrives within your 2-hour window. Results in 24-48 hours.}, q{A phlebotomist arrives within your 2-hour window. Results in 24 to 48 hours.});
rep(\$h, qq{<h3 class="mt-6 t-title">Join and book.</h3>\n<p class="mt-3 t-body">One membership covers 150+ biomarkers, tested twice a year. Choose who is being tested, for you or a family member anywhere we collect, and book visit 1.</p>},
         qq{<h3 class="mt-6 t-title">Join and book</h3>\n<p class="mt-3 t-body">Pay \$299 once. Choose who's being tested (you, or a family member at their own address) and pick a morning.</p>});
rep(\$h, qq{<h3 class="mt-6 t-title">Visit 1, results in 24-48 hours.</h3>\n<p class="mt-3 t-body">A phlebotomist comes to you in a 2-hour window, or visit one of our Dallas-area labs. Results land in MyHealth 24-48 hours after your sample reaches our lab, grouped by body system.</p>},
         qq{<h3 class="mt-6 t-title">Visit 1</h3>\n<p class="mt-3 t-body">A licensed phlebotomist comes to your home inside the 2-hour window you chose. The draw takes about 10 minutes. You can also go to our Irving or The Colony clinic. Results reach My Health 24 to 48 hours after the sample gets to the lab.</p>});
rep(\$h, qq{<h3 class="mt-6 t-title">Visit 2, see what changed.</h3>\n<p class="mt-3 t-body">Three to six months later, the full panel again. MyHealth shows what improved and what didn't. If something still needs a closer look, add a retest for it.</p>},
         qq{<h3 class="mt-6 t-title">Visit 2</h3>\n<p class="mt-3 t-body">From month three, book the second draw. Same panel, same lab, so the two reports can be compared line by line. Use it before your year ends.</p>});
rep(\$h, q{Back in range since visit 1. Two markers still worth a closer look.}, q{Back in range since visit 1. Compared line by line in My Health.});
rep(\$h, q{text-brand-bright">Add a retest <svg}, q{text-brand-bright">See what changed <svg});

# ---- WHERE WE ARE (new) ----
insert_before(\$h, '<section id="faqs"', where_we_are(zip_id => 'zip-home'));

# ---- FAQ (8) ----
set_faq(\$h, '<section id="faqs"',
  'What is the Biomarker Membership?', 'For $299 a year we run the same 164-biomarker panel two times, three to six months apart, and show you what changed.',
  "What's in the 164?", '66 measured tests, 63 calculated results and 35 readings from your blood count and urine profiles, across 17 health areas. The full list is on <a href="what-we-test.html" class="underline underline-offset-4">What we test</a>.',
  'How do the two visits work?', 'Visit 1 is your baseline. You can book visit 2 any time from three months after visit 1, as long as it\'s inside your membership year. It runs the same panel again, and My Health compares the two.',
  'Does it renew?', 'Yes. It renews automatically each year at $299, with two new visits, until you cancel. You can cancel any time in your account.',
  'Where do you collect?', 'At your home across more than 14,000 ZIP codes in 35 states, or at our clinics in Irving (2925 N Skyway Cir, Suite 140) and The Colony (6600 Paige Road, Suite 100), Texas. Enter your ZIP on any page to check your address.',
  'Can I book for a family member?', 'Yes. Each person needs their own membership ($299 each; two people are $598). Add them at checkout with their own address.',
  'Can I pick single tests?', 'No. The panel is fixed and runs in full at both visits.',
  'Do you take insurance?', "No. We don't bill insurance, Medicare or Medicaid.");

# ---- CLOSING BAND (new) ----
rep(\$h, "\n</main>", "\n" . closing_band('home-final', 'Two draws a year. $299.', '',
  qq{<a href="what-we-test.html#plan" class="btn-primary ">Join for \$299 a year$ARROW</a>}) . '</main>');

save('index.html', $h);
