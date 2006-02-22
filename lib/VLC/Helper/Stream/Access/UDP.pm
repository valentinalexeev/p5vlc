# $Id$
# UDP.pm -- Access type UDP.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.
package VLC::Helper::Stream::Access::UDP;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Helper::Stream::Access);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new);
our $VERSION = '1.0';

sub new() {
  my ($class, $name) = shift;
  $name = "udp" unless (defined $name);
  my $self = $class->SUPER::new($name);

  bless $self, $class;
  return $self;
}

sub cashing() {
  my ($self, $value) = @_;
  return $self->option("cashing", $value);
}

sub ttl() {
  my ($self, $value) = @_;
  return $self->option("ttl", $value);
}

sub group() {
  my ($self, $value) = @_;
  return $self->option("group", $value);
}

sub late() {
  my ($self, $value) = @_;
  return $self->option("late", $value);
}

sub raw() {
  my ($self, $value) = @_;
  return $self->switch("raw", $value);
}

1;

__END__
=head1 NAME

VLC::Helper::Access::UDP - access type UDP for Standard and similar streams.

=head1 SYNOPSIS

  use VLC::Helper::Stream::Standard;
  use VLC::Helper::Stream::Access::UDP;
  
  my $stdstream = VLC::Helper::Stream::Standard->new();
  ...
  # Creating access=udp{cashing=100}
  my $udpaccess = VLC::Helper::Stream::Access::UDP->new();
  $udpaccess->cashing(100);
  $stdstream->access($udpaccess);
  ...

=head1 DESCRIPTION

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.
