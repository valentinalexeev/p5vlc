# $Id$
# File.pm -- Access type File.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.
package VLC::Helper::Stream::Access::File;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Helper::Stream::Access);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new);
our $VERSION = '1.0';

sub new() {
  my $class = shift;
  my $self = $class->SUPER::new("file");
  
  bless $self, $class;
  return $self;
}

sub append() {
  my ($self, $value) = @_;
  return $self->switch("append", $value);
}

1;

__END__
=head1 NAME

VLC::Helper::Access::File - access type File for Standard and similar streams.

=head1 SYNOPSIS

  use VLC::Helper::Stream::Standard;
  use VLC::Helper::Stream::Access::File;
  
  my $stdstream = VLC::Helper::Stream::Standard->new();
  ...
  # Creating access=file{append}
  my $fileaccess = VLC::Helper::Stream::Access::File->new();
  $fileaccess->append(1);
  $stdstream->access($fileaccess);
  ...

=head1 DESCRIPTION

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.
