package HTTP::Headers::ActionPack::LinkList;
# ABSTRACT: A List of Link objects

use strict;
use warnings;

our $VERSION = '0.10';

use HTTP::Headers::ActionPack::LinkHeader;

use parent 'HTTP::Headers::ActionPack::Core::BaseHeaderList';

sub BUILDARGS { shift; +{ items => [ @_ ] } }

sub items { (shift)->{'items'} }

sub add {
    my ($self, $link) = @_;
    push @{ $self->items } => $link;
}

sub add_header_value {
    my ($self, $value) = @_;
    $self->add( HTTP::Headers::ActionPack::LinkHeader->new( @$value ) );
}

sub iterable { @{ (shift)->items } }

1;

__END__

=pod

=for Pod::Coverage items

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::LinkList;

=head1 DESCRIPTION

This is a simple list of Links since the Link header
can legally have more then one link in it.

=head1 METHODS

=over 4

=item C<add ( $link )>

=item C<add_header_value ( $header_value )>

=item C<iterable>

=back

=cut
