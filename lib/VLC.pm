# $Id$
# VLC.pm -- main interface to VLC module.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.

package VLC;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new &perform);
our $VERSION = '1.1';

use VLC::Transport::Telnet;
use VLC::Broadcast;
use VLC::VOD;
use VLC::Schedule;

use constant DEBUG => 1;

sub new($$$) {
  my $self = {};
  
  my ($class, $address, $port, $password) = @_;
  
  $self->{transport} = VLC::Transport::Telnet->new($address, $port, $password);
  my %object;
  $self->{object} = \%object;
  my @media;
  $self->{media} = \@media;
  my @schedule;
  $self->{schedule} = \@schedule;
  
  bless $self, $class;
  return $self;
}

sub align() {
  my $self = shift;
  
  # clean up current state.
  my (%object, @media, @schedule);
  $self->{object} = \%object;
  $self->{media} = \@media;
  $self->{schedule} = \@schedule;
  
  # get information
  my $desc = $self->perform("show");
  my @info = split /\r/, $desc;
  
  # section switches
  my $inmedia = 0;
  my $inschedule = 0;
  my $ininstances = 0;
  
  # media name being analyzed
  my $medianame = "";
  
  foreach (@info) {
    # prepare line for parsing, skip introduction
    chomp;
    s/^\s{5}//;
    next if /^show/;

    if (/^\s/) {
      # this is some value given in a list
      s/\s{4}//;
      if (!/^\s/) {
        # first level of a tree -- media/schedule name
        $medianame = $_;
      } else {
        # skip instances section
        next if (/^\s{8}/ && $ininstances);
        s/^\s+//;
        if ($inmedia) {
          # this is media section line
          if (/^type : broadcast/) {
            my $newbcast = $self->newo($medianame, VLC::Type::BROADCAST);
            $newbcast->load();
            next;
          }
          if (/^type : vod/) {
            my $newvod = $self->newo($medianame, VLC::Type::VOD);
            $newvod->load();
            next;
          }
          next if (/^enable/);
          if (/^instance/) {
            $ininstances = 1;
            next;
          }
        }
        if ($inschedule) {
          # this is schedule section line
          my $newsch = $self->newo($medianame, VLC::Type::SCHEDULE);
          $newsch->load();
          $medianame = "";
          next;
        }
      }
    }
    
    if (/^media/) {
      $inmedia = 1;
    }
    if (/^schedule/) {
      $inmedia = 0;
      $inschedule = 1;
    }
  }
}

sub load($) {
  my ($self, $file) = @_;
  return $self->perform("load $file");
}

sub save($) {
  my ($self, $file) = @_;
  return $self->perform("save $file");
}

sub geto($$) {
  my ($self, $name, $type) = @_;
  return %{$self->{object}} unless (defined $name);
  return $self->{object}->{$name};
}

sub newo($$) {
  my ($self, $name, $type) = @_;
  die "Object $name already exists" if exists($self->{object}->{$name});
  my $typen = "VLC::$type";
  push @{$self->{schedule}}, $name if $type eq VLC::Type::SCHEDULE;
  push @{$self->{media}}, $name if $type ne VLC::Type::SCHEDULE;  
  return $typen->new($self, $name);
}

sub add($) {
  my ($self, $bcast) = @_;
  print STDERR __PACKAGE__ . ": Added " . $bcast->{type} . " named " . $bcast->name() . "\n" if DEBUG;
  $self->{object}->{$bcast->name()} = $bcast;
}

sub haso($) {
  my ($self, $name) = @_;
  return exists($self->{object}->{$name});
}

sub perform($) {
  my ($self, $command) = @_;
  return $self->{transport}->perform($command);
}

sub disconnect() {
  my $self = shift;
  $self->{transport}->disconnect();
}

sub delete($) {
  my ($self, $name) = @_;
  $self->perform("del " . $name);
  delete($self->{object}->{$name});
}

use constant DELETEALL_ALL => 1;
use constant DELETEALL_MEDIA => 2;
use constant DELETEALL_SCHEDULE => 3;

