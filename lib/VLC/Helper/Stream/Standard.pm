# $Id$
# Standard.pm -- super class for all kinds of streams known by p5vlc.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.
package VLC::Helper::Stream::Standard;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Helper::Stream);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new);
our $VERSION = '1.0';

sub new() {
  my $class = shift;
  my $self = $class->SUPER::new("standard");
  
  bless $self, $class;
  return $self;
}

sub access() {
  my ($self, $value) = @_;
  return $self->option("access", $value);
}

sub mux() {
  my ($self, $value) = @_;
  return $self->option("mux", $value);
}

sub url() {
  my ($self, $value) = @_;
  return $self->option("url", $value);
}

sub sap() {
  my ($self, $value) = @_;
  return $self->switch("sap", $value);
}

sub slp() {
  my ($self, $value) = @_;
  return $self->switch("slp", $value);
}

sub sapipv6() {
  my ($self, $value) = @_;
  $self->sap(1);
  return $self->switch("sap-ipv6", $value);
}

sub name() {
  my ($self, $value) = @_;
  return $self->option("name", $value);
}

sub group() {
  my ($self, $value) = @_;
  $self->sap(1);
  return $self->option("group", $value);
}

sub check_parameter() {
  my $self = shift;
  die "access option is required" unless (defined $self->option("access"));
  die "mux option is required" unless (defined $self->option("mux"));
  # feature: url is, if i understand correct, is a necessary part of each access, so
  #   why can't we fetch/store url from access itself.
  if (!defined $self->option("url")) {
    my $fromacc = $self->option("access")->url();
    if (!defined $fromacc) {
      die "url option is required";
    }
    $self->url($fromacc);
  }
  die "sap option may be specified for access=udp only" if ($self->option("sap") and $self->option("access")->type ne "udp");
  die "group option may be specified only when sap is on" if (defined $self->option("group") and !$self->option("sap"));
  die "sapipv6 optiom may be specified only when sap is on" if ($self->option("sap-ipv6") and !$self->option("sap"));
  die "name may only be specified if either sap/sapipv6 or slp are on" if (defined $self->option("name") and !$self->option("sap") and !$self->option("slp"));
  1;
}

1;

__END__
=head1 NAME

VLC::Helper::Stream::Standard - standard stream type.

=head1 SYNOPSIS

  use VLC::Helper::Stream::Standard;
  # use VLC::Helper::Stream::Access::some-kind-of-access-type
  # use VLC::Helper::Stream::Mux::some-kind-of-mux-type
  
  ...
  my $stdstream = VLC::Helper::Stream::Standard->new();
  my $access = ...
  my $mux = ...
  $stdstream->access($access);
  $stdstream->mux($mux);
  $stdstream->url("url-path-for-access");
  # or: $access->url("url-path-for-access");
  $broadcast = $vlc->newo("bcast", VLC::Type::BROADCAST);
  $broadcast->output("#" . $stdstream->as_parameter());

=head1 DESCRIPTION

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.
