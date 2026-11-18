#!/usr/bin/perl
# Applies the sitewide USA copy (navigation + footer) to every page.
# usage: perl tools/sitewide.pl page.html [page2.html ...]   (idempotent)
use strict; use warnings;

my $link = 'block whitespace-nowrap py-1 t-secondary transition-colors hover:text-ink max-[600px]:whitespace-normal';
sub col { my ($title, @items) = @_;
  my $lis = join '', map { my ($t, $h) = @$_; qq{\n<li><a href="$h" class="$link">$t</a></li>} } @items;
  qq{\n<div>\n<h5 class="mb-5 font-15 font-semibold text-ink">$title</h5>\n<ul class="space-y-0.5">$lis</ul>\n</div>} }

my $nav = '<nav aria-label="Footer" class="grid grid-cols-[repeat(5,auto)] justify-between gap-x-10 gap-y-10 max-[1400px]:grid-cols-[repeat(3,auto)] max-[600px]:grid-cols-2 max-[600px]:gap-x-5">'
  . col('Membership', ['Biomarker Membership', 'index.html#plans'], ['What we test', 'what-we-test.html'], ['How it works', 'how-it-works.html'], ['Join', 'what-we-test.html#plan'])
  . col('Genetic panels', ['DNA Decoder', 'dna-decoder.html'], ['MedMatch', 'medmatch.html'], ['Yodaara', 'yodaara.html'])
  . col('Your account', ['My Health', 'my-health.html'], ['Orders', '#'], ['Track a kit or visit', '#'])
  . col('Company', ['About', 'about.html'], ['Contact', 'contact.html'], ['FAQs', 'faqs.html'], ['Blog', '#'])
  . col('Legal', ['Privacy Policy', '#'], ['Terms and Conditions', '#'], ['Refund Policy', '#'], ['Cancellation Policy', '#'], ['Cookie Policy', '#'])
  . '</nav>';

my $legal = <<'HTML';
<div data-usa="footer-legal" class="grid grid-cols-3 gap-8 border-t border-black/[.07] px-[var(--card-pad-xl)] py-6 max-[1000px]:grid-cols-1 max-[1000px]:gap-4">
<p class="t-caption">Blood and urine testing is performed by TestGo Diagnostics, 6600 Paige Road, Suite 100, The Colony, TX 75056. CLIA-certified and COLA-accredited.</p>
<p class="t-caption">Mr Yoda tests are ordered and reviewed by independent licensed physicians. Results are for information and do not diagnose, treat or cure any disease. Talk to your doctor before you change a medication or treatment. In an emergency, call 911.</p>
<p class="t-caption">We don't bill insurance, Medicare or Medicaid.</p></div>
HTML
chomp $legal;

for my $f (@ARGV) {
  local $/; open my $fh, '<:raw', $f or die "$f: $!"; my $h = <$fh>; close $fh;

  # header: pill was faded in by JS on the live site
  $h =~ s/(shadow-\[0_18px_44px_-30px_rgba\(10,23,18,\.35\)\]|shadow-[^"]*?)" style="opacity: 0;"/$1"/;
  $h =~ s/(<header\b.*?)(<div class="relative flex h-16[^"]*") style="opacity: 0;"/$1$2/s;
  # header: add Join next to Sign in
  $h =~ s{(<a href="#" class="[^"]*">Sign in</a>)(?!<a[^>]*hdr-join)}{$1<a href="what-we-test.html#plan" class="btn-primary hdr-join max-[1100px]:hidden">Join</a>};

  # footer tagline, columns, badges, legal lines
  $h =~ s{(<p class="mt-6 max-w-\[340px\] t-body">)[^<]*(</p>)}{$1Lab testing ordered and reviewed by a physician, priced up front, written so you can read it.$2};
  $h =~ s{<nav aria-label="Footer".*?</nav>}{$nav}s;
  $h =~ s{(<p class="t-label font-semibold">CLIA</p>\s*<p class="mt-0.5 t-caption">)[^<]*}{$1CLIA-certified lab};
  $h =~ s{(<p class="t-label font-semibold">COLA</p>\s*<p class="mt-0.5 t-caption">)[^<]*}{$1COLA-accredited};
  $h =~ s{(<p class="t-label font-semibold">HIPAA</p>\s*<p class="mt-0.5 t-caption">)[^<]*}{$1HIPAA privacy protections};
  $h =~ s{(<ul aria-label="Accreditations".*?</ul>)(?!\s*<div data-usa="footer-legal")}{$1\n$legal}s;

  open my $o, '>:raw', $f or die $!; print $o $h; close $o;
  print "sitewide: $f\n";
}
