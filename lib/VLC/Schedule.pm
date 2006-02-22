# $Id$
# Schedule.pm -- encapsulate schedule type of VLC.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.

package VLC::Schedule;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Type);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new );
our $VERSION = '$Id$';

use constant DEBUG => 1;

sub new($$) {
  my ($class, $vlc, $name) = @_;
  my $self = $class->SUPER::new($vlc, $name, "schedule");
  
  my @command;
  $self->{command} = \@command;
  $self->{date} = "now";
  $self->{period} = "0";
  $self->{repeat} = -1;
  
  bless $self, $class;
  
  $vlc->add($self);
  
  return $self;
}

sub load() {
  my $self = shift;
  print STDERR __PACKAGE__ . ": Loading schedule definition of " . $self->name . "\n" if DEBUG;
  
  my $desc = $self->{vlc}->perform("show " . $self->name);
  die "No such " . $self->{type} unless ($desc =~ /^show/);
  my @info = split /\r/, $desc;
  foreach (@info) {
    next if (/^show/);
    next if (/^\s{5}$self->{name}/);
    chomp;
    s/^\s{9}//;
    
    if (/^\s/) {
      s/^\s+//;
      push @{$self->{command}}, $_;
      next;
    }
        
    if (/^type :(.*)/) {
      die "Not a " . $self->{type} . " type" unless ($1 =~ /$self->{type}/);
    }
    if (/^enabled :(.*)/) {
      if ($1 =~ /yes/) {
        $self->{enabled} = 1;
      } else {
        $self->{enabled} = 0;
      }
    }
    if (/^date : (.*)/) {
      $self->{date} = $1;
    }
    if (/^period : (.*)/) {
      $self->{period} = $1;
    }
    if (/^repeat : (.*)/) {
      $self->{repeat} = $1;
    }
  }
}

sub date($) {
  my ($self, $date) = @_;
  return $self->{date} unless (defined $date);
  $self->{date} = $date;
  $self->setup("date $date");
}

sub period($) {
  my ($self, $period) = @_;
  return $self->{period} unless (defined $period);
  $self->{period} = $period;
  $self->setup("period $period");
}

sub repeat($) {
  my ($self, $repeat) = @_;
  return $self->{repeat} unless (defined $repeat);
  $self->{repeat} = $repeat;
  $self->setup("repeat $repeat");
}

sub command($) {
  my ($self, $newcommand) = @_;
  return @{$self->{command}} unless (defined $newcommand);
  push @{$self->{command}}, $newcommand;
  $self->setup("append $newcommand");
}

1;

__END__

=head1 NAME

VLC::Schedule -- encapsulate schedule type of VLC

=head1 SYNOPSIS

  use VLC::Schedule;
  
  my $schedule = $vlc->newo("schedulename", VLC::Type::SCHEDULE);
  $schedule->date("now");
  
=head1 CONSTRUCTOR

=over4

=item new ( vlc, name )

Create new instance of schedule. Generaly you wount use it. Instead
use C<$vlc->newo("schedulename", VLC::Type::SCHEDULE)>;

=back

=head1 METHODS

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.