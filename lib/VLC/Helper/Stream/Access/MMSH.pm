# $Id$
# MMSH.pm -- Access type MMSH.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.
package VLC::Helper::Stream::Access::MMSH;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Helper::Stream::Access::HTTP);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new);
our $VERSION = '1.0';

sub new() {
  my $class = shift;
  my $self = $class->SUPER::new("mmsh");
  
  bless $self, $class;
  return $self;
}

1;

__END__
=head1 NAME

VLC::Helper::Access::MMSH - access type MMSH for Standard and similar streams.

=head1 SYNOPSIS

  use VLC::Helper::Stream::Standard;
  use VLC::Helper::Stream::Access::MMSH;
  
  my $stdstream = VLC::Helper::Stream::Standard->new();
  ...
  # Creating access=mmsh{user=test,pwd=password}
  my $access = VLC::Helper::Stream::Access::MMSH->new();
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
