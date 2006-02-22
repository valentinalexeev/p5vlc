# $Id$
# Duplicate.pm -- duplicate 'stream' type.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.

package VLC::Helper::Stream::Duplicate;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Helper::Stream);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new);
our $VERSION = '$Id$';

sub new($$$) {
  my $class = shift;
  my $self = $class->SUPER::new("duplicate");
  
  bless $self, $class;
  return $self;
}

sub dst($) {
  my ($self, $value) = @_;
  return $self->option("dst") unless (defined $value);
  if (!defined $self->option("dst")) {
    my @dsts;
    $self->option("dst", \@dsts);
  }
  push @{$self->option("dst")}, $value;
}

sub select() {
  my ($self, $value) = @_;
  return $self->option("select", $value);
}

package VLC::Helper::Stream::Duplicate::Select;
use base qw(VLC::Helper::Parameter);

sub new() {
  my $class = shift;
  my $self = $class->SUPER::new("", "select");
  
  bless $self, $class;
  
  $self->quoted(1);
  
  return $self;
}

sub program() {
  my ($self, $value) = @_;
  $self->option("program", $value);
}

sub noprogram() {
  my ($self, $value) = @_;
  $self->option("noprogram", $value);
}

sub es() {
  my ($self, $value) = @_;
  $self->option("es", $value);
}

sub noes() {
  my ($self, $value) = @_;
  $self->option("noes", $value);
}

sub video() {
  my ($self, $value) = @_;
  $self->switch("video", $value);
}

sub novideo() {
  my ($self, $value) = @_;
  $self->switch("novideo", $value);
}

sub audio() {
  my ($self, $value) = @_;
  $self->switch("audio", $value);
}

sub noaudio() {
  my ($self, $value) = @_;
  $self->switch("noaudio", $value);
}

sub spu() {
  my ($self, $value) = @_;
  $self->switch("spu", $value);
}

sub nospu() {
  my ($self, $value) = @_;
  $self->switch("nospu", $value);
}

sub check_parameter() {
  my $self = shift;
  die "both audio and noaudio specified" if (defined $self->switch("audio") and defined $self->switch("noaudio"));
  die "both video and novideo specified" if (defined $self->switch("video") and defined $self->switch("novideo"));
  die "both spu and spu specified" if (defined $self->switch("spu") and defined $self->switch("spu"));
  1;
}

1;