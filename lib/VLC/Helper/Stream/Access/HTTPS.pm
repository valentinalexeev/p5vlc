# $Id$
# HTTPS.pm -- Access type HTTPS.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.
package VLC::Helper::Stream::Access::HTTPS;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Helper::Stream::Access::HTTP);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new);
our $VERSION = '1.0';

sub new() {
  my $class = shift;
  my $self = $class->SUPER::new("https");
  
  bless $self, $class;
  return $self;
}

sub cert() {
  my ($self, $value) = @_;
  return $self->option("cert", $value);
}

sub key() {
  my ($self, $value) = @_;
  return $self->option("key", $value);
}

sub ca() {
  my ($self, $value) = @_;
  return $self->option("ca", $value);
}

sub crl() {
  my ($self, $value) = @_;
  return $self->option("crl", $value);
}

1;

__END__
=head1 NAME

VLC::Helper::Access::HTTPS - access type HTTPS for Standard and similar streams.

=head1 SYNOPSIS

  use VLC::Helper::Stream::Standard;
  use VLC::Helper::Stream::Access::HTTPS;
  
  my $stdstream = VLC::Helper::Stream::Standard->new();
  ...
  # Creating access=https{cert=/path/to/cert.file}
  my $access = VLC::Helper::Stream::Access::HTTPS->new();
  $access->cert("/path/to/cert.file");
  ...
  $stdstream->access($access);
  ...

=head1 DESCRIPTION

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.
