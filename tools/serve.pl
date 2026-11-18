#!/usr/bin/perl
# Minimal static file server for previewing the pages: perl tools/serve.pl [port]
use strict; use warnings; use HTTP::Daemon; use HTTP::Status; use File::Basename qw(dirname);
my $port = shift || 4321;
chdir dirname(__FILE__) . '/..';
my $d = HTTP::Daemon->new(LocalAddr => '127.0.0.1', LocalPort => $port, ReuseAddr => 1) or die "cannot listen: $!";
print "Serving on http://localhost:$port/\n"; $| = 1;
my %ct = (html=>'text/html; charset=utf-8', css=>'text/css', js=>'application/javascript', svg=>'image/svg+xml',
  png=>'image/png', jpg=>'image/jpeg', jpeg=>'image/jpeg', webp=>'image/webp', gif=>'image/gif', woff2=>'font/woff2', mp4=>'video/mp4');
$SIG{CHLD} = "IGNORE";
while (my $c = $d->accept) {
  if (fork) { $c->close; next }
  while (my $r = $c->get_request) {
    my $p = $r->uri->path; $p =~ s/%([0-9A-Fa-f]{2})/chr hex $1/ge; $p = '/index.html' if $p eq '/';
    $p =~ s/\.\.//g; my $f = ".$p";
    if (-f $f) { my ($e) = $f =~ /\.(\w+)$/; $c->send_file_response($f) if 0;
      open my $fh, '<:raw', $f; local $/; my $b = <$fh>; close $fh;
      my $res = HTTP::Response->new(200); $res->header('Content-Type' => $ct{lc($e // '')} // 'application/octet-stream');
      $res->header('Cache-Control' => 'no-store'); $res->content($b); $c->send_response($res); $c->force_last_request;
    } else { $c->send_error(RC_NOT_FOUND) }
  }
  $c->close; exit 0;
}
