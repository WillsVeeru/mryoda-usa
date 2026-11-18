#!/usr/bin/perl
# FAQs (full page): USA copy, 8 topic tabs
use strict; use warnings; use utf8;
require './tools/lib.pl';
our $ARROW;
my $h = load('tools/base/faqs.html');

set_title(\$h, 'FAQs | Mr Yoda', 'Answers about the Biomarker Membership, collection and locations, results, DNA Decoder, MedMatch, Yodaara, My Health, billing and privacy.');

my $wwt = '<a href="what-we-test.html" class="underline underline-offset-4">What we test</a>';
my @groups = (
 ['membership', 'Membership', [
  'What is the Biomarker Membership?', 'For $299 a year we run the same 164-biomarker panel two times, three to six months apart, and show you what changed.',
  "What's in the 164?", "66 measured tests, 63 calculated results and 35 readings from your blood count and urine profiles, across 17 health areas. The full list is on $wwt.",
  'Can I pick single tests?', 'No. The panel is fixed and runs in full at both visits.',
  'When does my year start?', 'The day you join.',
  'When can I book visit 2?', "Any time from three months after visit 1, as long as it's inside your membership year.",
  "What if I don't use visit 2?", "It expires when your membership year ends. It doesn't carry over.",
  'Does the membership renew?', 'Yes. It renews automatically each year at $299, with two new visits, until you cancel.',
  'How do I cancel?', 'Any time, in your account.',
  'Can I book for a family member?', 'Yes. Each person needs their own membership ($299 each; two people are $598). Add them at checkout with their own address.',
  'Is there an age limit?', 'Members must be 18 or over.',
  'Does it include DNA Decoder or MedMatch?', 'No. Those are separate panels at $499 each.']],
 ['collection', 'Collection and locations', [
  'Where do you collect?', 'At your home across more than 14,000 ZIP codes in 35 states, or at our clinics in Irving (2925 N Skyway Cir, Suite 140) and The Colony (6600 Paige Road, Suite 100), Texas. Enter your ZIP on any page to check your address.',
  'How does a home visit work?', 'You pick a day and a 2-hour arrival window when you book. A licensed phlebotomist comes to you, and the draw takes about 10 minutes.',
  'Do I need to fast?', 'Yes. Your booking confirmation gives the exact fasting time. Water is fine.',
  'Can I reschedule?', 'Yes, from Orders in your account.',
  'How do the genetic tests work?', 'DNA Decoder and MedMatch use a saliva or cheek-swab kit that we ship to your home. You send it back using the instructions in the box.',
  "You're not in my area yet. Now what?", "Leave your ZIP and email and we'll write when we reach you. More clinics are opening this year.",
  "My parent lives in Dallas and I don't. Can I book for them?", 'Yes, if their address is in our area. You pay; they get the visit and their own My Health login.']],
 ['results', 'Results', [
  'How fast are results?', 'Blood and urine results arrive 24 to 48 hours after your sample reaches our lab. Genetic reports take about 3 weeks.',
  "How will I know they're ready?", 'We text and email you, and they appear in My Health.',
  'Who reviews them?', "A licensed physician reviews every report before it's released.",
  'What if something is seriously off?', "It's flagged in My Health and our team contacts you.",
  'Can my doctor see them?', 'Send a secure link or download a PDF from My Health.',
  'Are results a diagnosis?', "No. They're information for you and your doctor."]],
 ['dna', 'DNA Decoder', [
  'Is this a diagnosis?', "No. It reports genetic risk. Most conditions also depend on age, habits and chance, and a clean result doesn't rule a condition out.",
  "What does 'carrier' mean?", "You have one copy of a gene change that causes a condition only when a child inherits it from both parents. It matters most if you're planning a family.",
  'Do I get help reading the report?', 'Yes. One session with a genetic counselor is included.',
  'Will this affect my insurance?', "A federal law, GINA, bars health insurers and most employers from using your genetic results. It doesn't cover life, disability or long-term care insurance, so some people buy those policies before testing.",
  'Who sees my DNA data?', "You, the physician who reviews it and your genetic counselor. We don't sell it and we don't share it without your written consent. You can ask us to delete your data and destroy your sample.",
  'Does DNA Decoder include blood tests?', 'No. Blood work is the Biomarker Membership, which is separate ($299 a year).',
  'How long does it take?', 'About 3 weeks from the day your sample reaches the lab.',
  'Can I test my child?', 'DNA Decoder is for adults 18 and over. For children with developmental concerns, see <a href="yodaara.html" class="underline underline-offset-4">Yodaara</a>.']],
 ['medmatch', 'MedMatch', [
  'Does MedMatch tell me what to take?', 'No. It tells your doctor how your body is likely to process a medication. The prescribing decision stays with them.',
  'Should I change my dose if the report flags something?', "Don't start, stop or change any medication on your own. Take the report to your doctor or pharmacist.",
  'Does it cover every drug?', "No. It covers 260+ medications where gene effects are well studied. Many drugs aren't affected by the genes we test.",
  'Do I need to repeat it?', "No. Your genes don't change, so the report stays useful for every prescription after this one.",
  'Will my doctor accept it?', 'Most doctors and pharmacists know pharmacogenomic testing. The report has a one-page summary written for them.',
  'Is MedMatch part of DNA Decoder?', 'DNA Decoder includes medication response along with disease risk, carrier status, nutrition and fitness. MedMatch is the medication report alone.']],
 ['yodaara', 'Yodaara', [
  'Does this diagnose autism?', 'No. Autism is diagnosed by a specialist who observes your child. The panel looks for biological factors that may add to the symptoms, some of which can be treated.',
  'Does insurance cover it?', "We don't bill insurance. You pay by card or Apple Pay.",
  'My child already had some of these tests. Do we repeat them?', "No. Switch them off on the panel page and upload the old reports. We'll price the rest. Custom panels don't include My Health.",
  'How is the sample taken?', 'A phlebotomist comes to your home, or you can bring your child to our Irving or The Colony clinic. Some tests also need a urine or stool sample, which you collect yourself.',
  'How long do results take?', '5 to 7 weeks. Whole exome sequencing is the slowest part.',
  'Can I share results with the school or Early Intervention?', 'Yes. Export any report from My Health as a PDF.',
  'Where is Yodaara available?', 'Enter your ZIP on the <a href="yodaara.html" class="underline underline-offset-4">Yodaara page</a> to check your address.']],
 ['myhealth', 'My Health', [
  'What is My Health?', 'The place your Mr Yoda results live, on the web and in the app. It sorts them by body system and compares each visit with the last.',
  'Does it cost extra?', 'No. It comes with the Biomarker Membership and with every genetic panel.',
  'Can I upload old lab results?', 'Yes: PDFs or photos from any US lab.',
  'Which wearables connect?', 'Apple Health, Oura and WHOOP.',
  'Is my data private?', "Your results are encrypted, and we follow HIPAA. We don't sell health data. You can download or delete yours from Settings.",
  'Is the assistant a doctor?', "No. It explains what a marker is and what your number means. It can't diagnose or prescribe."]],
 ['billing', 'Billing and privacy', [
  'How do I pay?', 'Credit card, debit card or Apple Pay.',
  'Do you take insurance?', "No. We don't bill insurance, Medicare or Medicaid.",
  "What's your refund policy?", 'See our <a href="#" class="underline underline-offset-4">Refund Policy</a>.',
  'Do you sell my data?', "No. We don't sell health or genetic data.",
  'Can I delete my data?', 'Yes. Ask from Settings in My Health or write to support@mryoda.com. For genetic tests you can also ask us to destroy your sample.']],
);

