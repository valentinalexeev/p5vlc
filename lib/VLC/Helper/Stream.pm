# $Id$
# Stream.pm -- super class for all kinds of streams known by p5vlc.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.
package VLC::Helper::Stream;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Helper::Parameter);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new &type &as_parameter);
our $VERSION = '1.0';

sub new() {
  my ($class, $type) = @_;
  
  my $self = $class->SUPER::new($type);
  
  bless $self, $class;
  return $self;
}

1;

__END__
=head1 NAME

VLC::Helper::Stream - base class for all types of VLC.

=head1 SYNOPSIS

  You will unlikely to use this class but it's children.

=head1 DESCRIPTION

This is a base class for each and every stream p5vlc understands.

=head1 SEE ALSO

Classes that extends C<VLC::Helper::Stream>: L<VLC::Helper::Stream::Standard>,
L<VLC::Helper::Stream::RTP>, L<VLC::Helper::Stream::ES>, L<VLC::Helper::Stream::Duplicate>,
L<VLC::Helper::Stream::Display>.

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.
