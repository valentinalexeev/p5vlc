# $Id$
# Broadcast.pm -- encapsulation of broadcast media type.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.

package VLC::Broadcast;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Media);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new &create &enable &input &loop &output &option &load);
our $VERSION = '$Id$';

use constant DEBUG => 1;

sub new($$) {
  my ($class, $vlc, $name) = @_;
  my $self  = $class->SUPER::new($vlc, "broadcast", $name);
  
  $self->{loop} = 0;
  $self->{output} = "";
  
  bless $self, $class;
  return $self;
}

sub loop($) {
  my ($self, $isloop) = @_;
  return $self->{loop} unless (defined $isloop);
  $self->{loop} = $isloop;
  $self->setup("loop") if $isloop;
  $self->setup("unloop") unless $isloop;
}

sub output($) {
  my ($self, $output) = @_;
  return $self->{output} unless (defined $output);
  $self->{output} = $output;
  $self->setup("output $output");
}

1;
__END__
=head1 NAME

VLC::Broadcast - encapsulation of broadcast media type of VLC.

=head1 SYNOPSIS

  use VLC;
  
  # Creating your own broadcast
  my $bcast = $vlc->broadcast('broadcast');
  $bcast->autocommit(0);
  $bcast->delete();
  $bcast->create();
  $bcast->input("test.avi");
  $bcast->input("test1.avi");
  $bcast->output("udp/ts:239.255.1.1");
  $bcast->loop(1);
  $bcast->option("switch");
  $bcast->option("opion", "argument");
  $bcast->enable(1);
  $bcast->commit();
  
  # Loading broadcast definition by name
  my $bcast = VLC::Broadcast->new($vlm, "bcast");
  $bcast->load();

=head1 DESCRIPTION

C<VLC::Broadcast> is a sub class of C<VLC::Media> and provides additional
methods specific for broadcast media type of VLC. For common operations
see L<VLC::Media>.

=head1 CONSTRUCTOR

=over 4

=item new ( vlm, name )

Create new instance of C<VLC::Broadcast> for a given
instance of VLC connection with specified broadcast name.

=back

=head1 METHODS

=over 4

=item output ( [output] )

Set output stream configuration or return one.

=item loop ( [isloop] )

Get or set if this broadcast is looped.

=back

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.
