# $Id$
# Type.pm -- super class for type visible via VLM.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.
package VLC::Type;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new &enable);
our $VERSION = '$Id$';

use constant DEBUG => 1;

use constant SCHEDULE => "Schedule";
use constant BROADCAST => "Broadcast";
use constant VOD => "VOD";

sub new() {
  my ($class, $vlc, $name, $type) = @_;
  
  my $self = {};
  $self->{vlc} = $vlc;
  $self->{name} = $name;
  $self->{type} = $type;
  $self->{enabled} = 0;
  $self->{autocommit} = 0;
  my @pending;
  $self->{pending} = \@pending;
  
  bless $self, $class;
  return $self;
}

sub create() {
  my $self = shift;
  $self->perform("new " . $self->{name} . " " . $self->{type});
}

sub load() {
  die "Sub classes must implement load method.";
}

sub enable($) {
  my ($self, $isenable) = @_;
  return $self->{enabled} unless (defined $isenable);
  $self->{enabled} = $isenable;
  $self->setup("enabled") if $isenable;
  $self->setup("disabled") unless $isenable;
}

sub name() {
  my $self = shift;
  return $self->{name};
}

# private methods
sub setup($) {
  my ($self, $cmd) = @_;
  return $self->perform("setup " . $self->{name} . " $cmd");
}

sub autocommit($) {
  my ($self, $ac) = @_;
  return $self->{autocommit} unless (defined $ac);
  $self->{autocommit} = $ac;
}

sub commit() {
  my $self = shift;
  my @actions = @{$self->{pending}};
  my @newactions;
  $self->{pending} = \@newactions;
  foreach my $action (@actions) {
    $self->{vlc}->perform($action);
  }
}

sub forget() {
  my $self = shift;
  my @newactions;
  $self->{pending} = \@newactions;
}

sub perform($) {
  my ($self, $command) = @_;
  return $self->{vlc}->perform($command) if $self->{autocommit};
  push @{$self->{pending}}, "$command";
}

1;

__END__
=head1 NAME

VLC::Type - base class for all types of VLC.

=head1 SYNOPSIS

  Basicly you will not need anything from this class.

=head1 DESCRIPTION

This class provides core operations related to: creating a type
within VLC instance, enabling/disabling it, 'transaction' operations.

'Transactions' allow you to alter p5vlc's object state without actualy
performing any changes. Note that C<forget()>ing on an object does not
bring it's state to what it was before any actions. Instead it simply
removes any VLM operations that are in queue. To revert state back to what
it is in VLC you can do C<load()>.

Every operation of C<VLC::Type> and it's children that alters VLC state
should be (and is, currently) 'transaction'-aware.

By default auto commit mode is off.

=head1 CONSTRUCTOR

=over 4

=item new ( vlm, type, name )

Create new instance of C<VLC::Media> base class for a given
instance of VLC connection with specified name and of specific type.

=head1 METHODS

=over 4

=item name ( [newname] )

Get name of a object or rename it to a given newname.

Renaming does not actualy perform any action on VLC ever.

=item create ()

Create this object at VLC.

=item load ()

This is an 'abstract' method which subclasses must implement. It should load
all necessary information for this particular type and align object's state.

=item autocommit ( [autocommit] )

Check or set autocommit functionality. While in autocommit mode every
operation (except C<name> because of it's nature) are executed on VLC.

=item commit ()

Commit any pending operations to VLC.

=item forget ()

Forget about any operations that are currently pending execution.

=back

=head1 BUGS

There is no error handling at all currently.

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.
