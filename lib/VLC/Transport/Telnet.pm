# $Id$
# Telnet.pm -- perform VLM commands via Telnet.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.

package VLC::Transport::Telnet;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new &perform &disconnect);
our $VERSION = '$Id$';

use constant DEBUG => 1;

use IO::Socket;

sub new($$$) {
	my $self = {};
	my (undef, $address, $port, $password) = @_;
	$self->{address} = $address;
	$self->{port} = $port;
	
	# connecting to VLC
	my $socketref = IO::Socket::INET->new(PeerAddr => $address, PeerPort => $port) or die "Unable to connect to $address:$port";
	$socketref->autoflush(1);
	
	# login
	$socketref->blocking(0);
	$socketref->print($password . "\n");
	sleep(1);
	my @res = $socketref->getlines();
	$socketref->blocking(1);
	
	$self->{socketref} = $socketref;
	
	bless $self;
	return $self;
}

sub perform($) {
	my $self = shift;
	my $command = shift;
	print STDERR __PACKAGE__ . ": performing [$command]\n" if DEBUG;
	my $socketref = $self->{socketref};
	$socketref->print($command . "\n");
	my $strresult = "";
	
	my $buffer;
	while (sysread($socketref, $buffer, 1) == 1) {
	  if($buffer eq '>') {
	    # skip chars after prompt
	    sysread($socketref, $buffer, 1);
	    last;
	  } else {
	    $strresult .= $buffer;
	  }
	}
	
	return $strresult;
}

sub disconnect() {
  my $self = shift;
  $self->{socketref}->print("quit\n");
  $self->{socketref}->close();
}

DESTROY {
  my $self = shift;
  if ($self->{socketref}->connected) {
    $self->disconnect;
  }
}

1;

__END__

=head1 NAME

VLC::Transport::Telnet -- Telnet transport to connect to VLC.

=head1 SYNOPSIS

  Generaly you will not ever use or see this module.

=head1 CONSTRUCTOR

=over 4

=item new ( address, port, password )

Open connection to VLC's Telnet interface on specified address and port
specification and attempt to login with given password.

=back

=head1 METHODS

=over 4

=item perform ( command )

Perform command on remote Telnet interface.

=item disconnect ()

Say VLC quit, and close socket.

=back

=head1 BUGS

Login failures not handled.

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.