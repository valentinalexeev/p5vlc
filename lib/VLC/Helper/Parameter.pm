# $Id$
# Parameter.pm -- Utility class that does all the work required to make parameter string.
# Copyright (C) 2006 Valentin A. Alekseev
# Distribute under the terms of Apache License version 2.
package VLC::Helper::Parameter;
use strict;
use warnings;

require Exporter;
use base qw(Exporter);
use UNIVERSAL qw(isa);
our @EXPORT = qw();
our @EXPORT_OK = qw(&new);
our $VERSION = '1.0';

use constant SWITCH => "-THIS-OPTION-IS-A-SWITCH-";

sub new($$) {
  my ($class, $name, $type) = @_;
  my $self = {};
  
  $self->{name} = $name;
  $self->{type} = $type;
  my %options;
  $self->{options} = \%options;
  
  $self->{quotes} = 0;
  
  bless $self, $class;
  return $self;
}

sub check_parameter() {
  # override this method to provide parameter checking.
  1;
}

sub quoted() {
  my ($self, $value) = @_;
  return $self->{quotes} unless $value;
  $self->{quotes} = $value;
}

sub option($$) {
  my ($self, $optionname, $optionvalue) = @_;
  if (!defined $optionvalue) {
    if (!exists $self->{options}->{$optionname}) {
      return undef;
    }
    return $self->{options}->{$optionname};
  }
  $self->{options}->{$optionname} = $optionvalue;
}

sub switch($$) {
  my ($self, $optionname, $optionvalue) = @_;
  return $self->{options}->{$optionname} unless defined $optionvalue;
  $self->{options}->{$optionname} = SWITCH if $optionvalue;
  undef $self->{options}->{$optionname} unless $optionvalue;
}

sub parameter_type {
  my $self = shift;
  return $self->{type};
}

sub parameter_name() {
  my ($self, $name) = @_;
  return $self->{name} unless(defined $name);
  $self->{name} = $name;
}

sub makeoption() {
  # we may have some options...
  # optionvalue can be:
  #   - undef              => not set
  #   - SWITCH             => switch turned on
  #   - some scalar value  => this value
  #   - an array reference => a list of options with the same name
  #   - a Parameter        => value of it's as_parameter()
  my ($options, $key, $value) = @_;
  #my @options = @{$$optionsref};
  return unless defined ($value);
  if (ref(\$value) eq "SCALAR") {
    push @{$options}, $key if $value eq SWITCH;
    return if $value eq SWITCH;
    push @{$options}, "$key=$value" if defined $value;
    return;
   }
   if (ref($value) eq "ARRAY") {
     foreach my $line (@{$value}) {
       if (ref(\$line) eq "SCALAR") {
         push @{$options}, $line;
         next;
       }
       push @{$options}, "$key=" . $line->as_parameter() if $line->isa("VLC::Helper::Parameter");
     }
     return;
   }
   push @{$options}, $value->as_parameter() if $value->isa("VLC::Helper::Parameter");
}

sub as_parameter() {
  my $self = shift;
  die "Parameter check failed." unless $self->check_parameter();
  my $res = "";
  $res .= $self->{type} . "=" if (defined $self->{type});
  $res .= $self->{name};
  if (scalar keys %{$self->{options}} > 0) {
    my @options;
    while (my ($key, $value) = each %{ $self->{options} }) {
      &makeoption(\@options, $key, $value);
    }
    if (scalar @options > 0) {
      $res .= "{" . join(",", @options) . "}" unless $self->{quotes};
      $res .= "\"" . join(",", @options) . "\"" if $self->{quotes};
    }
  }
  return $res;
}

1;

__END__

=head1 NAME

VLC::Helper::Parameter -- utility class that provides wrapper for VLM-style parameters.

=head1 SYNOPSIS

  use VLC::Helper::Parameter;
  
  my $param = VLC::Helper::Parameter->new("udp", "access");
  $param->option("cashing", 100);
  print $param->as_parameter();
  #produces access=udp{cashing=100}

=head1 DESCRIPTION

C<VLC::Helper::Parameter> provides means to create parameter values in VLM-style with OO.
This class used over and over in Helper but it might be useful outside.

=head1 CONSTRUCTOR

=over 4

=item new ( name [, type] )

Create new parameter with given name. You can also specify type of the parameter. Code like
C<new("udp", "access")> will create parameter C<access=udp>.

=back

=head1 METHODS

=over 4

=item option ( name [, value] )

Get or set value of an option. If option not found returns undef. Value could be:
undef - to delete an option, scalar - to the value of it, array - will be treated
as list of options with the same name, instance or child of C<VLC::Helper::Parameter> --
to nest parameters.

=item switch ( name [, state] )

Just as C<option()> but sets or gets a switch (option with no value). State could be true
to set switch on and false to remove switch from parameter.

=item check_parameter ()

Sub classes should override this method if the need to perform any logic checks prior to
creating parameter string. In case of an error sub class should C<die>;

=item as_parameter ()

Convert parameter definition to string used by VLM.

=item parameter_type ( [type] )

Get or set parameter type.

=item parameter_name ( [name] )

Get or set parameter name.

=item quoted ( [state] )

Use quotes instead of braces for options enclosing. This is used, for e.g., in
select option of duplicate stream module.

=back

=head1 AUTHOR

The author of VLC package is Valentin A. Alekseev.

=head1 COPYRIGHT

This package is Copyright (C) 2006 Valentin A. Alekseev.
All rights reserved.

Distribute under the terms of Apache License version 2.