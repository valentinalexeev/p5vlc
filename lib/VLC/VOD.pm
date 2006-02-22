# $Id$
# VOD.pm -- encapsulate vod (video on demand) media type of VLC.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.

package VLC::VOD;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter VLC::Media);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new &create &load);
our $VERSION = '$Id$';

use constant DEBUG => 1;

sub new($$) {
  my ($class, $vlc, $name) = @_;
  my $self  = $class->SUPER::new($vlc, "vod", $name);
  
  $self->{mux} = "";
  
  bless $self, $class;
  return $self;
}

sub mux($) {
  my ($self, $mux) = @_;
  return $self->{mux} unless (defined $mux);
  $self->{mux} = $mux;
  $self->setup("mux $mux");
}

1;

__END__

=head1 NAME

VLC::VOD -- encapsulate vod (video on demand) media type of VLC

=head1 SYNOPSIS

  use VLC::VOD;
  
  my $vod = VLC::VOD->new($vlc, "vodname");
  print $vod->mux;

=head1 DESCRIPTION

C<VLC::VOD> is a sub class of C<VLC::Media> and provides additional
methods specific for video on demand media type of VLC. For common operations
see L<VLC::Media>.

=head1 CONSTRUCTOR

=over 4

=item new ( vlc, name )

Create new instance of C<VLC::VOD> for a given
instance of VLC connection with specified VoD name.

=back

=head1 METHODS

=over 4

=item mux ( [muxname] )

Set mux name of VoD media.

=back

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.