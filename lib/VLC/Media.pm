# $Id$
# Media.pm -- base class for media types.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.
package VLC::Media;
use strict;
use warnings;

require Exporter;
use base qw(Exporter VLC::Type);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new &create &enable &input &loop &output &option &load);
our $VERSION = '$Id$';

use constant DEBUG => 1;

use constant OPTION_ISSWITCH => 1;

sub new($$$) {
  my ($class, $vlc, $type, $name) = @_;
  my $self = $class->SUPER::new($vlc, $name, $type);

  # Media options themselves.
  my @input;
  $self->{input} = \@input;
  my %option;
  $self->{option} = \%option;
  my %instance;
  $self->{instance} = \%instance;

  bless $self, $class;
  
  $self->{vlc}->add($self);
  
  return $self;
}

sub load() {
  my $self = shift;
  
  print STDERR __PACKAGE__ . ": Loading " . $self->{type} . " definition named " . $self->name . "\n" if DEBUG;
  
  my $desc = $self->{vlc}->perform("show " . $self->name);
  die "No such " . $self->{type} unless ($desc =~ /^show/);
  my @info = split /\r/, $desc;
  my $ininputs = 0;
  my $inoptions = 0;
  my $ininstances = 0;
  foreach(@info) {
    next if (/^show/);
    next if (/^\s{5}$self->{name}/);
    chomp;
    s/^\s{9}//;
    
    if (/^\s/) {
      s/\s{5}//;
      push @{$self->{input}}, $_ if $ininputs;
      if ($ininstances) {
        my ($name, $state) = split /:/;
        $name =~ s/\s+//g;
        $state =~ s/\s+//g;
        $self->{instance}->{$name} = $state;
      }
      if ($inoptions) {
        my ($option, $value) = split /=/;
        $self->{option}->{$option} = $value if (defined $value);
        $self->{option}->{$option} = OPTION_ISSWITCH unless (defined $value);
      }
      next; 
    }
    
    if (/^type :(.*)/) {
      die "Not a " . $self->{type} . " type" unless ($1 =~ /$self->{type}/);
    }
    if (/^enabled :(.*)/) {
      if ($1 =~ /yes/) {
        $self->{enabled} = 1;
      } else {
        $self->{enabled} = 0;
      }
    }
    if (/^loop :(.*)/) {
      if ($1 =~ /yes/) {
        $self->{loop} = 1;
      } else {
        $self->{loop} = 0;
      }
    }
    if (/^inputs/) {
      $ininputs = 1;
    }
    if (/^output : (.*)/) {
      $self->{output} = $1;
    }
    if (/^options/) {
      $ininputs = 0;
      $inoptions = 1;
    }
    if (/^instances/) {
      $ininputs = 0;
      $inoptions = 0;
      $ininstances = 1;
    }
  }
}

sub input($) {
  my ($self, $inputsource) = @_;
  return @{$self->{input}} unless (defined $inputsource);
  push @{$self->{input}}, $inputsource;
  $self->setup("input '$inputsource'");
}

use constant INPUTDELETE_ALL => "all";
sub inputdel($) {
  my ($self, $inputname) = @_;
  $self->setup("inputdel '$inputname'") unless ($inputname eq INPUTDELETE_ALL);
  $self->setup("inputdel all") if ($inputname eq INPUTDELETE_ALL);
}

sub inputdeln($) {
  my ($self, $inputnum) = @_;
  $self->setup("inputdeln $inputnum");
}

sub option($$) {
  my ($self, $optionname, $optionarg) = @_;
  return %{$self->{option}} unless (defined $optionname);
  $self->{option}->{$optionname} = $optionarg if (defined $optionarg);
  $self->{option}->{$optionname} = OPTION_ISSWITCH unless (defined $optionarg);
  $self->setup("option $optionname=$optionarg") if (defined $optionarg);
  $self->setup("option $optionname") unless (defined $optionarg);
}

sub output($$) {
  my ($self, $output) = @_;
  return $self->{output} unless (defined $output);
  $self->{output} = $output;
  $self->setup("output '$output'");
}

1;
__END__
=head1 NAME

VLC::Media - base class for media types of VLC.

=head1 SYNOPSIS

  Basicly you will not need anything from this class.

=head1 DESCRIPTION

Media type could be either C<create()>ed or C<load()>ed
after class is instantiated. Any other action which modifies media
definition should appear only after them.

Sub classes, of course, may define their own contributions to methods.

C<VLC::Media> borrows 'transaction' operations from L<VLC::Type>, refer there
for more information.
  
=head1 CONSTRUCTOR

=over 4

=item new ( vlm, type, name )

Create new instance of C<VLC::Media> base class for a given
instance of VLC connection with specified name and of specific type.

=back

=head1 METHODS

=over 4

=item create ( )

Create new media.

=item load ( )

Load media definition from VLC.

=item enable ( [BOOL] )

Set or check if this broadcast is enabled.

=item input ( [input] )

Get list of known inputs or add one to the end of input list.

=item inputdel ( inputname )

Remove given input from input list.

=item output ( output )

Set or check output for a media type.

=item option ( [name [,value]] )

Get hash of options, turn on switch or set option with argument.

=back

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.
