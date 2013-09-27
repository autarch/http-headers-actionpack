package HTTP::Headers::ActionPack;
use v5.16;
use warnings;
use mop;

use Encode qw[ find_encoding ];

class AcceptCharset extends HTTP::Headers::ActionPack::PriorityList is overload('inherited') {

    method new_from_string ($class:) {
        # FIXME: this is wrong
        my $self = $class->next::method( @_ );

        # From RFC-2616 sec14.2
        # If no "*" is present in an Accept-Charset
        # field, then all character sets not explicitly
        # mentioned get a quality value of 0, except for
        # ISO-8859-1, which gets a quality value of 1
        # if not explicitly mentioned.
        unless ( defined $self->priority_of('*')
            || defined $self->priority_of('ISO-8859-1') ) {

            $self->add( 1 => 'ISO-8859-1' );
        }

        return $self;
    }

    method canonicalize_choice ($choice) {
        return unless defined $choice;
        return '*' if $choice eq '*';
        my $charset = find_encoding($choice)
            or return;
        return $charset->mime_name;
    }

}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::AcceptCharset;

  # normal constructor
  my $list = HTTP::Headers::ActionPack::AcceptCharset->new(
      [ 1.0 => 'UTF-8' ],
      [ 0.7 => 'ISO-8859-1' ],
  );

  # or from a string
  my $list = HTTP::Headers::ActionPack::AcceptCharsetList->new_from_string(
      'UTF-8; q=1.0, ISO-8859-1; q=0.7'
  );

=head1 DESCRIPTION

This is a subclass of the L<HTTP::Headers::ActionPack::PriorityList>
class with some charset specific features.

=head1 METHODS

=over 4

=item C<new_from_string>

This method overrides the default constructor to add some additional logic
required by RFC-2616. If an Accept-Charset header does not explicitly define
the priority for "*" or "ISO-8859-1", then the default priority for
"ISO-8859-1" must be set to 1.0.

Note that we do not override the C<new> method. If you are passing an
explicitly list of values to the constructor we assume you know what you are
doing.

=item C<canonicalize_choice>

This takes a string containing a character set name and returns the canonical
MIME name for the character set. For example, it transforms "utf8" to "UTF-8".

=back

=cut
