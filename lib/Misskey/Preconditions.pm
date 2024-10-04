package Misskey::Preconditions;

use v5.38;
use strict;
use warnings;

use Switch;

=head1 NAME

Misskey::Preconditions - Sanity Checking for various types

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

This module provides an assortment of helper functions to verify arguments

Perhaps a little code snippet.

    use Misskey::Account;
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS
=head2 verifyVisibility

This function ensures that the visibility argument passed to note create is
within the four possible options: 'public', 'home', 'specified', 'unlisted'.

=cut

sub verifyVisibility($visibility) {
    if (defined $visibility) {
        switch($visibility) {
            case 'public' { last; }
            case 'home' { last; }
            case 'specified' { last; }
            case 'unlisted' { last; }
            else { die 'Invalid visibility type!' }
        }
    }
}

=head2 verifyCW

This function ensures that the content warning is less than or equal to 500
characters as per limitation of the misskey api.

=cut

sub verifyCW($cw) {
    if (defined $cw) {
        if (500 < length($cw)) {
            die 'Content warning is too long!';
        }
    }
}

=head1 AUTHOR

Amber Null, C<< <amber at transfem.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-misskey-client at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Misskey-Client>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Misskey::Account

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Misskey-Client>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Misskey-Client>

=item * Search CPAN

L<https://metacpan.org/release/Misskey-Client>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2024 by Amber Null.

This is free software, licensed under:

  The MIT (X11) License

=cut

1; # End of Misskey::Preconditions
