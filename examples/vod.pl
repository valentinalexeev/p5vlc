#!/usr/bin/perl -w
use strict;
use warnings;

use VLC;
use Data::Dumper;

my $vlc = VLC->new("127.0.0.1", 4212, "admin");
$vlc->align();

my $vod = VLC::VOD->new($vlc, "newVoD");
$vod->create();
$vod->input("file:///test.mp4");
$vod->output("rtsp://0.0.0.0:1234");
$vod->commit();
$vlc->align();

print Dumper($vlc);