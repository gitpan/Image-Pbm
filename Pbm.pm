package Image::Pbm;

our $VERSION = '0.01';

use strict;
use warnings;
use Image::Xbm(); our @ISA = 'Image::Xbm';
use Image::PBMlib();

sub load
{
  my $self = shift ;
  my $file = shift || $self->get(-file ) or die 'No file specified';

  open my $fh, $file or die "Failed to open `$file': $!";

  my $h = Image::PBMlib::readppmheader( $fh );
  die "Failed to parse header in `$file': $h->{error}" if $h->{error};
  die "Wrong magic number: ($h->{type})" if $h->{type} != 1;

  $self->_set(  -file => $file );
  $self->_set( -width => $h->{width} );
  $self->_set(-height => $h->{height} );
  $self->_set(  -bits => pack 'b*', join '', Image::PBMlib::readpixels_dec(
    $fh, $h->{type}, $h->{width} * $h->{height} ) );
}

sub save
{
  my $self = shift;
  my $file = shift || $self->get(-file ) or die 'No file specified';

  $self->set(-file => $file,-setch => ' 1',-unsetch => ' 0');

  open my $fh, ">$file" or die "Failed to open `$file': $!";
  local $\ = "\n";
  print $fh 'P1';
  print $fh "# $file";
  print $fh $self->get(-width );
  print $fh $self->get(-height );
  print $fh $self->as_string;
}

1;

=head1 NAME

Image::Pbm - Load, create, manipulate and save pbm image files.

=head1 SYNOPSIS

  use Image::Pbm();

  my $i = Image::Pbm->new(-width => 50, -height => 25 );
  $i->line     ( 2, 2, 22, 22 => 1 );
  $i->rectangle( 4, 4, 40, 20 => 1 );
  $i->ellipse  ( 6, 6, 30, 15 => 1 );
  print $i->as_string;
  $i->save('test.pbm');

  $i = Image::Pbm->new(-file,'test.pbm');

=head1 DESCRIPTION

This module provides basic load, manipulate and save functionality for
the pbm file format. It inherits from C<Image::Xbm> which provides additional
functionality.

=head1 AUTHOR

Steffen Goeldner <sgoeldner@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2004 Steffen Goeldner. All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<perl>, L<Image::Base>, L<Image::Xbm>, L<Image::PBMlib>.

=cut
