# $Id$
# HTTP.pm -- Access type HTTP.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.
package VLC::Helper::Stream::Access::HTTP;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Helper::Stream::Access);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new);
our $VERSION = '1.0';

sub new() {
  my ($class, $name) = shift;
  $name = "http" unless (defined $name);
  my $self = $class->SUPER::new($name);
  
  bless $self, $class;
  return $self;
}

sub user() {
  my ($self, $value) = @_;
  return $self->option("user", $value);
}

sub pwd() {
  my ($self, $value) = @_;
  return $self->option("pwd", $value);
}

sub mime() {
  my ($self, $value) = @_;
  return $self->option("mime", $value);
}

1;

__END__
=head1 NAME

VLC::Helper::Access::HTTP - access type HTTP for Standard and similar streams.

=head1 SYNOPSIS

  use VLC::Helper::Stream::Standard;
  use VLC::Helper::Stream::Access::HTTP;
  
  my $stdstream = VLC::Helper::Stream::Standard->new();
  ...
  # Creating access=http{user=test,pwd=password}
  my $access = VLC::Helper::Stream::Access::HTTP->new();
  $access->user("test");
  $access->pwd("password");
  $stdstream->access($access);
  ...

=head1 DESCRIPTION

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.
