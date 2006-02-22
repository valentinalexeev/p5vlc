# $Id$
# Mux.pm -- super class for all kinds of mux types known by p5vlc.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.
package VLC::Helper::Stream::Mux;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter VLC::Helper::Parameter);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new);
our $VERSION = '1.0';

sub new {
  my ($class, $type) = @_;
  
  my $self = $class->SUPER::new($type, "mux");
  
  bless $self, $class;
  return $self;
}

1;