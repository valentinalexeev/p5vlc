# $Id$
# Display.pm -- display 'stream' type.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.

package VLC::Helper::Stream::Display;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Helper::Stream);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new &as_parameter &novideo &noaudio &delay);
our $VERSION = '$Id$';

sub new($$$) {
  my $class = shift;
  my $self = $class->SUPER::new("display");
  
  bless $self, $class;
  return $self;
}

sub novideo() {
  my ($self, $value) = @_;
  return $self->switch("novideo", $value);
}

sub noaudio() {
  my ($self, $value) = @_;
  return $self->switch("noaudio", $value);
}

sub delay() {
  my ($self, $value) = @_;
  return $self->option("delay", $value);
}

1;

__END__

=head1 NAME

VLC::Helper::Stream::Display -- display 'stream' type.

=head1 SYNOPSIS

  use VLC::Helper::Stream::Display;
  
  my $stream = VLC::Helper::Stream::Display();
  $broadcast->output("#" . $stream);

=head1 CONSTRUCTOR

=over 4

=item new ( )

=back

=head1 METHODS

=over 4

=back

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.