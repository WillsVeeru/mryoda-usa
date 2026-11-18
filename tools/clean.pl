#!/usr/bin/perl
# Turns a headless-Chrome DOM capture of a live Mr Yoda page into a static page:
# keeps header/main/footer, drops React scripts, localises images, resets GSAP
# start states so everything is visible, and points nav links at the local pages.
# usage: perl clean.pl <capture.html> <out.html> <root-dir>
use strict; use warnings;
my ($in, $out, $root) = @ARGV;
local $/; open my $fh, '<:raw', $in or die $!; my $h = <$fh>; close $fh;
my $base = 'https://mryoda-test-details.netlify.app';

my ($htmlAttrs) = $h =~ /<html([^>]*)>/; $htmlAttrs =~ s/\s*lenis//;
my ($title) = $h =~ /<title>(.*?)<\/title>/s;
my ($desc) = $h =~ /<meta name="description" content="([^"]*)"/;
my @styles = $h =~ /(<style[^>]*>.*?<\/style>)/sg;

my ($header) = $h =~ /(<header class="sticky.*?<\/header>)/s;
my ($main) = $h =~ /(<main.*<\/main>)/s;
my ($footer) = $h =~ /(<footer class="relative overflow-hidden.*<\/footer>)/s;
die "missing part in $in" unless $header && $main && $footer;
my $body = "$header\n$main\n$footer";

# scripts / noscript
$body =~ s/<script\b.*?<\/script>//sg;
$body =~ s/<noscript\b.*?<\/noscript>//sg;

# next/image urls -> original path
$body =~ s{/_next/image\?url=([^&"]+)[^"\s,]*}{my $u=$1; $u=~s/%([0-9A-Fa-f]{2})/chr hex $1/ge; $u}ge;

# localise images / media referenced from site root
my %assets;
my $ext = qr/\.(?:jpe?g|png|webp|svg|gif|mp4|webm|avif|ico)/i;
$body =~ s{(["\s,(]|&quot;)(/(?!/)[A-Za-z0-9_\-./%]+$ext)}{$assets{$2}=1; $1.'assets/img'.$2}ge;
for my $p (keys %assets) {
  my $dest = "$root/assets/img$p";
  next if -s $dest;
  (my $dir = $dest) =~ s{/[^/]+$}{}; system('mkdir', '-p', $dir);
  system('curl', '-s', '-f', '-o', $dest, "$base$p") == 0 or warn "fail $p\n";
}

# GSAP start states -> visible
$body =~ s{style="([^"]*)"}{
  my $s = $1;
  if ($s =~ /translate: none; rotate: none; scale: none;/) {
    $s =~ s/opacity: 0(?:\.\d+)?;\s*//g;
    $s =~ s/transform: translate\([^)]*\)(?: scale\([^)]*\))?;?\s*//g;
    $s =~ s/transform: scale\(0\.\d+, 0\.\d+\);?\s*//g;
    $s =~ s/visibility: hidden;\s*//g;
  }
  qq{style="$s"}
}ge;

# internal links -> local pages
my %map = ('/' => 'index.html', '/what-we-test' => 'what-we-test.html', '/membership' => 'what-we-test.html',
  '/how-it-works' => 'how-it-works.html', '/dna-decoder' => 'dna-decoder.html', '/medmatch' => 'medmatch.html',
  '/yodaara' => 'yodaara.html', '/myhealth' => 'my-health.html', '/myhealth/' => 'my-health.html',
  '/about' => 'about.html', '/contact' => 'contact.html', '/faqs' => 'faqs.html', '/about#contact' => 'contact.html');
$body =~ s{href="(/[^"]*)"}{
  my $u = $1; (my $k = $u) =~ s/\?.*//; $k =~ s{(.)/$}{$1};
  my ($path, $hash) = $k =~ /^([^#]*)(#.*)?$/; $hash //= '';
  exists $map{$k} ? qq{href="$map{$k}"} : exists $map{$path} ? qq{href="$map{$path}$hash"} : qq{href="#"}
}ge;

my $styleStr = join("\n", @styles);
open my $o, '>:raw', $out or die $!;
print $o <<"HTML";
<!DOCTYPE html>
<html$htmlAttrs>
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>$title</title>
<meta name="description" content="@{[ $desc // '' ]}"/>
<link rel="icon" href="assets/img/Logo.png"/>
<link rel="stylesheet" href="assets/css/3d_rpyrlg9hcj.css"/>
<link rel="stylesheet" href="assets/css/3hr5ki1bkz99h.css"/>
$styleStr
<link rel="stylesheet" href="assets/css/usa.css"/>
</head>
<body class="antialiased">
$body
<script src="assets/js/site.js"></script>
</body>
</html>
HTML
close $o;
print "ok $out (" . scalar(keys %assets) . " assets)\n";
