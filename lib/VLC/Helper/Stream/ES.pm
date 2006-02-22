# $Id$
# ES.pm -- ES stream type.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.

package VLC::Helper::Stream::ES;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Helper::Stream);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new);
our $VERSION = '$Id$';

sub new($$$) {
  my $class = shift;
  my $self = $class->SUPER::new("es");
  
  bless $self, $class;
  return $self;
}

sub accessaudio() {
  my ($self, $value) = @_;
  if (defined $value and ref(\$value) ne "SCALAR") {
    $value->parameter_type("access-audio");
  }
  return $self->option("access-audio", $value);
}

sub accessvideo() {
  my ($self, $value) = @_;
  if (defined $value and ref(\$value) ne "SCALAR") {
    $value->parameter_type("access-video");
  }
  return $self->option("access-video", $value);
}

sub access() {
  my ($self, $value) = @_;
  return $self->option("access", $value);
}

sub muxaudio() {
  my ($self, $value) = @_;
  if (defined $value and ref(\$value) ne "SCALAR") {
    $value->parameter_type("mux-audio");
  }
  return $self->option("mux-audio", $value);
}

sub muxvideo() {
  my ($self, $value) = @_;
  if (defined $value and ref(\$value) ne "SCALAR") {
    $value->parameter_type("mux-video");
  }
  return $self->option("mux-video", $value);
}

sub mux() {
  my ($self, $value) = @_;
  return $self->option("mux", $value);
}

sub dstaudio() {
  my ($self, $value) = @_;
  return $self->option("dst-audio", $value);
}

sub dstvideo() {
  my ($self, $value) = @_;
  return $self->option("dst-video", $value);
}

sub dst() {
  my ($self, $value) = @_;
  return $self->option("dst", $value);
}

sub check_parameter() {
  my $self = shift;
  die "none of access options specified" if (!defined $self->option("access") and !defined->$self->option("access-audio")
     and !defined->$self->option("access-video"));
  die "none of mux options specified" if (!defined $self->option("mux") and !defined->$self->option("mux-audio")
     and !defined->$self->option("mux-video"));
  die "none of dst options specified" if (!defined $self->option("dst") and !defined->$self->option("dst-audio")
     and !defined->$self->option("dst-video"));
  1;
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