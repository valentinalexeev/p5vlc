# $Id$
# RTP.pm -- RTP stream type.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.

package VLC::Helper::Stream::RTP;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Helper::Stream);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new);
our $VERSION = '$Id$';

sub new($$$) {
  my $class = shift;
  my $self = $class->SUPER::new("rtp");
  
  bless $self, $class;
  return $self;
}

sub dst() {
  my ($self, $value) = @_;
  return $self->option("dst", $value);
}

sub port() {
  my ($self, $value) = @_;
  return $self->option("port", $value);
}

sub portvideo() {
  my ($self, $value) = @_;
  return $self->option("port-video", $value);
}

sub portaudio() {
  my ($self, $value) = @_;
  return $self->option("port-audio", $value);
}

sub sdp() {
  my ($self, $value) = @_;
  return $self->option("sdp", $value);
}

sub ttl() {
  my ($self, $value) = @_;
  return $self->option("ttl", $value);
}

sub mux() {
  my ($self, $value) = @_;
  return $self->option("mux", $value);
}

sub name() {
  my ($self, $value) = @_;
  return $self->option("name", $value);
}

sub description() {
  my ($self, $value) = @_;
  return $self->option("description", $value);
}

sub url() {
  my ($self, $value) = @_;
  return $self->option("url", $value);
}

sub email() {
  my ($self, $value) = @_;
  return $self->option("email", $value);
}

sub check_parameter() {
  my $self = shift;
  die "dst option is missing along and no sdp options provided also" if (!defined $self->option("dst") and !defined->$self->option("sdp"));
  my $mux = $self->mux();
  if (defined $mux) {
    my $type = "";
    # we can set mux both as string and as ::Mux::...
    if (ref(\$mux) eq 'SCALAR') {
      $mux =~ /^([^{]+)/;
      $type = $1;
    } else {
      $type = $mux->parameter_name();
    }
    die "mux could be either ts or raw" unless ($type eq "ts" or $type eq "raw");
  }
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