my $on = 'border-accentink bg-accentink text-white';
my $off = 'border-hair-strong bg-white text-ink hover:bg-[#ecf7ee]';
my $tabs = qq{<div class="mx-auto mb-8 flex max-w-[820px] flex-wrap gap-2" role="tablist" aria-label="FAQ topics" data-faq-filters>}
  . qq{<button type="button" role="tab" aria-selected="true" data-faq-filter="all" class="rounded-full border px-4 py-2 font-14 font-medium transition-colors $on">All</button>}
  . join('', map { qq{<button type="button" role="tab" aria-selected="false" data-faq-filter="$_->[0]" class="rounded-full border px-4 py-2 font-14 font-medium transition-colors $off">$_->[1]</button>} } @groups)
  . '</div>';
my $list = '';
for my $g (@groups) {
  $list .= qq{<div data-faq-group="$g->[0]" class="mx-auto max-w-[820px] [&+&]:mt-12">\n<h2 class="mb-2 t-eyebrow">$g->[1]</h2>\n<div class="border-t border-hair-strong">\n} . faq_items(@{$g->[2]}) . qq{</div></div>\n};
}
rexf(\$h, qr{<div class="mx-auto mb-8 flex max-w-\[820px\] flex-wrap gap-2" role="tablist".*?(?=<div class="mx-auto mt-14 max-w-\[820px\]")}s, sub { "$tabs\n$list" });

# closing card
rep(\$h, q{Write to talktome@mryoda.com and we'll get back to you.}, q{Write to support@mryoda.com. A person replies by email.});

save('faqs.html', $h);
