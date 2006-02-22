#!/usr/bin/perl -w
use strict;
use warnings;

use VLC;
use VLC::Type;
use Data::Dumper;

my $vlc = VLC->new("127.0.0.1", 4212, "admin");
$vlc->align();
$vlc->delete("newsch") if $vlc->haso("newsch");
my $sch = $vlc->newo("newsch", VLC::Type::SCHEDULE);
$sch->create();
$sch->command("control bcast pause");
$sch->command("control bcast1 start");
$sch->date("now");
$sch->commit();
$vlc->align();
print Dumper($vlc);