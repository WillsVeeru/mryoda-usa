#!/usr/bin/perl
# Yodaara: USA copy
use strict; use warnings; use utf8;
require './tools/lib.pl';
our $ARROW;
my $h = load('tools/base/yodaara.html');
add_css(\$h, '0odjg3wdeqm61', '10jhy83u2_jc9', '1ad5enujtgz5f', '1kq69gxhuetn8');

set_title(\$h, 'Yodaara: Autism Decoder Panel for Children | Mr Yoda',
  '21 lab tests across 8 body systems for children with autism or developmental delay, from one home visit. Results explained by a genetic counselor. Includes a year of My Health.');

# pinned decks: GSAP pin-spacers become CSS sticky (driven by site.js)
rep_all(\$h, q{<div class="pin-spacer" style="order: 0; place-self: auto; grid-area: auto; z-index: auto; float: none; flex-shrink: 1; display: block; margin: 0px; inset: 0px; position: relative; flex-basis: auto; overflow: visible; box-sizing: border-box; width: 1440px; height: 2309px; padding: 0px 0px 1504px;">},
  q{<div class="pin-spacer usa-pin">});
$h =~ s{(class="yrd-deck yrd-deck-pinned") style="[^"]*"}{$1}g;

# split headings -> plain
sub split_h2 { my ($hr, $id, $text) = @_;
  rexf($hr, qr{<h2 id="\Q$id\E"[^>]*>.*?</h2>}s, sub { my ($open) = $_[0] =~ /^(<h2[^>]*?)(?: aria-label="[^"]*")?>/; qq{$open>$text</h2>} }); }

# ---- HERO ----
rep(\$h, q{color: rgb(44, 34, 25);">Find out what is driving <em data-rv-ink="true" style="color: rgb(176, 63, 17);">your child’s symptoms.</em></h1>},
         q{color: rgb(44, 34, 25);">Find out what may be behind <em data-rv-ink="true" style="color: rgb(176, 63, 17);">your child’s symptoms.</em></h1>});
rex(\$h, qr{(<p class="yrd-stat-s"[^>]*>)One sample, collected at home</p>}, q{${1}Home visit in a 2-hour window · results explained by a genetic counselor · 12 months of My Health</p>});
rex(\$h, qr{(<p data-rv-ink-soft="true" class="yrd-hero-sub"[^>]*>)[^<]*</p>},
  q{${1}Your pediatrician said wait and see. The developmental clinic has a long waiting list. The Autism Decoder Panel looks at 21 biological factors across 8 body systems now, from one visit to your home.</p>});
rep(\$h, q{href="#">Start with a screening call</a>}, q{href="#start">Start with a free screening call</a>});
rexf(\$h, qr{<div data-rv-hero-in="true" data-rv-ink-soft="true" class="yrd-trust".*?</div>}s, sub { my $t = shift; my @new = ("Physician-led from screening to care plan", "Reports in 5 to 7 weeks", "Every result kept in My Health", "We don't diagnose autism; we look for what can be treated"); my $i = 0; $t =~ s{(</svg>)[^<]+}{$1 . $new[$i++]}ge; die "trust: $i\n" unless $i == 4; $t });

# ---- WHAT YOU GET (two cards) ----
rex(\$h, qr{(<h2 id="yrd-book-h"[^>]*>)[^<]*</h2>\n<p data-rv-fade="true" class="yrd-lead">[^<]*</p>}, q{${1}What you get</h2>});
rep(\$h, qq{<h3>The Autism Decoder Panel</h3>\n<p class="yrd-sub">With 12 months of My Health</p>}, qq{<h3>Autism Decoder Panel</h3>});
sub ticks_text { my ($hr, $first, @new) = @_;
  rexf($hr, qr{<ul class="yrd-ticks[^"]*">(?:(?!</ul>).)*?\Q$first\E.*?</ul>}s, sub {
    my $ul = shift; my $i = 0;
    $ul =~ s{(<li>\n<svg.*?</svg>)(?:<span>.*?</span>|[^<]*)(</li>)}{$i < @new ? $1 . $new[$i++] . $2 : ''}gse;
    die "ticks: $first got $i\n" unless $i == @new; $ul }); }
ticks_text(\$h, '21 tests across 8 body systems</li>', '21 tests across 8 body systems', 'One visit to your home', 'A genetic counselor walks you through every result', 'A written summary for your pediatrician');
rep(\$h, qq{<p class="yrd-sub">Included with the panel</p>\n<p class="yrd-price"><b>Included</b><small>worth \$99 a year</small></p>}, q{<p class="yrd-price"><b>Included</b></p>});
rep(\$h, q{<img alt="My Health" class="yrd-mh-logo" src="assets/img/myhealth/myhealth-logo.svg"><span>set up around your child</span></p>},
         q{<img alt="My Health" class="yrd-mh-logo" src="assets/img/myhealth/myhealth-logo.svg"></p>});
ticks_text(\$h, '<b>Daily care plan:</b>', "A daily plan built from your child's results", 'Medication and supplement tracker with reminders',
  'A log for sleep, gut, behavior and therapy', 'One record you can share with every specialist and with the school');
rex(\$h, qr{\n<a class="yrd-link" href="what-we-test.html">See the Biomarker membership.*?</a>}s, '');
rex(\$h, qr{(<p data-rv-fade="true" class="yrd-fine">)[^<]*</p>}, q{${1}Already a member? Your benefits apply at checkout.</p>});

# ---- THE 8 BODY SYSTEMS ----
split_h2(\$h, 'yrd-sys-h', '21 tests, 8 systems, one visit');
rex(\$h, qr{(<p data-rv-fade="true" class="yrd-lead"[^>]*>)Genetic, metabolic, immune, nutritional and more[^<]*</p>},
  q{${1}Genetic, metabolic, immune and nutritional factors, checked together. Otherwise you collect them one referral at a time.</p>});
my %sys = ('Genetic Causes' => 'Genetic causes', 'Folate Transport and Brain Development' => 'Folate transport and brain development',
  'Metabolic Defects' => 'Metabolic disorders', 'Immune Function and Inflammation' => 'Immune function and inflammation',
  'Nutritional Health' => 'Nutrition', 'Gut Health and Microbiome' => 'Gut health and microbiome', 'Toxin and Stress Load' => 'Heavy metals',
  'Oxidative Stress' => 'Oxidative stress');
for my $o (keys %sys) { rep(\$h, "<span class=\"yrd-sname\"><b>$o</b>", "<span class=\"yrd-sname\"><b>$sys{$o}</b>"); }
rep(\$h, q{<div class="yrd-tests-top"><b>Genetic Causes</b>}, q{<div class="yrd-tests-top"><b>Genetic causes</b>});

# ---- THREE WAYS TO START ----
split_h2(\$h, 'yrd-start-h', 'Not ready for the full panel?');
rep(\$h, qq{<h3>Screening call</h3>\n<p class="yrd-way-t">A 30-minute, doctor-led conversation using the CARS assessment. No lab work, no commitment.</p>},
         qq{<h3>Screening call</h3>\n<p class="yrd-way-t">30 minutes with our clinical team, using the CARS rating scale. No lab work.</p>});
rep(\$h, qq{<h3>FRAT test</h3>\n<p class="yrd-way-t">One blood test that checks whether folate can reach your child's brain.</p>},
         qq{<h3>FRAT</h3>\n<p class="yrd-way-t">One blood test for the antibodies that can block folate from reaching the brain.</p>});
rep(\$h, qq{<h3>Autism Decoder Panel + My Health</h3>\n<p class="yrd-way-t">The complete picture across 8 body systems, plus 12 months of My Health.</p>},
         qq{<h3>Autism Decoder Panel</h3>\n<p class="yrd-way-t">All 21 tests, with 12 months of My Health.</p>});
rep(\$h, q{<span class="yrd-badge">Recommended</span>}, '');
rep(\$h, q{Not sure which fits? <button type="button" class="">Request a callback</button> and our team will help you decide.},
         q{Not sure? <button type="button" class="">Ask for a callback</button> and we'll go through it with you.});

# ---- FRAT ----
rex(\$h, qr{(<h2 id="yrd-frat-h"[^>]*>)[^<]*(</h2>\n<p data-rv-fade="true" class="yrd-lead">)[^<]*</p>},
  q{${1}FRAT: the folate test most parents haven't heard of${2}FRAT (the folate receptor antibody test) looks for antibodies that can stop folate from reaching the brain, a condition called cerebral folate deficiency. It is linked to autism and developmental delay. If the test is positive, your child's doctor may consider prescription folinic acid (leucovorin).</p>});
rep(\$h, q{<p>children with autism and cerebral folate deficiency showed improvement in overall symptoms with folinic acid treatment</p>},
         q{<p>children with autism and cerebral folate deficiency improved in overall symptoms on folinic acid</p>});
rex(\$h, qr{(<p data-rv-fade="true" class="yrd-small">).*?</p>}, q{${1}FRAT is one marker. It doesn't diagnose autism, and treatment is your child's doctor's decision.</p>});
rex(\$h, qr{(<p data-rv-fade="true" class="yrd-source">)[^<]*</p>}, q{${1}Source: Rossignol and Frye, Journal of Personalized Medicine, 2021. Pooled prevalence 71%; improvement 67% across 21 treatment studies.</p>});

# ---- SIGNS ----
split_h2(\$h, 'yrd-signs-h', 'What parents usually notice first');
rep(\$h, q{<p>One sign does not mean autism. It means it is worth a conversation.</p><a class="ybtn ybtn-primary" href="#">Book a screening call</a>},
         q{<p>One sign on its own doesn't mean autism, though it's worth asking about. The CDC's current estimate is 1 in 31 eight-year-olds.</p><a class="ybtn ybtn-primary" href="#start">Book a free screening call</a>});
my @signs = (['Avoiding eye contact', 'Little eye contact'], ['Delayed or unusual speech', "Speech that's late or unusual"],
  ['Not responding to their name', 'Not turning when you call their name'], ['Repeating actions or behaviours', 'Repeating the same movement or phrase'],
  ['Strong reactions to sound or touch', 'Strong reactions to sound or touch'], ['Difficulty with social cues', 'Trouble reading social cues']);
rep(\$h, "<figcaption>$_->[0]</figcaption>", "<figcaption>$_->[1]</figcaption>") for @signs;

# ---- FOUNDER (quote verbatim, unchanged) ----

# ---- FAQ ----
my @faq = ('Does this diagnose autism?', 'No. Autism is diagnosed by a specialist who observes your child. The panel looks for biological factors that may add to the symptoms, some of which can be treated.',
  'Does insurance cover it?', "We don't bill insurance. You pay by card or Apple Pay.",
  'My child already had some of these tests. Do we repeat them?', "No. Switch them off on the panel page and upload the old reports. We'll price the rest. Custom panels don't include My Health.",
  'How is the sample taken?', 'A phlebotomist comes to your home, or you can bring your child to our Irving or The Colony clinic. Some tests also need a urine or stool sample, which you collect yourself.',
  'How long do results take?', '5 to 7 weeks. Whole exome sequencing is the slowest part.',
  'Can I share results with the school or Early Intervention?', 'Yes. Export any report from My Health as a PDF.',
  'Where is Yodaara available?', 'Enter your ZIP on this page to check your address.');
my $details = ''; my $first = 1;
while (my ($q, $a) = splice(@faq, 0, 2)) { my $open = $first ? ' open=""' : ''; $first = 0;
  $details .= qq{<details$open>\n<summary>$q</summary>\n<p>$a</p></details>\n}; }
$details =~ s/\n$//;
rexf(\$h, qr{(<div data-rv-fade="true" class="yrd-faq-list"[^>]*>\n).*?(</div>)(?=</div></section>|</div>\n?</section>|</)}s, sub {
  my ($open) = $_[0] =~ /^(<div[^>]*>\n)/; $open . $details . '</div>' });
rex(\$h, qr{(<h2 id="yrd-faq-h" class="yrd-h2">Frequently asked questions</h2><a class="yrd-link" href=")#(">More frequently)}, q{${1}faqs.html${2}});

# ---- CLOSING BAND (+ ZIP check, which the FAQ points to) ----
split_h2(\$h, 'yrd-close-h', 'Start with a 30-minute call.');
rex(\$h, qr{\n<p data-rv-fade="true" class="yrd-lead"[^>]*>Book the Autism Decoder Panel with 12 months of My Health[^<]*</p>}, '');
rexf(\$h, qr{<a class="ybtn ybtn-primary rv-hero-cta" data-lit="true" href="#">Book the panel<svg.*?</svg></a><button type="button" class="ybtn ybtn-ghost">Request a callback</button></div></div></section>}s, sub {
  my ($svg) = $_[0] =~ m{(<svg.*?</svg>)}s;
  qq{<a class="ybtn ybtn-primary rv-hero-cta" data-lit="true" href="#start">Book a screening call$svg</a><a class="ybtn ybtn-ghost" href="#book">Book the panel</a></div>\n}
  . q{<div class="yrd-zip">} . zip_form('zip-yodaara', 'Check your address') . q{</div></div></section>} });

save('yodaara.html', $h);
