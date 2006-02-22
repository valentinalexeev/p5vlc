# $Id$
# Access.pm -- super class for all kinds of access types known by p5vlc.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.
package VLC::Helper::Stream::Access;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Helper::Parameter);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new);
our $VERSION = '1.0';

sub new() {
  my ($class, $type) = @_;
  
  my $self = $class->SUPER::new($type, "access");
  
  bless $self, $class;
  return $self;
}

sub url() {
  my ($self, $value) = @_;
  return $self->option("url", $value);
}

1;

__END__
=head1 NAME

VLC::Type - base class for all types of VLC.

=head1 SYNOPSIS

  Basicly you will not need anything from this class.

=head1 DESCRIPTION

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.
