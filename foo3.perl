#!/usr/bin/perl -I /home/audris/lib64/perl5/ -I /home/atutko/perl5/lib/perl5/ -I /home/audris/lookup -I /home/atutko/Research/PerlI/perl5 -I /home/atutko/Research/PerlI/ -I /home/atutko/Research/PerlI/ulib64/perl5 -I /home/atutko/Research/PerlI/alib64/perl5 -I /home/atutko/Research/PerlI/ulib64/perl5/Cpanel/ -I /home/audris/lib/x86_64-linux-gnu/perl 
use strict;
use warnings;
use Error qw(:try);

use TokyoCabinet;
use Compress::LZF;
use cmt;

my $pre = "/data/play/atutko/";

my $split = 32;
my %c2taF = ();
for my $sec (0..($split-1)){
		my $fname = "/fast/c2taFullP.$sec.tch";
		tie %{$c2taF{$sec}}, "TokyoCabinet::HDB", "$fname", TokyoCabinet::HDB::OREADER | TokyoCabinet::HDB::ONOLCK,   
				16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
						or die "cant open $fname\n";
}
my %c2pF = ();
for my $sec (0..($split-1)){
		my $fname = "/fast/c2pFullP.$sec.tch";
		tie %{$c2pF{$sec}}, "TokyoCabinet::HDB", "$fname", TokyoCabinet::HDB::OREADER | TokyoCabinet::HDB::ONOLCK,
				16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
						or die "cant open $fname\n";
}

my %out;
tie %out, "TokyoCabinet::HDB", "$pre/ap2ct.tch", TokyoCabinet::HDB::OWRITER |  TokyoCabinet::HDB::OCREAT,
		16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
		or die "cant open $pre/ap2ct.tch\n";

while (my ($i, $com) = each %c2taF) {
		while ( my ($k, $v) = each %$com) {
				my $c = toHex($k);
				my ($t, $a) = split(";", $v );

				my $sec = sHash ($k, $split);
				my $p = $c2pF{$sec}{$k};
				if( defined $p ) {
						my $pro = safeDecomp($p);
						my $hkey = "$a;$pro";
						my $vv = $out{$hkey};
						my $old = $vv ? $vv : '';
						$out{$hkey} = "$old;$c;$t";
				}
		}
}
for my $sec (0..($split-1)){
		untie %{$c2taF{$sec}};
		untie %{$c2pF{$sec}};
}


sub listP {
		my ($u, $p, $v, $res) = @_;
		my $fsn = safeDecomp($v);
		$fsn =~ s/\n//g;
		my @fs = split (/;/,$fsn);
		for my $f (@fs){
				next if defined $badProjects{$f};
				$res ->{$u}{$f}{$p}++;
		}
}

sub listB {
		my ($u, $p, $v, $res) = @_;
		my $ns = length($v)/20;
		for my $i (0..($ns-1)){
				my $c = substr ($v, 20*$i, 20);
				$res ->{$u}{toHex($c)}{$p}++;
		}
}
sub encode {
		  my $str = shift;
		  $str =~ s/([^A-Za-z0-9\.\/\_\-])/sprintf("%%%02X", ord($1))/seg;
  	  return $str;
			}


