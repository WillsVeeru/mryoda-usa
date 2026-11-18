#!/usr/bin/perl
# DNA Decoder: USA copy
use strict; use warnings; use utf8;
require './tools/lib.pl';
our $ARROW;
my $h = load('tools/base/dna-decoder.html');
drop_drawers(\$h);

set_title(\$h, 'DNA Decoder: 20,000+ Genetic Markers From One Saliva Kit | Mr Yoda',
  'One saliva kit reads 20,000+ genetic markers for disease risk, medication response, carrier status, nutrition and fitness. Genetic counselor session included. Report in about 3 weeks. $499.');

# ---- HERO ----
rep(\$h, q{max-[600px]:text-[40px]">The one test you never have to take twice.</h1>}, q{max-[600px]:text-[40px]">The one test you never take twice.</h1>});
rex(\$h, qr{(<p class="mt-6 max-w-\[660px\] t-lead max-\[600px\]:mt-5">)One saliva sample reads.*?</p>},
  q{${1}Your DNA is the same at 25 and at 75. One saliva kit reads 20,000+ genetic markers: the conditions you're at risk for, the ones you could pass on, the medications your body handles badly, and how you process food and exercise.</p>});
rex(\$h, qr{(<a href=")#plans(" class="btn-primary[^"]*">)Choose the panel</a><a href="#" data-hero-details="true" class="btn-secondary">View panel details</a>},
  q{${1}#plans${2}Order DNA Decoder · $499</a><a href="#reveals" class="btn-secondary">See what's in the report</a>});
rep(\$h, q{<p class="mt-4 max-w-[600px] t-caption text-ink-2">$499 a year for the panel with membership</p>},
         q{<p class="mt-4 max-w-[600px] t-caption text-ink-2">Includes a session with a genetic counselor and access to My Health.</p>});

# ticker
rep_all(\$h, '>300+ genes, one panel<span', '>20,000+ genetic markers<span');
rep_all(\$h, '>saliva swab at home<span', '>300+ medications<span');
rep_all(\$h, '>report in about 3 weeks<span', '>100+ inherited conditions<span');
rep_all(\$h, '>read once, keep for life<span', '>report in about 3 weeks<span');

# ---- WHAT IT REVEALS (5 cards x 3 loop copies) ----
set_h2_after(\$h, '<section id="reveals"', 'What your report covers');
rex(\$h, qr{\n<div class="" style="[^"]*">\n<p class="mt-6 max-w-\[620px\] t-lead">Most tests expire the moment you take them\..*?</p></div>}s, '');
my @rev = (
  ['Genetic disease risk', 'Disease risk', 'Your genetic predisposition to conditions across the major body systems, including diabetes, heart disease and kidney disorders.'],
  ['Chronic disease risk', 'Carrier status', 'Whether you carry a gene for any of 100+ inherited conditions. Carriers are usually healthy, and most find out only when a child is affected.'],
  ['Knowing the right medicine', 'Medications', 'How your genes may affect your response to 300+ medications. Take it to your doctor before your next prescription.'],
  ['Knowing the right food', 'Food', 'How you handle carbs, fat, caffeine and salt, and which nutrients you need more of.'],
  ['Knowing the right workout', 'Exercise', 'Endurance, recovery and the kind of training your body responds to.'],
);
for my $r (@rev) {
  my ($old, $new, $body) = @$r;
  my $n = 0;
  $h =~ s{aria-label="Show \Q$old\E"}{aria-label="Show $new"}g;
  $h =~ s{(<p class="mt-2 t-title-sm[^"]*">)\Q$old\E(</p></button>\n<div[^>]*>\n<p class="t-eyebrow text-ink-3">Overview</p>\n<p class="mt-2 t-secondary text-ink">)[^<]*(</p>)}{$n++; "$1$new$2$body$3"}ge;
  die "reveals: $old matched $n\n" unless $n == 3;
}

# ---- THE PANEL ----
rexf(\$h, qr{<h2 class="t-h2 text-balance"><span class="inline-block overflow-hidden[^>]*><span data-w="true"[^>]*>Four&nbsp;.*?</h2>}s, sub { '<h2 class="t-h2 text-balance">One panel. The complete one.</h2>' });
rex(\$h, qr{\n<div class="" style="[^"]*">\n<p class="mx-auto mt-5 max-w-\[620px\] t-lead text-pretty">Choose the report that fits.*?</p></div>}s, '');

my ($area) = $h =~ m{(<div class="mt-12 max-\[600px\]:mt-9">\n<div class="flex flex-wrap items-baseline justify-between gap-x-6 gap-y-1">\n<h3 class="t-h3">Panels with membership</h3>.*?</li></ul>\n</div>)(?=</div>\n?</section>|\n?</div></section>|</div>)}s
  or die "panel area not found\n";
my %card;
while ($area =~ m{(<li class="[^"]*"[^>]*>\n<article.*?</li>)}sg) { my $li = $1; my ($n) = $li =~ m{<h4[^>]*>([^<]+)</h4>}; $card{$n} //= $li; }
for ("DNA Decoder", "Sports Genetics", "Nutrigenomics") { die "card $_ missing\n" unless $card{$_} }

sub meta_line { qq{<p class="flex items-center gap-2 whitespace-nowrap text-[14px] font-medium leading-5 text-white/80"><span class="flex items-center gap-2">$_[0]</span></p>} }
sub restyle { my ($li, %o) = @_;
  $li =~ s{^<li class="[^"]*"}{<li class="h-full"};
  $li =~ s{ style="translate: none; rotate: none; scale: none; clip-path: none;"}{};
  $li =~ s{(<span class="absolute top-5 [^"]*left-5">)[^<]*(</span>)}{$1$o{badge}$2};
  $li =~ s{<span class="absolute top-5 [^"]*right-5">.*?</span>(</span>)?(?=\n|<div)}{}s;
  $li =~ s{(<p class="text-\[15px\] leading-\[22px\] text-white/85">)[^<]*(</p>)}{$o{desc} ? "$1$o{desc}$2" : ''}e;
  if ($li =~ m{<p class="flex items-center gap-2 whitespace-nowrap}) { $li =~ s{<p class="flex items-center gap-2 whitespace-nowrap.*?</p>}{meta_line($o{meta})}se }
  else { $li =~ s{(<h4[^>]*>[^<]*</h4>\n(?:<p class="text-\[15px\][^\n]*\n)?)}{$1 . meta_line($o{meta}) . "\n"}e }
  $li =~ s{>Book now<span class="tabular-nums">· \$\d+</span>}{>$o{cta}<span class="tabular-nums">· \$499</span>};
  $li =~ s{aria-label="Book now, [^"]*"}{aria-label="$o{cta}"};
  $li =~ s{<(button|a) [^>]*(?:data-plan-details|data-kit-details)[^>]*>Details</(?:button|a)>}{<a href="$o{more_href}" class="relative z-[1] flex items-center justify-center gap-1.5 whitespace-nowrap rounded-full py-4 text-[16px] font-semibold leading-5 transition-colors flex-auto px-5 border-[1.5px] border-white/80 text-white hover:bg-white/10">$o{more}</a>}s;
  $li }

my $main = restyle($card{'DNA Decoder'}, badge => 'The complete panel', desc => 'One saliva kit, taken once. Report in about 3 weeks.',
  meta => '$499 (was $599) · one payment · taken once', cta => 'Order DNA Decoder', more => "What's in the report", more_href => '#reveals');
my $nutri = restyle($card{'Nutrigenomics'}, badge => 'Also available', desc => 'Eat for your body. See how you handle carbs, fat, caffeine and salt.',
  meta => '$499 (was $599)', cta => 'Book now', more => 'Details', more_href => '#');
my $sports = restyle($card{'Sports Genetics'}, badge => 'Also available', desc => 'Train smart, recover faster. Find the routine your body is built for.',
  meta => '$499 (was $599)', cta => 'Book now', more => 'Details', more_href => '#');
$main =~ s{One saliva kit, taken once\. Report in about 3 weeks\.}{From one saliva kit at home.};

my $points = check_items(0, '20,000+ genetic markers', 'Disease risk across major body systems', 'Response to 300+ medications',
  'Carrier status for 100+ inherited conditions', 'Nutrition and fitness guidance', 'Genetic counselor session', 'My Health access');
my $list_card = qq{<li class="h-full"><div class="flex h-full min-h-[480px] flex-col rounded-[36px] border border-hair-strong bg-white p-10 max-[600px]:p-6">\n}
  . qq{<span class="t-eyebrow">DNA Decoder</span>\n<p class="mt-5 flex flex-wrap items-baseline gap-x-2 gap-y-2"><span class="t-price text-[40px]">\$499</span><s class="t-secondary text-ink-2"><span class="sr-only">Was </span>\$599</s></p>\n<p class="mt-2 t-secondary">One payment · taken once</p>\n}
  . qq{<ul class="mt-8 grid gap-[14px]">\n$points</ul>\n<div class="mt-auto pt-8"><a href="#" class="btn-primary h-14 w-full text-[16px]">Order DNA Decoder · \$499$ARROW</a></div></div></li>};

my $new_area = qq{<div class="mt-12 max-[600px]:mt-9" id="panel">\n<ul class="grid gap-4 lg:grid-cols-2">\n$main\n$list_card</ul>\n</div>\n}
  . qq{<div class="mt-12 max-[600px]:mt-9" id="also-available">\n<div class="flex flex-wrap items-baseline justify-between gap-x-6 gap-y-1">\n<h3 class="t-h3">Also available</h3></div>\n<ul class="mt-4 grid gap-4 lg:grid-cols-2">\n$nutri\n$sports</ul>\n</div>};
my $i = index($h, $area); substr($h, $i, length $area) = $new_area;

# ---- HOW IT WORKS (4 steps, marquee x3) ----
set_h2_after(\$h, '<section id="how"', 'From your kitchen table');
rex(\$h, qr{\n<p class="mx-auto mt-5 max-w-\[560px\] t-lead">Three simple steps, all from home\.</p>}, '');
my @steps = (['01', 'Order', 'We ship the kit to your home.'],
  ['02', 'Collect', 'Fill the tube to the line and cap it. It takes about five minutes. Send it back using the instructions in the box.'],
  ['03', 'Read', 'A physician reviews your results, and your report arrives in My Health in about 3 weeks, written in plain English.'],
  ['04', 'Talk it through', 'Book your genetic counselor session from My Health. Bring your questions and your family history.']);
my $track = '';
for my $copy (0 .. 2) { for my $s (@steps) {
  my $hid = $copy ? 'true' : 'false';
  $track .= qq{<div aria-hidden="$hid" class="w-[420px] shrink-0 max-[600px]:w-[300px]"><span class="t-eyebrow">$s->[0]</span>\n<h3 class="mt-3 t-title-lg">$s->[1]</h3>\n<p class="mt-3 t-body">$s->[2]</p></div>\n};
} }
rexf(\$h, qr{(<div class="flex w-max gap-x-20 will-change-transform[^"]*")[^>]*>\n<div aria-hidden="false" class="w-\[420px\].*?</p></div></div></div></section>}s, sub {
  my ($open) = $_[0] =~ /^(<div class="flex w-max gap-x-20 will-change-transform[^"]*")/;
  $track =~ s/\n$//;
  "$open data-marquee>\n$track</div></div></section>" });

# ---- BLOOD AND DNA ----
set_h2_after(\$h, '<section id="vs-blood"', 'Blood shows today. DNA shows what you were born with.');
rex(\$h, qr{\n<p class="mt-6 max-w-\[610px\] t-lead mx-auto">Both matter\..*?</p>}, '');
rep(\$h, '>Current levels</div>', '>Current levels</div>');
rep(\$h, '</svg></span>Inherited risk</div>', '</svg></span>Inherited risk</div>');
rep(\$h, '>Changes constantly</div>', '>Changes month to month</div>');
rep(\$h, '</svg></span>Never changes</div>', '</svg></span>Fixed for life</div>');
rep(\$h, '>Retest again and again</div>', '>Repeat it</div>');
rep(\$h, '</svg></span>Test once, keep forever</div>', '</svg></span>Take it once</div>');
rex(\$h, qr{\n<div class="relative grid grid-cols-2 border-t border-hair">\n<div class="flex items-center px-8 py-4 t-body max-\[600px\]:px-4">Catches what's happening now</div>.*?Reveals what could happen next</div></div>}s, '');
rep(\$h, q{<p class="mx-auto mt-7 max-w-[720px] text-center t-body">Take both, and you see your whole health: the moment you're in, and the road ahead.</p>},
         q{<p class="mx-auto mt-7 max-w-[720px] text-center t-body">Together they answer two questions: what am I at risk for, and has it started?</p>}
       . qq{\n<p class="mt-5 text-center"><a href="what-we-test.html" class="group/km inline-flex items-center gap-2 t-label font-semibold text-[#15692F] underline decoration-[#15692F]/30 underline-offset-[5px] hover:decoration-[#15692F]">See the Biomarker Membership · \$299 a year$ARROW</a></p>});

# ---- FAQ ----
set_faq(\$h, '<section id="faqs"',
  'Is this a diagnosis?', "No. It reports genetic risk. Most conditions also depend on age, habits and chance, and a clean result doesn't rule a condition out.",
  "What does 'carrier' mean?", "You have one copy of a gene change that causes a condition only when a child inherits it from both parents. It matters most if you're planning a family.",
  'Do I get help reading the report?', 'Yes. One session with a genetic counselor is included.',
  'Will this affect my insurance?', "A federal law, GINA, bars health insurers and most employers from using your genetic results. It doesn't cover life, disability or long-term care insurance, so some people buy those policies before testing.",
  'Who sees my DNA data?', "You, the physician who reviews it and your genetic counselor. We don't sell it and we don't share it without your written consent. You can ask us to delete your data and destroy your sample.",
  'Does DNA Decoder include blood tests?', 'No. Blood work is the Biomarker Membership, which is separate ($299 a year).',
  'How long does it take?', 'About 3 weeks from the day your sample reaches the lab.',
  'Can I test my child?', 'DNA Decoder is for adults 18 and over. For children with developmental concerns, see <a href="yodaara.html" class="underline underline-offset-4">Yodaara</a>.');

save('dna-decoder.html', $h);
