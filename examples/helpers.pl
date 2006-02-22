#!/usr/bin/perl -w
use strict;
use warnings;

use VLC::Helper::Stream::RTP;
use VLC::Helper::Stream::Duplicate;
use VLC::Helper::Stream::Access::UDP;
use VLC::Helper::Stream::Mux;

my $stdstream = VLC::Helper::Stream::RTP->new();
$stdstream->dst("123");
$stdstream->mux("ts");
my $dupstream = VLC::Helper::Stream::Duplicate->new();
$dupstream->dst($stdstream);
$dupstream->dst($stdstream);
my $select = VLC::Helper::Stream::Duplicate::Select->new();
$select->program(100);
$dupstream->select($select);
print $dupstream->as_parameter() . "\n";