sub deleteall($) {
  my ($self, $kind) = @_;
  if($kind eq DELETEALL_ALL) {
    $self->perform("del all");
    my %object;
    $self->{object} = \%object;
  }
  if($kind eq DELETEALL_MEDIA) {
    $self->perform("del media");
    map { delete $self->{object}->{$_} } @{$self->{media}};
  }
  if($kind eq DELETEALL_SCHEDULE) {
    $self->perform("del schedule");
    map { delete $self->{object}->{$_} } @{$self->{schedule}};
  }
}

use constant CONTROLINSTANCE_DEFAULT => "default";
use constant CONTROL_PLAY => 1;
use constant CONTROL_PAUSE => 2;
use constant CONTROL_STOP => 3;
use constant CONTROL_SEEK => 4;
sub control($$$$) {
  my ($self, $name, $instance, $kind, $percentage) = @_;
  die "Should specify at least name and kind." unless (defined $kind);
  return $self->perform("control $name $instance play") if $kind eq CONTROL_PLAY;
  return $self->perform("control $name $instance pause") if $kind eq CONTROL_PAUSE;
  return $self->perform("control $name $instance stop") if $kind eq CONTROL_STOP;
  die "Must specify percentage for CONTROL_SEEK." unless (defined $percentage);
  return $self->perform("control $name $instance seek $percentage") if $kind eq CONTROL_SEEK;
}

1;

__END__
=head1 NAME

VLC - a Perl interface to VideoLAN Client via Telnet interface.

=head1 SYNOPSIS

  use VLC;
  
  # List all broadcasts
  my $vlc = VLC->new("127.0.0.1", 4212, "admin");
  $vlc->align();
  my %broadcasts = $vlc->broadcast();
  foreach my $bcast (values %broadcasts) {
    print "Broadcast: " . $bcast->name() . "\n";
  }
  # Remove given item
  $vlc->delete("bcast");
  # Clean all schedule items
  $vlc->deleteall(VLC::DELETEALL_SCHEDULE);
  # Disconnect after all
  $vlc->disconnect(); 

=head1 DESCRIPTION

This is the main entry point of the module. If you intent to work
with VLC you'll shurely use it.

Unlike C<VLC::Type> and it's children C<VLC> operates without
'transactions' and any operation takes immediate action on VLC.

Most methods are self-explanatory and are simply proxies to actions
that you can make on VLC'c telnet interface with your own hands. So
for the parameter syntax please look into VideoLAN Stream Howto.

However there are some classes in VLC that aid working with this
parameters a little. Take a look at L<VLC::Helper::Stream>, for
more information on how to create C<output()> parameter in OO-way.

=head1 CONSTRUCTOR

=over 4

=item new ( address, port, password )

Create new instance of C<VLC> and connect to VLC via Telnet interface.
In future 

=back

=head1 METHODS

=over 4

=item align ( )

Align module internal structures to what is stored in VLC itself.

=item load ( filename )

Load VLM commands from specified filename. This is done on remote side
and if file name is a relative path it's counted from the directory vlc
was started from.

=item save ( filename )

Save VLM commands to specified file. This is done on remote side
and if file name is a relative path it's counted from the directory vlc
was started from.

=item geto ( [name] )

Returns hash of name C<VLC::Type> for each known item of this VLC.
If name is specified return only given C<VLC::Type>.

=item haso ( name )

Check if this VLC knows about given item.

=item newo ( name, type )

Construct new item of a given type. Types are:
C<VLC::Type::BROADCAST>, C<VLC::Type::VOD> and
C<VLC::Type::SCHEDULE>.

=item control ( name, instancename, kind [, percentage] )

Perform specified action kind on given instance of an object.
Kinds are: C<VLC::CONTROL_PLAY>, C<VLC::CONTROL_PAUSE>, C<VLC::CONTROL_STOP>,
C<VLC::CONTROL_SEEK>. In latter case you should also specify percentage.

Default instance should be named as C<VLC::CONTROLINSTANCE_DEFAULT>.

=item delete ( name )

Delete named item from VLC.

=item deleteall ( kind )

Delete all items of specified kind. Kinds are:
C<VLC::DELETEALL_ALL>, C<VLC::DELETEALL_MEDIA> and
C<VLC::DELETEALL_SCHEDULE>.

=item disconnect ()

Close transport connection to VLC.

=item perform ( command )

Perform an arbitrary command on VLC interface.

=back

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.